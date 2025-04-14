
module ForwardingUnit(
    input [4:0] Rs1E,
    input [4:0] Rs2E,
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

    if((Rs1E == WrM) & (RegWriteM) & (Rs1E != 0)) begin
        tempA = 2'b10;
    end 
    
    else if((Rs1E == WrW) & (RegWriteW) & (Rs1E != 0)) begin
       tempA = 2'b01;
    end 
    
    else begin
        tempA = 2'b00;
    end
    
end

// Logic For Rs2E

always @(*) begin

    if((Rs2E == WrM) & (RegWriteM) & (Rs2E != 0)) begin
        tempB = 2'b10;
    end 
    
    else if((Rs2E == WrW) & (RegWriteW) & (Rs2E != 0)) begin
        tempB = 2'b01;
    end 
    
    else begin
        tempB = 2'b00;
    end
    
end




endmodule