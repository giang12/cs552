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
   wire [63:0] reg_out, elm0, elm1, elm2, elm3;
   //decode write signals
   decoder2_4 decoder(.in(write_ptr), .out(selected_elm));    
   and2 add_or_nah[3:0](.out(en), .in1(add), .in2(selected_elm));

   //memaccess
   register_64bit cell0(.readdata(elm0), .clk(clk), .rst(rst), .writedata(data_in), .write(en[0]));
   register_64bit cell1(.readdata(elm1), .clk(clk), .rst(rst), .writedata(data_in), .write(en[1]));
   register_64bit cell2(.readdata(elm2), .clk(clk), .rst(rst), .writedata(data_in), .write(en[2]));
   register_64bit cell3(.readdata(elm3), .clk(clk), .rst(rst), .writedata(data_in), .write(en[3]));

    //data out
   mux4_1_64bit mux_out(.InA(elms[0]), .InB(elms[1]), .InC(elms[2]), .InD(elms[3]), .S(read_ptr), .Out(reg_out));

   assign data_out = read ? reg_out : 63'b0;

endmodule