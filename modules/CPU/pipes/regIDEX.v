module regIDEX(
	//reg control inputs
	input flush,
	input en,
	input clk,
	input rst,
	//data inputs
	input [15:0] instr_in, 
    input [15:0] pcCurrent_in, 
   	input [15:0] pcPlusTwo_in,

	input [15:0] data1_in,
    input [15:0] data2_in,
    input [15:0] imm_5_ext_in,
    input [15:0] imm_8_ext_in,
    input [15:0] imm_11_ext_in,
	//control inputs
	input [7:0] WB_control_in,
	input [7:0] MEM_control_in,
	input [15:0] EX_control_in,
	//data outputs
	output [15:0] instr_out, 
   	output [15:0] pcCurrent_out, 
   	output [15:0] pcPlusTwo_out,

	output [15:0] data1_out,
    output [15:0] data2_out,
    output [15:0] imm_5_ext_out,
    output [15:0] imm_8_ext_out,
    output [15:0] imm_11_ext_out,
	//control outputs
	output [7:0] WB_control_out,
	output [7:0] MEM_control_out,
	output [15:0] EX_control_out
);
	wire [15:0] next_instr = (flush | rst) ? 16'b0000100000000000 : instr_in;
	register_16bit inst0(.readdata(instr_out), .clk(clk), .rst(1'b0), .writedata(next_instr), .write(en));

	//data registers
	register_16bit inst1(.readdata(pcCurrent_out), .clk(clk), .rst(rst), .writedata(pcCurrent_in), .write(en));
	register_16bit inst2(.readdata(pcPlusTwo_out), .clk(clk), .rst(rst), .writedata(pcPlusTwo_in), .write(en));
	register_16bit inst3(.readdata(data1_out), .clk(clk), .rst(rst), .writedata(data1_in), .write(en));
	register_16bit inst4(.readdata(data2_out), .clk(clk), .rst(rst), .writedata(data2_in), .write(en));
	register_16bit inst5(.readdata(imm_5_ext_out), .clk(clk), .rst(rst), .writedata(imm_5_ext_in), .write(en));
	register_16bit inst6(.readdata(imm_8_ext_out), .clk(clk), .rst(rst), .writedata(imm_8_ext_in), .write(en));
	register_16bit inst7(.readdata(imm_11_ext_out), .clk(clk), .rst(rst), .writedata(imm_11_ext_in), .write(en));

	//control registers
	register_8bit inst8(.readdata(WB_control_out), .clk(clk), .rst(rst), .writedata(WB_control_in), .write(en));
	register_8bit inst9(.readdata(MEM_control_out), .clk(clk), .rst(rst), .writedata(MEM_control_in), .write(en));
	register_16bit inst10(.readdata(EX_control_out), .clk(clk), .rst(rst), .writedata(EX_control_in), .write(en));

endmodule