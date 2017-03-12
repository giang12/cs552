module execute(
      // Outputs
      output [15:0] next, 
      output [15:0] alu_out,
      output [15:0] slbi_out,
      output [15:0] btr_out,
      output [15:0] flag, 
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
      input alu_b_sel,
      input [2:0] alu_op, 
      input Cin, 
      input invA, 
      input invB, 
      input sign, 
      input jump, 
      input branch
   );

wire [15:0] data1_leftshift8;
//SLBI path
shifter data1_leftshift8(.In(data1), .Cnt(4'b1000), .Op(2'b01), .Out(data1_leftshift8));
or2_16bit    slbior(.in1(data1_leftshift8), .in2(imm_8_ext), .out(slbi_out));

//btr path
reverse_16bit btr(.in(data1), .out(btr_out));


endmodule