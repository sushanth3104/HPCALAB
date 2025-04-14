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
`include "PipelineRegister.v"
`include "Mux4to1.v"
`include "BranchDecision.v"



module PipelinedCPU (
    input clk,
    input start
    
);


wire [31:0]PCF,PCNextF,PCPlus4F,InstF,PCBranchD,PCJald,PCJalRD,PCTargetD;


wire [31:0]InstD,Rd1D,Rd2D,ImmD,ImmLD,PCPlus4D,PCD;
wire [31:0]SrcAE,SrcBE,Rd1E,Rd2E,ALUResultE,PCPlus4E,ImmE;
wire [31:0]ALUResultM,PCPlus4M,Rd2M,ReadDataM;
wire [31:0]ALUResultW,ReadDataW,PCPlus4W,ResultW;

wire RegWriteD,MemReadD,MemWriteD,ALUSrcD;
wire ALUSrcE,ReadWriteE,MemReadE,MemWriteE;
wire RegWriteE,MemReadM,MemWriteM;
wire RegWriteM;


wire [1:0]ResultSrcD,ALUOpD,PCTargetSelD;
wire [1:0]ResultSrcE,ALUOpE;
wire [1:0]ResultSrcM;
wire [1:0]ResultSrcW;


wire [3:0]ALUCtlE;

wire [4:0]Rs1D,Rs2D,WrD,WrE,WrM,WrW;

assign Rs1D = InstD[19:15];
assign Rs2D = InstD[24:20];
assign WrD = InstD[11:7];
assign SrcAE = Rd1E;

wire [6:0] Opcode;
wire [2:0] func3D,func3E,CompareResult;
wire func7_5D,func7_5E;
wire opcode_5D,opcode_5E;

assign func3D = InstD[14:12];
assign func7_5D = InstD[30];
assign opcode_5D = InstD[5];

assign  Opcode = InstD[6:0];


// Fetch Stage

wire [95:0]DataPathSignalsF;

wire [95:0]FetchStageOut,DecodeStageIn;

assign DataPathSignalsF = {PCF,PCPlus4F,InstF};

assign FetchStageOut = DataPathSignalsF;
assign {PCD,PCPlus4D,InstD} = DecodeStageIn;

PipelineRegister #(96) IF_ID(
    .clk(clk),
    .reset(start),
    .in(FetchStageOut),
    .out(DecodeStageIn)
);


// Decode Stage

wire [7:0]ControlSignalsD;
wire [137:0]DataPathSignalsD;

wire [145:0]DecodeStageOut,ExecuteStageIn;

assign ControlSignalsD = {RegWriteD,MemReadD,MemWriteD,ALUSrcD,ALUOpD,ResultSrcD};
assign DataPathSignalsD = {Rd1D,Rd2D,ImmD,PCPlus4D,WrD,func3D,func7_5D,opcode_5D};

assign DecodeStageOut = {ControlSignalsD,DataPathSignalsD};

assign {RegWriteE,MemReadE,MemWriteE,ALUSrcE,ALUOpE,ResultSrcE,Rd1E,Rd2E,ImmE,PCPlus4E,WrE,func3E,func7_5E,opcode_5E} = ExecuteStageIn;

PipelineRegister #(146) ID_EX(
    .clk(clk),
    .reset(start),
    .in(DecodeStageOut),
    .out(ExecuteStageIn)
);


// Execute Stage

wire [100:0]DataPathSignalsE;
wire [4:0]ControlSignalsE;

wire [105:0]ExecuteStageOut,MemoryStageIn;

assign ControlSignalsE = {RegWriteE,MemWriteE,MemReadE,ResultSrcE};
assign DataPathSignalsE = {ALUResultE,Rd2E,WrE,PCPlus4E};

assign ExecuteStageOut = {ControlSignalsE,DataPathSignalsE};

assign {RegWriteM,MemWriteM,MemReadM,ResultSrcM,ALUResultM,Rd2M,WrM,PCPlus4M} = MemoryStageIn;

PipelineRegister #(106) Ex_MEM(
    .clk(clk),
    .reset(start),
    .in(ExecuteStageOut),
    .out(MemoryStageIn)
);


// Memory Stage

wire [100:0]DataPathSignalsM;
wire [2:0]ControlSignalsM;
wire [103:0]MemoryStageOut,WriteBackStageIn;

assign ControlSignalsM = {RegWriteM,ResultSrcM};
assign DataPathSignalsM = {ALUResultM,ReadDataM,PCPlus4M,WrM};

assign MemoryStageOut = {ControlSignalsM,DataPathSignalsM};
assign {RegWriteW,ResultSrcW,ALUResultW,ReadDataW,PCPlus4W,WrW} = WriteBackStageIn;

PipelineRegister #(104) MEM_WB(
    .clk(clk),
    .reset(start),
    .in(MemoryStageOut),
    .out(WriteBackStageIn)
);





// Data Path & Control Path Connections 



PC PC1(
    .clk(clk),
    .rst(start),
    .pc_i(PCNextF),
    .pc_o(PCF)
);

Adder PCAdder(
    .a(PCF),
    .b(32'd4),
    .sum(PCPlus4F)
);

InstructionMemory IM(
    .readAddr(PCF),
    .inst(InstF)
);


Register RegisterFile(
    .clk(clk),
    .rst(start),
    .readReg1(Rs1D),
    .readReg2(Rs2D),
    .writeReg(WrW),
    .writeData(ResultW),
    .readData1(Rd1D),
    .readData2(Rd2D),
    .regWrite(RegWriteW)
);

BranchDecisionUnit BranchDecisionUnit(
    .Rd1(Rd1D),
    .Rd2(Rd2D),
    .CompareResult(CompareResult)
);

ImmGen ImmGen(
    .inst(InstD),
    .imm(ImmD)
);

Control Control(
    .opcode(Opcode),
    .memRead(MemReadD),
    .ResultSrc(ResultSrcD),
    .CompareResult(CompareResult),
    .ALUOp(ALUOpD),
    .memWrite(MemWriteD),
    .ALUSrc(ALUSrcD),
    .regWrite(RegWriteD),
    .PCTargetSel(PCTargetSelD),
    .func3(func3D)
);


ShiftLeftOne ShiftLeft(
    .i(ImmD),
    .o(ImmLD)
);

Mux2to1 MuxALU(
    .s0(Rd2E),
    .s1(ImmE),
    .sel(ALUSrcE),
    .out(SrcBE)
);


ALU ALU(
    .SrcA(SrcAE),
    .SrcB(SrcBE),
    .ALUCtl(ALUCtlE),
    .ALUOut(ALUResultE)
);

ALUCtrl ALUControl(
    .ALUOp(ALUOpE),
    .func3(func3E),
    .func7_5(func7_5E),
    .opcode_5(opcode_5E),
    .ALUCtl(ALUCtlE)
);

Adder PCTargetAdder(
    .a(PCD),
    .b(ImmLD),
    .sum(PCTargetD)
);

/* Mux2to1 MuxPCTarget(
    .s0(PCPlus4),
    .s1(PCTarget),
    .sel(PCSrc),
    .out(PCTargetOut)
); */


Adder JALRAdder(      // Presence of this adder enables JALR instruction to compute the target address in decode stage itself
    .a(Rd1D),
    .b(ImmD),
    .sum(PCJalRD) 
);


Mux4to1 PCTargetMux(
    .A(PCPlus4F),
    .B(PCTargetD), // For Jal 
    .C(PCJalRD),
    .D(PCTargetD), // For Branch
    .S(PCTargetSelD),
    .Y(PCNextF)
);


DataMemory DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(MemWriteM),
    .memRead(MemReadM), 
    .address(ALUResultM),
    .writeData(Rd2M),
    .readData(ReadDataM)
);


Mux3to1 MuxResultSrc(
    .A(ALUResultW),
    .B(ReadDataW),
    .C(PCPlus4W),
    .S(ResultSrcW),
    .Y(ResultW)
);




endmodule
