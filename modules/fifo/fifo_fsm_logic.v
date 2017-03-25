module fifo_fsm_logic(
	read_ptr,
	write_ptr,
	rst,
   curr_empty,
   curr_full,
	add_fifo,
	pop_fifo,
	state,
	next_state,
	fifo_empty,
   fifo_full,

   read_ctr_en,
   write_ctr_en,
      
   read_ctr_rst,
   write_ctr_rst,
   err
); 

   input [1:0] state, read_ptr, write_ptr;
   input rst, add_fifo, pop_fifo, curr_empty, curr_full;

   output [1:0] next_state;
   output fifo_empty, fifo_full, read_ctr_rst, write_ctr_rst, err;

   output read_ctr_en, write_ctr_en; 

	reg [1:0] next_state;
	reg fifo_empty, fifo_full, read_ctr_rst, write_ctr_rst, err;

   reg read_ctr_en, write_ctr_en; 

   localparam true = 1'b1;
   localparam false = 1'b0;
   localparam empty = 2'b00;
   localparam going_full = 2'b01;
   localparam full = 2'b11;
   localparam going_empty = 2'b10;

   	//FSM stage logic
   	always @(rst, add_fifo, pop_fifo, read_ptr, write_ptr, state)begin
      next_state <= state;
      fifo_empty <= false;
      fifo_full <= false;
      read_ctr_rst <= false;
      write_ctr_rst <= false;
      err <= false;
      read_ctr_en = false;
      write_ctr_en = false;
      casex({rst, state})
         3'b1_xx: begin //rst
            fifo_empty <= ~add_fifo;
            write_ctr_en = add_fifo;
            next_state <= add_fifo ? going_full : empty;
         end
         3'b0_00: begin //empty
            fifo_empty <= ~add_fifo;
            write_ctr_en = add_fifo;
            next_state <= add_fifo ? going_full : empty;
         end
         3'b0_01: begin //going full
            read_ctr_en = ~curr_empty & pop_fifo;
            write_ctr_en = ~curr_full & add_fifo;

            fifo_empty <= (read_ptr != write_ptr) & read_ctr_en & ~write_ctr_en;
            fifo_full <= (read_ptr == write_ptr) & write_ctr_en;

            next_state <= (fifo_full) ? full :
                                fifo_empty ? empty: going_full;
         end
         3'b0_11: begin //full
			   fifo_full <=  ~pop_fifo;
            read_ctr_en <= pop_fifo;
            next_state <= pop_fifo ? going_full : full;
         end
         3'b0_10: begin //going empty
            read_ctr_en = ~curr_empty & pop_fifo;
            write_ctr_en = ~curr_full & add_fifo;

            fifo_full <= (read_ptr != write_ptr) & ~read_ctr_en & write_ctr_en;
            fifo_empty <= (read_ptr == write_ptr) & read_ctr_en;

            next_state <= (read_ptr != write_ptr) ? going_empty :
                                read_ctr_en ? empty: going_full;
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
