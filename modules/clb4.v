
module clb4(Cin, Gin, Pin, Cout, Gout, Pout);
	input Cin;
	input [3:0] Gin, Pin;
	output [3:0] Cout;
	output Gout, Pout;


	assign Gout = Gin[3] | (Pin[3] & Gin[2]) | (Pin[3] & Pin[2] & Gin[1]) | (Pin[3] & Pin[2] & Pin[1] & Gin[0]);
	assign Pout = Pin[3] & Pin[2] & Pin[1] & Pin[0];

	assign Cout[0] = Gin[0] | (Pin[0] & Cin);
	assign Cout[1] = Gin[1] | (Pin[1] & Gin[0]) | (Pin[1] & Pin[0] & Cin);
	assign Cout[2] = Gin[2] | (Pin[2] & Gin[1]) | (Pin[2] & Pin[1] & Gin[0]) | (Pin[2] & Pin[1] & Pin[0] & Cin);

	assign Cout[3] = Gout | (Pout & Cin);

	//Gin[3] | (Pin[3] & Gin[2]) | (Pin[3] & Pin[2] & Gin[1]) | (Pin[3] & Pin[2] & Pin[1] & Gin[0]) | (Pin[3] & Pin[2] & Pin[1] & Pin[0] & Cin);

endmodule