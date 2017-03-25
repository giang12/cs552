module register_64bit(
           // Outputs
           readdata,
           // Inputs
           clk, rst, writedata, write
           );
   input clk, rst;

   input [63:0] writedata;
   input        write;

   output [63:0] readdata;

   wire[63:0] w;

   register_32bit regs[1:0](
    .readdata(readdata),
    .clk(clk),
    .rst(rst),
    .writedata(writedata),
    .write(write)
    );

endmodule
