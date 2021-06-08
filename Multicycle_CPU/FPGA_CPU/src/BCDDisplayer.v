`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/08 19:58:14
// Design Name: 
// Module Name: BCDDisplayer
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


module BCDDisplayer
(
    input reset,
    input clk,
    input [15:0] reg_to_display,
    output [3:0] bcd_choose,
    output reg [7:0] bcd_display
);

reg [3:0] bcd_choose_reg;
assign bcd_choose = bcd_choose_reg;

reg [16:0] divider;
reg clk_flush;

initial begin
    divider <= 0;
    clk_flush <= 0;
end

always @(posedge reset or posedge clk) begin
    if (reset) begin
        divider <= 0;
        clk_flush <= 0;
    end
    else begin
        if (divider >= 9999) begin
            clk_flush <= ~clk_flush;
            divider <= 0;
        end
        else begin
            divider = divider + 1;
        end
    end
end

always @(posedge reset or posedge clk_flush) begin
    if (reset) begin
        bcd_choose_reg <= 4'b0111;
    end
    else begin
        case (bcd_choose_reg)
            4'b0111: bcd_choose_reg <= 4'b1011;
            4'b1011: bcd_choose_reg <= 4'b1101;
            4'b1101: bcd_choose_reg <= 4'b1110;
            4'b1110: bcd_choose_reg <= 4'b0111;
            default: bcd_choose_reg <= 4'b0111;
        endcase
    end
end

reg [3:0] to_display;
always @(*) begin
    case (bcd_choose_reg)
    4'b0111: to_display <= reg_to_display[3:0];
    4'b1011: to_display <= reg_to_display[7:4];
    4'b1101: to_display <= reg_to_display[11:8];
    4'b1110: to_display <= reg_to_display[15:12];
    default: to_display <= 16'h0;
    endcase
end

always @(*) begin
    case (to_display)
    4'h0: bcd_display <= 8'b11000000;
    4'h1: bcd_display <= 8'b11111001;
    4'h2: bcd_display <= 8'b10100100;
    4'h3: bcd_display <= 8'b10110000;
    4'h4: bcd_display <= 8'b10011001;
    4'h5: bcd_display <= 8'b10010010;
    4'h6: bcd_display <= 8'b10000010;
    4'h7: bcd_display <= 8'b11111000;
    4'h8: bcd_display <= 8'b10000000;
    4'h9: bcd_display <= 8'b10010000;
    4'ha: bcd_display <= 8'b10001000;
    4'hb: bcd_display <= 8'b10000011;
    4'hc: bcd_display <= 8'b11000110;
    4'hd: bcd_display <= 8'b10100001;
    4'he: bcd_display <= 8'b10000110;
    4'hf: bcd_display <= 8'b10001110;
    default: bcd_display <= 8'b11111111;
    endcase
end

endmodule
