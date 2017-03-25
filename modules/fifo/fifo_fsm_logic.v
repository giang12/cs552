module fifo_fsm_logic(
	input [1:0] read_ptr,
	input [1:0] write_ptr,
	input rst,
	input add_fifo,
	input pop_fifo,
	input [1:0] state,
	output [1:0] next_state,
	output fifo_empty,
	output fifo_full,
	output read_ctr_rst,
	output write_ctr_rst,
	output err
);
	reg [1:0] next_state;
	reg fifo_empty, fifo_full, read_ctr_rst, write_ctr_rst, err;

   localparam true = 1'b1;
   localparam false = 1'b0;
   localparam empty = 2'b00;
   localparam going_full_empty = 2'b01;
   localparam full = 2'b11;

   	//FSM stage logic
   	always @(rst or state) begin
      next_state <= state;
      fifo_empty <= false;
      fifo_full <= false;
      read_ctr_rst <= false;
      write_ctr_rst <= false;
      err <= false;

      casex({rst, state})
         3'b1_xx: begin //rst
            fifo_empty <= true;
            next_state <= empty;
         end
         3'b0_00: begin //empty
            fifo_empty <= true;
            next_state <= add_fifo ? going_full_empty : empty;
         end
         3'b0_01: begin //neither
            next_state <= (read_ptr != write_ptr) ? going_full_empty : 
            				(add_fifo) ?  full : empty;
         end
         3'b0_11: begin //full
			fifo_full <= true;
            next_state <= pop_fifo ? going_full_empty : full;
         end
         default: begin
            err <= true;
            //reset counter on errors to recover
            read_ctr_rst <= true;
            write_ctr_rst <= true;
         end
      endcase
   end


endmodule
