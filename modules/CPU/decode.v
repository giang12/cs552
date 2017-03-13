module decode( 
    //output
    output [15:0] data1, //from register file
    output [15:0] data2,
    output [15:0] imm_5_ext,
    output [15:0] imm_8_ext,
    output [15:0] imm_11_ext,
    output [1:0] alu_b_sel, //select B input for alu
    output [2:0] alu_op, //alu opcode
    output Cin,
    output invA,
    output invB,
    output sign,

    output [2:0] RegDataSrcSel, //for write stage
    output RegWriteEn, //Determine if the result will be written back to the register file. should exposed??
    
    output MemEn, //should en data memory?
    output MemWr, //should write result to data memory

    output Branch, // branch flag
    output Jump, //jump flag
    output Exception, // there is error or create dump, (e.g halting)
    //input
    input [15:0] Instr,
    input [15:0] wb_data, //wb data
    input clk,
    input rst
    );

    wire [1:0] RegDst; //select re
    wire SignedExt; 

    // register file
    wire [2:0] writeregsel;
    wire err;
    
    rf   regFile0(   //output
                            .read1data(data1), 
                            .read2data(data2), 
                            .err(err),
                            //input
                            .clk(clk), 
                            .rst(rst), 
                            .read1regsel(Instr[10:8]),  //rs
                            .read2regsel(Instr[7:5]), //rt
                            .writeregsel(writeregsel), 
                            .writedata(wb_data), //supplied by Exec
                            .write(RegWriteEn)
                        );

    // control module
    control_unit ctrl(  //input
                        
                        .opcode(Instr[15:11]),
                        .fn(Instr[1:0]),

                        // outputs 
                        .RegDst(RegDst),
                        .RegDataSrcSel(RegDataSrcSel), 
                        .RegWriteEn(RegWriteEn), 


                        .MemEn(MemEn), 
                        .MemWr(MemWr), 

                        .SignedExt(SignedExt),  
                        .Branch(Branch), 
                        .Jump(Jump), 
                        .Exception(Exception), 

                        .alu_b_sel(alu_b_sel),
                        .alu_op(alu_op), 
                        .Cin(Cin), 
                        .invA(invA), 
                        .invB(invB),
                        .sign(sign)
                        );

    mux4_1_3bit wb_sel_mux(  // output
                            .Out(writeregsel),
                            // inputs
                            .S(RegDst), 
                            .InA(Instr[4:2]), //rd 0
                            .InB(Instr[7:5]), //rt 1
                            .InC(Instr[10:8]), //rs 2
                            .InD(3'b111) //Reg7 3
                        );




    ext5_16 ext0(.in(Instr[4:0]), .signext(SignedExt), .out(imm_5_ext));
    ext8_16 ext1(.in(Instr[7:0]), .signext(SignedExt), .out(imm_8_ext));
    ext11_16 ext3(.in(Instr[10:0]), .signext(SignedExt), .out(imm_11_ext));

endmodule