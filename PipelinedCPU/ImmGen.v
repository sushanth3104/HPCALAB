module ImmGen#(parameter Width = 32) (
    input [Width-1:0] inst,
    output reg signed [Width-1:0] imm
);
    // ImmGen generate imm value based on opcode

    wire [6:0] opcode = inst[6:0];

    parameter load = 3;
    parameter immediate = 19;
    parameter store = 35;
    parameter branch = 99;
    parameter jal = 111;
    parameter jalr = 103;

    always @(*) 
    begin
        case(opcode)

        load,immediate,jalr: // I-type
            begin
                if(inst[14:12] == 3'b101) imm = {{27{1'b0}},inst[24:20]}; // 5-Bit Unsigned Immediate in imm[4:0]
                else imm = {{20{inst[31]}},inst[31:20]}; // Signed Immediate
            end

        jal :
            begin
                imm = {{12{inst[31]}},{inst[31],inst[19:12],inst[20],inst[30:21]}};
            end

        store :
            begin
                imm = {{20{inst[31]}},inst[31:25],inst[11:7]}; // Signed Immediate
            end
        
        branch :
            begin
                imm = {{20{inst[31]}},inst[31],inst[7],inst[30:25],inst[11:8]}; // Signed Immediate
            end

        default :
              imm = 0;
        

	endcase
    end
            
endmodule

