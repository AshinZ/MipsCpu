/**
 * IF与ID之间的寄存器模块
 * @author AshinZ
 * @time   2020-4-25 
*/

module if_id(clk,rst,fourPC,instruction,IF_ID_write,out_fourPC,out_instruction);

    input          clk;
    input          rst;
    input  [31:2]  fourPC;
    input  [31:0]  instruction;
    input          IF_ID_write; 

    output [31:2]  out_fourPC;
    output [31:0]  out_instruction;

    reg [31:0]   out_instruction;
    reg [31:2]   out_fourPC;

    always @(posedge clk)
        begin 
            if(IF_ID_write!=0)
            begin
            out_instruction <= instruction;
            out_fourPC <= fourPC;
            end
        end
    
endmodule

