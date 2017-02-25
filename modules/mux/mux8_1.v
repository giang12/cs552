/* $Author: Giang Nguyen $ */
// CS/ECE 552

module mux8_1 (In0, In1, In2, In3, In4, In5, In6, In7, S, Out);

	input In0, In1, In2, In3, In4, In5, In6, In7;
	input [2:0] S;
	output Out;

	wire mux2_0_out, mux2_1_out;

	mux4_1 inst1(.InA(In0), .InB(In1), .InC(In2), .InD(In3), .S(S[1:0]), .Out(mux2_0_out));
	mux4_1 inst2(.InA(In4), .InB(In5), .InC(In6), .InD(In7), .S(S[1:0]), .Out(mux2_1_out));
	mux2_1 inst3(.InA(mux2_0_out), .InB(mux2_1_out), .S(S[2]), .Out(Out));

endmodule
