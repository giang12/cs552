module fifo_fsm_logic(
	read_ptr,
	write_ptr,
	rst,
	add_fifo,
	pop_fifo,
	state,
	next_state,
	fifo_empty,
	fifo_full,
	read_ctr_rst,
	write_ctr_rst,
	err
); 

   input [1:0] state, read_ptr, write_ptr;
   input rst, add_fifo, pop_fifo;

   output [1:0] next_state;
   output fifo_empty, fifo_full, read_ctr_rst, write_ctr_rst, err;

	reg [1:0] next_state;
	reg fifo_empty, fifo_full, read_ctr_rst, write_ctr_rst, err;

   localparam true = 1'b1;
   localparam false = 1'b0;
   localparam empty = 2'b00;
   localparam going_full_empty = 2'b01;
   localparam full = 2'b11;

   	//FSM stage logic
   	always @(*) begin
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
            fifo_empty <= false;
            next_state <= add_fifo ? going_full_empty : empty;
         end
         3'b0_01: begin //neither
            fifo_empty <= (read_ptr == write_ptr) & pop_fifo;
            fifo_full <= (read_ptr == write_ptr) & add_fifo;
            next_state <= (read_ptr != write_ptr) ? going_full_empty : 
            				(add_fifo) ?  full : empty;
         end
         3'b0_11: begin //full
			   fifo_full <=  true;
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
