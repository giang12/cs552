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
   wire [15:0] PC, PC_PLUS_TWO, Instr;
   wire Exception;
   wire [15:0] PC_Next; //next address from exceute

   wire [15:0] data_1, data_2;

   wire [15:0] exec_out, mem_data_out
   wire Cin, invA, invB, sign, dump, MemEn, MemWr;


   fetch Fetch( .instr(Instr), 
                  .pc(PC), 
                  .pcPlusTwo(PC_PLUS_TWO), 
                  .pcNext(PC_Next), 
                  .clk(clk), 
                  .rst(rst), 
                  .dump(dump), 
                  .exception(Exception)
               );
   //decode
   

   //exec
   
   memory MemAcccess(  .readData(mem_data_out), 
                       .addr(exec_out), 
                       .writeData(data_2), 
                       .en(MemEn), 
                       .write(MemWr), 
                       .halt(dump), //TODO ???
                       .clk(clk), 
                       .rst(rst)
                     );

   //wrback
   
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
