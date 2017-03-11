module decode( Instr, );

    // control module
    input [15:0] Instr;
    output [2:0] RegDataSrc, ALUSrc2, Alu_Op;

    output 	MemEn, 
    		MemWr, 
    		Branch, 
    		Jump, 
    		Exception,
    		Flag_word
    		MemToReg, 
    		Cin, 
    		invA, 
    		invB, 
    		sign, 
    		dump;
    wire [1:0] RegDst;
    wire SignedExt; 

    // register file
    input clk, rst;
    input [15:0] writedata;
    output [15:0] read1data, read2data;
    wire [15:0] reg1_data, reg2_data;
    assign read1data = reg1_data;
    assign read2data = reg2_data;


    wire [2:0] writeregsel; 
    wire err; // TODO ???
    wire RegWrite;
    
    
  
    // ext modules
    output [15:0] instrEightExt, instrElevenExt, instrFiveExt; 
    output [15:0] btr_out;
	
    control_unit ctrl(  //input
    					.opcode(Instr[15:11]),
    					.fn(Instr[1:0]),
    					// outputs 
                        .ALUSrc2(ALUSrc2), 
                        .RegDst(RegDst),
                        .RegDataSrc(RegDataSrc), 
                        .RegWriteEn(RegWrite), 


                        .MemEn(MemEn), 
                        .MemWr(MemWr), 

                        .SignedExt(SignedExt),  
                        .Branch(Branch), 
                        .Jump(Jump), 
                        .Exception(Exception), 
                        
                        .Op(Op), 
                        .Cin(Cin), 
                        .invA(invA), 
                        .invB(invB), 
                        .sign(sign)
                        );

    mux4_1_4bit mux0(  // output
                        .out(writeregsel),
                        // inputs
                        .sel(RegDst), 
                        .in0(Instr[4:2]), //rd
                        .in1(Instr[7:5]), //rt
                        .in2(Instr[10:8]), //rs
                        .in3(3'b111) //Reg7
                    );



	rf_bypass	reg_file(	.read1data(data1), 
							.read2data(data2), 
							.err(err),
                           	.clk(clk), 
                           	.rst(rst), 
                           	.read1regsel(Instr[10:8]), 
                           	.read2regsel(Instr[7:5]), 
                           	.writeregsel(writeregsel), .writedata(writedata), 
                           	.write(RegWrite)
                        );

	//extend 5
	//extend 8
	//extend 11
endmodule