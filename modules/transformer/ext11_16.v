module ext11_16 (in, signext, out);
    input [10:0] in;
    input signext;
    output [15:0] out;
    assign out = signext ? {{5{in[10]}}, {in}} : {{5{1'b0}}, {in}};
endmodule