module HazardUnit(
    input [4:0] Rs1D,
    input [4:0] Rs2D,
    input [4:0] WrE,
    input MemReadE,
    output Stall
);

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


endmodule

