/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module fifo(/*AUTOARG*/
   // Outputs
   data_out, fifo_empty, fifo_full, err,
   // Inputs
   data_in, data_in_valid, pop_fifo, clk, rst
   );

   input [63:0] data_in;
   input        data_in_valid; //writeSignal
   input        pop_fifo; //readSignal

   input        clk;
   input        rst;
   output [63:0] data_out;
   output        fifo_empty;
   output        fifo_full;
   output        err;

reg [63:0] out;
 

reg [63:0] regarray[3:0]; //number of words in fifo = 2^(number of address bits)
reg [1:0] wr_reg, wr_next, wr_succ; //points to the register that needs to be written to
reg [1:0] rd_reg, rd_next, rd_succ; //points to the register that needs to be read from
reg full_reg, empty_reg, full_next, empty_next;
 
assign wr_en = data_in_valid & ~fifo_full; //only write if write signal is high and fifo is not full
 
//always block for write operation
always @ (posedge clk)
 begin
  if(wr_en)
   regarray[wr_reg] <= data_in;  //at wr_reg location of regarray store what is given at din
 
 end
  
//always block for read operation
always @ (posedge clk)
 begin
   out <= regarray[rd_reg];
 end
  
 
always @ (posedge clk or posedge rst)
 begin
  if (clk)
   begin
   wr_reg <= 0;
   rd_reg <= 0;
   full_reg <= 1'b0;
   empty_reg <= 1'b1;
   end
   
  else
   begin
   wr_reg <= wr_next; //created the next registers to avoid the error of mixing blocking and non blocking assignment to the same signal
   rd_reg <= rd_next;
   full_reg <= full_next;
   empty_reg <= empty_next;
   end
 end
  
always @(*)
 begin
  wr_succ = wr_reg + 1; //assigned to new value as wr_next cannot be tested for in same always block
  rd_succ = rd_reg + 1; //assigned to new value as rd_next cannot be tested for in same always block
  wr_next = wr_reg;  //defaults state stays the same
  rd_next = rd_reg;  //defaults state stays the same
  full_next = full_reg;  //defaults state stays the same
  empty_next = empty_reg;  //defaults state stays the same
   
   case({data_in_valid,pop_fifo})
    //2'b00: do nothing LOL..
     
    2'b01: //read
     begin
      if(~fifo_empty) //if fifo is not empty continue
       begin
        rd_next = rd_succ;
        full_next = 1'b0;
       if(rd_succ == wr_reg) //all data has been read
         empty_next = 1'b1;  //its empty again
       end
     end
     
    2'b10: //write
     begin
       
      if(~fifo_full) //if fifo is not full continue
       begin
        wr_next = wr_succ;
        empty_next = 1'b0;
        if(wr_succ == (3)) //all registers have been written to
         full_next = 1'b1;   //its full now
       end
     end
      
    2'b11: //read and write
     begin
      wr_next = wr_succ;
      rd_next = rd_succ;
     end
     //no empty or full flag will be checked for or asserted in this state since data is being written to and read from together it can  not get full in this state.
    endcase
    
 
 end
 
assign fifo_full = full_reg;
assign fifo_empty = empty_reg;
assign data_out = out;
endmodule

//    input [63:0] data_in;
//    input        data_in_valid; //writeSignal
//    input        pop_fifo; //readSignal

//    input        clk;
//    input        rst;
//    output [63:0] data_out;
//    output        fifo_empty;
//    output        fifo_full;
//    output        err;

//    //your code here
//    wire fifo_empty, fifo_full, err;
//    wire en0, en1, en2, en3;
//    wire [63:0] reg_out0, reg_out1, reg_out2, reg_out3;
//    // pointers 
//    wire [1:0] read_ptr, write_ptr;

//    //counters
//    wire read_ctr_en, write_ctr_en, read_ctr_rst, write_ctr_rst;

