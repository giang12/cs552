module alu_control (in, Cin, invA, invB);

	input [2:0] in;
	output Cin, invA, invB;

// 001 - cin 1 and inv B
	// 011 inB 


   reg Cin_reg, invB_reg;

	always @(in) begin
		case(in)
			3'b001: begin
	   			Cin_reg = 1; 
	   			invB_reg = 1;
	   		end
      		3'b011: begin
	  			invB_reg = 1;
	      	end
	      	default: begin
	      		Cin_reg = 0;
	   			invB_reg = 0;
	      	end
		endcase
	end   

	assign invA = 0;
	assign invB = invB_reg;
	assign Cin = Cin_reg;

endmodule