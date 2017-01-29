/* $Author: Giang Nguyen $ */
// CS/ECE 552
// 1/28/17
//97 BCD: 1001 0111

module seqdec_97 (
               input Clk,
               input Reset,
               input InA,

               output Out
               );

	wire [3:0]         state;
	reg [3:0]          next_state;

	//fsm_req
	dff curr_state[3:0] (
		        // Outputs
		        .q              (state),
		        // Inputs
		        .d              (next_state),
		        .clk            (Clk),
		        .rst            (Reset));
	//fsm_control
	always @ (*) begin
		case (state) 
		4'h0: begin
		   next_state = InA ? 4'h1 : 4'h0;
		end
		4'h1: begin
		   next_state = !InA ? 4'h2 : 4'h1;
		end
		4'h2: begin
		   next_state = !InA ? 4'h3 : 4'h1;
		end
		4'h3: begin
		   next_state = InA ? 4'h4 : 4'h0;
		end
		4'h4: begin
		   next_state = !InA ? 4'h5 : 4'h1;
		end
		4'h5: begin
		   next_state = InA ? 4'h6 : 4'h3;
		end
		4'h6: begin
		   next_state = InA ? 4'h7 : 4'h2;
		end
		4'h7: begin
		   next_state = InA ? 4'h8 : 4'h2;
		end
		4'h8: begin
		   next_state = InA ? 4'h1 : 4'h2;
		end
		default: begin
		   next_state = 4'h0;
		end
		endcase // case (state)

	end // always @ (*)


	assign Out = (state == 4'h8) ? 1 : 0;

endmodule // seqdec
