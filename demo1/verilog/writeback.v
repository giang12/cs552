module writeback(
	output [15:0] data,
	input [2:0] DataSrcSel,
	input [15:0] mem_data_out,
	input [15:0] alu_out,
	input [15:0] imm_8_ext,
	input [15:0] slbi_out,
	input [15:0] btr_out,
	input [15:0] pc_plus_two,
	input [15:0] cond_out,
	input [15:0] constant
	);
  

  mux8_1_16bit wb_mux(
          // Outputs
          .out(data),
          // Inputs
          .sel(DataSrcSel),
          .In0(mem_data_out),
          .In1(alu_out),
          .In2(imm_8_ext),
          .In3(slbi_out),
          .In4(btr_out),
          .In5(pc_plus_two),
          .In6(cond_out),
          .In7(constant)
        );


endmodule