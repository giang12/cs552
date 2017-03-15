module fetch(instr, pcCurrent, pcPlusTwo, address, halt, clk, rst);

	input clk, rst, halt;
	input [15:0] address;

	output [15:0] instr, pcCurrent, pcPlusTwo;
    wire [15:0] next_pc;

    mux2_1_16bit pc_next_mux(	
    	.InA(address), 
		.InB(pcCurrent), 
		.S(halt), 
		.Out(next_pc)
	);

	PC pc0(
		//output
		.pcCurrent(pcCurrent),
		.pcNext(pcPlusTwo),
		//input
		.instrLen(4'h2), //pc + 2 bytes
		.set(next_pc),
		.clk(clk),
		.rst(rst)
	);

	//instr mem	
	memory2c InstrMEM(	
		.data_out(instr),
		.data_in(16'b0),
		.addr(pcCurrent), 
		.enable(1'b1), 
		.wr(1'b0), 
		.createdump(1'b0), //on halt ?
		.clk(clk), 
		.rst(rst)
	);

	


endmodule