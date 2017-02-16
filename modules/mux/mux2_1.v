/* $Author: Giang Nguyen $ */
// CS/ECE 552
// 1/28/17

module mux2_1 (InA, InB, S, Out);

	input InA, InB, S;
	output Out;

	wire S_n, w1,w2,w3;

	not1 inst1(.in1(S), .out(S_n));

	nand2 inst2(.in1(S_n), .in2(InA), .out(w1));

	nand2 inst3(.in1(S), .in2(InB), .out(w2));

	nand2 inst4(.in1(w1), .in2(w2), .out(Out));

endmodule
