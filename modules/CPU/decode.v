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

    output MemEn, //should en data memory?
    output MemWr, //should write result to data memory

    output Branch, // branch flag
    output Jump, //jump flag
    output Halt, //halting, create dump
    output Exception, // there is error
    output Rti,
    //input
    input [15:0] Instr,
    input [15:0] wb_data, //wb data
    input clk,
    input rst
    );

    wire [2:0] regS = Instr[10:8];
    wire [2:0] regT = Instr[7:5];
    wire [2:0] regD = Instr[4:2];
    wire [4:0] opCode = Instr[15:11];
    wire [1:0] opExt  = Instr[1:0];
    wire [4:0] imm_5  = Instr[4:0];
    wire [7:0] imm_8  = Instr[7:0];
    wire [10:0]imm_11 = Instr[10:0];
    
    wire [1:0] RegDst;
    wire SignedExt; 
    // register file
    wire [2:0] writeregsel;
    wire RegWriteEn;
    wire err;
    
    rf  regFile0(   
        //output
        .read1data(data1), 
        .read2data(data2), 
        .err(err),
        //input
        .clk(clk), 
        .rst(rst), 
        .read1regsel(regS),  //rs
        .read2regsel(regT), //rt
        .writeregsel(writeregsel), 
        .writedata(wb_data), //supplied by Exec
        .write(RegWriteEn)
    );

    // control module
    control_unit ctrl(  
        //input             
        .opcode(opCode),
        .opext(opExt),
        // outputs 
        .RegDst(RegDst),
        .RegDataSrcSel(RegDataSrcSel), 
        .RegWriteEn(RegWriteEn), 
        .MemEn(MemEn), 
        .MemWr(MemWr), 
        .SignedExt(SignedExt),  
        .Branch(Branch), 
        .Jump(Jump),
        .Halt(Halt),
        .Exception(Exception),
        .Rti(Rti),
        .alu_b_sel(alu_b_sel),
        .alu_op(alu_op), 
        .Cin(Cin), 
        .invA(invA), 
        .invB(invB),
        .sign(sign)
    );

    mux4_1_3bit wb_sel_mux(  
        // output
        .Out(writeregsel),
        // inputs
        .S(RegDst), 
        .InA(regD), //rd 0
        .InB(regT), //rt 1
        .InC(regS), //rs 2
        .InD(3'b111) //Reg7 3
    );

    //imm extension
    ext5_16 ext0(.in(imm_5), .signext(SignedExt), .out(imm_5_ext));
    ext8_16 ext1(.in(imm_8), .signext(SignedExt), .out(imm_8_ext));
    ext11_16 ext3(.in(imm_11), .signext(SignedExt), .out(imm_11_ext));

endmodule