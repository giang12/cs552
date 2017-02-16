module mux2_1_16bit (InA, InB, S, Out);

	input [15:0] InA, InB;
	input S;
	output [15:0] Out;

	mux2_1 inst[15:0] (.InA(InA), .InB(InB), .S(S), .Out(Out));

endmodule
