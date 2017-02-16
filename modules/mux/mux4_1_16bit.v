module mux4_1_16bit (InA, InB, InC, InD, S, Out);

	input [15:0] InA, InB, InC, InD;
	input [1:0] S;
	output [15:0] Out;

	mux4_1 inst[15:0] (.InA(InA), .InB(InB), .InC(InC), .InD(InD), .S(S), .Out(Out));



endmodule
