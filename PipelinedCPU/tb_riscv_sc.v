`include "SingleCycleCPU.v"
`timescale 1ns/1ps
module tb_riscv_sc;
//cpu testbench

reg clk;
reg start;


wire [31:0]X0,ra,sp,gp,tp,t0,t1,t2,s0,s1,a0,a1,a2,a3,a4,a5,a6,a7,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,t3,t4,t5,t6;

 assign X0 = riscv_DUT.RegisterFile.regs[0];
assign ra = riscv_DUT.RegisterFile.regs[1];
assign sp = riscv_DUT.RegisterFile.regs[2];
assign gp = riscv_DUT.RegisterFile.regs[3];
assign tp = riscv_DUT.RegisterFile.regs[4];
assign t0 = riscv_DUT.RegisterFile.regs[5];
assign t1 = riscv_DUT.RegisterFile.regs[6];
assign t2 = riscv_DUT.RegisterFile.regs[7];
assign s0 = riscv_DUT.RegisterFile.regs[8];
assign s1 = riscv_DUT.RegisterFile.regs[9];
assign a0 = riscv_DUT.RegisterFile.regs[10];
assign a1 = riscv_DUT.RegisterFile.regs[11];
assign a2 = riscv_DUT.RegisterFile.regs[12];
assign a3 = riscv_DUT.RegisterFile.regs[13];
assign a4 = riscv_DUT.RegisterFile.regs[14];
assign a5 = riscv_DUT.RegisterFile.regs[15];
assign a6 = riscv_DUT.RegisterFile.regs[16];
assign a7 = riscv_DUT.RegisterFile.regs[17];
assign s2 = riscv_DUT.RegisterFile.regs[18];
assign s3 = riscv_DUT.RegisterFile.regs[19];
assign s4 = riscv_DUT.RegisterFile.regs[20];
assign s5 = riscv_DUT.RegisterFile.regs[21];
assign s6 = riscv_DUT.RegisterFile.regs[22];
assign s7 = riscv_DUT.RegisterFile.regs[23];
assign s8 = riscv_DUT.RegisterFile.regs[24];
assign s9 = riscv_DUT.RegisterFile.regs[25];
assign s10 = riscv_DUT.RegisterFile.regs[26];
assign s11 = riscv_DUT.RegisterFile.regs[27];
assign t3 = riscv_DUT.RegisterFile.regs[28];
assign t4 = riscv_DUT.RegisterFile.regs[29];
assign t5 = riscv_DUT.RegisterFile.regs[30];
assign t6 = riscv_DUT.RegisterFile.regs[31];



initial begin

	$dumpfile("tb.vcd");
	$dumpvars(0,tb_riscv_sc);
	#1000 $finish;
end



SingleCycleCPU riscv_DUT(clk, start);

initial
	forever #5 clk = ~clk;

initial begin
	clk = 0;
	start = 0;
	#10 start = 1;

end

endmodule
