module ALUCtrl(
    input [1:0]ALUOp,
    input [2:0]func3,
    input func7_5,opcode_5,
    output [3:0]ALUCtl
);

reg [3:0]temp;
assign ALUCtl = temp;

// Issued by the Control Unit - ALUOp
parameter Load_Store_Type = 0;


//parameter Branch_Type = 1;   No longer needed as it is decoupled form ALU

parameter IR_Type = 2;


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

/* parameter BNE = 10;
parameter BLT = 11;
parameter BGE = 12;
parameter BLTU = 13;
parameter BGEU = 14;
 */

always @(*) begin
    case(ALUOp)

        Load_Store_Type : temp = ADD;

       /*  Branch_Type: begin
            case(func3)
                3'b000: temp = SUB;
                3'b001: temp = BNE;
                3'b100: temp = BLT;
                3'b101: temp = BGE;
                3'b110: temp = BLTU;
                3'b111: temp = BGEU;
                default: temp = 0;
            endcase 
        end */

        IR_Type: begin
            case(func3)

                3'b000: begin
                    if({opcode_5,func7_5}  == 2'b11) temp = SUB ;
                    else temp = ADD;
                end

                3'b001: temp = SLL;
                3'b010: temp = SLT;
                3'b011: temp = SLTU;
                3'b100: temp = XOR;

                3'b101: begin
                    if(func7_5) temp = SRA;
                    else temp = SRL;
                end

                3'b110: temp = OR;
                3'b111: temp = AND;
                
                default: temp = ADD;

            endcase
        end


        default: temp = ADD;


    endcase
    
end



endmodule
