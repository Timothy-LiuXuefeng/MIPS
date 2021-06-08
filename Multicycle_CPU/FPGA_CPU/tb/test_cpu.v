`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class: Fundamentals of Digital Logic and Processor
// Designer: Shulin Zeng
// 
// Create Date: 2021/04/30
// Design Name: MultiCycleCPU
// Module Name: MultiCycleCPU
// Project Name: Multi-cycle-cpu
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


module test_cpu();
    
    reg reset;
    reg clk;
    reg BTND;
    reg [1:0] display;
    wire [3:0] bcd_choose;
    wire [7:0] bcd_display;
    wire [7:0] pc_display;
    
    MultiCycleCPU MultiCycleCPU_1
    (
        reset,
        clk,
        BTND,
        display,
        bcd_choose,
        bcd_display,
        pc_display
    );
    
    initial begin
        reset = 1;
        clk = 1;
        #100 reset = 0;
    end

    initial begin
        BTND <= 0;
        display <= 0;
    end
    
    always #50 clk = ~clk;
    
endmodule
