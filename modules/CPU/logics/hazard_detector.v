module hazard_detector(
	// output 
	output stall,
	//inputs
	input [15:0] ifid_Instr,
	input [15:0] idex_Instr,
	input idex_MemRead,
	input idex_MemWr
);	

	//data hazard Stall
	assign stall = idex_MemRead & ~idex_MemWr & (
													(idex_Instr[7:5] == ifid_Instr[10:8]) | 
													(idex_Instr[7:5] == ifid_Instr[7:5])
												) ? 1'b1: 1'b0;
endmodule

