module control_unit(  
	//input
	opcode,
	fn,

	// outputs 
    RegDst,
    RegDataSrcSel, 
    RegWriteEn, 


    MemEn, 
    MemWr, 

    SignedExt,  
    Branch, 
    Jump, 
    Exception, 

    alu_b_sel,
    alu_op, 
    Cin, 
    invA, 
    invB,
    sign
    );

		//input
	input [4:0] opcode;
	input [1:0] fn;

	// outputs 
    output [1:0] RegDst;
    output [2:0] RegDataSrcSel;
    output RegWriteEn;


    output MemEn;
    output MemWr; 

    output SignedExt;
    output Branch;
    output Jump;
    output Exception;

    output [1:0] alu_b_sel;
    output [2:0] alu_op;
    output Cin;
    output invA; 
    output invB;
    output sign;

	reg [2:0] alu_op;
    reg	[1:0] RegDst;
    reg [1:0] alu_b_sel;
    reg [2:0] RegDataSrcSel;
    reg RegWriteEn, 
    	MemEn, 
    	MemWr,
    	SignedExt,
    	Branch,
    	Jump,
    	Exception,
    	Cin,
    	invA,
    	invB,
    	sign;
	// RegDst
	localparam rd = 2'b00;
	localparam rt = 2'b01;
	localparam rs = 2'b10;
	localparam r7 = 2'b11;

	// ALU functions (taken from alu.v)
	localparam rll = 3'b000;
	localparam sll = 3'b001;
	localparam sra = 3'b010;
	localparam srl = 3'b011;
	localparam ADD = 3'b100;
	localparam OR =  3'b101;
	localparam XOR = 3'b110;
	localparam AND = 3'b111;

	//alu b selec (taken from execute.v)
	localparam sel_data = 2'b00;
	localparam sel_imm = 2'b01;
    localparam sel_zero = 2'b10;

	//writeback DataSrcSel (taken from writeback.v)
	localparam mem_data_out = 3'b000;
    localparam alu_out = 3'b001;
	localparam imm_8_ext = 3'b010;
	localparam slbi_out = 3'b011;
	localparam btr_out = 3'b100;
	localparam pc_plus_two = 3'b101;
	localparam cond_out = 3'b110;
	localparam constant = 3'b111;

	localparam TRUE = 1'b1;
	localparam FALSE = 1'b0;


