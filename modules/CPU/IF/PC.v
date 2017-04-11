module PC(
	output [15:0] pcCurrent,
	output [15:0] pcNext,
	input [3:0]	instrLen,
	input [15:0] set,
	input en,
	input clk,
	input rst
);

    wire G_foo, P_foo;
	//PC register 
	register_16bit pc_register(
       // Outputs
       .readdata(pcCurrent),
       // Inputs
       .clk(clk), .rst(rst), .writedata(set), .write(en)
    );

	cla_16bit adder0(	
		.S(pcNext),
		.G(G_foo),
        .P(P_foo),
        .A(pcCurrent),
        .B({12'b0, instrLen}),
        .Cin(1'b0)
    );

endmodule