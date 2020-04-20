/**
 * 算数逻辑模块 
 * @author AshinZ
 * @time   2020-4-18 
 * @param NPC=>传来的npc  clk=>时钟 rst=>清零  
 * @return PC=>当前指令地址
*/

module pc(NPC,clk,rst,PC);
    input [31:2]   NPC;
    input          clk;
    input          rst;
    output [31:2]  PC;

    
    reg [31:2] PC;
    always @(posedge clk or posedge rst) begin
        if (rst) begin  //清零 那么pc地址回到30'h0c00
            PC <= 30'h0c00;
        end
        else 
            PC <= NPC;
    end

endmodule 