/*
changed register r0 to 0
*/
module register_file(rst, RegWrite, read_reg_1, read_reg_2, write_reg, write_data, out_data_1, out_data_2);
	input rst, RegWrite;
	input [4:0] read_reg_1, read_reg_2, write_reg;
	input [31:0] write_data;
	output [31:0] out_data_1, out_data_2;
	reg [31:0] register [31:0];
	
	always@ (*) begin
		if (!rst) begin
			register[0] <= 32'd0; register[1] <= 32'd1; register[2] <= 32'd2; register[3] <= 32'd3; register[4] <= 32'd4;
			register[5] <= 32'd5; register[6] <= 32'd6; register[7] <= 32'd7; register[8] <= 32'd8; register[9] <= 32'd9;
			register[10] <= 32'd10; register[11] <= 32'd11; register[12] <= 32'd12; register[13] <= 32'd13; register[14] <= 32'd14; 
			register[15] <= 32'd15; register[16] <= 32'd16; register[17] <= 32'd17; register[18] <= 32'd18; register[19] <= 32'd19; 
			register[20] <= 32'd20; register[21] <= 32'd21; register[22] <= 32'd22; register[23] <= 32'd23; register[24] <= 32'd24; 
			register[25] <= 32'd25; register[26] <= 32'd26; register[27] <= 32'd27; register[28] <= 32'd28; register[29] <= 32'd29; 
			register[30] <= 32'd30; register[31] <= 32'd31; 
		end
		else if (RegWrite == 1) begin
			register[write_reg] <= write_data;
		end
	end
	
	assign out_data_1 = register[read_reg_1];
	assign out_data_2 = register[read_reg_2];

endmodule
