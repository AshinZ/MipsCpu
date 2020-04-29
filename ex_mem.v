/**
 * Ex与MEM之间的寄存器模块
 * @author AshinZ
 * @time   2020-4-26
*/

module ex_mem(clk,rst,fourPC,//传时钟和pc+4
jump,branch,memRead,memToReg,memWrite,regWrite,//Ex传入的数�?
beqInstruction,zero,aluResult,readData2,writeDataReg,//beq的跳转地�? alu的zero和运算结�?
//寄存器输出的第二个数 要写入的寄存器地�?
out_jump,out_branch,out_memRead,out_memToReg,out_memWrite,out_regWrite,//�?后传输的数据
out_beqInstruction,out_zero,out_aluResult,out_readData2,out_writeDataReg,out_fourPC
);

    input           clk;
    input           rst;
    input  [31:2]   fourPC;
    input  [1:0]    jump;
    input  [1:0]    branch;
    input           memRead;
    input  [1:0]    memToReg;
    input           memWrite;
    input           regWrite;
    input  [31:0]   beqInstruction;
    input           zero;
    input  [31:0]   aluResult;
    input  [31:0]   readData2;
    input  [5:0]    writeDataReg;

    output reg [31:2]   out_fourPC;
    output reg [1:0]    out_jump;
    output reg [1:0]    out_branch;
    output reg          out_memRead;
    output reg [1:0]    out_memToReg;
    output reg          out_memWrite;
    output reg          out_regWrite;
    output reg [31:0]   out_beqInstruction;
    output reg          out_zero;
    output reg [31:0]   out_aluResult;
    output reg [31:0]   out_readData2;
    output reg [5:0]    out_writeDataReg;

    always @(posedge clk)
        begin
            out_fourPC <= fourPC;
            out_jump <= jump;
            out_branch <= branch;
            out_memRead <= memRead;
            out_memToReg <= memToReg;
            out_memWrite <= memWrite;
            out_regWrite <= regWrite;
            out_beqInstruction <= beqInstruction;
            out_zero <= zero;
            out_aluResult <= aluResult;
            out_readData2 <= readData2;
            out_writeDataReg <= writeDataReg;
        end
endmodule