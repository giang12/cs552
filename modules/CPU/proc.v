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
   wire decode_err;
   assign err = decode_err;
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   //Feedback wires
   wire Rti, Exception, Halt;
   wire [15:0] WriteBack_Data;
   wire [15:0] Next_Instr_Addr; //next instr address to execute, either PC+2 or JUMP/branch


   /**
    * Instruction Fetch (IF)
    */
   wire [15:0] fetch_instr_out, fetch_pc_out, fetch_pc_plus_two_out;
   fetch fetch0(   
      //output
      .instr(fetch_instr_out), 
      .pcCurrent(fetch_pc_out), 
      .pcPlusTwo(fetch_pc_plus_two_out), 
      //input
      .address(Next_Instr_Addr), 
      .halt(Halt), //todo ~stall from hazard detect
      .clk(clk), 
      .rst(rst)
   );
   /**
    * IF/ID Reg
    */
   wire [15:0] ifid_instr_out, ifid_pcCurrent_out, ifid_pcPlusTwo_out;
   regIFID IFID(
   //control inputs
   .flush(flush), //from exec branch predictor
   .en(~stall) //from hazard detector
   .clk(clk), 
   .rst(rst),
   //data inputs
   .instr_in(fetch_instr_out), 
   .pcCurrent_in(fetch_pc_out), 
   .pcPlusTwo_in(fetch_pc_plus_two_out),
   //outputs
   .instr_out(ifid_instr_out), 
   .pcCurrent_out(ifid_pcCurrent_out), 
   .pcPlusTwo_out(ifid_pcPlusTwo_out)
   );

   /**
    * Instruction Decode/Register Fetch (ID)
    */
   wire [15:0] data1, data2, imm_5_ext, imm_8_ext, imm_11_ext;
   wire [31:0] control_signals; // WB [7:0], MEM [15:8], EX [31:16]
   decode decode0( 
      //output
      .err(decode_err),

      .data1(data1), //from register file
      .data2(data2),
      .imm_5_ext(imm_5_ext), 
      .imm_8_ext(imm_8_ext), 
      .imm_11_ext(imm_11_ext), 
      .control_signals(control_signals),
      //input 
      .Instr(ifid_instr_out),
      //write back input
      .wb_dst(),
      .wb_data(WriteBack_Data), //wb data
      .wb_en(),
      .clk(clk),
      .rst(rst)
   );
   /**
    * ID/EX Reg
    */
   //control_signals = flush ? 0 : control_signals;
   wire [15:0] idex_instr_out, idex_pcCurrent_out, idex_pcPlusTwo_out;
   wire [15:0] idex_data1_out, idex_data2_out, idex_imm_5_ext_out, idex_imm_8_ext_out, idex_imm_11_ext_out;
   wire [7:0]  idex_WB_control_out, idex_MEM_control_out;
   wire [15:0] idex_EX_control_out;
   regIDEX IDEX(
      //reg control inputs
      .clk(clk),
      .rst(rst),
      .en(1'b1),
      //data inputs
      .instr_in(ifid_instr_out), 
      .pcCurrent_in(ifid_pcCurrent_out), 
      .pcPlusTwo_in(ifid_pcPlusTwo_out),

      .data1_in(data1),
      .data2_in(data2),
      .imm_5_ext_in(imm_5_ext),
      .imm_8_ext_in(imm_8_ext),
      .imm_11_ext_in(imm_11_ext),
      //control inputs
      .WB_control_in(control_signals[7:0]),
      .MEM_control_in(control_signals[15:8]),
      .EX_control_in(control_signals[31:16]),
      //data outputs
      .instr_out(idex_instr_out), 
      .pcCurrent_out(idex_pcCurrent_out), 
      .pcPlusTwo_out(idex_pcPlusTwo_out),

      .data1_out(idex_data1_out),
      .data2_out(idex_data2_out),
      .imm_5_ext_out(idex_imm_5_ext_out),
      .imm_8_ext_out(idex_imm_8_ext_out),
      .imm_11_ext_out(idex_imm_11_ext_out),
      //control outputs
      .WB_control_out(idex_WB_control_out),
      .MEM_control_out(idex_MEM_control_out),
      .EX_control_out(idex_EX_control_out)
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
      .instr(idex_instr_out),
      .pc(idex_pcCurrent_out), 
      .pc_plus_two(idex_pcPlusTwo_out), 
      .data1(idex_data1_out), 
      .data2(idex_data2_out), 
      .imm_5_ext(idex_imm_5_ext_out), 
      .imm_8_ext(idex_imm_8_ext_out), 
      .imm_11_ext(idex_imm_11_ext_out),

      .alu_a_sel(idex_EX_control_out[4:5]), //reserved
      .alu_b_sel(idex_EX_control_out[7:6]),
      .alu_op(idex_EX_control_out[10:8]),
      .Cin(idex_EX_control_out[11]),
      .invA(idex_EX_control_out[12]),
      .invB(idex_EX_control_out[13]), 
      .sign(idex_EX_control_out[14]), 
      .exception(idex_EX_control_out[2]), // there is error
      .rti(idex_EX_control_out[3]),
      .jump(idex_EX_control_out[1]),
      .branch(idex_EX_control_out[0]),

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
