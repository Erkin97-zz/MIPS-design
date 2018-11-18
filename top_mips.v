module top_mips(
		clk, rst, // Input
		PCaddr, IM_Ins, // IF Stage output
		OP, RS, RT, RD, SH, FU, RF_D1, RF_D2, SE, // ID Stage output
		ALU_Result, ALU_Zero, Branch_Addr, // EX Stage output
		Wrtie_Data, Read_Data, // MEM Stage output
		WB_Data // WB Stage output
	);

//////////////////////////////////////////////////////////////////////////////////////////////
//			input/output port

	// input
	input clk, rst;

	// output
	output [31:0] PCaddr, IM_Ins, RF_D1, RF_D2, SE, ALU_Result, Branch_Addr, Wrtie_Data, Read_Data, WB_Data;
	output [5:0] OP, FU;
	output [4:0] RS, RT, RD, SH;
	output ALU_Zero;
	
//////////////////////////////////////////////////////////////////////////////////////////////
//			wire/reg
	
	// IF stage wire
	wire [31:0] w_IF_PC_IM_PCAdder, w_IF_PCAdder_MUX_IFID, w_IF_MUX_PC, w_IF_MUX, w_IF_IM_IFID;
	
	// IF/ID stage reg
	reg [31:0] IFID_PC, IFID_Ins;
	
	// ID stage wire
	wire [5:0] w_op, w_fu;
	wire [4:0] w_rs, w_rt, w_rd, w_sh;
	wire [31:0] w_ID_Read_D1_IDEX, w_ID_Read_D2_IDEX, w_ID_SE_IDEX;
	
	wire [3:0] w_EX;
	wire [2:0] w_MEM;
	wire [1:0] w_WB;
	wire Jump;
	
	// ID/EX stage reg
	reg [31:0] IDEX_PC, IDEX_D1, IDEX_D2, IDEX_SE;
	reg [4:0] IDEX_RT, IDEX_RD;
	reg [3:0] IDEX_EX;
	reg [2:0] IDEX_MEM;
	reg [1:0] IDEX_WB;
	
	// EX stage wire
	wire [31:0] w_EX_PC_EXMEM, w_EX_MUX_ALU_D2, w_EX_ALU_Result;
	wire [4:0] w_EX_RegDst_EXMEM;
	wire [3:0] w_EX_ALU_Ctrl;
	wire w_EX_Zero;
	
	// EX/MEM stage reg
	reg [2:0] EXMEM_MEM;
	reg [1:0] EXMEM_WB;
	reg [31:0] EXMEM_PC, EXMEM_ALU_Result, EXMEM_Read_D2;
	reg [4:0] EXMEM_RegDst;
	reg EXMEM_Zero;
	
	// MEM stage wire
	wire [31:0] w_MEM_Read_Data_MEMWB;
	
	// MEM/WB stage reg
	reg [31:0] MEMWB_ReadData, MEMWB_ALU_Result;
	reg [4:0] MEMWB_RegDst;
	reg [1:0] MEMWB_WB;

	// WB stage wire
	wire [31:0] w_MUX_RF;

//////////////////////////////////////////////////////////////////////////////////////////////
//			for debug

	initial begin
		$monitor(
			"[IF/ID  STAGE]PC: %d ", IFID_PC,
			"INS: %b\n", IFID_Ins,
			"[ID/EX  STAGE]PC: %d ", IDEX_PC,
			"D1: %b ", IDEX_D1,
			"D2: %b ", IDEX_D2,
			"SE: %b ", IDEX_SE,
			"RT: %b ", IDEX_RT,
			"RD: %b ", IDEX_RD,
			"EX: %b ", IDEX_EX,
			"MEM: %b ", IDEX_MEM,
			"WB: %b\n", IDEX_WB,
			"[EX/MEM STAGE]PC: %d ", EXMEM_PC,
			"RES: %b ", EXMEM_ALU_Result,
			"ZERO: %b ", EXMEM_Zero,
			"D2: %b ", EXMEM_Read_D2,
			"RegDst: %b ", EXMEM_RegDst,
			"MEM: %b ", EXMEM_MEM,
			"WB: %b\n", EXMEM_WB,
			"[MEM/WB STAGE]RD: %b ", MEMWB_ReadData,
			"ALU_RES: %b ", MEMWB_ALU_Result,
			"RegDst: %b ", MEMWB_RegDst,
			"WB: %b\n", MEMWB_WB
		);
	end

