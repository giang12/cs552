module fifo_controlla(
   read_ctr,
   write_ctr,
   add_fifo,
   pop_fifo,
   inc_read_ctr,
   inc_write_ctr,
   read_ptr,
   write_ptr,
   writeEn,
   readEn,
   fifo_empty,
   fifo_full
);

   input [2:0] read_ctr, write_ctr;
   input add_fifo, pop_fifo;

   output inc_read_ctr, inc_write_ctr, writeEn, readEn, fifo_empty, fifo_full;
   output [1:0] read_ptr, write_ptr;

   assign fifo_empty = read_ctr == write_ctr;
   assign fifo_full  = (write_ctr[2] != read_ctr[2]) & (write_ctr[1:0] == read_ctr[1:0]);

   assign read_ptr  = read_ctr[1:0];
   assign write_ptr = write_ctr[1:0];

   assign readEn = ~fifo_empty;
   assign writeEn = ~fifo_full & add_fifo;
   
   assign inc_read_ctr   = ~fifo_empty & pop_fifo;
   assign inc_write_ctr  = writeEn;

endmodule
