module instruction_memory(rst, addr, ins);
	input rst;
	input [31:0] addr;
	output [31:0] ins;
	reg [31:0] memory[31:0];
	
	// OP
	// 000000 R-Type
	// 000001 lw
	// 000010 sw
	// 000011 beq
	// 000100 Jump
	// 001000 addi
	// 001001 subi
	
	// FU (R-Type)
	// 000000 AND
	// 000001 OR
	// 000010 ADD
	// 000110 SUB
	// 000111 set on less then
	// 001100 NOR
		
	always@ (negedge rst) begin
		if (!rst) begin
			//						       OP    RS    RT    RD   SH    FU
			memory[0] <= 32'b000000_00100_01000_01010_00000_000010; // add $10, $4, $8
			memory[1] <= 32'b001000_00010_00000_00000_00000_000100; // addi $0, $2, 4
			memory[2] <= 32'b000000_00010_00101_01100_00000_000000; // and $12, $2, $5
			memory[3] <= 32'b000000_01100_00110_01101_00000_000001; // or $13, $12, $6
			memory[4] <= 32'b000001_00010_10100_00000_00000_000100; // lw $20, 4($20)
			memory[5] <= 32'b000000_00001_00101_00100_00000_000110; // sub $4, $1, $5
			memory[6] <= 32'b000000_00001_00111_00110_00000_000000; // and $6, $1, $7
			memory[7] <= 32'b000010_00011_10101_00000_00000_000100; // sw $21, 4($24)
			memory[8] <= 32'b000000_00100_01000_01001_00000_000001; // or $9, $4, $8
			memory[9] <= 32'b001001_00010_00000_00000_00000_000100; // subi $0, $2, 4
			memory[10] <= 32'b000000_00000_00001_00100_00000_001100; // nor $4, $0, $1
			memory[11] <= 32'b000000_00000_00001_00101_00000_000111; // slt $5, $0, $1
			memory[12] <= 32'b000100_00000_00000_00000_00000_000000; // j 0
			end
	end
	
	assign ins = memory[addr>>2];

endmodule