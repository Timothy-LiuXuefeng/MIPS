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

module MultiCycleCPU
    (
        input reset,
        input sysclk,
        input BTND,
        input [1:0] display,
        output [3:0] bcd_choose,
        output [7:0] bcd_display,
        output [7:0] pc_display
    );

    wire clk_btnd;

    debounce debounce(sysclk, BTND, clk_btnd);

    reg clk;
    reg [31:0] timer;
    initial begin
        timer <= 0;
        clk <= 0;
    end
    parameter max_timer = 15000000;
    always @(posedge reset or posedge sysclk) begin
        if (reset) begin
            clk <= 0;
            timer <= 0;
        end
        else begin
            if (timer == max_timer - 1) begin
                clk <= ~clk;
                timer <= 0;
            end
            else begin
                timer <= timer + 1;
            end
        end
    end

    //--------------Your code below-----------------------
    
    // ...

    /////////////////////
    //
    // Initiate modules
    //

    // PC Register

    wire PCWrite_Real;
    wire [31:0] PC_i;
    wire [31:0] PC_o;

    PC PC(reset, clk, PCWrite_Real, PC_i, PC_o);

    // Instruction memory and data memory
    
    wire [31:0] Address;
    wire [31:0] InstAndDataMemory_Write_data;
    wire MemRead;
    wire MemWrite;
    wire [31:0] Mem_data;
    InstAndDataMemory InstAndDataMemory
    (
        reset,
        clk,
        Address,
        InstAndDataMemory_Write_data,
        MemRead,
        MemWrite,
        Mem_data
    );

    // instruction register

    wire IRWrite;
    wire [5:0] OpCode;
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [4:0] Shamt;
    wire [5:0] Funct;
    InstReg InstReg
    (
        reset,
        clk,
        IRWrite,
        Mem_data,
        OpCode,
        rs, rt, rd,
        Shamt,
        Funct
    );

    // register for data memory

    wire [31:0] Mem_data_save;
    RegTemp MemDataReg(reset, clk, Mem_data, Mem_data_save);

    // all registers from 0 to 31

    wire RegWrite;
    wire [4:0] Write_register;
    wire [31:0] RegisterFile_Write_data;
    wire [31:0] Read_data1;
    wire [31:0] Read_data2;
    
    wire [15:0] reg_to_display;
    RegisterFile RegisterFile
    (
        reset,
        clk,
        RegWrite,
        rs,
        rt,
        Write_register,
        RegisterFile_Write_data,
        Read_data1,
        Read_data2,

        display,
        reg_to_display
    );

    // register for the value of rs and rt

    wire [31:0] Read_data1_save;
    wire [31:0] Read_data2_save;
    RegTemp Read_data_A_Reg(reset, clk, Read_data1, Read_data1_save);
    RegTemp Read_data_B_Reg(reset, clk, Read_data2, Read_data2_save);

    // ALU Controller

    wire [3:0] ALUOp;
    wire [4:0] ALUConf;
    wire Sign;
    ALUControl ALUControl(ALUOp, Funct, ALUConf, Sign);

    // ALU

    wire [31:0] In1;
    wire [31:0] In2;
    wire Zero;
    wire [31:0] Result;
    ALU ALU(ALUConf, Sign, In1, In2, Zero, Result);

    // register for the result of ALU

    wire [31:0] Result_save;
    RegTemp ALUOut(reset, clk, Result, Result_save);

    wire [15:0] Immediate;
    wire ExtOp;
    wire LuiOp;
    wire [31:0] ImmExtOut;
    wire [31:0] ImmExtShift;
    ImmProcess ImmProcess(ExtOp, LuiOp, Immediate, ImmExtOut, ImmExtShift);

    wire EPCWrite;
    wire [31:0] EPC_o;
    ControlableReg EPC(reset, clk, EPCWrite, PC_o, EPC_o);

    wire ErrTargetWrite;
    wire [4:0] ErrTarget_i;
    wire [4:0] ErrTarget_o;
    ControlableReg #(.CAPACITY(5)) ErrTarget (reset, clk, ErrTargetWrite, ErrTarget_i, ErrTarget_o);

    wire Err;
    ErrProc ErrProc(In1, In2, Result, OpCode, Funct, Err);

    /////////////////////
    //
    // Connect Wires.
    //

    // Connect PC inputs

    wire PCWrite;
    wire PCWriteCond;
    assign PCWrite_Real = PCWrite | (PCWriteCond & Zero);

    wire [1:0] PCSource;
    wire [1:0] PCErrSource;
    assign PC_i =
                PCErrSource == 2'b01 ? 8'h7c :
                PCErrSource == 2'b10 ? EPC_o :
                PCSource == 2'b00 ? Result :
                PCSource == 2'b01 ? Result_save :
                PCSource == 2'b10 ? {PC_o[31:28], rs, rt, rd, Shamt, Funct, 2'b00} :
                PCSource == 2'b11 ? Read_data1_save :
                Result_save;
    
    // Connect InstAndDataMemory inputs

    wire IorD;
    assign Address = IorD == 1'b0 ? PC_o : Result_save;
    assign InstAndDataMemory_Write_data = Read_data2_save;

    // Connect RegisterFile

    wire [1:0] RegDst;
    assign Write_register =
                        RegDst == 2'b00 ? rt :
                        RegDst == 2'b01 ? rd :
                        RegDst == 2'b10 ? 5'd31 :
                        RegDst == 2'b11 ? ErrTarget_o :
                        rd;
    
    wire [1:0] MemtoReg;
    assign RegisterFile_Write_data =
                    MemtoReg == 2'b00 ? Mem_data_save :
                    MemtoReg == 2'b01 ? Result_save :
                    MemtoReg == 2'b10 ? PC_o :
                    MemtoReg == 2'b11 ? 32'hffffffff :
                    Result_save;

    // Connect ALU inputs

    wire [1:0] ALUSrcA;
    assign In1 =
                ALUSrcA == 2'b00 ? PC_o :
                ALUSrcA == 2'b01 ? Read_data1_save :
                ALUSrcA == 2'b10 ? Shamt :
                Read_data1_save;
    
    wire [1:0] ALUSrcB;
    assign In2 = 
                ALUSrcB == 2'b00 ? Read_data2_save :
                ALUSrcB == 2'b01 ? 32'd4 :
                ALUSrcB == 2'b10 ? ImmExtOut :
                ALUSrcB == 2'b11 ? ImmExtShift :
                Read_data2_save;

    // Connect ImmProcess inputs

    assign Immediate = {rd, Shamt, Funct};

    assign ErrTarget_i = OpCode == 6'h0 ? rd : rt;

    // Connect control unit.

    Controller Controller
    (
        reset,
        clk,
        OpCode,
        Funct,
        PCWrite,
        PCWriteCond,
        IorD,
        MemWrite,
        MemRead,
        IRWrite,
        MemtoReg,
        RegDst,
        RegWrite,
        ExtOp,
        LuiOp,
        ALUSrcA,
        ALUSrcB,
        ALUOp,
        PCSource,
        Err,
        EPCWrite,
        ErrTargetWrite,
        PCErrSource
    );

    /*Display modules*/

    BCDDisplayer BCDDisplayer
    (
        reset,
        sysclk,
        reg_to_display,
        bcd_choose,
        bcd_display
    );

    assign pc_display = PC_o[7:0];

    //--------------Your code above-----------------------

endmodule
