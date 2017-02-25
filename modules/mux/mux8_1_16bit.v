/* $Author: Giang Nguyen $ */
// CS/ECE 552

module mux8_1_16bit(In0, In1, In2, In3, In4, In5, In6, In7, S, Out);

	input [15:0] In0, In1, In2, In3, In4, In5, In6, In7;
	input [2:0] S;
	output [15:0] Out;

	mux8_1 inst[15:0] (.In0(In0), .In1(In1), .In2(In2), .In3(In3), .In4(In4), .In5(In5), .In6(In6), .In7(In7), .S(S), .Out(Out));


endmodule