always @ (opcode or fn)
begin
    casex({opcode, fn})
	  
	  //1: ADDI Rd, Rs, immediate
	  7'b01000_xx:
	  begin
	    RegDst <= rt;
	    RegDataSrcSel <= alu_out;
	    RegWriteEn <= TRUE;
	   	alu_b_sel <= sel_imm;
	    alu_op <= ADD;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= TRUE;
	   	MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= TRUE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end
	  
	  //2: SUBI Rd, Rs, immediate
	  7'b01001_xx:
	  begin
	    RegDst <= rt;
	    RegDataSrcSel <= alu_out;
	    RegWriteEn <= TRUE;
	    alu_b_sel <= sel_imm;
	   	alu_op <= ADD;
	    Cin <= TRUE;
	    invA <= TRUE;
	    invB <= FALSE;
	    sign <= TRUE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= TRUE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end

	  //3: XORI Rd, Rs, immediate
	  7'b01010_xx:
	  begin
	    RegDst <= rt;
	    RegDataSrcSel <= alu_out;
	    RegWriteEn <= TRUE;
	    alu_b_sel <= sel_imm;
	    alu_op <= XOR;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= FALSE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= FALSE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end

	  //4: ANDNI Rd, Rs, immediate	
	  7'b01011_xx:
	  begin
	    RegDst <= rt;
	    RegDataSrcSel <= alu_out;
	    RegWriteEn <= TRUE;
	    alu_b_sel <= sel_imm;
	    alu_op <= AND;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= TRUE;
	    sign <= FALSE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= FALSE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end

	  //5: ROLI Rd, Rs, immediate
	  7'b10100_xx:
	  begin
	    RegDst <= rt;
	    RegDataSrcSel <= alu_out;
	    RegWriteEn <= TRUE;
	    alu_b_sel <= sel_imm;
	    alu_op <= rll;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= FALSE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= FALSE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end

	  //6: SLLI Rd, Rs, immediate	
	  7'b10101_xx:
	  begin
	    RegDst <= rt;
	    RegDataSrcSel <= alu_out;
	    RegWriteEn <= TRUE;
	    alu_b_sel <= sel_imm;
	    alu_op <= sll;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= FALSE;
	   	MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= FALSE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end

	  //7: RORI Rd, Rs, immediate	
	  // we have to implement this instruction in ALU
	  7'b10110_xx:
	  begin
	    RegDst <= rt;
	    RegDataSrcSel <= alu_out;
	   	RegWriteEn <= TRUE;
	    alu_b_sel <= sel_imm;
	   	alu_op <= sra; //wrong
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= FALSE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= FALSE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end

	  //8: SRLI Rd, Rs, immediate	
	  7'b10111_xx:
	  begin
	    RegDst <= rt;
	    RegDataSrcSel <= alu_out;
	   	RegWriteEn <= TRUE;
	    alu_b_sel <= sel_imm;
	    alu_op <= srl;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= FALSE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= FALSE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end

	  //9: ST Rd, Rs, immediate
	  7'b10000_xx:
	  begin
	    RegDst <= rt;
	    RegDataSrcSel <= alu_out;
	   	RegWriteEn <= FALSE;
	    alu_b_sel <= sel_imm;
	    alu_op <= ADD;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= TRUE;
	    MemEn <= TRUE;
	    MemWr <= TRUE;
	    SignedExt <= TRUE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end

	  //10: LD Rd, Rs, immediate	
	  7'b10001_xx:
	  begin
	  	RegDst <= rt;
	    RegDataSrcSel <= mem_data_out;
	   	RegWriteEn <= TRUE;
	    alu_b_sel <= sel_imm;
	    alu_op <= ADD;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= TRUE;
	    MemEn <= TRUE;
	    MemWr <= FALSE;
	    SignedExt <= TRUE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end

	  //11: STU Rd, Rs, immediate	
	  7'b10011_xx:
	  begin
	  	RegDst <= rs;
	    RegDataSrcSel <= alu_out;
	   	RegWriteEn <= TRUE;
	    alu_b_sel <= sel_imm;
	    alu_op <= ADD;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= TRUE;
	    MemEn <= TRUE;
	    MemWr <= TRUE;
	    SignedExt <= TRUE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end

  	  //12: BTR Rd, Rs	
	  7'b11001_xx:
	  begin
	  	RegDst <= rd;
	    RegDataSrcSel <= btr_out;
	   	RegWriteEn <= TRUE;
	    alu_b_sel <= sel_imm;
	    alu_op <= ADD;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= FALSE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= TRUE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end

	  //13: ADD Rd, Rs, Rt	
	  7'b11011_00:
	  begin
	  	RegDst <= rd;
	    RegDataSrcSel <= alu_out;
	   	RegWriteEn <= TRUE;
	    alu_b_sel <= sel_data;
	    alu_op <= ADD;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= TRUE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= FALSE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end

	  //14: SUB Rd, Rs, Rt	
	  7'b11011_01:
	  begin
	  	RegDst <= rd;
	    RegDataSrcSel <= alu_out;
	   	RegWriteEn <= TRUE;
	    alu_b_sel <= sel_data;
	    alu_op <= ADD;
	    Cin <= TRUE;
	    invA <= TRUE;
	    invB <= FALSE;
	    sign <= TRUE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= FALSE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end

	  //15: XOR Rd, Rs, Rt	
	  7'b11011_10:
	  begin
	  	RegDst <= rd;
	    RegDataSrcSel <= alu_out;
	   	RegWriteEn <= TRUE;
	    alu_b_sel <= sel_data;
	    alu_op <= XOR;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= FALSE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= FALSE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end

	  //16: ANDN Rd, Rs, Rt	
	  7'b11011_11:
	  begin
	  	RegDst <= rd;
	    RegDataSrcSel <= alu_out;
	   	RegWriteEn <= TRUE;
	    alu_b_sel <= sel_data;
	    alu_op <= AND;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= TRUE;
	    sign <= FALSE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= FALSE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end

	  //17: ROL Rd, Rs, Rt	
	  7'b11010_00:
	  begin
	  	RegDst <= rd;
	    RegDataSrcSel <= alu_out;
	   	RegWriteEn <= TRUE;
	    alu_b_sel <= sel_data;
	    alu_op <= rll;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= FALSE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= FALSE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end

	  //18: SLL Rd, Rs, Rt	
	  7'b11010_01:
	  begin
	  	RegDst <= rd;
	    RegDataSrcSel <= alu_out;
	   	RegWriteEn <= TRUE;
	    alu_b_sel <= sel_data;
	    alu_op <= sll;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= FALSE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= FALSE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end

	  //19: ROR Rd, Rs, Rt need to implement
	  //TODO TODO
	  7'b11010_10:
	  begin
	  	RegDst <= rd;
	    RegDataSrcSel <= alu_out;
	   	RegWriteEn <= TRUE;
	    alu_b_sel <= sel_data;
	    alu_op <= sra;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= FALSE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= FALSE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end

	  //20: SRL Rd, Rs, Rt	
	  7'b11010_11:
	  begin
	  	RegDst <= rd;
	    RegDataSrcSel <= alu_out;
	   	RegWriteEn <= TRUE;
	    alu_b_sel <= sel_data;
	    alu_op <= srl;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= FALSE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= FALSE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end
