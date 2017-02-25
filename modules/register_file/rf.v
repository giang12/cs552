/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module rf (
           // Outputs
           read1data, read2data, err,
           // Inputs
           clk, rst, read1regsel, read2regsel, writeregsel, writedata, write
           );
   input clk, rst;
   input [2:0] read1regsel;
   input [2:0] read2regsel;
   input [2:0] writeregsel;
   input [15:0] writedata;
   input        write;

   output [15:0] read1data;
   output [15:0] read2data;
   output        err;

   //code here
   //it is illegal in Verilog (pre-2009 when it merged into SystemVerilog) to have ports that are two (or more) 
   //dimensional arrays; for arrays on ports, only simple, one-dimensional vectors are allowed.
   //wire [15:0] regs_out [7:0];
   wire [15:0] reg_0;
   wire [15:0] reg_1;
   wire [15:0] reg_2;
   wire [15:0] reg_3;
   wire [15:0] reg_4;
   wire [15:0] reg_5;
   wire [15:0] reg_6;
   wire [15:0] reg_7;

   wire [7:0]  decode_out;
   wire [7:0]  write_signals;

   //decode write signal
   decoder3_8 inst0(.in(writeregsel), .out(decode_out));
   and2 inst1[7:0](.in1(write), .in2(decode_out), .out(write_signals));


   //accress registers
   //r_16bit isnt2[7:0](.readdata(regs_out), .clk(clk), .rst(rst), .writedata(writedata), .write(write_signals));
   r_16bit isnta0(.readdata(reg_0), .clk(clk), .rst(rst), .writedata(writedata), .write(write_signals[0]));
   r_16bit isnta1(.readdata(reg_1), .clk(clk), .rst(rst), .writedata(writedata), .write(write_signals[1]));
   r_16bit isnta2(.readdata(reg_2), .clk(clk), .rst(rst), .writedata(writedata), .write(write_signals[2]));
   r_16bit isnta3(.readdata(reg_3), .clk(clk), .rst(rst), .writedata(writedata), .write(write_signals[3]));
   r_16bit isnta4(.readdata(reg_4), .clk(clk), .rst(rst), .writedata(writedata), .write(write_signals[4]));
   r_16bit isnta5(.readdata(reg_5), .clk(clk), .rst(rst), .writedata(writedata), .write(write_signals[5]));
   r_16bit isnta6(.readdata(reg_6), .clk(clk), .rst(rst), .writedata(writedata), .write(write_signals[6]));
   r_16bit isnta7(.readdata(reg_7), .clk(clk), .rst(rst), .writedata(writedata), .write(write_signals[7]));

   //read registers based on read selects
   mux8_1_16bit inst4[1:0](.In0(reg_0),
                           .In1(reg_1),
                           .In2(reg_2),
                           .In3(reg_3),
                           .In4(reg_4),
                           .In5(reg_5),
                           .In6(reg_6),
                           .In7(reg_7),
                           .S({read1regsel, read2regsel}),
                           .Out({read1data, read2data})
                          );

endmodule
// DUMMY LINE FOR REV CONTROL :1:
