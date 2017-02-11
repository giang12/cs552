
module cla(A, B, Cin, S, G, P)

	input A, B, Cin;
	output S, G, P;

	wire w1;

	//compute SUM
	xor2 inst1(.in1(A), .in2(B), .out(w1));
	xor2 inst2(.in1(w1), .in2(Cin), .out(S));

	//compute Generate and Propagate
	and2 inst3(.in1(A), .in2(B), .out(G)); //both 1 to generate carry
	or2 inst4(.in1(A), .in2(B), .out(P)); //one or both 1s to propagate carry
endmodule