//Set and Test
	  //21: SEQ Rd, Rs, Rt	
	  7'b11100_xx:
	  begin
	  	RegDst <= rd;
	    RegDataSrcSel <= cond_out;
	   	RegWriteEn <= TRUE;
	    alu_b_sel <= sel_data;
	    alu_op <= ADD;
	    Cin <= TRUE;
	    invA <= FALSE;
	    invB <= TRUE;
	    sign <= TRUE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= FALSE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end
	  //22: SLT Rd, Rs, Rt	
	  7'b11101_xx:
	  begin
	  	RegDst <= rd;
	    RegDataSrcSel <= cond_out;
	   	RegWriteEn <= TRUE;
	    alu_b_sel <= sel_data;
	    alu_op <= ADD;
	    Cin <= TRUE;
	    invA <= FALSE;
	    invB <= TRUE;
	    sign <= TRUE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= FALSE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end
	  //23: SLE Rd, Rs, Rt	
	  7'b11110_xx:
	  begin
	  	RegDst <= rd;
	    RegDataSrcSel <= cond_out;
	   	RegWriteEn <= TRUE;
	    alu_b_sel <= sel_data;
	    alu_op <= ADD;
	    Cin <= TRUE;
	    invA <= FALSE;
	    invB <= TRUE;
	    sign <= TRUE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= FALSE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end
	  // 24: SCO Rd, Rs, Rt	
	  7'b11111_xx:
	  begin
	  	RegDst <= rd;
	    RegDataSrcSel <= cond_out;
	   	RegWriteEn <= TRUE;
	    alu_b_sel <= sel_data;
	    alu_op <= ADD;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= TRUE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= FALSE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end
//Branching
	  //25: BEQZ Rs, immediate		
	  7'b01100_xx:
	  begin
	    RegDst <= rs;
	    RegDataSrcSel <= alu_out;
	    RegWriteEn <= FALSE;
	    alu_b_sel <= sel_zero;
	    alu_op <= ADD;
	    Cin <= TRUE;
	    invA <= FALSE;
	    invB <= TRUE;
	    sign <= TRUE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= TRUE;
	    Branch <= TRUE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end
	  //26: BNEZ Rs, immediate	
	  7'b01101_xx:
	  begin
	    RegDst <= rs;
	    RegDataSrcSel <= alu_out;
	    RegWriteEn <= FALSE;
	    alu_b_sel <= sel_zero;
	    alu_op <= ADD;
	    Cin <= TRUE;
	    invA <= FALSE;
	    invB <= TRUE;
	    sign <= TRUE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= TRUE;
	    Branch <= TRUE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end
	  //27: BLTZ Rs, immediate	
	  7'b01110_xx:
	  begin
	    RegDst <= rs;
	    RegDataSrcSel <= alu_out;
	    RegWriteEn <= FALSE;
	    alu_b_sel <= sel_zero;
	    alu_op <= ADD;
	    Cin <= TRUE;
	    invA <= FALSE;
	    invB <= TRUE;
	    sign <= TRUE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= TRUE;
	    Branch <= TRUE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end
	  //28: BGEZ Rs, immediate		
	  7'b01111_xx:
	  begin
	    RegDst <= rs;
	    RegDataSrcSel <= alu_out;
	    RegWriteEn <= FALSE;
	    alu_b_sel <= sel_zero;
	    alu_op <= ADD;
	    Cin <= TRUE;
	    invA <= FALSE;
	    invB <= TRUE;
	    sign <= TRUE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= TRUE;
	    Branch <= TRUE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end

