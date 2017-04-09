module regIFID(
	flush, en, clk, rst,
	instr_in, pcCurrent_in, pcPlusTwo_in,
	instr_out, pcCurrent_out, pcPlusTwo_out
);
	input [15:0] instr_in, pcCurrent_in, pcPlusTwo_in;
	
	input flush, en, clk, rst;

	output [15:0] instr_out, pcCurrent_out, pcPlusTwo_out;

	wire [15:0] instr;
	assign instr = (flush | rst) ? 16'b00001_xxxxxxxxxxx : instr_in; //NOP bubble on rst or flush

	register_16bit inst0(.readdata(instr_out), .clk(clk), .rst(rst), .writedata(instr), .write(en));
	register_16bit inst1(.readdata(pcCurrent_out), .clk(clk), .rst(rst), .writedata(pcCurrent_in), .write(en));
	register_16bit inst2(.readdata(pcPlusTwo_out), .clk(clk), .rst(1'b0), .writedata(pcPlusTwo_in), .write(en));

endmodule