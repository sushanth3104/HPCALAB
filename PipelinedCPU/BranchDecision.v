module BranchDecisionUnit  #(parameter WIDHT = 32) 
(
    input [WIDHT-1:0] Rd1,Rd2,
    output [2:0] CompareResult   // 0: equal, 1: less than, 2: less than unsigned
);

assign CompareResult[0] = (Rd1 == Rd2) ? 1 : 0; 
assign CompareResult[1] = ($signed(Rd1) < $signed(Rd2)) ? 1 : 0;
assign CompareResult[2] = (Rd1 < Rd2) ? 1 : 0; 


endmodule