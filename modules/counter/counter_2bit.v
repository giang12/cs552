module counter_2bit(
	clk,
	rst,
	en,
	ctr_rst,
	out,
	err
);
  
  input clk, rst, en, ctr_rst;
  output [1:0] out;
  output err;


  wire [1:0] count;
  reg [1:0] next_count;
  reg err;
  
  assign out = count;

  //count reg
  dff states[1:0](.q(count), .d(next_count), .clk(clk), .rst(rst));

   //count logic
	always @(ctr_rst, count) begin
     	err = 1'b0;
     	casex({ctr_rst, en})
     		2'b1_x: begin //ctr_rst
     			next_count = 2'b00;
     		end
     		2'b0_1: begin //enable
     			next_count = count + 1'b1;
     		end
     		2'b0_0: begin //disable
     			next_count = count;
     		end
     		default: begin
     			next_count = 2'bxx;
     			err = 1'b1;
     		end
     	endcase
	end

endmodule
