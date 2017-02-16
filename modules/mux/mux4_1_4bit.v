/* $Author: Giang Nguyen $ */
// CS/ECE 552
// 1/28/17

module mux4_1_4bit (InA, InB, InC, InD, S, Out);

	input [3:0] InA, InB, InC, InD;
	input [1:0] S;
	output [3:0] Out;

	mux4_1 inst[3:0] (.InA(InA), .InB(InB), .InC(InC), .InD(InD), .S(S), .Out(Out));

endmodule
