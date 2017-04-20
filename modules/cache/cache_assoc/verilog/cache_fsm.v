module cache_fsm(
    //output
    state,
    err,
    stall,
    canHit,
    //to cache
    c_en,
    c_offset,
    c_comp,
    c_write,
    c_valid_in,
    //to mem
    m_offset,
    m_wr,
    m_rd,
    //input
    clk,
    rst,
    Rd,
    Wr,
    //from cache
    hit,
    dirty,
    valid,
    //from mem
    m_stall
);
    output [3:0] state;
    output reg err, stall, canHit;
    output reg c_en, c_comp, c_write, c_valid_in, m_wr, m_rd;
    output reg [1:0] c_offset, m_offset;


    input clk, rst, Rd, Wr, hit, dirty, valid, m_stall;

/**
 * States
 */
   localparam IDLE          = 4'b0000; // 0
   localparam COMPARE_READ  = 4'b0001; // 1
   localparam COMPARE_WRITE = 4'b0010; // 2

   localparam WB_0   = 4'b0011; // 3
   localparam WB_1   = 4'b0100; // 4
   localparam WB_2   = 4'b0101; // 5
   localparam WB_3   = 4'b0110; // 6

   localparam ALLOC0     = 4'b0111; // 7 read mem0
   localparam ALLOC1     = 4'b1000; // 8 read mem1
   localparam ALLOC2     = 4'b1001; // 9 read mem2 & install cacheblock0
   localparam ALLOC3     = 4'b1010; // 10/a read mem3 & install cacheblock1
   localparam ALLOC4     = 4'b1011; // 11/b install cacheblock2
  
   localparam COMMIT = 4'b1100; // 12/c install cacheblock3, last block and commit(set valid_in == true) cache line
   localparam RD_RETRY = 4'b1101; // 13/d //rereading on a miss after install new cache line 
   localparam WR_RETRY = 4'b1110; // 14/e //rereading on a miss after install new cache line
   localparam ERROR   = 4'b1111; // 15/f //shit hit the fan

   localparam TRUTH = 1'b1;
   localparam FALSE = 1'b0;

/** 
 * FSM States Reg
 */
    wire [3:0] cstate;
    reg [3:0] nstate;
    dff state_reg[3:0](.q(cstate), .d(nstate), .clk(clk), .rst(rst));
    assign  state = cstate;
/**
 * FSM Logics
 */
always @(*) begin
    err = FALSE;
    stall = (cstate != IDLE);
    canHit = (cstate == COMPARE_READ | cstate == COMPARE_WRITE);
    //cache
    c_en = TRUTH;
    c_offset = 2'bxx; 
    c_comp = FALSE;
    c_write = FALSE;
    c_valid_in = FALSE; //on write, set valid bit when comp==0
    //mem
    m_offset = 2'bxx;
    m_wr = FALSE;
    m_rd = FALSE;
    case(cstate)
        ERROR: begin
            nstate = IDLE;
            c_en = FALSE;
            err = TRUTH;
        end
        IDLE: begin
            nstate = Rd ? COMPARE_READ  :
                     Wr ? COMPARE_WRITE : IDLE;
            c_comp = Rd | Wr;
            c_en = Rd | Wr;
        end
        COMPARE_READ: begin
            nstate = (~(hit & valid)  & dirty) ? WB_0 : //miss & dirty -> wb to mem
                     (~(hit & valid)  & ~dirty) ? ALLOC0 : IDLE; //miss & not dirty -> load from mem OR hit&value->done idle

            c_comp = TRUTH;
            c_write = FALSE;
        end
        COMPARE_WRITE: begin
            nstate = (~(hit & valid) & dirty) ? WB_0 : //miss & dirty -> wb to mem
                     (~(hit & valid) & ~dirty) ? ALLOC0 : IDLE; //miss & not dirty -> load from mem OR hit&value->done idle

            c_comp = TRUTH;
            c_write = TRUTH;
        end

        WB_0: begin
            nstate = m_stall ? WB_0 : WB_1;
            c_comp = FALSE;
            c_write = FALSE;
            m_wr = TRUTH;
            m_rd = FALSE;
            c_offset = 2'b00;
            m_offset = 2'b00;
        end
        WB_1: begin
            nstate = m_stall ? WB_1 : WB_2;
            c_comp = FALSE;
            c_write = FALSE;
            m_wr = TRUTH;
            m_rd = FALSE;
            c_offset = 2'b01;
            m_offset = 2'b01;
        end
        WB_2: begin
            nstate = m_stall ? WB_2 : WB_3;
            c_comp = FALSE;
            c_write = FALSE;
            m_wr = TRUTH;
            m_rd = FALSE;
            c_offset = 2'b10;
            m_offset = 2'b10;
        end
        WB_3: begin
            nstate = m_stall ? WB_3 : ALLOC0;
            c_comp = FALSE;
            c_write = FALSE;
            m_wr = TRUTH;
            m_rd = FALSE;
            c_offset = 2'b11;
            m_offset = 2'b11;
        end
        ALLOC0: begin
            nstate = m_stall ? ALLOC0 : ALLOC1;
            
            c_comp = FALSE;
            c_write = TRUTH;
            //c_en = FALSE;//notenote

            m_wr = FALSE;
            m_rd = TRUTH;

            c_offset = 2'bxx;
            m_offset = 2'b00;
        end
        ALLOC1: begin
            nstate = m_stall ? ALLOC1 : ALLOC2;
            
            c_comp = FALSE;
            c_write = TRUTH;
            //c_en = FALSE;//notenote

            m_wr = FALSE;
            m_rd = TRUTH;

            c_offset = 2'bxx;
            m_offset = 2'b01;
        end
        ALLOC2: begin
            nstate = m_stall ? ALLOC2 : ALLOC3;
            
            c_comp = FALSE;
            c_write = TRUTH;

            m_wr = FALSE;
            m_rd = TRUTH;

            c_offset = 2'b00;
            m_offset = 2'b10;
        end
        ALLOC3: begin
            nstate = m_stall ? ALLOC3 : ALLOC4;
            
            c_comp = FALSE;
            c_write = TRUTH;

            m_wr = FALSE;
            m_rd = TRUTH;

            c_offset = 2'b01;
            m_offset = 2'b11;
        end
        ALLOC4: begin
            nstate = COMMIT;

            c_comp = FALSE;
            c_write = TRUTH;

            m_wr = FALSE;
            m_rd = FALSE;

            c_offset = 2'b10;
            m_offset = 2'bxx;
        end
        COMMIT: begin
            nstate = Rd ? RD_RETRY  :
                     Wr ? WR_RETRY  : ERROR;

            c_comp = FALSE;
            c_write = TRUTH;
            c_valid_in = TRUTH; //mark cache in valid once all words loaded

            m_wr = FALSE;
            m_rd = FALSE;

            c_offset = 2'b11;
            m_offset = 2'bxx;        
        end
        RD_RETRY: begin //RD miss resolver
            nstate = IDLE;
            
            c_comp = TRUTH;
            c_write = FALSE;

            m_wr = FALSE;
            m_rd = FALSE;

        end
        WR_RETRY: begin //WR miss resolver
            nstate = IDLE;

            c_comp = TRUTH;
            c_write = TRUTH;

            m_wr = FALSE;
            m_rd = FALSE;
        end
    endcase 
end
endmodule