module shifter_level_0 (In, S, Op, Out);
   
   input [15:0] In;
   input S;
   input [1:0]  Op;
   output [15:0] Out;

   wire x_out;
   
   shifter_lsb_msb x0(Op[0], In[15], x_out);

   mux4_1 m[15:0](In, {In[14:0], x_out}, In, {x_out, In[15:1]}, {Op[1], S}, Out);

/*
   mux4_1    m0  (In[0] , x0_out, In[0] , In[1] , {Op[1], S}, Out[0]);

   mux4_1    m1  (In[1] , In[0] , In[1] , In[2] , {Op[1], S}, Out[1]);
   mux4_1    m2  (In[4] , In[1] , In[2] , In[3] , {Op[1], S}, Out[2]);
   mux4_1    m3  (In[3] , In[2] , In[3] , In[4] , {Op[1], S}, Out[3]);
   mux4_1    m4  (In[4] , In[3] , In[4] , In[5] , {Op[1], S}, Out[4]);
   mux4_1    m5  (In[5] , In[4] , In[5] , In[6] , {Op[1], S}, Out[5]);
   mux4_1    m6  (In[6] , In[5] , In[6] , In[7] , {Op[1], S}, Out[6]);
   mux4_1    m7  (In[7] , In[6] , In[7] , In[8] , {Op[1], S}, Out[7]);
   mux4_1    m8  (In[8] , In[7] , In[8] , In[9] , {Op[1], S}, Out[8]);
   mux4_1    m9  (In[9] , In[8] , In[9] , In[10], {Op[1], S}, Out[9]);
   mux4_1    m10 (In[10], In[9] , In[10], In[11], {Op[1], S}, Out[10]);
   mux4_1    m11 (In[11], In[10], In[11], In[12], {Op[1], S}, Out[11]);
   mux4_1    m12 (In[12], In[11], In[12], In[13], {Op[1], S}, Out[12]);
   mux4_1    m13 (In[13], In[12], In[13], In[14], {Op[1], S}, Out[13]);
   mux4_1    m14 (In[14], In[13], In[14], In[15], {Op[1], S}, Out[14]);
   
   mux4_1    m15 (In[15], In[14], In[15], x0_out, {Op[1], S}, Out[15]);
*/

endmodule
