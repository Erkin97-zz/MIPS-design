module mux_2to1(in0, in1, sel, out);
	parameter integer N = 32;

	input [N-1:0] in0, in1;
	input sel;
	output reg [N-1:0] out;


	always@ (sel or in0 or in1) begin
		case (sel)
			0 : out <= in0;
			1 : out <= in1;
			default : out <= in0;
		endcase
	end

endmodule
