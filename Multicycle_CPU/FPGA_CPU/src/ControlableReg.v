`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/08 01:23:35
// Design Name: 
// Module Name: ControlableReg
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

module ControlableReg(reset, clk, CanWrite, Data_i, Data_o);

    parameter CAPACITY = 32;
    //Input Clock Signals
    input reset;
    input clk;
    input CanWrite;
    //Input Data
    input [CAPACITY - 1:0] Data_i;
    //Output Data
    output reg [CAPACITY - 1:0] Data_o;
    
    always@(posedge reset or posedge clk) begin
        if (reset) begin
            Data_o <= 32'h00000000;
        end else begin
            if (CanWrite) Data_o <= Data_i;
        end
    end
endmodule

