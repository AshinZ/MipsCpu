/**
 * IF与ID之间的寄存器模块
 * @author AshinZ
 * @time   2020-4-25 
*/

module if_id(clk,rst,fourPC,instruction,out_fourPC,out_instruction);

    input         clk;
    input         rst;
    input  [31:2]  fourPC;
    input  [31:0]  instruction;

    output [31:2]  out_fourPC;
    output [31:0]  out_instruction;

    reg [31:0]   out_instruction;
    reg [31:2]   out_fourPC;

    always @(posedge clk)
        begin 
            out_instruction <= instruction;
            out_fourPC <= fourPC;
        end
    
endmodule

