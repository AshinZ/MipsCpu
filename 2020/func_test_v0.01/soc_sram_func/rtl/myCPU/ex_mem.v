/**
 * Ex与MEM之间的寄存器模块
 * @author AshinZ
 * @time   2020-4-26
*/

module ex_mem(clk,rst,fourPC,//传时钟和pc+4
aluResult,readData2,readData1,writeDataReg,//beq的跳转地�?? alu的zero和运算结�??
//寄存器输出的第二个数 要写入的寄存器地�??
instruction,inst_name,HI_data,LO_data,
out_aluResult,out_readData2,out_readData1,out_writeDataReg,out_fourPC
,out_instruction,out_inst_name,out_HI_data,out_LO_data
);

    input           clk;
    input           rst;
    input  [31:0]   fourPC;
    input  [31:0]   aluResult;
    input  [31:0]   readData2;
    input  [31:0]   readData1;
    input  [4:0]    writeDataReg;
    input  [31:0]   instruction;
    input  [7:0]    inst_name;
    input  [31:0]   HI_data;
    input  [31:0]   LO_data;

    output reg [31:0]   out_fourPC;
    output reg [31:0]   out_aluResult;
    output reg [31:0]   out_readData2;
    output reg [31:0]   out_readData1;
    output reg [4:0]    out_writeDataReg;
    output reg [31:0]   out_instruction;
    output reg [7:0]    out_inst_name;
    output reg [31:0]   out_HI_data;
    output reg [31:0]   out_LO_data;

    always @(posedge clk)
        begin
            out_fourPC <= fourPC;
            out_instruction <= instruction;
            out_aluResult <= aluResult;
            out_readData2 <= readData2;
            out_readData1 <= readData1;
            out_writeDataReg <= writeDataReg;
            out_inst_name <= inst_name;
            out_HI_data <= HI_data;
            out_LO_data <= LO_data;
        end
endmodule