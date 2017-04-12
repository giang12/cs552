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
	wire ctrl_sigs_rst = (flush | ~en);
	wire [15:0] next_instr = (ctrl_sigs_rst | rst) ? 16'b0000100000000000 : instr_in;

	wire [7:0] next_wb_ctrl = ctrl_sigs_rst ? 8'b0 : WB_control_in;
	wire [7:0] next_mem_ctrl = ctrl_sigs_rst ? 8'b0 : MEM_control_in;
	wire [15:0] next_ex_ctrl = ctrl_sigs_rst ? 16'b0 : EX_control_in;


	register_16bit inst0(.readdata(instr_out), .clk(clk), .rst(1'b0), .writedata(next_instr), .write(1'b1));

	//data registers
	register_16bit inst1(.readdata(pcCurrent_out), .clk(clk), .rst(rst), .writedata(pcCurrent_in), .write(en));
	register_16bit inst2(.readdata(pcPlusTwo_out), .clk(clk), .rst(rst), .writedata(pcPlusTwo_in), .write(en));
	register_16bit inst3(.readdata(data1_out), .clk(clk), .rst(rst), .writedata(data1_in), .write(en));
	register_16bit inst4(.readdata(data2_out), .clk(clk), .rst(rst), .writedata(data2_in), .write(en));
	register_16bit inst5(.readdata(imm_5_ext_out), .clk(clk), .rst(rst), .writedata(imm_5_ext_in), .write(en));
	register_16bit inst6(.readdata(imm_8_ext_out), .clk(clk), .rst(rst), .writedata(imm_8_ext_in), .write(en));
	register_16bit inst7(.readdata(imm_11_ext_out), .clk(clk), .rst(rst), .writedata(imm_11_ext_in), .write(en));

	//control registers
	register_8bit inst8(.readdata(WB_control_out), .clk(clk), .rst(rst), .writedata(next_wb_ctrl), .write(1'b1));
	register_8bit inst9(.readdata(MEM_control_out), .clk(clk), .rst(rst), .writedata(next_mem_ctrl), .write(1'b1));
	register_16bit inst10(.readdata(EX_control_out), .clk(clk), .rst(rst), .writedata(next_ex_ctrl), .write(1'b1));

endmodule
