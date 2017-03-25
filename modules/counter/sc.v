/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */

//6states. saturating counter up to 5

module sc( clk, rst, ctr_rst, out, err);
   input clk;
   input rst;
   input ctr_rst;
   output [2:0] out;
   output err;

   // your code
   wire [2:0] state;
   reg [2:0] next_state;
   reg err;
   
   assign out = state;
   
   //state reg
   dff states[2:0](.q(state), .d(next_state), .clk(clk), .rst(rst));

   //state logic
	always @(ctr_rst or state) begin
      err = 1'b0;
		case(state)
			   3'b000: begin
      			next_state = ctr_rst ? 3'b000 : 3'b001;
      		end
      		3'b001: begin
      			next_state = ctr_rst ? 3'b000 : 3'b010;
      		end
      		3'b010: begin
      			next_state = ctr_rst ? 3'b000 : 3'b011;
      		end
      		3'b011: begin
      			next_state = ctr_rst ? 3'b000 : 3'b100;
      		end
      		3'b100: begin
      			next_state = ctr_rst ? 3'b000 : 3'b101;
      		end
      		3'b101: begin
      			next_state = ctr_rst ? 3'b000 : 3'b101;
      		end
      		default: begin
      			next_state = 3'bxxx;
      			err = 1'b1;
      		end
		endcase
	end   
endmodule

// DUMMY LINE FOR REV CONTROL :1:
