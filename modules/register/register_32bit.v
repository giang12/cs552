module register_32bit(
           // Outputs
           readdata,
           // Inputs
           clk, rst, writedata, write
           );
   input clk, rst;

   input [31:0] writedata;
   input        write;

   output [31:0] readdata;

   wire[31:0] w;

   register_16bit regs[1:0](
    .readdata(readdata),
    .clk(clk),
    .rst(rst),
    .writedata(writedata),
    .write(write)
    );

endmodule
