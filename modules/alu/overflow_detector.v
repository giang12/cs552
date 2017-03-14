module overflow_detector(msbA, msbB, msbS, Carry, Sign, Ofl);
	
	input msbA, msbB, msbS, Carry, Sign;
	output Ofl;

	assign Ofl = (~Sign & Carry) //unsigned add
				|(~msbS & msbA & msbB & Sign) //positve Sum from 2 negative addends 
				|(msbS	& ~msbA & ~msbB & Sign); //negative Sum from 2 positive addends 

endmodule

