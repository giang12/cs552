module memory(readData, addr, writeData, en, write, halt, clk, rst);

    input [15:0] addr, writeData;
    input en, write, halt, clk, rst;
    output [15:0] readData; 
    
    // instruction mem
    memory2c DataMem( 	.data_out(readData),
                        .data_in(writeData),
                        .addr(addr),
                        .enable(en),
                        .wr(write),
                        .createdump(halt),
                        .clk(clk),
                        .rst(rst)
                    );


endmodule 