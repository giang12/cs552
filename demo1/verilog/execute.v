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
      input jump, 
      input branch
   );

wire [15:0] data1_leftshift8;
wire [15:0] alu_data2_in;

wire ofl, zero, neg, cout;
//SLBI path
shifter data1_leftshift8(.In(data1), .Cnt(4'b1000), .Op(2'b01), .Out(data1_leftshift8));
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
	.Ofl(ofl),
	//.Cout(cout)
	//.N(neg), 
	.Z(zero)
);

//Conditional Set
wire inst11_out, mux8_out;
or2	inst11 (.in1(zero), .in2(neg), .out(inst11_out));
mux4_1 mux8(.InA(zero), .InB(neg), .InC(inst11_out), .InD(cout), .S(instr[12:11]), .Out(mux8_out));
assign cond_out = {{15{1'b0}}, {mux8_out}};

////////////////////////////////////////////////////////////////////////////////////////////////////////
//Calculate branch?
wire jump_ctr, branch_ctr, pcOut;
wire [15:0] pc_a_src;
wire [15:0] pc_b_src;
wire [15:0] pc_val;

and2 inst3(.in1(jump), .in2(instr[11]), .out(jump_ctr));
or2  inst4(.in1(jump_ctr), .in2(branch), .out(branch_ctr));

mux2_1_16bit pc_a_mux(.InA(pc_plus_two), .InB(data1), .S(jump_ctr), .Out(pc_a_src));
mux2_1_16bit pc_b_mux(.InA(imm_11_ext), .InB(imm_8_ext), .S(branch_ctr), .Out(pc_b_src));
fulladder16  pc_adder(.A(pc_a_src), .B(pc_b_src), .SUM(pc_val), .CO(pcOut));


not1         inst8         (.in(zero), .out(inst8_out));
not1         inst9         (.in(data1[15]), .out(inst9_out));
mux4_1       mux7          (.InA(zero), .InB(inst8_out), .InC(data1[15]), .InD(inst9_out), 
                         	.S(instruction[12:11], .Out(branch_taken)));


      and2             inst12   (.in1(branch), .in2(branch_taken), .out(inst12_out));
      or2              inst13   (.in1(inst12_out), .in2(jump), .out(inst13_out));
      mux2_1_16bit     mux9    (.InA(pc_plus_two), .InB(pc_val) , .S(inst13_out), .Out(mux9_out));
      mux2_1_16bit     mux10   (.InA(mux9_out), .InB(pc) , .S(halt), .Out(pc_next));
endmodule
