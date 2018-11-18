module ALU_tb;
  reg [31:0] data1, data2;
  reg [3:0] ctrl;
  wire [31:0] result;
  wire zero;
  ALU alu(data1, data2, ctrl, zero, result);
  initial begin
    data1 = 32'd14;
    data2 = 32'd9;
    ctrl = 4'b0000; // AND
    #100;
    $display("Output data1: %b, data2: %b, ctrl: %b, result: %b", 
      data1, data2, ctrl, result);
    ctrl = 4'b0001; // OR
    #100;
    $display("Output data1: %b, data2: %b, ctrl: %b, result: %b", 
      data1, data2, ctrl, result);
    ctrl = 4'b0010; // ADD
    #100;
    $display("Output data1: %b, data2: %b, ctrl: %b, result: %b", 
      data1, data2, ctrl, result);
    ctrl = 4'b0110; // SUB
    #100;
    $display("Output data1: %b, data2: %b, ctrl: %b, result: %b", 
      data1, data2, ctrl, result);
    ctrl = 4'b0111; // set on less then
    #100;
    $display("Output data1: %b, data2: %b, ctrl: %b, result: %b", 
      data1, data2, ctrl, result);
    ctrl = 4'b1100; // XOR
    #100;
    $display("Output data1: %b, data2: %b, ctrl: %b, result: %b", 
      data1, data2, ctrl, result);
    ctrl = 4'b1111; // NOP
    #100;
    $display("Output data1: %b, data2: %b, ctrl: %b, result: %b", 
      data1, data2, ctrl, result);
  end
endmodule