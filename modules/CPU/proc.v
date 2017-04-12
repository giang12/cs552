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
   wire Rti, Exception, Halt, Flush, Stall;
   // for fetch
   wire [15:0] Next_Instr_Addr; //next instr address to execute, either PC+2 or JUMP/branch
   // for decode
   wire [15:0] WB_Data; wire [2:0] WB_Dst; wire WB_en;
   // for exec
   wire [1:0] forwardA, forwardB;
   wire [15:0] Prior_ALU_Res;

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
      .pc_sel(Flush),
      .en(~Stall & ~Halt), //Stop incrementing PC
      .clk(clk), 
      .rst(rst)
   );
   /**
    * IF/ID Reg
    */
   wire [15:0] ifid_instr_out, ifid_pcCurrent_out, ifid_pcPlusTwo_out;
   regIFID IFID(
   //control inputs
   .flush(Flush), //flush from exec branch predictor
   .en(~Stall), //~stallfrom hazard detector
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
      .wb_dst(WB_Dst),
      .wb_data(WB_Data),
      .wb_en(WB_en),
      .clk(clk),
      .rst(rst)
   );
   /**
    * ID/EX Reg
    */
   //remove Stall | Flush  and I will kill you
//   wire [31:0] control_signals_in = (Stall | Flush) ? 32'b0000_0000_0000_0000_0000_0000_0000_0000 : control_signals;
   wire [15:0] idex_instr_out, idex_pcCurrent_out, idex_pcPlusTwo_out;
   wire [15:0] idex_data1_out, idex_data2_out, idex_imm_5_ext_out, idex_imm_8_ext_out, idex_imm_11_ext_out;
   wire [15:0] idex_EX_control_out;
   wire [7:0]  idex_WB_control_out, idex_MEM_control_out;
   assign Halt = control_signals[10]; //TODO: find better place to assign Halt

   regIDEX IDEX(
      //reg control inputs
      .flush(Flush),
      .en(~Stall), //always
      .clk(clk),
      .rst(rst),
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
   wire [15:0] data_to_mem, alu_out, slbi_out, btr_out, cond_out;
   assign Rti = idex_EX_control_out[2];
   assign Exception = idex_EX_control_out[3];
   execute execute0(
      // Global Output
      .flush(Flush), // on branch, jump, rti, exception
      .next(Next_Instr_Addr),
      //output to next stage
      .data_to_mem(data_to_mem),
      .alu_out(alu_out),
      .slbi_out(slbi_out),
      .btr_out(btr_out),
      .cond_out(cond_out),
      // Inputs
      .instr(idex_instr_out),
      .pc(idex_pcCurrent_out), 
      .pc_plus_two(idex_pcPlusTwo_out), 
      .data1_in(idex_data1_out), 
      .data2_in(idex_data2_out), 
      .imm_5_ext(idex_imm_5_ext_out), 
      .imm_8_ext(idex_imm_8_ext_out), 
      .imm_11_ext(idex_imm_11_ext_out),

      .alu_a_sel(idex_EX_control_out[5:4]), //reserved
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
      //feedback forwarding data
      .prior_alu_out(Prior_ALU_Res),
      .wb_data(WB_Data),
      .forwardA(forwardA),
      .forwardB(forwardB),
      .clk(clk),
      .rst(rst)
   );

   /**
    * EX/MEM Reg
    */
   wire [15:0] exmem_write_data_out, exmem_pcPlusTwo_out, exmem_imm_8_ext_out, 
               exmem_alu_out, exmem_slbi_out, exmem_btr_out, exmem_cond_out;
   wire [7:0]  exmem_WB_control_out, exmem_MEM_control_out;

   regEXMem EXMEM(
      //reg control inputs
      .clk(clk),
      .rst(rst),
      .en(1'b1),// stall?
      //data inputs
      .write_data_in(data_to_mem),
      .pcPlusTwo_in(idex_pcPlusTwo_out),
      .imm_8_ext_in(idex_imm_8_ext_out),
      .alu_out_in(alu_out),
      .slbi_out_in(slbi_out),
      .btr_out_in(btr_out),
      .cond_out_in(cond_out),
      //control inputs
      .WB_control_in(idex_WB_control_out),
      .MEM_control_in(idex_MEM_control_out),

      //data outputs
      .write_data_out(exmem_write_data_out),
      .pcPlusTwo_out(exmem_pcPlusTwo_out),
      .imm_8_ext_out(exmem_imm_8_ext_out),
      .alu_out(exmem_alu_out),
      .slbi_out(exmem_slbi_out),
      .btr_out(exmem_btr_out),
      .cond_out(exmem_cond_out),
      //control outputs
      .WB_control_out(exmem_WB_control_out),
      .MEM_control_out(exmem_MEM_control_out)
   );
   //alu committer
   mux8_1_16bit prev_alu_out(
    // Outputs
    .Out(Prior_ALU_Res),
    // Inputs
    .S(exmem_WB_control_out[5:3]),
    .In0(16'bxxxx_xxxx_xxxx_xxxx),
    .In1(exmem_alu_out),
    .In2(exmem_imm_8_ext_out),
    .In3(exmem_slbi_out),
    .In4(exmem_btr_out),
    .In5(exmem_pcPlusTwo_out),
    .In6(exmem_cond_out),
    .In7(16'bxxxx_xxxx_xxxx_xxxx)
  );
   /** 
    * Memory Access (MEM)
    */
   wire [15:0] mem_data_out;
   memory memory0(  
      //output
      .readData(mem_data_out), 
      //input
      .addr(exmem_alu_out), 
      .writeData(exmem_write_data_out), 
      .en(exmem_MEM_control_out[0]), 
      .write(exmem_MEM_control_out[1]), 
      .halt(exmem_MEM_control_out[2]), //createdump
      .clk(clk), 
      .rst(rst)
   );

   /**
    * MemWB Reg
    */
    wire [15:0] memwb_mem_data_out, memwb_pcPlusTwo_out, memwb_imm_8_ext_out, 
               memwb_alu_out, memwb_slbi_out, memwb_btr_out, memwb_cond_out;
    wire [7:0]  memwb_WB_control_out;
   regMemWB MemWB(
      //reg control inputs
      .clk(clk),
      .rst(rst),
      .en(1'b1),
      //data inputs
      .mem_data_in(mem_data_out),
      .pcPlusTwo_in(exmem_pcPlusTwo_out),
      .imm_8_ext_in(exmem_imm_8_ext_out),
      .alu_out_in(exmem_alu_out),
      .slbi_out_in(exmem_slbi_out),
      .btr_out_in(exmem_btr_out),
      .cond_out_in(exmem_cond_out),
      //control inputs
      .WB_control_in(exmem_WB_control_out),

      //data outputs
      .mem_data_out(memwb_mem_data_out),
      .pcPlusTwo_out(memwb_pcPlusTwo_out),
      .imm_8_ext_out(memwb_imm_8_ext_out),
      .alu_out(memwb_alu_out),
      .slbi_out(memwb_slbi_out),
      .btr_out(memwb_btr_out),
      .cond_out(memwb_cond_out),
      //control outputs
      .WB_control_out(memwb_WB_control_out)
   );
   /**
    * Write Back (WB)
    */
   assign WB_Dst = memwb_WB_control_out[2:0];
   assign WB_en = memwb_WB_control_out[6];
   writeback WB(
      // Outputs
      .data(WB_Data),
      // Inputs
      .DataSrcSel(memwb_WB_control_out[5:3]),
      .mem_data_out(memwb_mem_data_out),
      .alu_out(memwb_alu_out),
      .imm_8_ext(memwb_imm_8_ext_out),
      .slbi_out(memwb_slbi_out),
      .btr_out(memwb_btr_out),
      .pc_plus_two(memwb_pcPlusTwo_out),
      .cond_out(memwb_cond_out),
      .constant(16'bxxxx_xxxx_xxxx_xxxx)// should never
   );


   /** Hazard Detection */
   hazard_detector hazy(
   // output 
   .stall(Stall),
   //inputs
   .ifid_Instr(ifid_instr_out),
   .idex_Instr(idex_instr_out),
   .idex_MemRead(idex_MEM_control_out[0]),
   .idex_MemWr(idex_MEM_control_out[1])
   );
   
   /** Forwarding */
   forwarding_unit fwd(
      //output
      .forwardA(forwardA),
      .forwardB(forwardB),
      //input
      .idex_Instr(idex_instr_out),
      .exmem_RegWriteEn(exmem_WB_control_out[6]),
      .exmem_RegD(exmem_WB_control_out[2:0]),
      .memwb_RegWriteEn(memwb_WB_control_out[6]),
      .memwb_RegD(memwb_WB_control_out[2:0])
   );
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
