module fifo_counter(
	input [1:0] rd_ctr_op,
	input [1:0] wd_ctr_op,
	input clk,
	input rst,
	output [2:0] rd_ctr,
	output [2:0] wd_ctr,
	output err
);
	wire rd_err, wd_err;
	assign err = rd_err | wd_err;
   
   up_counter_3bit fifo_rd_ctr(.clk(clk), .rst(rst), .ctr_en(rd_ctr_op[0]), .ctr_rst(rd_ctr_op[1]), .out(rd_ctr), .err(rd_err));
   up_counter_3bit fifo_wr_ctr(.clk(clk), .rst(rst), .ctr_en(rd_ctr_op[0]), .ctr_rst(rd_ctr_op[1]), .out(wd_ctr), .err(wd_err));

endmodule