//////////////////////////////////////////////////////////////////////////////////////////////
//			IF stage

	program_count PC(
		.clk(clk),
		.rst(rst),
		.addr_in(w_IF_MUX_PC),
		.addr_out(w_IF_PC_IM_PCAdder)
	);

	instruction_memory IM(
		.rst(rst),
		.addr(w_IF_PC_IM_PCAdder),
		.ins(w_IF_IM_IFID)
	);
	
	// Implement program count adder using assign
	assign w_IF_PCAdder_MUX_IFID = w_IF_PC_IM_PCAdder + 4;

	mux_2to1 #(
		.N(32)
	) IF_PCSrc_MUX (
		.in0(w_IF_PCAdder_MUX_IFID),
		.in1(EXMEM_PC),
		.sel(EXMEM_MEM[2]),
		.out(w_IF_MUX)
	);
	
	mux_2to1 #(
		.N(32)
	) IF_Jump_MUX (
		.in0(w_IF_MUX),
		.in1({4'b0, IFID_Ins[25:0], 2'b0}),
		.sel(Jump),
		.out(w_IF_MUX_PC)
	);
	
//////////////////////////////////////////////////////////////////////////////////////////////
//			IF/ID stage

	always@ (posedge clk or negedge rst) begin
		if (!rst) begin
			IFID_PC <= 32'b0;
			IFID_Ins <= 32'b0;		
		end
		else begin
			IFID_PC <= w_IF_PCAdder_MUX_IFID;
			IFID_Ins <= w_IF_IM_IFID;
		end
	end
	
//////////////////////////////////////////////////////////////////////////////////////////////
//			ID stage

	// Implement instruction decoder using assign
	assign w_op = IFID_Ins[31:26];
	assign w_rs = IFID_Ins[25:21];
	assign w_rt = IFID_Ins[20:16];
	assign w_rd = IFID_Ins[15:11];
	assign w_sh = IFID_Ins[10:6];
	assign w_fu = IFID_Ins[5:0];

	control_unit CU(
		.opcode(w_op),
		.Jump(Jump),
		.EX(w_EX),
		.MEM(w_MEM),
		.WB(w_WB)
	);
	
	//module register_file(rst, RegWrite, read_reg_1, read_reg_2, write_reg, write_data, out_data_1, out_data_2);
	register_file RF(
		.rst(rst),
		.RegWrite(MEMWB_WB[1]),
		.read_reg_1(w_rs),
		.read_reg_2(w_rt),
		.write_reg(MEMWB_RegDst),
		.write_data(w_MUX_RF),
		.out_data_1(w_ID_Read_D1_IDEX),
		.out_data_2(w_ID_Read_D2_IDEX)
	);
	
	sign_extend SE_1(
		.in({w_rd, w_sh, w_fu}),
		.out(w_ID_SE_IDEX)
	);

//////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////
//		ID/EX stage

	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			IDEX_PC <= 32'b0;
			IDEX_D1 <= 32'b0;
			IDEX_D2 <= 32'b0;
			IDEX_SE <= 32'b0;
			IDEX_RT <= 5'b0;
			IDEX_RD <= 5'b0;
			IDEX_EX <= 4'b0;
			IDEX_MEM <= 3'b0;
			IDEX_WB <= 2'b0;
		end
		else begin
			IDEX_PC <= IFID_PC;
			IDEX_D1 <= w_ID_Read_D1_IDEX;
			IDEX_D2 <= w_ID_Read_D2_IDEX;
			IDEX_SE <= w_ID_SE_IDEX;
			IDEX_RT <= w_rt;
			IDEX_RD <= w_rd;
			IDEX_EX <= w_EX;
			IDEX_MEM <= w_MEM;
			IDEX_WB <= w_WB;
		end
	end
	
