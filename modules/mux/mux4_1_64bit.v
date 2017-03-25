module mux4_1_64bit (InA, InB, InC, InD, S, Out);

	input [63:0] InA, InB, InC, InD;
	input [1:0] S;
	output [63:0] Out;

	mux4_1 inst[63:0] (.InA(InA), .InB(InB), .InC(InC), .InD(InD), .S(S), .Out(Out));

endmodule