//LBI and SLBI
	  //29: LBI Rs, immediate	
	  7'b11000_xx:
	  begin
	  	RegDst <= rs;
	    RegDataSrcSel <= imm_8_ext;
	   	RegWriteEn <= TRUE;
	    alu_b_sel <= sel_imm;
	    alu_op <= ADD;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= FALSE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= TRUE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end

	  //30: SLBI Rs, immediate
	  7'b10010_xx:
	  begin
	  	RegDst <= rs;
	    RegDataSrcSel <= slbi_out;
	   	RegWriteEn <= TRUE;
	    alu_b_sel <= sel_imm;
	    alu_op <= ADD;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= FALSE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= FALSE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	  end
//JUMP
	  //31: J displacement	
	  7'b00100_xx:
	  begin
	  	RegDst <= rs;
	    RegDataSrcSel <= alu_out;
	   	RegWriteEn <= FALSE;
	    alu_b_sel <= sel_imm;
	    alu_op <= ADD;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= FALSE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= TRUE;
	    Branch <= FALSE;
	    Jump <= TRUE;
	    Exception <= FALSE;
	  end

	  //32: JR Rs, immediate	
	  7'b00101_xx:
	  begin
	  	RegDst <= rs;
	    RegDataSrcSel <= alu_out;
	   	RegWriteEn <= FALSE;
	    alu_b_sel <= sel_imm;
	    alu_op <= ADD;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= FALSE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= TRUE;
	    Branch <= FALSE;
	    Jump <= TRUE;
	    Exception <= FALSE;
	  end
	  
	  //33: JAL displacement	
	  7'b00110_xx:
	  begin
	  	RegDst <= r7;
	    RegDataSrcSel <= pc_plus_two;
	   	RegWriteEn <= TRUE;
	    alu_b_sel <= sel_imm;
	    alu_op <= ADD;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= FALSE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= TRUE;
	    Branch <= FALSE;
	    Jump <= TRUE;
	    Exception <= FALSE;
	  end
	  //34: JALR Rs, immediate
	  7'b00111_xx:
	  begin
	    RegDst <= r7;
	    RegDataSrcSel <= pc_plus_two;
	   	RegWriteEn <= TRUE;
	    alu_b_sel <= sel_imm;
	    alu_op <= ADD;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= FALSE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= TRUE;
	    Branch <= FALSE;
	    Jump <= TRUE;
	    Exception <= FALSE;
	  end

//special Instruction
	  /* 
	  not implemented yet
	  //35: siic Rs	
	  //36: NOP / RTI	
	  */

	  //37: HALT
	  7'b00000_xx:
	  begin
	    RegDst <= rs;
	    RegDataSrcSel <= alu_out;
	    RegWriteEn <= FALSE;
	    alu_b_sel <= sel_imm;
	    alu_op <= ADD;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= FALSE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= FALSE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= TRUE;
	    
	  end

	  //38: NOP
	  7'b00001_xx:
	  begin
	    RegDst <= rs;
	    RegDataSrcSel <= alu_out;
	    RegWriteEn <= FALSE;
	    alu_b_sel <= sel_imm;
	    alu_op <= ADD;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= FALSE;
	   	MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= FALSE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;

	  end

    endcase
end
endmodule