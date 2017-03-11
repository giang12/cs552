module control_unit inst1 (opcode, fn, regS, regD, alu_op, alu_src, btr_sel, branch, jump, sign_ext, memread, memwrite, regwrite, flag_cond, lbi_sel, slbi_sel, memtoreg, halt);
	
	input [4:0] opcode;
	input [1:0] fn;
	
	output [2:0] alu_op;
	output regS, regD, 
		   alu_src,
		   branch, jump, 
		   sign_ext, 
		   memread, memwrite, regwrite, memtoreg, 
		   flag_cond, 
		   btr_sel, lbi_sel, slbi_sel, 
		   halt;

    reg    [2:0] alu_op;
    reg    regS, regD, 
		   alu_src,
		   branch, jump, 
		   sign_ext, 
		   memread, memwrite, regwrite, memtoreg, 
		   flag_cond, 
		   btr_sel, lbi_sel, slbi_sel, 
		   halt;

	always @(opcode) begin
		case(opcode)
			5'b001: begin
	   			Cin_reg = 1; 
	   			invB_reg = 1;
	   		end
      		3'b011: begin
	  			invB_reg = 1;
	      	end
	      	default: begin
	      		Cin_reg = 0;
	   			invB_reg = 0;
	      	end
		endcase
	end   

	assign invA = 0;
	assign invB = invB_reg;
	assign Cin = Cin_reg;


	/*

	*/

endmodule