/**
 * 计算next pc
 * @author AshinZ
 * @time   2020-4-18 
*/

module (
    input  [31:2]  PC; //当前pc
    input  [25:0]  instruction;//指令的后26位 在j指令的时候使用
    input  [31:0]  beqInstruction;//beq指令用到的地址 这里是经过了左移两位的
    input  [1:0]   branch; //是否是beq
    input  [1:0]   jump;//是否为j指令
    input          zero;//alu计算出来的是否符合条件
    output [31:2]  NPC; //next pc
    output [31:2]  fourPc;//pc+4 用来针对jr指令
);

    parameter no_jump = 2'b00 , J = 2'b01 , Jr=2'b10 , jal=2'b11;
    parameter no_branch = 2'b00 , beq = 2'b10 , bne = 2'b11;
    reg   [31:2]   NPC;
    reg   [31:2]   fourPC;

    always @(*) begin
        fourPC = PC + 1;//先进行pc加四
        if ( jump != no_jump) begin
            case (jump)
                J  : NPC <= {PC[31:28],instruction}
        //        Jr :  
                default: NPC <= 30'h0c00;
            endcase
        end
        else if ( branch != no_branch) begin
            case (branch)
                beq:if (zero == 1) begin //相等
                    NPC <= beqInstruction[31:2] + fourPC;
                end
                bne:if (zero == 0) begin //bne不相等
                    NPC <= beqInstruction[31:2] + fourPC;
                end
        end
        else
            begin
                NPC = fourPC;
    end
endmodule 
