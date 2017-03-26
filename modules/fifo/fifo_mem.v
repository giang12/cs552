module fifo_mem(
	input clk,
	input rst,
	input [63:0] data_in,
	input [1:0] write_ptr,
	input [1:0] read_ptr,
	input write,
	input read,
	output [63:0] data_out
);

	//fifo regs
   wire [3:0] selected_elm, en;
   wire [63:0] reg_out;
   wire [63:0] elms[3:0];
   //decode write signals
   decoder2_4 decoder(.in(write_ptr), .out(selected_elm));    
   and2 add_or_nah[3:0](.out(en), .in1(add), .in2(selected_elm));

   //memaccess
   register_64bit array[3:0](.readdata(elms), .clk(clk), .rst(rst), .writedata(data_in), .write(en));

    //data out
   mux4_1_64bit mux_out(.InA(elms[0]), .InB(elms[1]), .InC(elms[2]), .InD(elms[3]), .S(read_ptr), .Out(reg_out));

   assign data_out = read ? reg_out : 63'b0;
   
endmodule
