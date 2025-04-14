module PipelineRegisterWithDisable #(parameter WIDTH = 4) (

    input [WIDTH-1:0] in,
    input clk,
    input reset,
    input disableSig,
    output [WIDTH-1:0] out
);

    reg [WIDTH-1:0] temp;

    assign out = temp;

    always @(posedge clk) begin
        if (~reset) begin
            temp <= 0;
        end 
        else if(disableSig) begin
            temp <= temp;
        end
        else begin
            temp <= in;
        end
    end



endmodule