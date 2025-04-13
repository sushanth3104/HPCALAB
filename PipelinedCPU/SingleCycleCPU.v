`include "PC.v"
`include "Adder.v"
`include "InstructionMemory.v"
`include "Control.v"
`include "Register.v"
`include "ImmGen.v"
`include "ShiftLeftOne.v"
`include "Mux2to1.v"
`include "Mux3to1.v"
`include "ALUCtrl.v"
`include "ALU.v"
`include "DataMemory.v"



module SingleCycleCPU (
    input clk,
    input start
    
);

wire [31:0]PC,PCNext,PCPlus4,Inst,Rd1,Rd2,Imm,ImmL,SrcA,SrcB,ALUResult,PCTarget,PCTargetOut,ReadData,Result;
wire RegWrite,Branch,Jump,MemRead,MemWrite,ALUSrc,PCLoad,Zero,PCSrc,AndOutBranch;
wire [1:0]ResultSrc,ALUOp;
wire [3:0]ALUCtl;
wire [4:0]Rs1,Rs2,Wr;

assign Rs1 = Inst[19:15];
assign Rs2 = Inst[24:20];
assign Wr = Inst[11:7];
assign SrcA = Rd1;

wire [6:0] Opcode;
wire [2:0] func3;
wire func7_5;
wire opcode_5;

assign func3 = Inst[14:12];
assign func7_5 = Inst[30];
assign opcode_5 = Inst[5];

assign  Opcode = Inst[6:0];

wire [31:0] JalrResult;

PC PC1(
    .clk(clk),
    .rst(start),
    .pc_i(PCNext),
    .pc_o(PC)
);

Adder PCAdder(
    .a(PC),
    .b(32'd4),
    .sum(PCPlus4)
);

InstructionMemory IM(
    .readAddr(PC),
    .inst(Inst)
);


Register RegisterFile(
    .clk(clk),
    .rst(start),
    .readReg1(Rs1),
    .readReg2(Rs2),
    .writeReg(Wr),
    .writeData(Result),
    .readData1(Rd1),
    .readData2(Rd2),
    .regWrite(RegWrite)
);

ImmGen ImmGen(
    .inst(Inst),
    .imm(Imm)
);

Control Control(
    .opcode(Opcode),
    .branch(Branch),
    .jump(Jump),
    .memRead(MemRead),
    .ResultSrc(ResultSrc),
    .ALUOp(ALUOp),
    .PCLoad(PCLoad),
    .memWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .regWrite(RegWrite)
);

ShiftLeftOne ShiftLeft(
    .i(Imm),
    .o(ImmL)
);

Mux2to1 MuxALU(
    .s0(Rd2),
    .s1(Imm),
    .sel(ALUSrc),
    .out(SrcB)
);

ALU ALU(
    .SrcA(SrcA),
    .SrcB(SrcB),
    .ALUCtl(ALUCtl),
    .ALUOut(ALUResult),
    .Zero(Zero)
);

ALUCtrl ALUControl(
    .ALUOp(ALUOp),
    .func3(func3),
    .func7_5(func7_5),
    .opcode_5(opcode_5),
    .ALUCtl(ALUCtl)
);

Adder PCTargetAdder(
    .a(PC),
    .b(ImmL),
    .sum(PCTarget)
);

Mux2to1 MuxPCTarget(
    .s0(PCPlus4),
    .s1(PCTarget),
    .sel(PCSrc),
    .out(PCTargetOut)
);


Adder JALRAdder(      // Presence of this adder enables JALR instruction to compute the target address in decode stage itself
    .a(Rd1),
    .b(Imm),
    .sum(JalrResult) 
);


Mux2to1 MuxPCNext(            //  This is written for Unconditional Jump : JALR 
    .s0(PCTargetOut),
    .s1(JalrResult),
    .sel(PCLoad),
    .out(PCNext)
);

and andBranch(AndOutBranch,Branch,Zero);
or orPCSrc(PCSrc,AndOutBranch,Jump);


DataMemory DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(MemWrite),
    .memRead(MemRead), 
    .address(ALUResult),
    .writeData(Rd2),
    .readData(ReadData)
);


Mux3to1 MuxResultSrc(
    .A(ALUResult),
    .B(ReadData),
    .C(PCPlus4),
    .S(ResultSrc),
    .Y(Result)
);




endmodule
