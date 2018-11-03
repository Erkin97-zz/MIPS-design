module data_memory_tb;
  reg [31:0] addr, writedata;
  reg rst, MemWrite, MemRead;
  wire [31:0] readdata;
  data_memory dm(rst, addr, MemWrite, MemRead, writedata, readdata);
  initial begin
    rst = 0; // load data to the memory
    #100;
    // check reading
    rst = 1;
    MemRead = 1; 
    addr = 32'd16;  // readdata = memory[4]
    #100;
    $display("Output rst: %b, addr: %b, MemWrite: %b, MemRead: %b, writedata: %d, readdata: %d", 
    rst, addr, MemWrite, MemRead, writedata, readdata);
    // check writing
    rst = 1;
    MemRead = 0; 
    MemWrite = 1;
    writedata = 32'd97;
    addr = 32'd16;  // memory[4] = 97
    #100;
    $display("Output rst: %b, addr: %b, MemWrite: %b, MemRead: %b, writedata: %d, readdata: %d", 
    rst, addr, MemWrite, MemRead, writedata, readdata);
    // should be 97
    rst = 1;
    MemRead = 1; 
    MemWrite = 0;
    addr = 32'd16;  // memory[3] = 97
    #100;
    $display("Output rst: %b, addr: %b, MemWrite: %b, MemRead: %b, writedata: %d, readdata: %d", 
    rst, addr, MemWrite, MemRead, writedata, readdata);
  end
endmodule
