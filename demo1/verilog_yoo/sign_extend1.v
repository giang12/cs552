module sign_extend1 (in, en, out);

	input [4:0] in;
	input en;
	output [15:0] out;

	reg temp [15:0];

	
	assign temp = en? {{11{in[4]}}, in} : {11{0}, in};
	assign out = temp;

endmodule