
module xor2_16bit (in1,in2,out);
	input [15:0] in1,in2;
	output [15:0] out;

	xor2 inst[15:0] (.in1(in1), .in2(in2), .out(out));

endmodule