//    counter_2bit read_ctr(.clk(clk), .rst(rst), .en(read_ctr_en), .ctr_rst(read_ctr_rst), .out(read_ptr), .err());
//    counter_2bit write_ctr(.clk(clk), .rst(rst), .en(write_ctr_en), .ctr_rst(write_ctr_rst), .out(write_ptr), .err());
   
//    wire curr_empty_flag, curr_full_flag;

//    dff empty_flag(.q(curr_empty_flag), .d(fifo_empty), .clk(clk), .rst(rst));
//    dff full_flag(.q(curr_full_flag), .d(fifo_full), .clk(clk), .rst(rst)); 
   
//    wire add, pop;
//    wire [63:0] data, next_data;
//    assign next_data = data_in_valid ? data_in : data;
//    dff dataff[63:0](.q(data), .d(next_data), .clk(clk), .rst(rst));


//    dff addff(.q(add), .d(data_in_valid), .clk(clk), .rst(rst));
//    dff popff(.q(pop), .d(pop_fifo), .clk(clk), .rst(rst)); 

//    //fifo_fsm_stage
//    wire[1:0] curr_state;
//    wire [1:0] next_state;
//    dff fsm_stage[1:0](.q(curr_state),.d(next_state),.clk(clk),.rst(rst));

//    fifo_fsm_logic fsm_logic(
//       //input
//       .read_ptr(read_ptr),
//       .write_ptr(write_ptr),
//       .rst(rst),
//       .curr_empty(curr_empty_flag),
//       .curr_full(curr_full_flag),
//       .add_fifo(add),
//       .pop_fifo(pop),
//       .state(curr_state),

//       //output
//       .next_state(next_state),

//       .fifo_empty(fifo_empty),
//       .fifo_full(fifo_full),

//       .read_ctr_en(read_ctr_en),
//       .write_ctr_en(write_ctr_en),
      
//       .read_ctr_rst(read_ctr_rst),
//       .write_ctr_rst(write_ctr_rst),
//       .err()
//    );

//    //fifo regs
//    wire [3:0] decode_out;
//    wire [63:0] reg_out;
//    wire bypass;
//    assign bypass = (write_ptr == read_ptr) & (write_ctr_en | ~read_ctr_en);
//    decoder2_4 decoder(.in(write_ptr), .out(decode_out));
    
//    and2 and_0(.out(en0), .in1(write_ctr_en), .in2(decode_out[0]));
//    and2 and_1(.out(en1), .in1(write_ctr_en), .in2(decode_out[1]));
//    and2 and_2(.out(en2), .in1(write_ctr_en), .in2(decode_out[2]));
//    and2 and_3(.out(en3), .in1(write_ctr_en), .in2(decode_out[3]));

//    register_64bit inst0(.readdata(reg_out0), .clk(clk), .rst(rst), .writedata(data) , .write(en0));
//    register_64bit inst1(.readdata(reg_out1), .clk(clk), .rst(rst), .writedata(data) , .write(en1));
//    register_64bit inst2(.readdata(reg_out2), .clk(clk), .rst(rst), .writedata(data) , .write(en2));
//    register_64bit inst3(.readdata(reg_out3), .clk(clk), .rst(rst), .writedata(data) , .write(en3));

//    mux4_1_64bit mux_out(.InA(reg_out0), .InB(reg_out1), .InC(reg_out2), .InD(reg_out3), .S(read_ptr), .Out(reg_out));

//    mux2_1_64bit mux_mux(.InA(reg_out), .InB(data), .S(bypass), .Out(data_out));

//    always @(posedge clk) begin
//       $display("\n curr_state: %b next_state: %b, read_ctr_en: %b, write_ctr_en: %b", curr_state, next_state, read_ctr_en, write_ctr_en);
//       $display("\n read_ctr: %d write_ctr: %d", read_ptr, write_ptr);

//    end

// endmodule

// DUMMY LINE FOR REV CONTROL :1:
