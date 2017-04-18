module regMemWB(
	//reg control inputs
  input clk,
  input rst,
  input en,
  //data inputs
  input [15:0] mem_data_in,
  input [15:0] pcPlusTwo_in,
  input [15:0] imm_8_ext_in,
  input [15:0] alu_out_in,
  input [15:0] slbi_out_in,
  input [15:0] btr_out_in,
  input [15:0] cond_out_in,
  //control inputs
  input [7:0]  WB_control_in,

  //data outputs
  output [15:0] mem_data_out,
  output [15:0] pcPlusTwo_out,
  output [15:0]	imm_8_ext_out,
  output [15:0] alu_out,
  output [15:0] slbi_out,
  output [15:0] btr_out,
  output [15:0] cond_out,
  //control outputs
  output [7:0]  WB_control_out
);

	//data reg
	register_16bit data0(.readdata(mem_data_out), .clk(clk), .rst(rst), .writedata(mem_data_in), .write(en));
	register_16bit data1(.readdata(pcPlusTwo_out), .clk(clk), .rst(rst), .writedata(pcPlusTwo_in), .write(en));
	register_16bit data2(.readdata(imm_8_ext_out), .clk(clk), .rst(rst), .writedata(imm_8_ext_in), .write(en));
	register_16bit data3(.readdata(alu_out), .clk(clk), .rst(rst), .writedata(alu_out_in), .write(en));
	register_16bit data4(.readdata(slbi_out), .clk(clk), .rst(rst), .writedata(slbi_out_in), .write(en));
	register_16bit data5(.readdata(btr_out), .clk(clk), .rst(rst), .writedata(btr_out_in), .write(en));
	register_16bit data6(.readdata(cond_out), .clk(clk), .rst(rst), .writedata(cond_out_in), .write(en));

	//control reg
	register_8bit ctrl0(.readdata(WB_control_out), .clk(clk), .rst(rst), .writedata(WB_control_in), .write(en));


endmodule