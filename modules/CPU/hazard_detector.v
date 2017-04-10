module hazard_detector(
	// output 
	output stall,
	//inputs
	input [15:0] idex_Instr,
	input [15:0] ifid_Instr,
	input idex_MemRead
);
	
	assign stall = idex_MemRead & (
									(idex_Instr[7:5] == ifid_Instr[10:8]) | 
									(idex_Instr[7:5] == ifid_Instr[7:5])
								);
	// input [5:0] opcode;
	// input [1:0] opext;
	// input [2:0] pipe_if_id_regRs ,
	// 			pipe_if_id_regRt ,
	// 			pipe_id_ex_regRd ,
	// 			pipe_ex_mem_regRd,
	// 			pipe_mem_wb_regRd;
	// output 		stall;


	// localparam TRUE = 1'b1;
	// localparam FALSE = 1'b0;

	// /*
	// * instructions w/ 1 read registers
	// */
	// localparam addi = 7'b01000_xx; 
	// localparam subi = 7'b01001_xx; 
	// localparam xori = 7'b01010_xx; 
	// localparam andni = 7'b01011_xx; 
	// localparam roli = 7'b10100_xx; 
	// localparam slli = 7'b10101_xx; 
	// localparam rori = 7'b10110_xx; 
	// localparam srli = 7'b10111_xx; 
	// localparam ld = 7'b10001_xx;

	// localparam jal = 7'b00110_xx;
	// localparam jalr = 7'b00111_xx;


	// /*
	// * instructions w/ 2 read registers
	// */
	// localparam btr = 7'b11001_xx; 
	// localparam add = 7'b11011_00; 
	// localparam sub = 7'b11011_01; 
	// localparam xor = 7'b11011_10; 
	// localparam andn = 7'b11011_11; 
	// localparam rol = 7'b11010_00; 
	// localparam sll = 7'b11010_01; 
	// localparam ror = 7'b11010_10; 
	// localparam srl = 7'b11010_11;
	// localparam seq = 7'b11100_xx;
	// localparam slt = 7'b11101_xx;
	// localparam sle = 7'b11110_xx;
	// localparam sco = 7'b11111_xx;

	// localparam st = 7'b10000_xx;
	// localparam stu = 7'b10011_xx;

	// localparam sbi = 7'b10010_xx; 


	// /*
	// * branch isntructions
	// */
	// localparam beqz = 7'b01100_xx; 
	// localparam bnez = 7'b01101_xx; 
	// localparam bltz = 7'b01110_xx; 
	// localparam bgez = 7'b01111_xx; 

	// /*
	// * instructions w/ 0 read registers i.e. no hazards
	// */
		
	// localparam lbi = 7'b11000_xx; 	// are these needed at all since they are the default cases??

	// localparam j = 7'b00100_xx; 
	// localparam jr = 7'b00101_xx; 

	// localparam nop = 7'b00011_xx;

	// localparam halt = 7'b00000_xx; // should stall be done for this

	// /*4 CASES
	// - RAW 
	//    - 2 read reg
	//    - 1 read reg
	//    - 0 read reg (default)
	// - branch or halt
	// */

	// always @(opcode or opext) 
	// begin

	// 	casex({opcode, opext})

	// 		 // instructions w/ 1 read registers
	// 		 addi:
	// 	 	 subi:
	// 		 xori:
	// 	 	 andni:
	// 	 	 roli:
	// 	 	 slli: 
	// 	 	 rori:  
	// 	 	 srli:  
	// 	 	 ld:
	// 	 	 jal:
	// 	 	 jalr:
	// 	 	 begin
	// 	 	    // ***** let it be bitwise or do not change to logical or
	// 	 	 	stall = ((pipe_if_id_regRs == pipe_id_ex_regRd)  | 
	// 	 	 			 (pipe_if_id_regRs == pipe_ex_mem_regRd)) ? 
	// 	 	 			 TRUE: FALSE; 	 
	// 	 	 end

	// 	 	 // instructions w/ 2 read registers
	// 		 btr:
	// 		 add:
	// 	 	 sub:
	// 		 xor:
	// 	 	 andn:
	// 	 	 rol:
	// 	 	 sll: 
	// 	 	 ror:  
	// 	 	 srl:  
	// 	 	 seq:
	// 	 	 slt:
	// 	 	 sle:
	// 	 	 sco:
	// 	 	 st:
	// 	 	 stu:
	// 	 	 sbi:
	// 	 	 begin
	// 	 	    // ***** let it be bitwise or do not change to logical or
	// 	 	 	stall = ((pipe_if_id_regRs == pipe_id_ex_regRd)  | 
	// 	 	 			 (pipe_if_id_regRt == pipe_id_mex_regRd) | 
	// 	 	 			 (pipe_if_id_regRs == pipe_ex_mem_regRd) | 
	// 	 	 			 (pipe_if_id_regRt == pipe_ex_mem_regRd)) ? 
	// 	 	 			 TRUE: FALSE; 	 
	// 	 	 end

 //  			// branch instructions
 //  			beqz: 
	// 	    bnez: 
	//  		bltz: 
	//  		bgez:
	// 		begin
	// 			stall = TRUE; 
	// 		end
			
	// 		halt:
	// 		begin 
	// 			stall =  TRUE;  // is this needed or should halt proceed without the aid of hazard unit???
	// 		end
			
	// 		// instructions w/ no hazard j, jr halt, noop
	// 		default: 
	// 		begin
	// 			stall = FALSE;
	// 		end
	
	// 	endcase
	// end
endmodule

