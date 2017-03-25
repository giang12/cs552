module decoder2_4(in, out);
	
	input [1:0] in;
	output [3:0] out;

	and2 out0(.in1(~in[1]), .in2(~in[0]), .out(out[0])); //00
	and2 out1(.in1(~in[1]), .in2(in[0]), .out(out[1])); //01
	and2 out2(.in1(in[1]), .in2(~in[0]), .out(out[2])); //10
	and2 out3(.in1(in[1]), .in2(in[0]), .out(out[3])); //11


endmodule
