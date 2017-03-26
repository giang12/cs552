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
  assign err = ctr_err;
  
  wire writeEn, readEn, ctr_err;
 
  // counters 
  wire [2:0] read_ctr, write_ctr;
  wire [1:0] read_ctr_op, write_ctr_op;//counters control msb->rst lsb->en

  wire [1:0] read_ptr, write_ptr;

  fifo_counter ctr(
    //input
    .rd_ctr_op(read_ctr_op),
    .wd_ctr_op(write_ctr_op),
    .clk(clk),
    .rst(rst),
    //output
    .rd_ctr(read_ctr),
    .wd_ctr(write_ctr),
    .err(ctr_err)
  );

  fifo_controlla ctrl(
    //input
    .clk(clk),
    .rst(rst),
    .read_ctr(read_ctr),
    .write_ctr(write_ctr),
    .add_fifo(data_in_valid),
    .pop_fifo(pop_fifo),
    //output
    .inc_read_ctr(read_ctr_op[0]),
    .inc_write_ctr(write_ctr_op[0]),
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
