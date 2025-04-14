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


wire [31:0]PCF,PCNextF,PCPlus4F,InstF,PCBranchD,PCJald,PCJalRD;


wire [31:0]InstD,Rd1D,Rd2D,ImmD,ImmLD,SrcBD,PCPlus4D,PCD;
wire [31:0]SrcAE,SrcBE,Rd1E,Rd2E,ALUResultE,PCPlus4E,ImmE;
wire [31:0]ALUResultM,ResultM,PCPlus4M,SrcBM,ReadDataM;
wire [31:0]ALUResultW,ReadDataW,PCPlus4W;

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

assign func3 = InstD[14:12];
assign func7_5 = InstD[30];
assign opcode_5 = InstD[5];

assign  Opcode = InstD[6:0];


// Fetch Stage

wire []DataPathSignalsF;

wire []FetchStageOut,DecodeStageIn;

assign DataPathSignalsF = {PCF,PCPlus4F,InstF};

assign FetchStageOut = DataPathSignalsF;
assign {PCD,PCPlus4D,InstD} = DecodeStageIn;

PipelineRegister #() IF_ID(
    .clk(clk),
    .rst(start),
    .in(FetchStageOut),
    .out(DecodeStageIn)
);


// Decode Stage

wire []ControlSignalsD;
wire []DataPathSignalsD;

wire []DecodeStageOut,ExecuteStageIn;

assign ControlSignalsD = {RegWriteD,MemReadD,MemWriteD,ALUSrcD,ALUOpD,ResultSrcD};
assign DataPathSignalsD = {Rd1D,Rd2D,ImmD,PCPlus4D,WrD,func3D,func7_5D,opcode_5D};

assign DecodeStageOut = {ControlSignalsD,DataPathSignalsD};

assign {RegWriteE,MemReadE,MemWriteE,ALUSrcE,ALUOpE,ResultSrcE,Rd1E,Rd2E,ImmE,PCPlus4E,WrE,func3E,func7_5E,opcode_5E} = ExecuteStageIn;

PipelineRegister #() ID_EX(
    .clk(clk),
    .rst(start),
    .in(DecodeStageOut),
    .out(ExecuteStageIn)
);


// Execute Stage

wire []DataPathSignalsE;
wire []ControlSignalsE;

wire []ExecuteStageOut,MemoryStageIn;

assign ControlSignalsE = {RegWriteE,MemWriteE,MemReadE,ResultSrcE};
assign DataPathSignalsE = {ALUResultE,SrcBE,WrE,PCPlus4E};

assign ExecuteStageOut = {ControlSignalsE,DataPathSignalsE};

assign {RegWriteM,MemWriteM,MemReadM,ResultSrcM,ALUResultM,SrcBM,WrM,PCPlus4M} = MemoryStageIn;

PipelineRegister #() Ex_MEM(
    .clk(clk),
    .rst(start),
    .in(ExecuteStageOut),
    .out(MemoryStageIn)
);


// Memory Stage

wire []DataPathSignalsM;
wire []ControlSignalsM;
wire []MemoryStageOut,WriteBackStageIn;

assign ControlSignalsM = {RegWriteM,ResultSrcM};
assign DataPathSignalsM = {ALUResultM,ReadDataM,PCPlus4M,WrM};

assign MemoryStageOut = {ControlSignalsM,DataPathSignalsM};
assign {RegWriteW,ResultSrcW,ALUResultW,ReadDataW,PCPlus4W,WrW} = WriteBackStageIn;

PipelineRegister #() MEM_WB(
    .clk(clk),
    .rst(start),
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
    .regWrite(RegWrite)
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
    .memRead(MemRead),
    .ResultSrc(ResultSrc),
    .CompareResult(CompareResult),
    .ALUOp(ALUOp),
    .memWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .regWrite(RegWrite),
    .PCTargetSel(PCTargetSel),
    func3(func3)
);


ShiftLeftOne ShiftLeft(
    .i(ImmD),
    .o(ImmLD)
);

Mux2to1 MuxALU(
    .s0(Rd2D),
    .s1(ImmD),
    .sel(ALUSrc),
    .out(SrcBD)
);


ALU ALU(
    .SrcA(SrcAE),
    .SrcB(SrcBE),
    .ALUCtl(ALUCtl),
    .ALUOut(ALUResultE)
);

ALUCtrl ALUControl(
    .ALUOp(ALUOp),
    .func3(func3),
    .func7_5(func7_5),
    .opcode_5(opcode_5),
    .ALUCtl(ALUCtl)
);

Adder PCTargetAdder(
    .a(PCD),
    .b(ImmLD),
    .sum(PCTarget)
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
    .B(PCTarget), // For Jal 
    .C(PCJalRD),
    .D(PCTarget), // For Branch
    .S(PCTargetSel),
    .Y(PCNextF)
);


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
    .A(ALUResultW),
    .B(ReadDataW),
    .C(PCPlus4W),
    .S(ResultSrc),
    .Y(ResultW)
);




endmodule
