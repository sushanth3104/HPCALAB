module Control (
    input [6:0] opcode,
    output reg branch,
    output reg jump,
    output reg memRead,
    output reg [1:0]ResultSrc,
    output  reg [1:0] ALUOp,
    output reg PCLoad,
    output reg memWrite,
    output reg ALUSrc,
    output reg regWrite
    );



// For ALUOp
parameter Load_Store_Type = 0;
parameter Branch_Type = 1;
parameter IR_Type = 2;




// Opcodes
parameter LoadInst = 3;
parameter StoreInst = 35;
parameter BranchInst = 99;
parameter I_TypeInst = 19;
parameter R_TypeInst = 51;
parameter J_TypeInst = 111;
parameter JALR_Inst = 103;


always@(*)begin

    case(opcode)

        LoadInst:begin

            
            branch = 0;
            jump = 0;
            memRead = 1;
            ResultSrc = 2'b01;
            ALUOp = Load_Store_Type;
            PCLoad = 0;
            memWrite = 0;
            ALUSrc = 1;
            regWrite = 1;
            
            

        end

        StoreInst:begin
            
            
            branch = 0;
            jump = 0;
            memRead = 0;
            ResultSrc = 2'b00;
            ALUOp = Load_Store_Type;
            PCLoad = 0;
            memWrite = 1;
            ALUSrc = 1;
            regWrite = 0;

        end

        BranchInst:begin

            
            branch = 1;
            jump = 0;
            memRead = 0;
            ResultSrc = 2'b00;
            ALUOp = Branch_Type;
            PCLoad = 0;
            memWrite = 0;
            ALUSrc = 0;
            regWrite = 0;

        end

        I_TypeInst:begin

            
            branch = 0;
            jump = 0;
            memRead = 0;
            ResultSrc = 2'b00;
            ALUOp = IR_Type;
            PCLoad = 0;
            memWrite = 0;
            ALUSrc = 1;
            regWrite = 1;

        end

        R_TypeInst:begin

            
            branch = 0;
            jump = 0;
            memRead = 0;
            ResultSrc = 2'b00;
            ALUOp = IR_Type;
            PCLoad = 0;
            memWrite = 0;
            ALUSrc = 0;
            regWrite = 1;

        end

        J_TypeInst:begin

            
            branch = 0;
            jump = 1;
            memRead = 0;
            ResultSrc = 2'b10;
            ALUOp = 0;
            PCLoad = 0;
            memWrite = 0;
            ALUSrc = 0;
            regWrite = 1;

        end

        JALR_Inst:begin

            
            branch = 0;
            jump = 1;
            memRead = 0;
            ResultSrc = 2'b10;
            ALUOp = Load_Store_Type; // For addition
            PCLoad = 1;
            memWrite = 0;
            ALUSrc = 1;
            regWrite = 1;

        end

        default : {ResultSrc,ALUOp,branch,jump,memRead,PCLoad,memWrite,ALUSrc,regWrite} = 0;

    endcase

end


endmodule




