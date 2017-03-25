/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module fifo(/*AUTOARG*/
   // Outputs
   data_out, fifo_empty, fifo_full, err,
   // Inputs
   data_in, data_in_valid, pop_fifo, clk, rst
   );
   input [63:0] data_in;
   input        data_in_valid; //writeSignal
   input        pop_fifo; //readSignal

   input        clk;
   input        rst;
   output [63:0] data_out;
   output        fifo_empty;
   output        fifo_full;
   output        err;

   //your code here
   wire fifo_empty, fifo_full, err;
   wire en0, en1, en2, en3;
   wire [63:0] reg_out0, reg_out1, reg_out2, reg_out3;
   // pointers 
   wire [1:0] read_ptr, write_ptr;

   wire read_ctr_en, write_ctr_en, read_ctr_rst, write_ctr_rst, read_ctr_in, write_ctr_in;

   wire empty_flag_in, full_flag_in;
   //counters
   dff read_ctr_ff(.q(read_ctr_en), .d(read_ctr_in), .clk(clk), .rst(rst));
   dff write_ctr_ff(.q(write_ctr_en), .d(write_ctr_in), .clk(clk), .rst(rst));

   dff empty_flag(.q(fifo_empty), .d(empty_flag_in), .clk(clk), .rst(rst));
   dff full_flag(.q(fifo_empty), .d(full_flag_in), .clk(clk), .rst(rst));

   assign read_ctr_in = ~fifo_empty & pop_fifo;
   assign write_ctr_in = ~fifo_full & data_in_valid;
   
   counter_2bit read_ctr(.clk(clk), .rst(rst), .en(read_ctr_en), .ctr_rst(read_ctr_rst), .out(read_ptr), .err());
   counter_2bit write_ctr(.clk(clk), .rst(rst), .en(write_ctr_en), .ctr_rst(write_ctr_rst), .out(write_ptr), .err());

   //fifo_fsm_stage
   wire[1:0] curr_state;
   wire [1:0] next_state;
   dff fsm_stage[1:0](.q(curr_state),.d(next_state),.clk(clk),.rst(rst));

   fifo_fsm_logic fsm_logic(
      //input
      .read_ptr(read_ptr),
      .write_ptr(write_ptr),
      .rst(rst),
      .add_fifo(write_ctr_en),
      .pop_fifo(read_ctr_en),
      .state(curr_state),
      //output
      .next_state(next_state),
      .fifo_empty(empty_flag_in),
      .fifo_full(full_flag_in),
      .read_ctr_rst(read_ctr_rst),
      .write_ctr_rst(write_ctr_rst),
      .err()
   );

   //fifo regs
   wire [3:0] decode_out;

   decoder2_4 decoder(.in(write_ptr), .out(decode_out));
    
   and2 and_0(.out(en0), .in1(write_ctr_en), .in2(decode_out[0]));
   and2 and_1(.out(en1), .in1(write_ctr_en), .in2(decode_out[1]));
   and2 and_2(.out(en2), .in1(write_ctr_en), .in2(decode_out[2]));
   and2 and_3(.out(en3), .in1(write_ctr_en), .in2(decode_out[3]));

   register_64bit inst0(.readdata(reg_out0), .clk(clk), .rst(rst), .writedata(data_in) , .write(en0));
   register_64bit inst1(.readdata(reg_out1), .clk(clk), .rst(rst), .writedata(data_in) , .write(en1));
   register_64bit inst2(.readdata(reg_out2), .clk(clk), .rst(rst), .writedata(data_in) , .write(en2));
   register_64bit inst3(.readdata(reg_out3), .clk(clk), .rst(rst), .writedata(data_in) , .write(en3));

   mux4_1_64bit mux_out(.InA(reg_out0), .InB(reg_out1), .InC(reg_out2), .InD(reg_out3), .S(read_ptr), .Out(data_out));



<<<<<<< HEAD
   always @(negedge clk) begin
      $display("\n curr_state: %b next_state: %b, read_ctr_en: %b, write_ctr_en: %b", curr_state, next_state, read_ctr_en, write_ctr_en);
      $display("\n read_ctr: %d write_ctr: %d", read_ptr, write_ptr);
=======
   always @(posedge clk) begin
      $display("\n curr_state: %2d next_state: %2d, read_ctr_en: %b, write_ctr_en: %b", curr_state, next_state, read_ctr_en, write_ctr_en);
      $display("\n read_ctr: %2d write_ctr: %2d", read_ctr, write_ctr);
>>>>>>> parent of cfe13cd... ble ble

   end

endmodule
// DUMMY LINE FOR REV CONTROL :1:
