module sign_extend (in, out);
	input [15:0] in;
	output reg [31:0] out;

	always@ (in) begin
		if (in[15] == 0) begin
			//out[15:0] <= in[15:0];
			//out[31:16] <= 16'b0000_0000_0000_0000;
			out <= {16'b0000_0000_0000_0000, in[15:0]};
		end
		else begin
			//out[15:0] <= in[15:0];
			//out[31:16] <= 16'b1111_1111_1111_1111;
			out <= {16'b1111_1111_1111_1111, in[15:0]};
		end
	end
endmodule
