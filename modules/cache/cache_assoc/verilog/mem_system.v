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

/**
 * States
 */
   localparam IDLE          = 4'b0000; // 0
   localparam COMPARE_READ  = 4'b0001; // 1

   localparam STALL0 = 4'b0010; // 2
   localparam STALL1 = 4'b0011; // 3
   localparam STALL2 = 4'b0100; // 4
   localparam STALL3 = 4'b0101; // 5
   
   localparam COMPARE_WRITE = 4'b0110; // 6
   localparam ACCESS_READ   = 4'b0111; // 7

   localparam WB_0   = 4'b1000; // 8 change line 89ish if you update this
   localparam WB_1   = 4'b1001; // 9
   localparam WB_2   = 4'b1010; // 10/a
   localparam WB_3   = 4'b1011; // 11/b

   localparam ALLOC0     = 4'b1100; // 12/c
   localparam ALLOC1     = 4'b1101; // 13/d
   localparam ALLOC2     = 4'b1110; // 14/e
   localparam ALLOC3     = 4'b1111; // 15/f

    //cache set input
    wire [15:0] c_addr;
    wire[4:0] c_tag_in;
    wire[7:0] c_index;
    wire[2:0] c_offset;
    wire [15:0] c_data_in;


    // Shared Control lines
    wire c_comp, c_write, //cache
        m_wr, m_rd; //mem

    wire [1:0] cache_en;
    wire [15:0] cache_dataout, c0_data_out, c1_data_out;
    wire [4:0]  cache_tagout, c0_tag_out, c1_tag_out;
    wire c_enable, c0_en, c1_en;
    wire cache_hit, cache_dirty, cache_valid, cache_err;
    wire c0_hit, c0_dirty, c0_valid, c0_err;   
    wire c1_hit, c1_dirty, c1_valid, c1_err;
    wire c_valid_in;//what to do & with (,~)evict_c0?
        
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
                          .tag_in               (c_tag_in),
                          .index                (c_index),
                          .offset               (c_offset),
                          .data_in              (c_data_in),
                          .comp                 (c_comp),
                          .write                (c_write),
                          .valid_in             (1'b1));
   cache #(2 + memtype) c1(// Outputs
                          .tag_out              (c1_tag_out),
                          .data_out             (c1_data_out),
                          .hit                  (c1_hit),
                          .dirty                (c1_dirty),
                          .valid                (c1_valid),
                          .err                  (c1_err),
                          // Inputs
                          .enable               (c1_en),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (c_tag_in),
                          .index                (c_index),
                          .offset               (c_offset),
                          .data_in              (c_data_in),
                          .comp                 (c_comp),
                          .write                (c_write),
                          .valid_in             (1'b1));

  wire [15:0] m_addr, m_data_in, m_data_out;
  wire m_stall, m_err;
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
   
  // your code here
  wire cache_stall, canHit;
  wire [1:0] m_offset, c_offset_out;
  wire [3:0] curr_state;
  // your code here
  cache_fsm cache_fsm0(
    //output
    .state(curr_state),
    .stall(cache_stall),
    .canHit(canHit),
    //to cache
    .c_en(c_enable),
    .c_offset(c_offset_out), //width = 3
    .c_comp(c_comp),
    .c_write(c_write),
    .c_valid_in(c_valid_in),
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
    .hit(cache_hit),
    .dirty(cache_dirty),
    .valid(cache_valid),
    //from mem
    .m_stall(m_stall)
  );

  //caches input
  assign c_addr = c_comp ? Addr : {Addr[15:3], c_offset_out, Addr[0]};
  assign c_tag_in = c_addr[15:11];
  assign c_index  = c_addr[10:3];
  assign c_offset = c_addr[2:0];
  assign c_data_in = c_comp ? DataIn : m_data_out;

//offset width = 2 bit & Addr[0] == 0 always since word-allieged.
  assign m_addr =   c_comp ? Addr : //compare
                    (~c_comp & ~c_write) ? { cache_tagout, Addr[10:3], m_offset, Addr[0]} : //access read 
                    {Addr[15:3], m_offset, Addr[0]}; //access write
  
  assign m_data_in  = cache_dataout;
  //2ways 2wayssss
  wire victim, next_victim; wire[1:0] victimway;
  dff coinflip (.q(victim), .d(next_victim), .clk(clk), .rst(rst));
  assign next_victim = (curr_state == COMPARE_WRITE | curr_state == COMPARE_READ) ? ~victim : victim; //only toggle victimway on compread compwrite
  assign victimway = (victim == 1'b1) ? 2'b01 : 2'b10;

  assign c0ValidHit = c0_hit & c0_valid;
  assign c1ValidHit = c1_hit & c1_valid;

  //valid and dirty register (update on idle (on complete))
     
  wire wb_c0_out, wb_c1_out;    
  dff wb_c0 (.q(wb_c0_out), .d(cache_en[0]), .clk(clk), .rst(rst));
  dff wb_c1 (.q(wb_c1_out), .d(cache_en[1]), .clk(clk), .rst(rst));

  wire cmp_c0_out, cmp_c1_out;    
  dff cmp_c0(.q(cmp_c0_out), .d(c1ValidHit), .clk(clk), .rst(rst));
  dff cmp_c1(.q(cmp_c1_out), .d(c0ValidHit), .clk(clk), .rst(rst));

  wire c0_valid_out, c1_valid_out;    
  dff  c0_v(.q(c0_valid_out), .d( (curr_state == IDLE) ? c0_valid : c0_valid_out), .clk(clk), .rst(rst));
  dff  c1_v(.q(c1_valid_out), .d( (curr_state == IDLE) ? c1_valid : c1_valid_out), .clk(clk), .rst(rst));

  wire c0_dirty_out, c1_dirty_out;    
  dff  c0_d(.q(way_0_dirty_out), .d( (curr_state == IDLE) ? c0_dirty : c0_dirty_out), .clk(clk), .rst(rst));
  dff  c1_d(.q(way_1_dirty_out), .d( (curr_state == IDLE) ? c1_dirty : c1_dirty_out), .clk(clk), .rst(rst));

  wire overall_valid_out;    
  dff  all_v(.q(overall_valid_out), .d( (curr_state == IDLE) ? ( (data_sel == 1'b1) ? c1_valid : c0_valid) : overall_valid_out), .clk(clk), .rst(rst));
  
  wire overall_dirty_out;    
  dff  all_d(.q(overall_dirty_out), .d( (curr_state == IDLE) ? ( (data_sel == 1'b1) ? c1_dirty : c0_dirty) : overall_dirty_out), .clk(clk), .rst(rst));


  assign cache_en =   (c_enable == 1 && c0_valid == 1 && c1_valid == 0 && curr_state ==IDLE) ? 2'b01 :
                      (c_enable == 1 && c0_valid == 0 && c1_valid == 1 && curr_state ==IDLE) ? 2'b10 :
                      (c_enable == 1 && c0_valid == 0 && c1_valid == 0 && curr_state ==IDLE) ? 2'b10 :                        
                      (c_enable == 1 && c0_valid_out == 1 && c1_valid_out == 0 && curr_state !=IDLE) ? 2'b01 :
                      (c_enable == 1 && c0_valid_out == 0 && c1_valid_out == 1 && curr_state !=IDLE) ? 2'b10 :
                      (c_enable == 1 && c0_valid_out == 0 && c1_valid_out == 0 && curr_state !=IDLE) ? 2'b10 :
                      (c_enable == 1 && c0_valid_out == 1 && c1_valid_out == 1 && curr_state == IDLE) ? ~victimway :
                      (c_enable == 1 && c0_valid_out == 1 && c1_valid_out == 1 && curr_state !=IDLE) ? victimway : 2'b00; //TODO: pesudo mdoule
              
  assign c0_en = (curr_state == STALL3) ? wb_c1_out : 
                                  ((curr_state == COMPARE_WRITE) ? cmp_c1_out : ( (curr_state == IDLE)  ? 1'b1 : (cache_en[1] | c_comp)));
  assign c1_en = (curr_state == STALL3) ? wb_c0_out : 
                                  ((curr_state == COMPARE_WRITE) ? cmp_c0_out : ( (curr_state == IDLE)  ? 1'b1 : (cache_en[0] | c_comp)));



  assign data_sel = (c0ValidHit | c1ValidHit) ? c1ValidHit : cache_en[0];
    
  
  /**
   * 
   * Cache output
   */
  assign cache_dataout = (data_sel == 1'b1) ? c1_data_out : c0_data_out;
  assign cache_tagout = (data_sel == 1'b1) ? c1_tag_out : c0_tag_out;
  assign cache_hit = (data_sel == 1'b1) ? c1ValidHit : c0ValidHit;
  assign cache_valid = overall_valid_out;
  assign cache_dirty = overall_dirty_out;
  /**
   * Outputs assignment
   */
  assign DataOut = cache_dataout;
  assign CacheHit = (cache_hit | cache_valid) & canHit; 
  assign Done = (curr_state == STALL3 | curr_state == STALL2) ? 1'b1: ( (curr_state == COMPARE_READ | curr_state == COMPARE_WRITE) ? (cache_hit & cache_valid) : 1'b0 );
  assign Stall = cache_stall; 
  assign cache_err = c0_err | c1_err;
  assign err = cache_err | m_err;
   
endmodule // mem_system

   


// DUMMY LINE FOR REV CONTROL :9:
