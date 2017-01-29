/* $Author: Giang Nguyen $ */
// CS/ECE 552
// 1/28/17

module fulladder1(input A, input B, input Cin, output S, output Cout);


wire w1,w2,w3;

xor2 inst1(.in1(A), .in2(B), .out(w1));
nand2 inst2(.in1(A), .in2(B), .out(w2));

nand2 inst3(.in1(Cin), .in2(w1), .out(w3));

xor2 inst4(.in1(w1), .in2(Cin), .out(S));
nand2 inst5(.in1(w3), .in2(w2), .out(Cout));

endmodule
