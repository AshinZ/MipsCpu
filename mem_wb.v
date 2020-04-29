/**
 * Mem与WB之间的寄存器模块
 * @author AshinZ
 * @time   2020-4-26
*/

module mem_wb(clk,rst,fourPC,//传时钟和pc+4
jump,memToReg,//Ex传入的数据
readData,aluResult,writeDataReg,
//从dm取出的数 要写入的寄存器地址
out_jump,out_memToReg,//往后传输的数据
out_readData,out_aluResult,out_writeDataReg,out_fourPC
);

    input           clk;
    input           rst;
    input  [31:2]   fourPC;
    input  [1:0]    jump;
    input  [1:0]    memToReg;
    input  [31:0]   aluResult;
    input  [31:0]   readData;
    input  [5:0]    writeDataReg;

    output reg [31:2]   out_fourPC;
    output reg [1:0]    out_jump;
    output reg [1:0]    out_memToReg;
    output reg [31:0]   out_aluResult;
    output reg [31:0]   out_readData;
    output reg [5:0]    out_writeDataReg;

    always @(posedge clk)
        begin
            out_fourPC <= fourPC;
            out_jump <= jump;
            out_memToReg <= memToReg;
            out_aluResult <= aluResult;
            out_readData <= readData;
            out_writeDataReg <= writeDataReg;
        end
endmodule