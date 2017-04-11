module decode( 
    //output
    output err,
    output [15:0] data1, //from register file
    output [15:0] data2,
    output [15:0] imm_5_ext,
    output [15:0] imm_8_ext,
    output [15:0] imm_11_ext,
    output [31:0] control_signals,
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
    wire [2:0] writeregsel, RegDataSrcSel; //for write stage
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

    wire [7:0] WB_control_sigs, MEM_control_sigs; 
    wire [15:0] EX_control_sigs;

    assign WB_control_sigs[2:0] = writeregsel;
    assign WB_control_sigs[5:3] = RegDataSrcSel;
    assign WB_control_sigs[6] = RegWriteEn;
    assign WB_control_sigs[7] = 1'b0; //reserved

    assign MEM_control_sigs[0] = MemEn;
    assign MEM_control_sigs[1] = MemWr;
    assign MEM_control_sigs[2] = Halt;
    assign MEM_control_sigs[7:3] = 5'b0; //reserved;

    assign EX_control_sigs[0] = Branch;
    assign EX_control_sigs[1] = Jump;
    assign EX_control_sigs[2] = Exception;
    assign EX_control_sigs[3] = Rti;
    assign EX_control_sigs[5:4] = 2'b00; //reserved for alu_a_sel
    assign EX_control_sigs[7:6] = alu_b_sel;
    assign EX_control_sigs[10:8] = alu_op;
    assign EX_control_sigs[11] = Cin;
    assign EX_control_sigs[12] = invA;
    assign EX_control_sigs[13] = invB;
    assign EX_control_sigs[14] = sign;
    assign EX_control_sigs[15] = 1'b0; //reserved
    // WB [7:0]    // MEM [15:8]    // EX [31:16]
    assign control_signals = {EX_control_sigs, MEM_control_sigs, WB_control_sigs};


    rf_bypass regFile0(   
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