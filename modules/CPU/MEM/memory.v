module memory(readData, stall, err, addr, writeData, en, write, halt, clk, rst);
    
    output [15:0] readData; 
    output stall, err;
    input [15:0] addr, writeData;
    input en, write, halt, clk, rst;
    
    wire Done, CacheHit;
    // data mem
    mem_system DataMem(
       // Outputs
       .DataOut(readData), .Done(Done), .Stall(stall), .CacheHit(CacheHit), .err(err), 
       // Inputs
       .Addr(addr), .DataIn(writeData), .Rd(en & ~write), .Wr(en & write), .createdump(halt | err), .clk(clk), .rst(rst)
    );

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