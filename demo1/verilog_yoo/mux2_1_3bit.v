module mux2_1_3bit (InA, InB, S, Out);

	input [2:0] InA, InB;
	input S;
	output [2:0] Out;

	mux2_1 inst[2:0] (.InA(InA), .InB(InB), .S(S), .Out(Out));

endmodule