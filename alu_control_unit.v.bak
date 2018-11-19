module alu_control_unit(ins, ALUOp, ALUctrl);
	input [5:0] ins;
	input [1:0] ALUOp;
	output reg [3:0] ALUctrl;
	always@ (ins or ALUOp) begin
	  if (ALUOp == 2'b00) 
	    ALUctrl <= 4'b0010;
	  else if (ALUOp == 2'b01) 
	    ALUctrl <= 4'b0110;
	  else if (ALUOp == 2'b10)
	    case(ins)
	       6'b100000 : ALUctrl <= 4'b0010; // AND
	       6'b100010 : ALUctrl <= 4'b0110; // SUB
	       6'b100100 : ALUctrl <= 4'b0000; // AND
	       6'b100101 : ALUctrl <= 4'b0001; // OR
	       6'b101010 : ALUctrl <= 4'b0111; // set-on-less-than
	    endcase
	end

// complete the code

endmodule

