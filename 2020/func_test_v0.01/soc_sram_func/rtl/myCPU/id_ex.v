/**
 * ID与Ex之间的寄存器模块
 * @author AshinZ
 * @time   2020-4-26
*/

module id_ex(clk,rst,fourPC,//传时钟和pc+4
readData1,readData2, //regfile和拓展其输入
instruction,inst_name,register_d,aluSrc,signExtNumber,
out_readData1,out_readData2,
out_fourPC,out_instruction,out_inst_name,
out_register_d,out_aluSrc,out_signExtNumber);

    input           clk;
    input           rst;
    input  [31:0]   fourPC;
    input  [31:0]   readData1;
    input  [31:0]   readData2;
    input  [31:0]   instruction;
    input  [7:0]    inst_name;
    input  [4:0]    register_d;//目标写入寄存器
    input           aluSrc;
    input  [31:0]   signExtNumber;

    output reg [31:0]   out_fourPC;
    output reg [31:0]   out_readData1;
    output reg [31:0]   out_readData2;
    output reg [31:0]   out_instruction;
    output reg [7:0]    out_inst_name;
    output reg [4:0]    out_register_d;
    output reg            out_aluSrc;
    output reg [31:0]      out_signExtNumber;
    always @(posedge clk)
        begin
            out_fourPC <= fourPC;
            out_readData1 <= readData1;
            out_readData2 <= readData2;
            out_instruction <= instruction;
            out_inst_name <= inst_name;
            out_register_d<=register_d;
            out_aluSrc <= aluSrc;
            out_signExtNumber <= signExtNumber;
        end
endmodule