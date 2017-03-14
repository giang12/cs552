

module alu (A, B, Cin, Op, invA, invB, sign, Out, Ofl, Cout, N,  Z);
   
        input [15:0] A;
        input [15:0] B;
        input Cin;
        input [2:0] Op;
        input invA;
        input invB;
        input sign;
        output [15:0] Out;

        //flags
        output Ofl, Cout, N, Z;

   /*
	Your code goes here
   */ 
    wire [15:0] inA, inB;
    wire [15:0] shifter_out, and_out, xor_out, or_out, add_out, arithmetic_out;

    wire g_out, p_out, ofl_out; //use to calculate carryout (G+P&Cin) and Overflow (need carryout, msb: sum A B and sign)
    

    inverter_16bit inst[1:0](.in({A,B}), .inv({invA, invB}), .out({inA, inB})); //condition inputs

    //shifter 
    shifter sh1(.In(inA), .Cnt(inB[3:0]), .Op(Op[1:0]), .Out(shifter_out));

    //Arithmetics
    and2_16bit and2f(.in1(inA), .in2(inB), .out(and_out));
    xor2_16bit xor2f(.in1(inA), .in2(inB), .out(xor_out));
    or2_16bit or2f(.in1(inA), .in2(inB), .out(or_out));

    cla_16bit adderf(.A(inA), .B(inB), .Cin(Cin), .S(add_out), .G(g_out), .P(p_out));

    mux4_1_16bit arith_mux(.InA(add_out), .InB(or_out), .InC(xor_out), .InD(and_out), .S(Op[1:0]), .Out(arithmetic_out));

    //final Out
    mux2_1_16bit res_mux(.InA(shifter_out), .InB(arithmetic_out), .S(Op[2]), .Out(Out));

    //setting flags
    alu_flags flags(
        //output
        .N(N),
        .Z(Z),
        .V(ofl_out),
        .C(Cout),
        //input
        .inA(inA),
        .inB(inB),
        .Result(Out),
        .G(g_out),
        .P(p_out),
        .Cin(Cin),
        .Sign(sign)
    );

    and4 should_ofl(.in1(Op[2]), .in2(~Op[1]), .in3(~Op[0]), .in4(ofl_out),  .out(Ofl)); //only Ofl on ADD

endmodule