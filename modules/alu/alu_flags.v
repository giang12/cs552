/**
 * Standard ALU Conditional Code Flags
 * N(egative)
 * Z(ero)
 * V(flow)
 * C(carry)
 */
module alu_flags(
	output N,
	output Z,
	output V,
	output C,
	input [15:0] inA,
	input [15:0] inB,
	input [15:0] Result,
	input G,
	input P,
	input Cin,
	input Sign
	);
	
	//C
	assign C = G | (P & Cin);

    //N 
    and2 inst1(.in1(Result[15]), .in2(Sign), .out(N));

    //Z
    nor16 inst7(.in(Result), .out(Z));

    //V 
    overflow_detector inst8(.msbA(inA[15]), .msbB(inB[15]), .msbS(Result[15]), .Carry(C), .Sign(Sign), .Ofl(V));

endmodule
