module inverter_16bit(in, inv, out);
	input [15:0] in;
	input inv;
	output [15:0] out;


	inverter inst[15:0](.in(in), .inv(inv), .out(out));

endmodule