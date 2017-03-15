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
   assign err = 1'b0;
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   //Feedback wires
   wire Rti, Exception, Halt;
   wire [15:0] WriteBack_Data;
   wire [15:0] Next_Instr_Addr; //next instr address to execute, either PC+2 or JUMP/branch


   /**
    * Instruction Fetch (IF)
    */
   wire [15:0] Instr, PC, PC_Plus_Two;
   fetch fetch0(   
      //output
      .instr(Instr), 
      .pcCurrent(PC), 
      .pcPlusTwo(PC_Plus_Two), 
      //input
      .address(Next_Instr_Addr), 
      .halt(Halt),
      .clk(clk), 
      .rst(rst)
   );
   
   /**
    * Instruction Decode/Register Fetch (ID)
    */
   wire [15:0] data1, data2, imm_5_ext, imm_8_ext, imm_11_ext;
   wire Branch, Jump, Cin, invA, invB, sign, MemEn, MemWr;
   wire [1:0] alu_b_sel;
   wire [2:0] alu_op, RegDataSrc;
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
      
      .MemEn(MemEn), //should en data memory?
      .MemWr(MemWr), //should write result to data memory

      .Branch(Branch), // branch flag
      .Jump(Jump), //jump flag
      .Halt(Halt),
      .Exception(Exception), // there is error, or halting
      .Rti(Rti),
      //input
      .Instr(Instr),
      .wb_data(WriteBack_Data), //wb data
      .clk(clk),
      .rst(rst)
   );

   /**
    * Execute/Address Calculation (EX)
    */
   wire [15:0] alu_out, slbi_out, btr_out, cond_out;
   execute execute0(
      // Outputs
      .next(Next_Instr_Addr), 
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

      .alu_a_sel(2'b0), //reserved
      .alu_b_sel(alu_b_sel), 
      .alu_op(alu_op), 
      .Cin(Cin), 
      .invA(invA),
      .invB(invB), 
      .sign(sign), 

      .exception(Exception), // there is error
      .rti(Rti),
      .jump(Jump), 
      .branch(Branch),
      .clk(clk),
      .rst(rst)
   );

   /** 
    * Memory Access (MEM)
    */
   wire [15:0] mem_data_out;
   memory memory0(  
      //output
      .readData(mem_data_out), 
      //input
      .addr(alu_out), 
      .writeData(data2), 
      .en(MemEn), 
      .write(MemWr), 
      .halt(Halt), //createdump
      .clk(clk), 
      .rst(rst)
   );

   /**
    * Write Back (WB)
    */
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
