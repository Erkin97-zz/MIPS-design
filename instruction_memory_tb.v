module instruction_memory_tb;
  reg rst;
  reg [31:0] addr;
  wire [31:0] ins;
  instruction_memory im(rst, addr, ins);
  initial begin
    addr = 2; // ins = memory[0]
    rst = 0;
    #100;
    $display("Output rst: %b, addr: %b, ins: %b", 
      rst, addr, ins);
    addr = 4; // ins = memory[1]
    rst = 0;
    #100;
    $display("Output rst: %b, addr: %b, ins: %b", 
      rst, addr, ins);
    addr = 8; // ins = memory[2]
    rst = 0;
    #100;
    $display("Output rst: %b, addr: %b, ins: %b", 
      rst, addr, ins);
    addr = 16; // ins = memory[3]
    rst = 0;
    #100;
    $display("Output rst: %b, addr: %b, ins: %b", 
      rst, addr, ins);
    addr = 16;
    rst = 1;
    #100;
    $display("Output rst: %b, addr: %b, ins: %b", 
      rst, addr, ins);
  end
endmodule
