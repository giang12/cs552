module bin2gray_2bit(
	input [1:0] in,
	output [1:0] out
);

	wire q0; 
	//bin2gray 2bit
   assign q0 = in[1] ^ in[0];
   assign out = {in[1], q0};

endmodule
