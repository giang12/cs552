

module alu (A, B, Cin, Op, invA, invB, sign, Out, Ofl, Z);
   
        input [15:0] A;
        input [15:0] B;
        input Cin;
        input [2:0] Op;
        input invA;
        input invB;
        input sign;
        output [15:0] Out;
        output Ofl;
        output Z;

   /*
	Your code goes here
   */ 
    wire [15:0] inA, inB;
    wire [15:0] shifter_out, and_out, xor_out, or_out, add_out, arithmetic_out;

    wire g_out, p_out; //use to calculate carryout (G+P*Cin) and Overflow (need carryout and sign)

    inverter_16bit inst[1:0](.in({A,B}), .inv({invA, invB}), .out({inA, inB})); //condition inputs

    //shifter 
    shifter sh1(.In(inA), .Cnt(inB[3:0]), .Op(Op[1:0]), .Out(shifter_out));

    and2_16bit inst1(.in1(inA), .in2(inB), .out(and_out));
    xor2_16bit inst2(.in1(inA), .in2(inB), .out(xor_out));
    or2_16bit inst3(.in1(inA), .in2(inB), .out(or_out));
    cla_16bit inst4(.A(inA), .B(inB), .Cin(Cin), .S(add_out), .G(g_out), .P(p_out));


    mux4_1_16bit inst5(.InA(add_out), .InB(or_out), .InC(xor_out), .InD(and_out), .S(Op[1:0]), .Out(arithmetic_out));
    mux2_1_16bit inst6(.InA(shifter_out), .InB(arithmetic_out), .S(Op[2]), .Out(Out));

    //to do
    //zero detection
    assign Ofl = 0;
    //overflow detection
    assign Z = 0;
endmodule
