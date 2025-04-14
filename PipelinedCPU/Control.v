module Control (
    input [6:0] opcode,
    input [2:0] func3,
    input [2:0] CompareResult, // For branch decision

/*     output reg branch,
    output reg jump, */   // No longer needed as it is decoupled form ALU

    output reg [1:0]PCTargetSel,

    output reg memRead,
    output reg [1:0]ResultSrc,
    output  reg [1:0] ALUOp,

    //output reg PCLoad  // This is for JALR selection : Not needed in Pipeline

    output reg memWrite,
    output reg ALUSrc,
    output reg regWrite
    );


// For PC Taget Selection
parameter PCPlus4 = 0;
parameter PCBranch = 1; // For branch decision
parameter PCJump = 2; // For JAL
parameter PCJALR = 3; // For JALR


// For ALUOp
parameter Load_Store_Type = 0;

//parameter Branch_Type = 1;
// No longer needed as it is decoupled form ALU

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

            
    
            memRead = 1;
            ResultSrc = 2'b01;
            ALUOp = Load_Store_Type;
            memWrite = 0;
            ALUSrc = 1;
            regWrite = 1;
            PCTargetSel = PCPlus4; // For Load
            
            

        end

        StoreInst:begin
            

            memRead = 0;
            ResultSrc = 2'b00;
            ALUOp = Load_Store_Type;
            memWrite = 1;
            ALUSrc = 1;
            regWrite = 0;
            PCTargetSel = PCPlus4; // For Store

        end

        BranchInst:begin


            memRead = 0;
            ResultSrc = 2'b00;
            ALUOp = Load_Store_Type;// Can be anything 
            memWrite = 0;
            ALUSrc = 0;
            regWrite = 0;
            
            case(func3)
                3'b000:begin // BEQ
                    if(CompareResult[0] == 1) begin
                        PCTargetSel = PCBranch; // For BEQ
                    end else begin
                        PCTargetSel = PCPlus4; // For BEQ
                    end
                end

                3'b001:begin // BNE
                    if(CompareResult[0] == 0) begin
                        PCTargetSel = PCBranch; // For BNE
                    end else begin
                        PCTargetSel = PCPlus4; // For BNE
                    end
                end

                3'b100:begin // BLT
                    if(CompareResult[1] == 1) begin
                        PCTargetSel = PCBranch; // For BLT
                    end else begin
                        PCTargetSel = PCPlus4; // For BLT
                    end
                end

                3'b101:begin // BGE
                    if(CompareResult[1] == 0) begin
                        PCTargetSel = PCBranch; // For BGE
                    end else begin
                        PCTargetSel = PCPlus4; // For BGE
                    end
                end

                3'b110:begin // BLTU
                    if(CompareResult[2] == 1) begin
                        PCTargetSel = PCBranch; // For BLTU
                    end else begin
                        PCTargetSel = PCPlus4; // For BLTU
                    end
                end

                3'b111:begin // BGEU
                    if(CompareResult[2] == 0) begin
                        PCTargetSel = PCBranch; // For BGEU
                    end else begin
                        PCTargetSel = PCPlus4; // For BGEU
                    end
                end

                default:begin // Default case for other branches (BLT, BGE, etc.)
                    PCTargetSel = PCPlus4;
                end
            endcase

        end

        I_TypeInst:begin

            
 
            memRead = 0;
            ResultSrc = 2'b00;
            ALUOp = IR_Type;
            memWrite = 0;
            ALUSrc = 1;
            regWrite = 1;
            PCTargetSel = PCPlus4; // For I-Type Inst

        end

        R_TypeInst:begin


            memRead = 0;
            ResultSrc = 2'b00;
            ALUOp = IR_Type;
            memWrite = 0;
            ALUSrc = 0;
            regWrite = 1;
            PCTargetSel = PCPlus4; // For R-Type Inst

        end

        J_TypeInst:begin

            
            memRead = 0;
            ResultSrc = 2'b10;
            ALUOp = 0;
            memWrite = 0;
            ALUSrc = 0;
            regWrite = 1;
            PCTargetSel = PCJump; // For JAL

        end

        JALR_Inst:begin

            
            memRead = 0;
            ResultSrc = 2'b10;      // Store PC+4 in rd
            ALUOp = Load_Store_Type; // For addition
            memWrite = 0;
            ALUSrc = 1;
            regWrite = 1;
            PCTargetSel = PCJALR; // For JALR

        end

        default : {ResultSrc,ALUOp,memRead,memWrite,ALUSrc,regWrite,PCTargetSel} = 0;

    endcase

end


endmodule




