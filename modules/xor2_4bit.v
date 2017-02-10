
module xor2_4bit (in1,in2,out);
	input [3:0] in1,in2;
	output [3:0] out;

	xor2 inst[3:0] (.in1(in1), .in2(in2), .out(out));

endmodule

