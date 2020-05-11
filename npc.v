/**
 * 计算next pc
 * @author AshinZ
 * @time   2020-4-18 
*/

module npc(PC,instruction,beqInstruction,branch,jump,NPC,fourPC);
    input  [31:2]  PC; //当前pc
    input  [25:0]  instruction;//指令的后26位 在j指令的时候使用
    input  [31:2]  beqInstruction;//beq指令用到的地址 这里是已经计算好了的
    input          branch; //是否是beq
    input  [1:0]   jump;//是否为j指令
    output [31:2]  NPC; //next pc
    output [31:2]  fourPC;//pc+4 用来针对jr指令

    
    parameter no_jump = 2'b00 , J = 2'b01 , Jr=2'b10 , jal=2'b11;
    parameter no_branch = 2'b00 , beq = 2'b10 , bne = 2'b11;
    reg   [31:2]   NPC;
    reg   [31:2]   fourPC;

    always @(*) begin
        fourPC <= PC + 1;//先进行pc加四
        if (branch == 0 && jump == 2'b00) begin
            NPC <= fourPC;
        end
        else if ( jump != 2'b00) begin
            case (jump)
                J  : NPC <= {PC[31:28],instruction[25:0]};
        //        Jr :  
                default: NPC <= 30'h0c00;
            endcase
        end
        else if (branch == 1) begin //相等
                    NPC <= beqInstruction;
                end
        else 
            NPC <= fourPC;
        end
endmodule 
