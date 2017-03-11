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
   
   
   /* your code here */

/*
* does clk need to passed to modules?
* mofidy the always statement in the modules
* modify the alu to add outputs 
* compute the final er value 
* enable input d and i mem - how to set it?
*/

   // pc
   reg  [15:0] pc_reg;
   wire [15:0] pc_next,
               pc,
               pc_plus_two,
               instruction,
               final_write_data,
               data1,
               data2,
               se1,
               se2,
               data1_shifted,
               slbi,
               pc_val,
               alu_out,
               is_zero_out,
               data1_reversed,
               memdata_read,
               wr_d,
               mux4_out,
               mux5_out,
               mux6_out,
               mux8_out,
               mux12_out, 
               mux13_out,
               mux14_out,
               inst11_out;

   wire [2:0]  writeregsel,
               mux1_out, 
               mux2_out;

   wire        garbage1, // for holding values not needed in modules
               garbage2,
               garbage3,
               err1, 
               err2,
               inst1_out,
               inst3_out,
               inst4_out,
               inst6_out,
               inst8_out,
               inst9_out,
               inst12_out,
               inst13_out,
               branch_taken,
               Z, C, N,
               Cin, invA, invB,
               mem_enable;

   // control signals
   wire        regS, regD, alu_src, btr_sel, 
               branch, jump, sign_ext, memread, memwrite, regwrite, 
               flag_cond, lbi_sel, slbi_sel, memtoreg, halt;  
   wire [2:0]  alu_op,



   always @(posedge clk) begin
      
      // INSTRUCTION FETCH
      pc_reg = rst? pc_next: pc;
      assign pc = pc_reg;

      memory2c    i_mem    (.data_out(instruction), .data_in(0), .addr(pc), .enable(mem_enable), .wr(0), 
                              .createdump(halt), .clk(clk), .rst(rst));
      fulladder16 fulladder1  (.A(pc), .B(2), .SUM(pc_plus_two), .CO(garbage1));

      // INSTRUCTION DECODE     
      control_unit inst0 (.opcode(instruction[15:11]), .fn(instruction[1:0]), 
                          .regS(regS), .regD(regD), .alu_op(alu_op), .alu_src(alu_src), 
                          .btr_sel(btr_sel), .branch(branch), .jump(jump), .sign_ext(sign_ext), 
                          .memread(memread), .memwrite(memwrite), .regwrite(regwrite), .flag_cond(flag_cond), 
                          .lbi_sel(lbi_sel), .slbi_sel(slbi_sel), .memtoreg(memtoreg), .halt(halt));

      and2        inst1  (.in1(jump), .in2(instruction[12]), .out(inst1_out));

      mux2_1_3bit mux1   (.InA(instruction[7:5]), .InB(instruction[4:2]), .S(regD), .Out(mux1_out));
      mux2_1_3bit mux2   (.InA(mux1_out), .InB(instruction[10:8]), .S(regS), .Out(mux2_out));
      mux2_1_3bit mux3   (.InA(mux2_out), .InB(7), .S(inst1_out), .Out(writeregsel));

      rf_bypass   reg_file (.read1data(data1), .read2data(data2), .err(err1),
                           clk.(clk), rst.(rst), .read1regsel(instruction[10:8]), .read2regsel(7:5), 
                           .writeregsel(writeregsel), .writedata(final_write_data), .write(regwrite));

      sign_extend1 sign_extend1 (.in(instruction[4:0]), .en(sign_extend), .out(se1);
      sign_extend2 sign_extend2 (.in(instruction[7:0]), .en(sign_extend), .out(se2);

      // EXECUTE
      shift_left_8 shift_left_8 (.in(data1), .out(data1_shifted));
      or2_16bit    inst2        (.in1(data1_shifted), .in2(se2), .out(slbi));

      mux2_1_16bit  mux4         (.InA(data1), .InB(pc_plus_two), .S(branch), .Out(mux4_out));
      
      and2          inst3         (.in1(jump), .in2(instruction[11]), .out(inst3_out));
      or2           inst4         (.in1(inst3_out), .in2(branch), .out(inst4_out));
      mux2_1_16bit  mux5          (.InA(instruction[10:0]), .InB(se2), .S(inst4_out), .Out(mux5_out));
      
      fulladder16  fulladder2    (.A(mux4_out), .B(mux5_out), .SUM(pc_val), .CO(garbage2));

      alu_control  inst5         (.in(alu_op), .Cin(Cin), .invA(invA), .invB(invB);
      mux2_1_16bit mux6          (.InA(data2), .InB(instruction[4:0]), .S(alu_src), .Out(mux6_out));       
      alu          inst6          (.A(data1), .B(mux6_out), .Cin(Cin), .Op(alu_op), .invA(invA), .invB(invB), .sign(z), 
                                   .Out(alu_out), .Ofl(garbage3), .Z(Z));
      // should we create a alu which contains the alu made in the hw? or would that not be efficient

      is_zero      inst7         (.in(data1), .out(is_zero_out));
      not1         inst8         (.in(is_zero_out), .out(inst8_out));
      not1         inst9         (.in(data1[15]), .out(inst9_out));
      mux4_1       mux7          (.InA(is_zero_out), .InB(inst8_out), .InC(data1[15]), .InD(inst9_out), 
                                 .S(instruction[12:11], .Out(branch_taken)));

      reverse      reverse       (.in(data1), .out(data1_reversed));

      // MEMORY
      or2            inst10            (.in1(memwrite), .in2(memread), .out(mem_enable));
      memory2c       d_mem          (.data_out(memdata_read), .data_in(data2), .addr(alu_out), .enable(mem_enable), 
                                        .wr(memwrite), .createdump(halt), .clk(clk), .rst(rst));
      // is ~memwrite same as memread
      // should enable be zero when both read and write are 0
      or2_16bit      inst11      (.in1(Z), .in2(N), .out(inst11_out));
      mux4_1_16bit   mux8        (.InA(Z), .InB(N), .InC(inst11_out), .InD(C), .S(instruction[12:11]), .Out(mux8_out));
      
      // WRITEBACK
      and2             inst12   (.in1(branch), .in2(branch_taken), .out(inst12_out));
      or2              inst13   (.in1(inst12_out), .in2(jump), .out(inst13_out));
      mux2_1_16bit     mux9    (.InA(pc_plus_two), .InB(pc_val) , .S(inst13_out), .Out(mux9_out));
      mux2_1_16bit     mux10   (.InA(mux9_out), .InB(pc) , .S(halt), .Out(pc_next));
      
      mux2_1_16bit     mux11     (.InA(alu_out), .InB(memdata_read) , .S(memtoreg), .Out(mux11_out));

      mux2_1_16bit     mux12    (.InA(mux11_out), .InB(mux8_out) , .S(flag_cond), .Out(mux12_out));
      mux2_1_16bit     mux13    (.InA(mux12_out), .InB(pc_plus_two) , .S(inst1_out), .Out(mux13_out));
      // how to represent high impedance
      mux4_1_16bit     mux14    (.InA(mux13_out), .InB(se2), .C(slbi), .D(z), .S({slbi_sel, lbi_sel}), .Out(mux14_out));
      mux2_1_16bit     mux15    (.InA(mux14_out), .InB(reverse) , .S(btr_sel), .Out(final_write_data));

   end 
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
