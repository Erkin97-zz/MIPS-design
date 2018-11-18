module program_count(clk, rst, addr_in, addr_out);
	input clk, rst;
	input [31:0] addr_in;
	output reg [31:0] addr_out;

	always @(negedge rst or posedge clk) begin
		if (!rst) begin
			addr_out <= 0;
		end
		else begin
			addr_out <= addr_in;
		end
	end

endmodule
