/**
 * Mem与WB之间的寄存器模块
 * @author AshinZ
 * @time   2020-4-26
*/

module mem_wb(clk,rst,fourPC,//传时钟和pc+4
memToReg,//Ex传入的数据
readData,aluResult,writeDataReg,regWrite,instruction,
//从dm取出的数 要写入的寄存器地址
out_memToReg,//往后传输的数据
out_readData,out_aluResult,out_writeDataReg,out_regWrite,out_fourPC,out_instruction
);

    input           clk;
    input           rst;
    input  [31:2]   fourPC;
    input  [1:0]    memToReg;
    input  [31:0]   aluResult;
    input  [31:0]   readData;
    input  [4:0]    writeDataReg;
    input  [31:0]   instruction;
    input           regWrite;

    output reg [31:2]   out_fourPC;
    output reg [1:0]    out_memToReg;
    output reg [31:0]   out_aluResult;
    output reg [31:0]   out_readData;
    output reg [4:0]    out_writeDataReg;
    output reg [31:0]   out_instruction;
    output reg          out_regWrite;

    always @(posedge clk)
        begin
            out_fourPC <= fourPC;
            out_memToReg <= memToReg;
            out_aluResult <= aluResult;
            out_readData <= readData;
            out_writeDataReg <= writeDataReg;
            out_instruction <= instruction;
            out_regWrite <= regWrite;
        end
endmodule