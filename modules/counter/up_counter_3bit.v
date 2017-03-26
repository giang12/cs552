module up_counter_3bit(
	clk,
	rst,
	ctr_en,
	ctr_rst,
	out,
	err
);
  
  input clk, rst, ctr_en, ctr_rst;
  output [2:0] out;
  output err;


  wire [2:0] count;
  reg [2:0] next_count;
  reg err;
  
  assign out = count;

  //count reg
  dff states[2:0](.q(count), .d(next_count), .clk(clk), .rst(rst));

   //count logic
  always @(ctr_rst or ctr_en or count) begin
     	err <= 1'b0;
     	casex({ctr_rst, ctr_en})
     		2'b1_x: begin //ctr_rst
     			next_count <= 3'b000;
     		end
     		2'b0_1: begin //enable
     			next_count <= {{count[2] ^ (count[1] & count[0])}, {count[1] ^ count[0]}, ~count[0]};
     		end
     		2'b0_0: begin //disable
     			next_count <= count;
     		end
     		default: begin
     			next_count <= 3'bxxx;
     			err <= 1'b1;
     		end
     	endcase
	end

endmodule
