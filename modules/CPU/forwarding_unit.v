module forwarding_unit(
	output [1:0] forwardA,
	output [1:0] forwardB,
	input [15:0] idex_Instr,
	input exmem_RegWriteEn,
	input [2:0] exmem_RegD,
	input memwb_RegWriteEn,
	input [2:0] memwb_RegD
);
/** 
 1. EX hazard:
	if (EX/MEM.RegWrite
	and (EX/MEM.RegisterRd ≠ 0)
	and (EX/MEM.RegisterRd = ID/EX.RegisterRs)) ForwardA = 10
	
	if (EX/MEM.RegWrite
	and (EX/MEM.RegisterRd ≠ 0)
	and (EX/MEM.RegisterRd = ID/EX.RegisterRt)) ForwardB = 10

2. MEM hazard:
	if (MEM/WB.RegWrite
	and (MEM/WB.RegisterRd ≠ 0)
	and ( MEM/WB.RegisterRd = ID/EX.RegisterRs)) ForwardA = 01

	if (MEM/WB.RegWrite
	and (MEM/WB.RegisterRd ≠ 0)
	and (MEM/WB.RegisterRd = ID/EX.RegisterRt)) ForwardB = 01
 */

assign forwardA = exmem_RegWriteEn & (exmem_RegD == idex_Instr[10:8]) ? 2'b10 :
				  memwb_RegWriteEn & (memwb_RegD == idex_Instr[10:8]) ? 2'b01 : 2'b00;



assign forwardB = exmem_RegWriteEn & (exmem_RegD == idex_Instr[7:5]) ? 2'b10 :
				  memwb_RegWriteEn & (memwb_RegD == idex_Instr[7:5]) ? 2'b01 : 2'b00;




endmodule