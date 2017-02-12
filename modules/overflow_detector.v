module overflow_detector(msbA, msbB, msbS, Cout, Sign, Ofl);
	
	input msbA, msbB, msbS, Cout, Sign;
	output Ofl;

	assign Ofl = (~Sign & Cout) //unsigned add
				|(~msbS & msbA & msbB & Sign) //positve Sum from 2 negative addends 
				|(msbS	& ~msbA & ~msbB & Sign); //negative Sum from 2 positive addends 

endmodule

