module fifo_controlla(
   clk,
	rst,
   read_ctr,
   write_ctr,
   add_fifo,
   pop_fifo,

   inc_read_ctr,
   inc_write_ctr,
   writeEn,
   readEn,
   fifo_empty,
   fifo_full
); 

   input [2:0] read_ctr, write_ctr;
   input clk, rst, add_fifo, pop_fifo;

   output reg  inc_read_ctr,
               inc_write_ctr,

               writeEn,
               readEn;
   output wire fifo_empty,
               fifo_full;

   localparam true = 1'b1;
   localparam false = 1'b0;

   assign fifo_empty = read_ctr == write_ctr;
   assign fifo_full  = (write_ctr[2] != read_ctr[2]) & (write_ctr[1:0] == read_ctr[1:0]);
   reg pop;
   //or add_fifo or pop_fifo
	//FSM stage logic
	always @(posedge clk) begin

      inc_read_ctr   <= pop; //add commit
      inc_write_ctr  <= writeEn;  //pop commit

      readEn   <= ~fifo_empty;
      writeEn  <= ~fifo_full & add_fifo;
      pop      <= ~fifo_empty & pop_fifo;

   end


endmodule
