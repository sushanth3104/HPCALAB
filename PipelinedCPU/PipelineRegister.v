module #(parameter WIDHT = 4) PipelineRegister(

    input [WIDHT-1:0] data_in,
    input clk,
    input reset,
    output [WIDHT-1:0] data_out
);

    reg [WIDHT-1:0] temp;

    assign data_out = temp;

    always @(posedge clk) begin
        if (~reset) begin
            temp <= 0;
        end else begin
            temp <= data_in;
        end
    end



endmodule