`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Class: Fundamentals of Digital Logic and Processor
// Designer: Shulin Zeng
// 
// Create Date: 2021/04/30
// Design Name: MultiCycleCPU
// Module Name: Controller
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


module Controller(reset, clk, OpCode, Funct, 
                PCWrite, PCWriteCond, IorD, MemWrite, MemRead,
                IRWrite, MemtoReg, RegDst, RegWrite, ExtOp, LuiOp,
                ALUSrcA, ALUSrcB, ALUOp, PCSource,
                Err, EPCWrite, ErrTargetWrite, PCErrSource);
    //Input Clock Signals
    input reset;
    input clk;
    //Input Signals
    input  [5:0] OpCode;
    input  [5:0] Funct;
    //Output Control Signals
    output reg PCWrite;
    output reg PCWriteCond;
    output reg IorD;
    output reg MemWrite;
    output reg MemRead;
    output reg IRWrite;
    output reg [1:0] MemtoReg;
    output reg [1:0] RegDst;
    output reg RegWrite;
    output reg ExtOp;
    output reg LuiOp;
    output reg [1:0] ALUSrcA;
    output reg [1:0] ALUSrcB;
    output reg [3:0] ALUOp;
    output reg [1:0] PCSource;

    input wire Err;
    output reg EPCWrite;
    output reg ErrTargetWrite;
    output reg [1:0] PCErrSource;
      
    //--------------Your code below-----------------------
    
    // ...

    // OpCode Parameter

    parameter lw = 6'h23;
    parameter sw = 6'h2b;
    parameter lui = 6'h0f;
    parameter r_type = 6'h00;
    parameter addi = 6'h08;
    parameter addiu = 6'h09;
    parameter andi = 6'h0c;
    parameter slti = 6'h0a;
    parameter sltiu = 6'h0b;
    parameter beq = 6'h04;
    parameter j = 6'h02;
    parameter jal = 6'h03;
    parameter errproc = 6'h1;

    parameter jr_funct = 6'h08;
    parameter jalr_funct = 6'h09;
    parameter sll_funct = 6'h00;
    parameter srl_funct = 6'h02;
    parameter sra_funct = 6'h03;

    // States parameter

    parameter sIF = 0;
    parameter sID = 1;
    parameter sREX = 2;
    parameter sRWB = 3;
    parameter sLWSWEX = 4;
    parameter sSWMEM = 5;
    parameter sLWMEM = 6;
    parameter sLWWB = 7;
    parameter sIEX = 8;
    parameter sIWB = 9;
    parameter sBEQEX = 10;
    parameter sJ = 11;
    parameter sErr = 12;
    parameter sENDERR = 13;


    reg [3:0] state;

    initial begin
        state <= sRWB;
        PCWrite <= 0;
        PCWriteCond <= 0;
        IorD <= 0;
        MemWrite <= 0;
        MemRead <= 0;
        IRWrite <= 0;
        MemtoReg <= 0;
        RegDst <= 0;
        RegWrite <= 0;
        ExtOp <= 0;
        LuiOp <= 0;
        ALUSrcA <= 0;
        ALUSrcB <= 0;
        ALUOp <= 0;
        PCSource <= 0;
        EPCWrite <= 0;
        ErrTargetWrite <= 0;
        PCErrSource <= 0;
    end

    always @(posedge reset or posedge clk) begin
        if (reset) begin
            state <= sIF;
        end
        else begin
            case (state)
                sRWB, sSWMEM, sLWWB, sIWB, sBEQEX, sJ, sErr, sENDERR: begin
                    state <= sIF;
                end
                sIF: begin
                    state <= sID;
                end
                sID: begin
                    if (OpCode == errproc) begin
                        state <= sENDERR;
                    end
                    else if (OpCode == r_type && Funct != jr_funct && OpCode != jalr_funct) begin
                        state <= sREX;
                    end
                    else if (OpCode == lw || OpCode == sw) begin
                        state <= sLWSWEX;
                    end
                    else if (OpCode == lui || OpCode == addi || OpCode == addiu
                    || OpCode == andi || OpCode == slti || OpCode == sltiu) begin
                        state <= sIEX;
                    end
                    else if (OpCode == beq) begin
                        state <= sBEQEX;
                    end
                    else begin
                        state <= sJ;
                    end
                    
                end
                sREX: begin
                    if (Err == 1) begin
                        state <= sErr;
                    end
                    else begin
                        state <= sRWB;
                    end

                end
                sIEX: begin
                    if (Err == 1) begin
                        state <= sErr;
                    end
                    else begin
                        state <= sIWB;
                    end
                end
                sLWSWEX: begin
                    if (OpCode == lw) begin
                        state <= sLWMEM;
                    end
                    else begin
                        state <= sSWMEM;
                    end
                end
                sLWMEM: begin
                    state <= sLWWB;
                end
            endcase
        end
    end

    always @(*) begin
        case (state)
        sIF: begin
            PCWrite <= 1;
            ALUSrcA <= 2'b00;
            ALUSrcB <= 2'b01;
            IRWrite <= 1;
            MemRead <= 1;

            PCWriteCond <= 0;
            IorD <= 0;
            MemWrite <= 0;
            MemtoReg <= 0;
            RegDst <= 0;
            RegWrite <= 0;
            ExtOp <= 0;
            LuiOp <= 0;
            PCSource <= 0;
            EPCWrite <= 0;
            ErrTargetWrite <= 0;
            PCErrSource <= 0;
        end
        sID: begin
            ALUSrcA <= 2'b00;
            ALUSrcB <= 2'b11;
            ExtOp <= 1;

            PCWrite <= 0;
            PCWriteCond <= 0;
            IorD <= 0;
            MemWrite <= 0;
            MemRead <= 0;
            IRWrite <= 0;
            MemtoReg <= 0;
            RegDst <= 0;
            RegWrite <= 0;
            LuiOp <= 0;
            PCSource <= 0;
        end
        sENDERR: begin
            PCWrite <= 1;
            PCErrSource <= 2'b10;
            RegWrite <= 1;
            RegDst <= 2'b11;
            MemtoReg <= 2'b11;

            
            PCWriteCond <= 0;
            IorD <= 0;
            MemWrite <= 0;
            MemRead <= 0;
            IRWrite <= 0;
            ExtOp <= 0;
            LuiOp <= 0;
            ALUSrcA <= 0;
            ALUSrcB <= 0;
            PCSource <= 0;
            EPCWrite <= 0;
            ErrTargetWrite <= 0;
        end
        sREX: begin
            
            if (Funct == sll_funct || Funct == sra_funct || Funct == srl_funct) begin
                ALUSrcA <= 2'b10;
            end
            else begin
                ALUSrcA <= 2'b01;
            end
            ALUSrcB <= 2'b00;
            

            PCWrite <= 0;
            PCWriteCond <= 0;
            IorD <= 0;
            MemWrite <= 0;
            MemRead <= 0;
            IRWrite <= 0;
            MemtoReg <= 0;
            RegDst <= 0;
            RegWrite <= 0;
            ExtOp <= 0;
            LuiOp <= 0;
            PCSource <= 0;
        end
        sLWSWEX: begin
            ALUSrcA <= 2'b01;
            ALUSrcB <= 2'b10;
            ExtOp <= 1;
            LuiOp <= 0;

            PCWrite <= 0;
            PCWriteCond <= 0;
            IorD <= 0;
            MemWrite <= 0;
            MemRead <= 0;
            IRWrite <= 0;
            MemtoReg <= 0;
            RegDst <= 0;
            RegWrite <= 0;
            PCSource <= 0;
        end
        sIEX: begin
            ALUSrcA <= 2'b01;
            ALUSrcB <= 2'b10;
            LuiOp <= (OpCode == lui ? 1 : 0);
            ExtOp <= (OpCode == addiu || OpCode == sltiu ? 1 : 1);

            PCWrite <= 0;
            PCWriteCond <= 0;
            IorD <= 0;
            MemWrite <= 0;
            MemRead <= 0;
            IRWrite <= 0;
            MemtoReg <= 0;
            RegDst <= 0;
            RegWrite <= 0;
            PCSource <= 0;
        end
        sBEQEX: begin
            ALUSrcA <= 2'b01;
            ALUSrcB <= 2'b00;
            PCWriteCond <= 1;
            PCSource <= 2'b01;
            
            PCWrite <= 0;
            IorD <= 0;
            MemWrite <= 0;
            MemRead <= 0;
            IRWrite <= 0;
            MemtoReg <= 0;
            RegDst <= 0;
            RegWrite <= 0;
            LuiOp <= 0;
            ExtOp <= 0;
        end
        sJ: begin
            PCWrite <= 1;

            if (OpCode == j || OpCode == jal) begin
                PCSource <= 2'b10;
            end
            else begin
                PCSource <= 2'b11;
            end

            if (Funct == jalr_funct || OpCode == jal) begin
                RegWrite <= 1;
                MemtoReg <= 2'b10;
                RegDst <= 2'b10;
            end
            else begin
                MemtoReg <= 0;
                RegDst <= 0;
                RegWrite <= 0;
            end


            PCWriteCond <= 0;
            IorD <= 0;
            MemWrite <= 0;
            MemRead <= 0;
            IRWrite <= 0;
            ExtOp <= 0;
            LuiOp <= 0;
            ALUSrcA <= 0;
            ALUSrcB <= 0;
        end
        sErr: begin
            PCWrite <= 1;
            PCErrSource <= 2'b01;
            ErrTargetWrite <= 1;
            EPCWrite <= 1;
            
            RegWrite <= 0;
            RegDst <= 0;
            MemtoReg <= 0;
            PCWriteCond <= 0;
            IorD <= 0;
            MemWrite <= 0;
            MemRead <= 0;
            IRWrite <= 0;
            ExtOp <= 0;
            LuiOp <= 0;
            ALUSrcA <= 0;
            ALUSrcB <= 0;
            PCSource <= 0;
        end
        sRWB: begin
            RegWrite <= 1;
            RegDst <= 2'b01;
            MemtoReg <= 2'b01;

            PCWrite <= 0;
            PCWriteCond <= 0;
            IorD <= 0;
            MemWrite <= 0;
            MemRead <= 0;
            IRWrite <= 0;
            ExtOp <= 0;
            LuiOp <= 0;
            ALUSrcA <= 0;
            ALUSrcB <= 0;
            PCSource <= 0;
        end
        sIWB: begin
            RegWrite <= 1;
            RegDst <= 2'b00;
            MemtoReg <= 1;

            PCWrite <= 0;
            PCWriteCond <= 0;
            IorD <= 0;
            MemWrite <= 0;
            MemRead <= 0;
            IRWrite <= 0;
            ExtOp <= 0;
            LuiOp <= 0;
            ALUSrcA <= 0;
            ALUSrcB <= 0;
            PCSource <= 0;
        end
        sLWMEM: begin
            IorD <= 1;
            MemRead <= 1;

            MemWrite <= 0;
            PCWrite <= 0;
            PCWriteCond <= 0;
            IRWrite <= 0;
            MemtoReg <= 0;
            RegDst <= 0;
            RegWrite <= 0;
            ExtOp <= 0;
            LuiOp <= 0;
            ALUSrcA <= 0;
            ALUSrcB <= 0;
            PCSource <= 0;
        end
        sSWMEM: begin
            IorD <= 1;
            MemWrite <= 1;
            
            PCWrite <= 0;
            PCWriteCond <= 0;
            IRWrite <= 0;
            MemtoReg <= 0;
            RegDst <= 0;
            RegWrite <= 0;
            ExtOp <= 0;
            LuiOp <= 0;
            ALUSrcA <= 0;
            ALUSrcB <= 0;
            PCSource <= 0;
            MemRead <= 0;
        end
        sLWWB: begin
            MemtoReg <= 2'b00;
            RegWrite <= 1;
            RegDst <= 2'b00;

            PCWrite <= 0;
            PCWriteCond <= 0;
            IorD <= 0;
            MemWrite <= 0;
            MemRead <= 0;
            IRWrite <= 0;
            ExtOp <= 0;
            LuiOp <= 0;
            ALUSrcA <= 0;
            ALUSrcB <= 0;
            PCSource <= 0;
        end

        endcase
    end

    //--------------Your code above-----------------------


    //ALUOp
    always @(*) begin
        ALUOp[3] = OpCode[0];
        if (state == sIF || state == sID) begin
            ALUOp[2:0] = 3'b000;
        end else if (OpCode == 6'h00) begin 
            ALUOp[2:0] = 3'b010;
        end else if (OpCode == 6'h04) begin
            ALUOp[2:0] = 3'b001;
        end else if (OpCode == 6'h0c) begin
            ALUOp[2:0] = 3'b100;
        end else if (OpCode == 6'h0a || OpCode == 6'h0b) begin
            ALUOp[2:0] = 3'b101;
        end else begin
            ALUOp[2:0] = 3'b000;
        end
    end

endmodule