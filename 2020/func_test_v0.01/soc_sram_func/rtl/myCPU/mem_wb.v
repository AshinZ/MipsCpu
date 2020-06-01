/**
 * Mem与WB之间的寄存器模块
 * @author AshinZ
 * @time   2020-4-26
*/

module mem_wb(clk,rst,fourPC,//传时钟和pc+4
memResult,memRead2,writeDataReg,instruction,inst_name,
HI_data,LO_data,
//从dm取出的数 要写入的寄存器地址
out_memResult,out_memRead2,out_writeDataReg,
out_fourPC,out_instruction,out_inst_name,
out_HI_data,out_LO_data
);

    input           clk;
    input           rst;
    input  [31:0]   fourPC;
    input  [31:0]   memResult;//mem阶段的数据
    input  [31:0]   memRead2;
    input  [4:0]    writeDataReg;
    input  [31:0]   instruction;
    input  [7:0]    inst_name;
    input  [31:0]   HI_data;
    input  [31:0]   LO_data;

    output reg [31:0]   out_fourPC;
    output reg [31:0]   out_memResult;
    output reg [31:0]   out_memRead2;
    output reg [4:0]    out_writeDataReg;
    output reg [31:0]   out_instruction;
    output reg [7:0]    out_inst_name;
    output reg [31:0]   out_HI_data;
    output reg [31:0]   out_LO_data;

    always @(posedge clk)
        begin
            out_fourPC <= fourPC;
            out_memResult <= memResult;
            out_writeDataReg <= writeDataReg;
            out_instruction <= instruction;
            out_inst_name <= inst_name;
            out_memRead2 <= memRead2;
            out_HI_data <= HI_data;
            out_LO_data <= LO_data;
        end
endmodule