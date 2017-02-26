
module xor2_3bit (in1,in2,out);
	input [2:0] in1,in2;
	output [2:0] out;

	xor2 inst[2:0] (.in1(in1), .in2(in2), .out(out));

endmodule

