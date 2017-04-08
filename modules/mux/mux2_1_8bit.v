module mux2_1_8bit (InA, InB, S, Out);

	input [7:0] InA, InB;
	input S;
	output [7:0] Out;

	mux2_1 inst[7:0] (.InA(InA), .InB(InB), .S(S), .Out(Out));

endmodule
