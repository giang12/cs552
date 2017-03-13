/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input clk;
   input rst;

   output err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   assign err = 1'b0;
   /* your code here */
   wire [15:0] Instr, PC, PC_Plus_Two;

   wire [15:0] data1, data2;
   wire Branch, Jump, Exception, WBen;
   wire [2:0] alu_op; wire [1:0] alu_b_sel;
   wire Cin, invA, invB, sign, MemEn, MemWr;
   wire [2:0] RegDataSrc;
   wire [15:0] imm_5_ext, imm_8_ext, imm_11_ext;

   wire [15:0] PC_Next; //next address from exceute, either PC+2 or JUMP/branch
   wire [15:0] alu_out, slbi_out, btr_out, cond_out;

   wire [15:0] mem_data_out;

   wire [15:0] WriteBack_Data;

   fetch fetch0(   
      //output
      .instr(Instr), 
      .pcCurrent(PC), 
      .pcPlusTwo(PC_Plus_Two), 
      //input
      .pcNext(PC_Next), 
      .halt(Exception), 
      .clk(clk), 
      .rst(rst)
   );
   //decode
   
   decode decode0( 
      //output
      .data1(data1), //from register file
      .data2(data2),
      .imm_5_ext(imm_5_ext), 
      .imm_8_ext(imm_8_ext), 
      .imm_11_ext(imm_11_ext), 

      .alu_b_sel(alu_b_sel), //select B input for alu
      .alu_op(alu_op), //alu opcode
      .Cin(Cin),
      .invA(invA),
      .invB(invB),
      .sign(sign),

      .RegDataSrcSel(RegDataSrc), //for write stage
      .RegWriteEn(WBen), //foo
      
      .MemEn(MemEn), //should en data memory?
      .MemWr(MemWr), //should write result to data memory

      .Branch(Branch), // branch flag
      .Jump(Jump), //jump flag
      .Exception(Exception), // there is error, or halting

      //input
      .Instr(Instr),
      .wb_data(WriteBack_Data), //wb data
      .clk(clk),
      .rst(rst)
   );
   //exec
   execute execute0(
      // Outputs
      .next(PC_Next), 
      .alu_out(alu_out), 
      .slbi_out(slbi_out),
      .btr_out(btr_out),
      .cond_out(cond_out), 
      // Inputs
      .instr(Instr),
      .pc(PC), 
      .pc_plus_two(PC_Plus_Two), 
      .data1(data1), 
      .data2(data2), 
      .imm_5_ext(imm_5_ext), 
      .imm_8_ext(imm_8_ext), 
      .imm_11_ext(imm_11_ext), 

      .alu_a_sel(1'b0), //NOT USED
      .alu_b_sel(alu_b_sel), 
      .alu_op(alu_op), 
      .Cin(Cin), 
      .invA(invA), 
      .invB(invB), 
      .sign(sign), 

      .halt(Exception),
      .jump(Jump), 
      .branch(Branch)
   );

   //MEM
   
   memory memory0(  
      //output
      .readData(mem_data_out), 
      //input
      .addr(alu_out), 
      .writeData(data2), 
      .en(MemEn), 
      .write(MemWr), 
      .halt(Exception), //createdump
      .clk(clk), 
      .rst(rst)
   );

   //wrback
   writeback WB(
      // Outputs
      .data(WriteBack_Data),
      // Inputs
      .DataSrcSel(RegDataSrc),
      .mem_data_out(mem_data_out),
      .alu_out(alu_out),
      .imm_8_ext(imm_8_ext),
      .slbi_out(slbi_out),
      .btr_out(btr_out),
      .pc_plus_two(PC_Plus_Two),
      .cond_out(cond_out),
      .constant(16'bxxxx_xxxx_xxxx_xxxx)// should never
   );
   
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
