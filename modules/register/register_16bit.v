module register_16bit(
           // Outputs
           readdata,
           // Inputs
           clk, rst, writedata, write
           );
   input clk, rst;

   input [15:0] writedata;
   input        write;

   output [15:0] readdata;

   wire[15:0] w;

   //touch or write new data
   mux2_1_16bit inst0(.InA(readdata), .InB(writedata), .S(write), .Out(w));

   dff dff_inst[15:0](.q(readdata), .d(w), .clk(clk), .rst(rst));

endmodule