module HazardUnit(
    input [6:0] opcodeD,
    input [4:0] Rs1D,
    input [4:0] Rs2D,
    input [4:0] WrE,
    input MemReadE,
    output Stall,
    output reg FlushIF_ID
);

parameter Branch = 99;
parameter JAL = 111;
parameter JALR = 103;

reg tempStall;

assign Stall = tempStall;

always @(*) begin
    
    if((MemReadE) && ((Rs1D == WrE) || (Rs2D == WrE))) begin
       tempStall = 1'b1;
    end 
    
    else begin
        tempStall = 1'b0;
    end
end

always @(*) begin
    if( ( opcodeD == Branch ) || ( opcodeD == JAL ) || ( opcodeD == JALR )) begin
        FlushIF_ID = 1'b0;
    end else begin
        FlushIF_ID = 1'b1;
    end

end


endmodule

