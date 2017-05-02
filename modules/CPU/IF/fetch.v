module fetch(instr, pcCurrent, pcPlusTwo, address, flush, en, clk, rst);

	input clk, rst, flush, en;
	input [15:0] address;

	output [15:0] instr, pcCurrent, pcPlusTwo;
    wire [15:0] next_pc, mem_data_out;

    wire Done, Stall, CacheHit, err;

	assign instr =	Done ? mem_data_out :
					err ? 16'b0 : 16'b0000100000000000;

    mux2_1_16bit pc_next_mux(	
    	.InA(pcPlusTwo),
		.InB(address), 
		.S(flush), 
		.Out(next_pc)
	);

	PC pc0(
		//output
		.pcCurrent(pcCurrent),
		.pcNext(pcPlusTwo),
		//input
		.instrLen(4'h2), //pc + 2 bytes
		.set(next_pc),
		.en(en & (Done | flush)), //increment PC when done reading valid instr OR force branch(reading new instr)
		.clk(clk),
		.rst(rst)
	);
	
	mem_system InstrMEM(
	   // Outputs
	   .DataOut(mem_data_out), .Done(Done), .Stall(Stall), .CacheHit(CacheHit), .err(err), 
	   // Inputs
	   .Addr(pcCurrent), .DataIn(16'b0), .Rd(1'b1), .Wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst)
	);

	// //instr mem	
	// memory2c InstrMEM(
	// 	.data_out(mem_data_out),
	// 	.data_in(16'b0),
	// 	.addr(pcCurrent), 
	// 	.enable(1'b1), 
	// 	.wr(1'b0), 
	// 	.createdump(1'b0), //on halt ?
	// 	.clk(clk), 
	// 	.rst(rst)
	// );
endmodule