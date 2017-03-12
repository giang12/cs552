

module control_unit(  
	//input
	input [4:0] opcode,
	input [1:0] fn,

	// outputs 
    .RegDst(RegDst),
    .RegDataSrcSel(), 
    .RegWriteEn(RegWriteEn), 


    .MemEn(MemEn), 
    .MemWr(MemWr), 

    .SignedExt(SignedExt),  
    .Branch(Branch), 
    .Jump(Jump), 
    .Dump(Dump),
    .Exception(Exception), 

    .alu_b_sel(alu_b_sel),
    .alu_op(alu_op), 
    .Cin(Cin), 
    .invA(invA), 
    .invB(invB),
    .sign(sign)
    );

	
	reg [2:0] alu_op;
    reg	[1:0] RegDst;
    reg [2:0] RegDataSrcSel;
    reg RegWriteEn, 
    	MemEn, 
    	MemWr,
    	SignedExt,
    	Branch,
    	Jump,
    	Dump,
    	Exception,
    	alu_b_sel,
    	Cin,
    	invA,
    	invB,
    	sign;
    	
	// RegDst
	localparam rd = 1'b00;
	localparam rt = 1'b01;
	localparam rs = 1'b10;
	localparam r7 = 1'b11;                       .

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
	localparam sel_data = 1'b0;
	localparam sel_imm = 1'b1;

	//writeback DataSrcSel (taken from writeback.v)
	localparam mem_data_out = 3'b000;
    localparam alu_out = 3'b001;
	localparam imm_8_ext = 3'b010;
	localparam slbi_out = 3'b011;
	localparam btr_out = 3'b100;
	localparam pc_plus_two = 3'b101;
	localparam cond_flag = 3'b110;
	localparam constant = 3'b111;

	localparam TRUE = 1'b1;
	localparam FALSE = 1'b0;


always @ (opcode or fn)
begin
    casex({opcode, fn})
	  //ADDI Rd, Rs, immediate
	  7'b01000_xx:
	  begin
	    RegDst <= rt;
	    RegDataSrcSel <= alu_out;
	    alu_b_sel <= sel_imm;
	    RegWriteEn <= TRUE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= TRUE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	    alu_op <= ADD;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= FALSE;
	  end
	  //SUBI Rd, Rs, immediate
	  7'b01001_xx:
	  begin
	    RegDst <= rt;
	    RegDataSrcSel <= alu_out;
	    alu_b_sel <= sel_imm;
	    RegWriteEn <= TRUE;
	    MemEn <= FALSE;
	    MemWr <= FALSE;
	    SignedExt <= TRUE;
	    Branch <= FALSE;
	    Jump <= FALSE;
	    Exception <= FALSE;
	    alu_op <= ADD;
	    Cin <= FALSE;
	    invA <= FALSE;
	    invB <= FALSE;
	    sign <= FALSE;
	  end

    endcase
end
endmodule