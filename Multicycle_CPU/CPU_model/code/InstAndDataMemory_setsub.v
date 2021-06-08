`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class: Fundamentals of Digital Logic and Processor
// Designer: Shulin Zeng
// 
// Create Date: 2021/04/30
// Design Name: MultiCycleCPU
// Module Name: InstAndDataMemory
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


module InstAndDataMemory(reset, clk, Address, Write_data, MemRead, MemWrite, Mem_data);
	//Input Clock Signals
	input reset;
	input clk;
	//Input Data Signals
	input [31:0] Address;
	input [31:0] Write_data;
	//Input Control Signals
	input MemRead;
	input MemWrite;
	//Output Data
	output [31:0] Mem_data;
	
	parameter RAM_SIZE = 256;
	parameter RAM_SIZE_BIT = 8;
	parameter RAM_INST_SIZE = 32;
	
	reg [31:0] RAM_data[RAM_SIZE - 1: 0];

	//read data
	assign Mem_data = MemRead? RAM_data[Address[RAM_SIZE_BIT + 1:2]]: 32'h00000000;
	
	//write data
	integer i;
	always @(posedge reset or posedge clk) begin
		if (reset) begin
		    // init instruction memory
            // lui $t0, 0xabcd
            RAM_data[8'd0] <= {6'h0f, 5'd0 , 5'd8 , 16'habcd};
            // addiu $t0, $t0, 0x1234
            RAM_data[8'd1] <= {6'h09, 5'd8 , 5'd8 , 16'h1234};
            // lui $t1, 0xcdef
            RAM_data[8'd2] <= {6'h0f, 5'd0 , 5'd9 , 16'hcdef};
            // addiu $t1, $t1, 0x3456
            RAM_data[8'd3] <= {6'h09, 5'd9 , 5'd9 , 16'h3456};
            // setsub $t2, $t0, $t1
            RAM_data[8'd4] <= {6'h00, 5'd8 , 5'd9, 5'd10, 5'd0 , 6'h19};
            // Loop:
            // j Loop
            RAM_data[8'd5] <= {6'h02, 26'd5};
       
            //init instruction memory
            //reset data memory		  
			for (i = RAM_INST_SIZE - 1; i < RAM_SIZE; i = i + 1)
				RAM_data[i] <= 32'h00000000;
		end else if (MemWrite) begin
			RAM_data[Address[RAM_SIZE_BIT + 1:2]] <= Write_data;
		end
	end

endmodule
