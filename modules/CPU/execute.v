module execute(
      // Outputs
      output [15:0] next, 
      output [15:0] alu_out,
      output [15:0] slbi_out,
      output [15:0] btr_out,
      output [15:0] cond_out, 
      // Inputs
      input [15:0] instr,
      input [15:0] pc, 
      input [15:0] pc_plus_two, 
      input [15:0] data1, 
      input [15:0] data2, 
      input [15:0] imm_5_ext, 
      input [15:0] imm_8_ext, 
      input [15:0] imm_11_ext, 

      input alu_a_sel, //NOT USED
      input [1:0] alu_b_sel,
      input [2:0] alu_op, 
      input Cin, 
      input invA, 
      input invB, 
      input sign,
      input dump, 
      input jump, 
      input branch
   );

wire [15:0] data1_leftshift8;
wire [15:0] alu_data2_in;

wire cond_set;
wire  Ofl, 
      Cout,
      Zero,
      EQZ, //=0
      NEZ, //!=0
      LTZ, //<0
      LEZ, //<=0
      GEZ; //>=0

wire jump_ctr, branch_ctr, branch_taken, should_branch, br_jmp, pcOut;
wire [15:0] pc_a_src;
wire [15:0] pc_b_src;
wire [15:0] pc_val;
wire [15:0] branch_target;
//SLBI path
shifter leftshift8(.In(data1), .Cnt(4'b1000), .Op(2'b01), .Out(data1_leftshift8));
or2_16bit    slbior(.in1(data1_leftshift8), .in2(imm_8_ext), .out(slbi_out));

//btr path
reverse_16bit btr(.in(data1), .out(btr_out));

//Arithmetic

mux4_1_16bit alu_b_src(
	//input
	.InA(data2),
	.InB(imm_5_ext),
	.InC(16'b0000_0000_0000_0000),
	.InD(16'bxxxx_xxxx_xxxx_xxxx),
	.S(alu_b_sel),
	.Out(alu_data2_in)
);

alu alu_main(
	//input
	.A(data1),
	.B(alu_data2_in), 
	.Cin(Cin), 
	.Op(alu_op), 
	.invA(invA), 
	.invB(invB), 
	.sign(sign), 
	//output
	.Out(alu_out), 
	.Ofl(Ofl),
	.Cout(Cout),
	.Z(Zero)
);
alu_cond_set conds(
      //output
      .EQZ(EQZ),
      .GEZ(GEZ),
      .LTZ(LTZ),
      .LEZ(LEZ),
      .NEZ(NEZ),
      //input
      .Z(Zero),
      .msb(alu_out[15]),
      .sign(sign)
);
//Conditional Set
mux4_1 cond_test(.InA(EQZ), .InB(LTZ), .InC(LEZ), .InD(Cout), .S(instr[12:11]), .Out(cond_set));
assign cond_out = {{15{1'b0}}, {cond_set}};


//Calculate branch?


and2 inst3(.in1(jump), .in2(instr[11]), .out(jump_ctr));
or2  inst4(.in1(jump_ctr), .in2(branch), .out(branch_ctr));

mux2_1_16bit pc_a_mux(.InA(pc_plus_two), .InB(data1), .S(jump_ctr), .Out(pc_a_src));
mux2_1_16bit pc_b_mux(.InA(imm_11_ext), .InB(imm_8_ext), .S(branch_ctr), .Out(pc_b_src));
fulladder16  pc_adder(.A(pc_a_src), .B(pc_b_src), .SUM(pc_val), .CO(pcOut));


mux4_1 mux7(.InA(EQZ), .InB(NEZ), .InC(LTZ), .InD(GEZ), 
            .S(instr[12:11]), 
            .Out(branch_taken)
            );


and2             inst12   (.in1(branch), .in2(branch_taken), .out(should_branch));
or2              brorjmp   (.in1(should_branch), .in2(jump), .out(br_jmp));
mux2_1_16bit     mux9    (.InA(pc_plus_two), .InB(pc_val) , .S(br_jmp), .Out(branch_target));
mux2_1_16bit     mux10   (.InA(branch_target), .InB(pc_plus_two) , .S(dump), .Out(next));

endmodule
