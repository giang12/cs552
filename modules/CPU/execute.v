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

      input [1:0] alu_a_sel, //reserved
      input [1:0] alu_b_sel,
      input [2:0] alu_op, 
      input Cin, 
      input invA, 
      input invB, 
      input sign,
      input exception,
      input rti,
      input jump, 
      input branch,
      input clk,
      input rst
   );
//TODO: data1 & data2 forwarding

//SLBI path
wire [15:0] data1_leftshift8;
shifter leftshift8(.In(data1), .Cnt(4'b1000), .Op(2'b01), .Out(data1_leftshift8));
or2_16bit    slbior(.in1(data1_leftshift8), .in2(imm_8_ext), .out(slbi_out));

//btr path
reverse_16bit btr(.in(data1), .out(btr_out));

//Arithmetic
wire [15:0] alu_data2_in;
wire  Ofl, Cout, N, Zero;
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
      .N(N),
	.Z(Zero)
);

//Setting Conditional Flags
wire  EQ, NE, HS, LO, MI, PL, VS, VC, HI, LS, GE, LT, GT, LE, AL,
      cond_check;
cond_set conds(
      EQ, NE, HS, LO, MI, PL, VS, VC, HI, LS, GE, LT, GT, LE, AL,
      Ofl, Cout, N, Zero
);

//Conditional Set
mux4_1 cond_test(.InA(EQ), .InB(LT), .InC(LE), .InD(HS), .S(instr[12:11]), .Out(cond_check));
assign cond_out = {{15{1'b0}}, {cond_check}};


//Address Calculation
wire foo, jump_imm, branch_imm, branch_test, branch_taken, br_jmp;
wire [15:0] branch_target;
wire [15:0] pc_a_src;
wire [15:0] pc_b_src;
wire [15:0] EPC;

register_16bit EPC_register(
      // Outputs
      .readdata(EPC),
      // Inputs
      .clk(clk), .rst(rst), .writedata(pc_plus_two), .write(exception)
);

and2 inst3(.in1(jump), .in2(instr[11]), .out(jump_imm));
or2  inst4(.in1(jump_imm), .in2(branch), .out(branch_imm));
mux4_1 mux7(.InA(EQ), .InB(NE), .InC(LT), .InD(GE), .S(instr[12:11]), .Out(branch_test));
and2             inst12(.in1(branch), .in2(branch_test), .out(branch_taken));
or2              brorjmp(.in1(branch_taken), .in2(jump), .out(br_jmp));

mux2_1_16bit pc_a_mux(.InA(pc_plus_two), .InB(data1), .S(jump_imm), .Out(pc_a_src));
mux2_1_16bit pc_b_mux(.InA(imm_11_ext), .InB(imm_8_ext), .S(branch_imm), .Out(pc_b_src));
fulladder16  pc_adder(.A(pc_a_src), .B(pc_b_src), .SUM(branch_target), .CO(foo));

mux8_1_16bit branch_src(
      .In0(pc_plus_two),
      .In1(branch_target), 
      .In2(EPC), 
      .In3(EPC),
      .In4(16'h2), //exception handler address
      .In5(16'h2), 
      .In6(16'h2), 
      .In7(16'h2), 
      .S({exception, rti, br_jmp}), 
      .Out(next)
);


endmodule
