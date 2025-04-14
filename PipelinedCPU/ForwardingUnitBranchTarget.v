
module ForwardingUnitBranchTarget(
    input [4:0] Rs1D,
    input [4:0] Rs2D,
    input [4:0] WrM,
    input [4:0] WrW,
    input RegWriteM,
    input RegWriteW,
    output [1:0] ForwardAE,
    output [1:0] ForwardBE
);

// Logic For Rs1E
reg [1:0]tempA,tempB;
assign ForwardAE = tempA;
assign ForwardBE = tempB;

always @(*) begin

    if((Rs1D == WrM) & (RegWriteM) & (Rs1D != 0)) begin
        tempA = 2'b10;
    end 
    
    else if((Rs1D == WrW) & (RegWriteW) & (Rs1D != 0)) begin
       tempA = 2'b01;
    end 
    
    else begin
        tempA = 2'b00;
    end
    
end

// Logic For Rs2E

always @(*) begin

    if((Rs2D == WrM) & (RegWriteM) & (Rs2D != 0)) begin
        tempB = 2'b10;
    end 
    
    else if((Rs2D == WrW) & (RegWriteW) & (Rs2D != 0)) begin
        tempB = 2'b01;
    end 
    
    else begin
        tempB = 2'b00;
    end
    
end




endmodule