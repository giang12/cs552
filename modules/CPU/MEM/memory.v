module memory(readData, stall, err, addr, writeData, en, write, halt, clk, rst);
    
    output [15:0] readData; 
    output stall, err;
    input [15:0] addr, writeData;
    input en, write, halt, clk, rst;
    
    wire Done, CacheHit;

    // data mem
    stallmem DataMem(
       // Outputs
       .DataOut(readData), .Done(Done), .Stall(stall), .CacheHit(CacheHit), .err(err), 
       // Inputs
       .Addr(addr), .DataIn(writeData), .Rd(en & ~write), .Wr(en & write), .createdump(halt), .clk(clk), .rst(rst)
    );

    // assign Done = 1'b1;
    // assign CacheHit = 1'b1;
    // assign stall = 1'b0;
    // assign err = 1'b0;
    
    // memory2c DataMem(
    //     //output
    //     .data_out(readData),
    //     //input
    //     .data_in(writeData),
    //     .addr(addr),
    //     .enable(en),
    //     .wr(write),
    //     .createdump(halt),
    //     .clk(clk),
    //     .rst(rst)
    // );
endmodule