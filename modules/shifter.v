module shifter (In, Cnt, Op, Out);
   
   input [15:0] In;
   input [3:0]  Cnt;
   input [1:0]  Op;
   output [15:0] Out;

   wire [15:0] out_0, out_1, out_2;

   shifter_level_0 l0(In   , Cnt[0], Op, out_0);
   shifter_level_1 l1(out_0, Cnt[1], Op, out_1);
   shifter_level_2 l2(out_1, Cnt[2], Op, out_2);
   shifter_level_3 l3(out_2, Cnt[3], Op, Out  );

   endmodule
