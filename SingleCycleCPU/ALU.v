module ALU (
    input [3:0] ALUCtl,
    input [31:0] SrcA,SrcB,
    output reg [31:0] ALUOut,
    output Zero
);

 reg [WIDTH-1:0]temp;

parameter ADD = 0;
parameter SUB = 1;
parameter SLL = 2;
parameter SLT = 3;
parameter SLTU = 4;
parameter XOR = 5;
parameter SRL = 6;
parameter SRA = 7;
parameter OR = 8;
parameter AND = 9;

//  For Branch 
parameter BNE = 10;
parameter BLT = 11;
parameter BGE = 12;
parameter BLTU = 13;
parameter BGEU = 14;

assign ALUOut = temp;
assign Zero = ~|temp;

always@(*) begin

    case(ALUCtl) 

        ADD :temp = SrcA + SrcB ;
        SUB :temp = SrcA - SrcB ;
        SLL :temp = SrcA << SrcB ;
        SLT :temp = $signed(SrcA) < $signed(SrcB) ;
        SLTU :temp = SrcA < SrcB ;
        XOR :temp = SrcA ^ SrcB ;
        SRL :temp = SrcA >> SrcB ;
        SRA :temp = $signed(SrcA) >>> SrcB ;
        OR :temp = SrcA | SrcB ;
        AND :temp = SrcA & SrcB ;
        BNE :temp = (SrcA == SrcB);
        BLT :temp = ($signed(SrcA) < $signed(SrcB)) ? 0 : 1 ;
        BGE :temp = ($signed(SrcA) >= $signed(SrcB)) ? 0 : 1 ;
        BLTU :temp = (SrcA < SrcB)? 0 : 1 ;
        BGEU :temp = (SrcA >= SrcB)? 0 : 1 ;
        default :temp = 0;


    endcase

        

end


endmodule

