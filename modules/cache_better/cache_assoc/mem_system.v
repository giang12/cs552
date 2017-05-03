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

    //cache set inputs
    wire [15:0] c_addr;
    wire[4:0] c_tag_in;
    wire[7:0] c_index;
    wire[2:0] c_offset;
    wire [15:0] c_data_in;
    wire c_valid_in;

    //Control lines
    wire c_comp, c_write, //cache
         m_wr, m_rd; //mem

    wire c_enable, c0_en, c1_en;
    //cache set outputs
    wire [15:0] cache_dataout, c0_data_out, c1_data_out;
    wire [4:0]  cache_tagout, c0_tag_out, c1_tag_out;
    wire cache_hit, cache_dirty, cache_valid, cache_err;
    wire c0_hit, c0_dirty, c0_valid, c0_err;   
    wire c1_hit, c1_dirty, c1_valid, c1_err;
    
    //Mem IO lines
    wire [15:0] m_addr, m_data_in, m_data_out;
    wire m_stall, m_err;
    wire [3:0] m_busy; 
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
                          .valid_in             (c_valid_in));
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
                          .valid_in             (c_valid_in));

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
  wire cache_done, cache_stall, canHit, deadlyErr;
  wire [1:0] m_offset_out, c_offset_out;
  wire [3:0] cache_state;
  // your code here
  cache_fsm cache_fsm0(
    //output
    .state(cache_state),
    .err(deadlyErr),
    .done(cache_done),
    .stall(cache_stall),
    .canHit(canHit),
    //to cache
    .c_en(c_enable),
    .c_offset(c_offset_out), //width = 3
    .c_comp(c_comp),
    .c_write(c_write),
    .c_valid_in(c_valid_in),
    //to mem
    .m_offset(m_offset_out), //width = 3
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
                    (~c_comp & ~c_write) ? { cache_tagout, Addr[10:3], m_offset_out, Addr[0]} : //access read 
                    {Addr[15:3], m_offset_out, Addr[0]}; //access write
  assign m_data_in  = cache_dataout;

  //2ways 2wayssss
  wire victim, victimSel, c0_valid_out, c1_valid_out;
  register_1bit victimway(.readdata(victim), .clk(clk), .rst(rst), .writedata(~victim),
                         .write(cache_done));
  
  //register_1bit c0_v(.readdata(c0_valid_out), .clk(clk), .rst(rst), .writedata(c0_valid), .write(~cache_stall | cache_done));
  //register_1bit c1_v(.readdata(c1_valid_out), .clk(clk), .rst(rst), .writedata(c1_valid), .write(~cache_stall | cache_done));
  
  // assign victimSel =  (c_enable & c0_valid & ~c1_valid & cache_state == IDLE) ? 1'b1 :
  //                     (c_enable & ~c0_valid & c1_valid & cache_state == IDLE) ? 1'b0 :
  //                     (c_enable & ~c0_valid & ~c1_valid & cache_state == IDLE) ? 1'b0 : 
  //                     (c_enable & c0_valid & c1_valid & cache_state == IDLE) ? ~victim :
                       
  //                     (c_enable & c0_valid_out & ~c1_valid_out & cache_state != IDLE) ? 1'b1 :
  //                     (c_enable & ~c0_valid_out & c1_valid_out & cache_state != IDLE) ? 1'b0 :
  //                     (c_enable & ~c0_valid_out & ~c1_valid_out & cache_state != IDLE) ? 1'b0 :
  //                     (c_enable & c0_valid_out & c1_valid_out & cache_state != IDLE) ? victim : 1'b0;
  
  assign c0_en = (cache_state == 0 |~victim);
  assign c1_en = (cache_state == 0 | victim);                               

  assign c0ValidHit = c0_hit & c0_valid;
  assign c1ValidHit = c1_hit & c1_valid;
  assign data_sel =  c0ValidHit ? 0 :
                     c1ValidHit ? 1 : victim;       
  /**
   * Cache output
   */
  //register_1bit all_h(.readdata(cache_hit), .clk(clk), .rst(rst), .writedata(data_sel ? c1_hit : c0_hit), .write(~cache_stall));
  //register_1bit all_v(.readdata(cache_valid), .clk(clk), .rst(rst), .writedata(data_sel ? c1_valid : c0_valid), .write(~cache_stall));
  //register_1bit all_d(.readdata(cache_dirty), .clk(clk), .rst(rst), .writedata(data_sel ? c1_dirty : c0_dirty), .write(~cache_stall));

  assign cache_dataout = data_sel ? c1_data_out : c0_data_out;
  assign cache_tagout = data_sel ? c1_tag_out : c0_tag_out;
  assign cache_hit = data_sel ? c1_hit : c0_hit;
  assign cache_valid = data_sel ? c1_valid : c0_valid;
  assign cache_dirty = data_sel ? c1_dirty : c0_dirty;
  assign cache_err = data_sel ? c1_err : c0_err;

  /**
   * Outputs assignment
   */
  // assign Done = (cache_state == COMPARE_READ | cache_state == COMPARE_WRITE) ? (cache_hit & cache_valid) : //hit right away
  //               (cache_state == WR_RETRY | cache_state == RD_RETRY); //hit on retry after installing cache line
  assign Done = cache_done;

  assign Stall = cache_stall; 
 
  assign err =  (cache_err | m_err) & Done;

  assign DataOut = cache_dataout;
  
  assign CacheHit = cache_hit & cache_valid & canHit; 


  
endmodule // mem_system
// DUMMY LINE FOR REV CONTROL :9:
