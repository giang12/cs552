module memory(readData, addr, writeData, en, write, halt, clk, rst);

    input [15:0] addr, writeData;
    input en, write, halt, clk, rst;
    output [15:0] readData; 
    
    // data mem
    memory2c DataMem(
        //output
        .data_out(readData),
        //input
        .data_in(writeData),
        .addr(addr),
        .enable(en),
        .wr(write),
        .createdump(halt),
        .clk(clk),
        .rst(rst)
    );
endmodule