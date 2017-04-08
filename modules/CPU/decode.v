module decode( 
    //output
    output err,
    output [15:0] data1, //from register file
    output [15:0] data2,
    output [15:0] imm_5_ext,
    output [15:0] imm_8_ext,
    output [15:0] imm_11_ext,
    output [31:0] control_signals,
    /*
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
    */
    //control input
    input [15:0] Instr, //to decode
    //write back input
    input [2:0] wb_dst,
    input [15:0] wb_data, //wb data
    input wb_en,

    input clk,
    input rst
    );
    //internal wires
    wire [2:0] regS = Instr[10:8];
    wire [2:0] regT = Instr[7:5];
    wire [2:0] regD = Instr[4:2];

    wire [4:0] opCode = Instr[15:11];
    wire [1:0] opExt  = Instr[1:0];
    wire [4:0] imm_5  = Instr[4:0];
    wire [7:0] imm_8  = Instr[7:0];
    wire [10:0]imm_11 = Instr[10:0];
    
    wire SignedExt; 
    wire [1:0] RegDst;
    //internal control signals
    //WB    
    wire [2:0] writeregsel;
    wire [2:0] RegDataSrcSel, //for write stage
    wire RegWriteEn;
    //MEM
    wire MemEn; //should en data memory?
    wire MemWr; //should write result to data memory
    wire Halt; //halting, create dump
    //EX 
    wire Branch; // branch flag
    wire Jump; //jump flag
    wire Exception; // there is error
    wire Rti;
    wire [1:0] alu_b_sel; //select B input for alu
    wire [2:0] alu_op; //alu opcode
    wire Cin;
    wire invA;
    wire invB;
    wire sign;

    // WB [7:0]
    assign control_signals[2:0] = writeregsel;
    assign control_signals[5:3] = RegDataSrcSel;
    assign control_signals[6] = RegWriteEn;
    assign control_signals[7] = 1'bx; //reserved
    // MEM [15:8]
    assign control_signals[8] = MemEn;
    assign control_signals[9] = MemWr;
    assign control_signals[10] = Halt;
    assign control_signals[15:11] = 5'bxxxxx; //reserved;
    // EX [31:16]
    assign control_signals[16] = Branch;
    assign control_signals[17] = Jump;
    assign control_signals[18] = Exception;
    assign control_signals[19] = Rti;
    assign control_signals[21:20] = alu_b_sel;
    assign control_signals[24:22] = alu_op;
    assign control_signals[25] = Cin;
    assign control_signals[26] = invA;
    assign control_signals[27] = invB;
    assign control_signals[28] = sign;
    assign control_signals[31:29] = 3'bxxx //reserved;

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

        .writeregsel(wb_dst), 
        .writedata(wb_data), //supplied by writeback
        .write(wb_en)
    );

    // control module
    control_unit ctrl(  
        //input             
        .opcode(opCode),
        .opext(opExt),
        // outputs
        .RegDst(RegDst),
        // WB 
        .RegDataSrcSel(RegDataSrcSel), 
        .RegWriteEn(RegWriteEn), 
        // MEM
        .MemEn(MemEn), 
        .MemWr(MemWr),
        .Halt(Halt),
        //EX
        .Branch(Branch),
        .Jump(Jump),
        .Exception(Exception),
        .Rti(Rti),
        .alu_b_sel(alu_b_sel),
        .alu_op(alu_op),
        .Cin(Cin),
        .invA(invA),
        .invB(invB),
        .sign(sign),

        .SignedExt(SignedExt)
    );

    mux4_1_3bit wb_sel_mux(  
        // output
        // WB
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