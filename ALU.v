module ALU(data1, data2, ctrl, zero, result);
	input [31:0] data1, data2;
	input [3:0] ctrl;
	output reg zero;
	output reg [31:0] result;
	
	always@ (ctrl or data1 or data2) begin
	// write the condition of operation
	// refer to below for ALU operation
	// if(ctrl = 4'b0000) result = data1 & data2
	// if(ctrl = 4'b0001) result = data | data2
	// if(ctrl = 4'b0010) result = data + data2;
	// if(ctrl = 4'b0110) result = data1 - data2;
	// ... 
		case(ctrl)
			4'b0000 : result <= data1 & data2; // AND
			4'b0001 : result <= data1 | data2; // OR
			4'b0010 : result <= data1 + data2; // ADD
			4'b0110 : result <= data1 - data2; // SUB
			4'b0111 : // set on less then
				begin
					if (data1 < data2) result <= 1;
					else result <= 0;
				end
			4'b1100 : result <= data1 ^ data2; // XOR
			4'b1111 : result <= 0; // NOP
		endcase
	end

	always@ (result) begin
	// write the condition of zero
		if (result == 0) zero <= 1'b1;
		else zero <= 1'b0;
	end
		
endmodule
