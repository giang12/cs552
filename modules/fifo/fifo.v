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
  wire writeEn, readEn, inc_read_ctr, inc_write_ctr, ctr_err;
 
  // counters pointers
  wire [2:0] read_ctr, write_ctr;
  wire [1:0] read_ptr, write_ptr;
  
  assign err = ctr_err;

  fifo_counter ctr(
    //input
    .rd_ctr_op({1'b0, inc_read_ctr}),
    .wd_ctr_op({1'b0, inc_write_ctr}),
    .clk(clk),
    .rst(rst),
    //output
    .rd_ctr(read_ctr),
    .wd_ctr(write_ctr),
    .err(ctr_err)
  );

  fifo_controlla ctrl(
    //input
    .read_ctr(read_ctr),
    .write_ctr(write_ctr),
    .add_fifo(data_in_valid),
    .pop_fifo(pop_fifo),
    //output
    .inc_read_ctr(inc_read_ctr),
    .inc_write_ctr(inc_write_ctr),
    .read_ptr(read_ptr),
    .write_ptr(write_ptr),
    .writeEn(writeEn),
    .readEn(readEn),
    .fifo_empty(fifo_empty),
    .fifo_full(fifo_full)
  );

  fifo_mem mem(
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .write(writeEn),
    .read(readEn),
    .write_ptr(write_ptr),
    .read_ptr(read_ptr),
    //output
    .data_out(data_out)
  );

endmodule

// DUMMY LINE FOR REV CONTROL :1:
