module match_both(opcode, matchBoth);
    input [4:0] opcode;
    output matchBoth;
    reg matchBoth;

always @ (opcode)
begin
    casex(opcode)
      5'b01xxx:
      begin
        matchBoth <= 1'b0;
      end
      5'b11001:
      begin
        matchBoth <= 1'b0;
      end
      5'b101xx:
      begin
        matchBoth <= 1'b0;
      end
      5'b001x1:
      begin
        matchBoth <= 1'b0;
      end
      5'b1101x:
      begin
        matchBoth <= 1'b1;
      end
      5'b111xx:
      begin
        matchBoth <= 1'b1;
      end
      5'b10000:
      begin
        matchBoth <= 1'b1;
      end
      5'b10001:
      begin
        matchBoth <= 1'b0;
      end
      5'b10011:
      begin
        matchBoth <= 1'b1;
      end
      5'b10010:
      begin
        matchBoth <= 1'b0;
      end
   
     
      default:
      begin
        matchBoth <= 1'b0;
      end
    endcase
end
endmodule
