module mux2_1_64bit (InA, InB, S, Out);

	input [63:0] InA, InB;
	input S;
	output [63:0] Out;

	mux2_1 inst[63:0] (.InA(InA), .InB(InB), .S(S), .Out(Out));

endmodule
