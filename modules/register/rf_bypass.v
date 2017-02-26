/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module rf_bypass (
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

   // your code
   wire [15:0] rf_read1data, rf_read2data;
   wire [2:0] w0, w1;
   wire w3, w4, bypassdata1, bypassdata2;

   rf rf0(
          // Outputs
          .read1data                    (rf_read1data[15:0]),
          .read2data                    (rf_read2data[15:0]),
          .err                          (err),
          // Inputs
          .clk                          (clk),
          .rst                          (rst),
          .read1regsel                  (read1regsel[2:0]),
          .read2regsel                  (read2regsel[2:0]),
          .writeregsel                  (writeregsel[2:0]),
          .writedata                    (writedata[15:0]),
          .write                        (write)
        );

   //check if writeregsel match  read1regsel or read2regsel
   xor2_3bit inst0[1:0] (.in1({read1regsel, read2regsel}), .in2(writeregsel), .out({w0, w1}));

   nor3 inst1[1:0](.in1({w0[0], w1[0]}), .in2({w0[1], w1[1]}), .in3({w0[2], w1[2]}), .out({w3, w4}));
   and2 inst2[1:0](.in1({w3, w4}),.in2(write),.out({bypassdata1, bypassdata2}));

   mux2_1_16bit inst3[1:0](.InA({rf_read1data, rf_read2data}),
                           .InB(writedata),
                           .S({bypassdata1, bypassdata2}),
                           .Out({read1data, read2data})
                          );


endmodule
// DUMMY LINE FOR REV CONTROL :1:
