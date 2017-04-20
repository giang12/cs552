module register_1bit(
           // Outputs
           readdata,
           // Inputs
           clk, rst, writedata, write
           );
   input clk, rst;

   input  writedata;
   input  write;

   output readdata;

   wire w;

   //touch or write new data
   mux2_1 inst0(.InA(readdata), .InB(writedata), .S(write), .Out(w));

   dff dff_inst[7:0](.q(readdata), .d(w), .clk(clk), .rst(rst));

endmodule