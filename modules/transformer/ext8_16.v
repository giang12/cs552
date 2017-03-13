module ext8_16 (in, signext, out);
    input [7:0] in;
    input signext;
    output [15:0] out;
    assign out = signext ? {{8{in[7]}}, {in}} : {{8{1'b0}}, {in}};
endmodule