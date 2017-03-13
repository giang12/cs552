/* $Author: Giang Nguyen $ */
// CS/ECE 552
// 1/28/17

module fulladder16 (input[15:0] A, input[15:0] B, output[15:0] SUM, output CO);


wire c1,c2,c3;

fulladder4  inst0(.A(A[3:0]), .B(B[3:0]), .CI(1'b0), .SUM(SUM[3:0]), .CO(c1));
fulladder4  inst1(.A(A[7:4]), .B(B[7:4]), .CI(c1), .SUM(SUM[7:4]), .CO(c2));
fulladder4  inst2(.A(A[11:8]), .B(B[11:8]), .CI(c2), .SUM(SUM[11:8]), .CO(c3));
fulladder4  inst3(.A(A[15:12]), .B(B[15:12]), .CI(c3), .SUM(SUM[15:12]), .CO(CO));

endmodule
