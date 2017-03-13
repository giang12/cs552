module fetch(instr, pcCurrent, pcPlusTwo, pcNext, dump, exception, clk, rst);

	input clk, rst, dump, exception;
	input [15:0] pcNext;

	output [15:0] pcCurrent;
	output [15:0] pcPlusTwo;
	output [15:0] instr;

  	wire [15:0] pc_current;
    assign pcCurrent = pc_current;

    wire G_foo;
    wire P_foo;
    wire [15:0] next_pc;


    //maybe move to execute???
    mux2_1_16bit pc_next_mux(	.InA(pcNext), 
    							.InB(pc_current), 
    							.S(exception), 
    							.Out(next_pc)
    						);


	//PC register 
	register_16bit PC(
	           // Outputs
	           .readdata(pc_current),
	           // Inputs
	           .clk(clk), .rst(rst), .writedata(next_pc), .write(1'b1)
	           );

	//instr mem
	memory2c InstrMEM(	.data_out(instr),
						.data_in(16'b0),
						.addr(pc_current), 
						.enable(1'b1), 
						.wr(1'b0), 
						.createdump(1'b0), //dump ?
						.clk(clk), 
						.rst(rst)
					);

	//pc + 2
	cla_16bit adder0(	.S(pcPlusTwo),
						.G(G_foo),
                        .P(P_foo),
                        .A(pc_current),
                        .B(16'b0000_0000_0000_0010), // pc + 2
                        .Cin(1'b0)
                    );


endmodule