//////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////
//		EX stage
//		EX reg: RegDst, ALUOp[1:0], ALUSrc

	assign w_EX_PC_EXMEM = IDEX_PC + (IDEX_SE << 2);

	mux_2to1 #(
		.N(32)
	) ALUSrc_MUX (
		.in0(IDEX_SE),
		.in1(IDEX_D2),
		.sel(IDEX_EX[0]),
		.out(w_EX_MUX_ALU_D2)
	);

	ALU ALU(
		.data1(IDEX_D1),
		.data2(w_EX_MUX_ALU_D2),
		.ctrl(w_EX_ALU_Ctrl),
		.zero(w_EX_Zero),
		.result(w_EX_ALU_Result)
	);

	alu_control_unit ACU(
		.ins(IDEX_SE[5:0]),
		.ALUOp(IDEX_EX[2:1]),
		.ALUctrl(w_EX_ALU_Ctrl)
	);
	
	mux_2to1 #(
		.N(5)
	) REG_DST_MUX (
		.in0(IDEX_RD),
		.in1(IDEX_RT),
		.sel(IDEX_EX[3]),
		.out(w_EX_RegDst_EXMEM)
	);

//////////////////////////////////////////////////////////////////////////////////////////////
//		EX/MEM stage

	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			EXMEM_PC <= 32'b0;
			EXMEM_ALU_Result <= 32'b0;
			EXMEM_Zero <= 1'b0;
			EXMEM_Read_D2 <= 32'b0;
			EXMEM_RegDst <= 5'b0;
			EXMEM_MEM <= 3'b0;
			EXMEM_WB <= 2'b0;
		end
			
		else begin
			EXMEM_PC <= w_EX_PC_EXMEM;
			EXMEM_ALU_Result <= w_EX_ALU_Result;
			EXMEM_Zero <= w_EX_Zero;
			EXMEM_Read_D2 <= IDEX_D2;
			EXMEM_RegDst <= w_EX_RegDst_EXMEM;
			EXMEM_MEM <= IDEX_MEM;
			EXMEM_WB <= IDEX_WB;
		end
	end

//////////////////////////////////////////////////////////////////////////////////////////////
//		MEM stage
//		MEM reg: Branch, Mem-Read, Mem-Write
	
	data_memory DM(
		.rst(rst),
		.addr(EXMEM_ALU_Result),
		.MemWrite(EXMEM_MEM[0]),
		.MemRead(EXMEM_MEM[1]),
		.writedata(EXMEM_Read_D2),
		.readdata(w_MEM_Read_Data_MEMWB)
	);

//////////////////////////////////////////////////////////////////////////////////////////////
//		MEM/WB stage

	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			MEMWB_WB <= 2'b0;
			MEMWB_ReadData <= 32'b0;
			MEMWB_ALU_Result <= 32'b0;
			MEMWB_RegDst <= 5'b0;
		end
			
		else begin
			MEMWB_WB <= EXMEM_WB;
			MEMWB_ReadData <= w_MEM_Read_Data_MEMWB;
			MEMWB_ALU_Result <= EXMEM_ALU_Result;
			MEMWB_RegDst <= EXMEM_RegDst;
		end
	end

//////////////////////////////////////////////////////////////////////////////////////////////
//		WB stage
//		WB reg: Reg-Write, MemtoReg

	mux_2to1 #(
		.N(32)
	) WB_MUX (
		.in0(MEMWB_ReadData),
		.in1(MEMWB_ALU_Result),
		.sel(MEMWB_WB[0]),
		.out(w_MUX_RF)
	);

//////////////////////////////////////////////////////////////////////////////////////////////
//		output assign

	assign PCaddr = w_IF_PC_IM_PCAdder;
	assign IM_Ins = w_IF_IM_IFID;
	assign OP = w_op;
	assign RS = w_rs;
	assign RT = w_rt;
	assign RD = w_rd;
	assign SH = w_sh;
	assign FU = w_fu;
	assign RF_D1 = w_ID_Read_D1_IDEX;
	assign RF_D2 = w_ID_Read_D2_IDEX;
	assign SE = w_ID_SE_IDEX;
	assign ALU_Result = w_EX_ALU_Result;
	assign ALU_Zero = w_EX_Zero;
	assign Branch_Addr = w_EX_PC_EXMEM;
	assign Wrtie_Data = EXMEM_Read_D2;
	assign Read_Data = w_MEM_Read_Data_MEMWB;
	assign WB_Data = w_MUX_RF;
	
//////////////////////////////////////////////////////////////////////////////////////////////

endmodule
