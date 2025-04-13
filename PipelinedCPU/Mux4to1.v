module  Mux4to1 #(parameter WIDTH = 32) (
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    input [WIDTH-1:0] C,
    input [WIDTH-1:0] D,
    input [1:0] S,
    output [WIDTH-1:0] Y
);

reg [WIDTH-1:0] temp  ;

assign Y = temp;

always @(*) begin
    case(S)
        2'b00: temp = A;
        2'b01: temp = B;
        2'b10: temp = C;
        2'b11: temp = D;
        default: temp = A;
    endcase
end


endmodule