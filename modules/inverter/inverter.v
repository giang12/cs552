module inverter(in, inv, out);
	input in, inv;
	output out;

	wire in_inv;

	not1 inst1(.in1(in), .out(in_inv));

	assign out = inv ? in_inv : in;

endmodule