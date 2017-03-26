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
   wire fifo_empty, fifo_full, writeEn, readEn, err;
   // pointers 
   wire [2:0] read_ctr, write_ctr;
   wire [1:0] read_ptr, write_ptr;
   assign read_ptr  = read_ctr[1:0];
   assign write_ptr = write_ctr[1:0];

   //counters
   wire en_read_ctr, en_write_ctr, rst_read_ctr, rst_write_ctr;
   up_counter_3bit ctr(.clk(clk), .rst(rst), .en(en_read_ctr), .ctr_rst(rst_read_ctr), .out(read_ctr), .err());
   up_counter_3bit ctr1(.clk(clk), .rst(rst), .en(en_write_ctr), .ctr_rst(rst_write_ctr), .out(write_ctr), .err());

   fifo_controlla ctrl(
      //input
      .clk(clk),
      .rst(rst),
      .read_ctr(read_ctr),
      .write_ctr(write_ctr),
      .add_fifo(data_in_valid),
      .pop_fifo(pop_fifo),
      //sync output
      .inc_read_ctr(en_read_ctr),
      .inc_write_ctr(en_write_ctr),

      .writeEn(writeEn),
      .readEn(readEn),
      //async output
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

   always @(posedge clk) begin
      $display("\n writeEn: %d readEn: %d", writeEn, readEn);
      $display("\n read_ctr: %d write_ctr: %d", read_ctr, write_ctr);
   end

endmodule

// DUMMY LINE FOR REV CONTROL :1:
