`timescale 1ns / 1ps
/**
 * 算数逻辑模块 
 * @author AshinZ
 * @time   2020-4-18 
 * @param NPC=>传来的npc  clk=>时钟 rst=>清零  
 * @return PC=>当前指令地址
*/

module pc(NPC,clk,rst,PC_write,if_exc,pipe_stall_info,PC);
    input [31:0]   NPC;
    input          clk;
    input          rst;
    input          PC_write;
    input          if_exc;
    input [3:0]    pipe_stall_info;
    output [31:0]  PC;

 /*   initial
    begin
        PC<=32'hbfc0_0000;
    end*/
    
    reg [31:0] PC;
   /* always @(posedge clk) begin
        last_PC <= PC;
    end*/
    reg  [31:0]  last_PC;
    always @(posedge clk) begin
        last_PC <= PC ;
        if (!rst) begin  //清零 那么pc地址回到30'h0c00
            PC <= 32'hbfc00000-4;
        end
        else if(PC_write == 0 && if_exc==0 )
            PC <= last_PC;
        else 
            PC <= NPC;
    end

endmodule 