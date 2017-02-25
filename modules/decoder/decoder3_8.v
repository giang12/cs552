module decoder3_8 (in, out);

	input [2:0] in;
	output [7:0] out;

	and3 inst0(.in1(~in[2]), .in2(~in[1]), .in3(~in[0]), .out(out[0]));
	and3 inst1(.in1(~in[2]), .in2(~in[1]), .in3(in[0]), .out(out[1]));
	and3 inst2(.in1(~in[2]), .in2(in[1]), .in3(~in[0]), .out(out[2]));
	and3 inst3(.in1(~in[2]), .in2(in[1]), .in3(in[0]), .out(out[3]));
	and3 inst4(.in1(in[2]), .in2(~in[1]), .in3(~in[0]), .out(out[4]));
	and3 inst5(.in1(in[2]), .in2(~in[1]), .in3(in[0]), .out(out[5]));
	and3 inst6(.in1(in[2]), .in2(in[1]), .in3(~in[0]), .out(out[6]));
	and3 inst7(.in1(in[2]), .in2(in[1]), .in3(in[0]), .out(out[7]));
endmodule
