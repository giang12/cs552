module up_counter_3bit(
	clk,
	rst,
	en,
	ctr_rst,
	out,
	err
);
  
  input clk, rst, en, ctr_rst;
  output [2:0] out;
  output err;


  wire [2:0] count;
  reg [2:0] next_count;
  reg err;
  
  assign out = count;

  //count reg
  dff states[2:0](.q(count), .d(next_count), .clk(clk), .rst(rst));

   //count logic
  always @(ctr_rst or count) begin
     	err <= 1'b0;
      $display("\n IsCounter En: %b", en);

     	casex({ctr_rst, en})
     		2'b1_x: begin //ctr_rst
     			next_count <= 3'b000;
     		end
     		2'b0_x: begin //enable
     			next_count <= count + 1;//{{count[2] ^ (count[1] & count[0])}, {count[1] ^ count[0]}, ~count[0]};
     		end
     		/*2'b0_0: begin //disable
     			next_count <= count;
     		end*/
     		default: begin
     			next_count <= 3'bxxx;
     			err <= 1'b1;
     		end
     	endcase
	end

endmodule
