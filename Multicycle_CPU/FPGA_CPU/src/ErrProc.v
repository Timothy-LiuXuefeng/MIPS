`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/08 01:39:39
// Design Name: 
// Module Name: ErrProc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ErrProc(
        In1,
        In2,
        Result,
        OpCode,
        Funct,
        Err
    );
input wire [31:0] In1;
input wire [31:0] In2;
input wire [31:0] Result;
inout wire [5:0] OpCode;
input wire [5:0] Funct;
output reg Err;

initial begin
    Err <= 0;
end

always @(*) begin
    if (OpCode == 0)
    begin
        case (Funct)
            6'h20: Err <= (In1[31] == In2[31] && In1[31] != Result[31] ? 1 : 0);
            6'h22: Err <= (In1[31] != In2[31] && In1[31] != Result[31] ? 1 : 0);
            default: Err <= 0;
        endcase
    end
    else if (OpCode == 6'h08) Err <= (In1[31] == In2[31] && In1[31] != Result[31] ? 1 : 0);
    else Err <= 0;
end

endmodule
