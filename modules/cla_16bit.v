
module cla_16bit(A, B, Cin, S, G, P);
	
	input [15:0] A, B;
	input Cin;
	output [15:0] S;
	output G, P;

	wire [3:0] g_w, p_w, c_w;

	//1 4 block carry lookahead
	clb4 inst1(.Cin(Cin), .Gin(g_w), .Pin(p_w), .Cout(c_w), .Gout(G), .Pout(P));
	//Carry out = c_w[3] = G | P & Cin

	//4 1 bit cla adder
	cla_4bit inst2[3:0](.A(A), .B(B), .Cin({c_w[2:0], Cin}), .S(S),.G(g_w), .P(p_w));

endmodule