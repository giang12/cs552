module alu_cond_set(
	output EQZ,
	output GEZ,
	output LTZ,
	output LEZ,
	output NEZ,
	input Ofl,
	input Z,
	input msb,
	input sign
	);
assign EQZ = Z;

wire ofl_n, signout;

not1 inst0(.in1(Z), .out(NEZ)); //not equal zero

not1 inst4(.in1(Ofl), .out(ofl_n));

and2 inst1(.in1(msb), .in2(sign), .out(signout));

assign LTZ = (signout & ofl_n) | (~signout & Ofl);

or2	inst2(.in1(Z), .in2(LTZ), .out(LEZ));
not1 inst3(.in1(LTZ), .out(GEZ));

endmodule

