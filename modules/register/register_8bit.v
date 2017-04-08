module register_8bit(
           // Outputs
           readdata,
           // Inputs
           clk, rst, writedata, write
           );
   input clk, rst;

   input [7:0] writedata;
   input        write;

   output [7:0] readdata;

   wire[7:0] w;

   //touch or write new data
   mux2_1_8bit inst0(.InA(readdata), .InB(writedata), .S(write), .Out(w));

   dff dff_inst[7:0](.q(readdata), .d(w), .clk(clk), .rst(rst));

endmodule