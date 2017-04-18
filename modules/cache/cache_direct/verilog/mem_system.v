/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err,
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
   input [15:0] Addr;
   input [15:0] DataIn;
   input        Rd;
   input        Wr;
   input        createdump;
   input        clk;
   input        rst;
   
   output [15:0] DataOut;
   output Done;
   output Stall;
   output CacheHit;
   output err;

    wire c0_en;
    wire [4:0] c0_tag_in;
    wire [7:0] c0_index;
    wire [2:0] c0_offset;
    wire [15:0] c0_data_in;
    wire comp;
    wire write;
    wire c0_valid_in;

    wire [4:0] c0_tag_out;
    wire [15:0] c0_data_out;
    wire c0_hit;
    wire c0_dirty;
    wire c0_valid;
    wire c0_err;
    wire [15:0] c_addr;
   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (c0_tag_out),
                          .data_out             (c0_data_out),
                          .hit                  (c0_hit),
                          .dirty                (c0_dirty),
                          .valid                (c0_valid),
                          .err                  (c0_err),
                          // Inputs
                          .enable               (c0_en),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (c0_tag_in),
                          .index                (c0_index),
                          .offset               (c0_offset),
                          .data_in              (c0_data_in),
                          .comp                 (comp),
                          .write                (write),
                          .valid_in             (c0_valid_in));

    wire [15:0] m_addr, m_data_in, m_data_out;
    wire m_wr, m_rd, m_stall, m_err;
    wire [3:0] m_busy; 
   four_bank_mem mem(// Outputs
                     .data_out          (m_data_out),
                     .stall             (m_stall),
                     .busy              (m_busy),
                     .err               (m_err),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (m_addr),
                     .data_in           (m_data_in),
                     .wr                (m_wr),
                     .rd                (m_rd));

   wire cache_stall, canHit;
   wire [1:0] m_offset, c_offset;
   // your code here
   cache_fsm cache_fsm0(
    //output
    .stall(cache_stall),
    .canHit(canHit),
    //to cache
    .c_en(c0_en),
    .c_offset(c_offset), //width = 3
    .c_comp(comp),
    .c_write(write),
    .c_valid_in(c0_valid_in),
    //to mem
    .m_offset(m_offset), //width = 3
    .m_wr(m_wr),
    .m_rd(m_rd),
    //input
    .clk(clk),
    .rst(rst),
    .Rd(Rd),
    .Wr(Wr),
    //from cache
    .hit(c0_hit),
    .dirty(c0_dirty),
    .valid(c0_valid),
    //from mem
    .m_stall(m_stall)
    );
    //offset width = 2 bit & Addr[0] == 0 always since word-allieged.
    assign m_addr =   comp ? Addr : //compare
                      (~comp & ~write) ? {c0_tag_out, Addr[10:3], m_offset, Addr[0]} : //access read 
                      {Addr[15:3], m_offset, Addr[0]}; //access write
    assign m_data_in  = c0_data_out;

    assign c_addr = comp ? Addr : {Addr[15:3], c_offset, Addr[0]};

    assign c0_tag_in = c_addr[15:11];
    assign c0_index  = c_addr[10:3];
    assign c0_offset = c_addr[2:0];
    assign c0_data_in = comp ? DataIn : m_data_out;
    

    assign DataOut = c0_data_out;
    assign CacheHit = c0_hit & c0_valid & canHit; 
    assign Done = c0_hit & c0_valid; //WRONGGGG Giang said so
    assign Stall = cache_stall; 

    assign err = c0_err | m_err;

endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
