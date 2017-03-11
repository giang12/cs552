module sign_extend2 (in, en, out);

	input [7:0] in;
	input en;
	output [15:0] out;

	reg temp [15:0];

	assign temp = en? {{8{in[7]}}, in} : {8{0}, in};
	assign out = temp;

endmodule