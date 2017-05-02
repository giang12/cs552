module regIFID(
	flush, en, clk, rst,
	instr_in, pcCurrent_in, pcPlusTwo_in,
	instr_out, pcCurrent_out, pcPlusTwo_out
);
	input [15:0] instr_in, pcCurrent_in, pcPlusTwo_in;
	
	input flush, en, clk, rst;

	output [15:0] instr_out, pcCurrent_out, pcPlusTwo_out;

	wire [15:0] next_instr = (flush | rst) ? 16'b0000100000000000 : instr_in; //NOP bubble on rst or flush
	
	//overwrite reset behavior
	register_16bit inst0(.readdata(instr_out), .clk(clk), .rst(1'b0), .writedata(next_instr), .write(en));
	
	register_16bit inst1(.readdata(pcCurrent_out), .clk(clk), .rst(rst), .writedata(pcCurrent_in), .write(en));
	register_16bit inst2(.readdata(pcPlusTwo_out), .clk(clk), .rst(rst), .writedata(pcPlusTwo_in), .write(en));

endmodule
