module ext5_16 (in, signext, out);
    input [4:0] in;
    input signext;
    output [15:0] out;
    assign out = signext ? {{11{in[4]}}, {in}} : {{11{1'b0}}, {in}};
endmodule