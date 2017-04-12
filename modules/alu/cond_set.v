/**
 * Extended Conditional Code Flags
 */
module cond_set(
	EQ, NE, HS, LO, MI, PL, VS, VC, HI, LS, GE, LT, GT, LE, AL,
	V, C, N, Z
	);
/** Taken From https://community.arm.com/processors/b/blog/posts/condition-codes-1-condition-flags-and-codes 
			Code		Meaning (for cmp or subs)	Flags Tested 
**/
	output 	EQ,//			Equal.	Z==1
			NE,//			Not equal.	Z==0
			HS,//	 or cs	Unsigned higher or same (or carry set).	C==1
			LO,//	 or cc	Unsigned lower (or carry clear).	C==0
			MI,//			Negative. The mnemonic stands for "minus".	N==1
			PL,//			Positive or zero. The mnemonic stands for "plus".	N==0
			VS,//			Signed overflow. The mnemonic stands for "V set".	V==1
			VC,//			No signed overflow. The mnemonic stands for "V clear".	V==0
			HI,//			Unsigned higher.	(C==1) && (Z==0)
			LS,//			Unsigned lower or same.	(C==0) || (Z==1)
			GE,//			Signed greater than or equal.	N==V
			LT,//			Signed less than.	N!=V
			GT,//			Signed greater than.	(Z==0) && (N==V)
			LE,//			Signed less than or equal.	(Z==1) || (N!=V)
			AL; //			(or omitted)	Always executed.	None tested.
	input	V, C, N, Z;

	assign EQ = Z;
	not1 inst0(.in1(Z), .out(NE));

	assign HS = C;
	not1 inst1(.in1(C), .out(LO));

	assign MI = N;
	not1 inst2(.in1(N), .out(PL));

	assign VS = V;
	not1 inst3(.in1(V), .out(VC));

	assign HI = C & (~Z);

	assign LS = ~C | Z;

	assign GE = N == V;

	assign LT = N != V;

	assign GT = ~Z & (N==V);

	assign LE = Z | (N!=V);

	assign AL = 1'b1;

endmodule

