/**
 * 算数逻辑模块 
 * @author AshinZ
 * @time   2020-4-18 
 * @param NPC=>传来的npc  clk=>时钟 rst=>清零  
 * @return PC=>当前指令地址
*/

module pc(NPC,clk,rst,PC_write,PC);
    input [31:0]   NPC;
    input          clk;
    input          rst;
    input          PC_write;
    output [31:0]  PC;

    
    reg [31:0] PC;
    reg [31:0] last_PC;
    always @(posedge clk or posedge rst) begin
        last_PC <= PC ;
        if (rst) begin  //清零 那么pc地址回到30'h0c00
            PC <= 30'h0c00;
        end
        else if(PC_write==0)
            PC <= last_PC;
        else 
            PC <= NPC;
    end

endmodule 