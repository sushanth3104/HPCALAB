module HazardUnit(
    input [6:0] opcodeD,
    input [4:0] Rs1D,
    input [4:0] Rs2D,
    input [4:0] WrE,
    input [1:0]BranchTaken,
    input MemReadE,
    input RegWriteE,
    output Stall,
    output reg FlushIF_ID
);

parameter Branch = 99;
parameter JAL = 111;
parameter JALR = 103;

reg tempStall_lw,tempStall_branch;

assign Stall = tempStall_branch || tempStall_lw;

always @(*) begin
    
    if((MemReadE) && ((Rs1D == WrE) || (Rs2D == WrE))) begin
       tempStall_lw = 1'b1;
    end 
    
    else begin
        tempStall_lw = 1'b0;
    end
end

always @(*) begin
    if(( opcodeD == JAL ) || ( opcodeD == JALR )) begin
        FlushIF_ID = 1'b0;
    end
    else if((opcodeD == Branch)&&(BranchTaken == 1)) begin
        FlushIF_ID = 1'b0;
    end
     else begin
        FlushIF_ID = 1'b1;
    end

end



always @(*) begin

    if((opcodeD == Branch) && (RegWriteE) && ((Rs1D == WrE) || (Rs2D == WrE))) begin
       tempStall_branch = 1'b1;
    end 
    else begin
        tempStall_branch = 1'b0;
    end
    end
    

endmodule

