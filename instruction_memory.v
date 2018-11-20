/*
instruction memory is outdated so I used format using this reference: https://bit.ly/2zh8SK6
and rewrited the instruction codes
*/
module instruction_memory(rst, addr, ins);
	input rst;
	input [31:0] addr;
	output [31:0] ins;
	reg [31:0] memory[31:0];
		
	always@ (negedge rst) begin
		if (!rst) begin
			//						       OP    RS    RT    RD   SH    FU
			memory[0] <= 32'b000000_00100_01000_01010_00000_100000; // add $10, $4, $8
			memory[1] <= 32'b001000_00000_00010_00000_00000_000100; // addi $2, $0, 4
			memory[2] <= 32'b000000_00100_00101_01100_00000_100100; // and $12, $4, $5
			memory[3] <= 32'b000000_11110_00110_01101_00000_100101; // or $13, $30, $6
			memory[4] <= 32'b100011_10100_10100_00000_00000_000100; // lw $20, 4($20)
			memory[5] <= 32'b000000_00101_00001_00100_00000_100010; // sub $4, $5, $1
			memory[6] <= 32'b000000_00001_00111_00110_00000_100100; // and $6, $1, $7
			memory[7] <= 32'b101011_11000_10101_00000_00000_000100; // sw $21, 4($24)
			memory[8] <= 32'b000000_00100_01000_01001_00000_100101; // or $9, $4, $8
			memory[9] <= 32'b000000_00000_00001_00101_00000_101010; // slt $5, $0, $1
			memory[10] <= 32'b000010_00000_00000_00000_00000_000000; // j 0
			end
	end
	
	assign ins = memory[addr>>2];

endmodule
