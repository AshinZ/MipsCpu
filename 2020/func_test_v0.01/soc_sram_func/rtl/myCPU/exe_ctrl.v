/**
 * exe ctrl模块
 * 主要用于指令在exe阶段控制信号的生成 主要生成 aluOp aluSrc 两个信号
 * @author AshinZ
 * @time   2020-5-27
*/

module exe_ctrl(inst_name,if_work,aluOp,multiply,div,unsign);
    input [7:0] inst_name;
    input       if_work;
    output reg [3:0]   aluOp  ;
    // 4'b0000  +   4'b0001 -  4'b0010 and 4'b0011 or    4'b0100 nor
    // 4'b0101  xor  4'b0110 sll左移  4'b0111 sra   4'b1000  srl
    // 4'b1001  u+    4'b1010 u-  4'b1011 slt   s'b1100 无符号比较
    // 4'b1101 lui
    output wire         multiply;
    //  1乘 0不乘
    output wire         div;
    output wire         unsign;
    //  1除 0不除
    // 考虑到用到乘除的指令不多 我们进行单独赋值
    `include "decode_list.v"

    assign  multiply = (inst_name == MULT || inst_name ==MULTU)?1:0;
    assign  div = (inst_name == DIV || inst_name == DIVU)?1:0;
    assign  unsign = (inst_name == DIVU || inst_name == MULTU)?1:0;
    always @(*)
        if(if_work==1)
            aluOp = 4'b1111;
        else
        case (inst_name)
            ADD    : aluOp = 4'b0000;
            ADDI   : aluOp = 4'b0000;
            ADDU   : aluOp = 4'b1001;
            ADDIU  : aluOp = 4'b1001;
            SUB    : aluOp = 4'b0001;
            SUBU   : aluOp = 4'b1010;
            SLT    : aluOp = 4'b1011;
            SLTI   : aluOp = 4'b1011;
            SLTU   : aluOp = 4'b1100;
            SLTIU  : aluOp = 4'b1100;
            DIV    : aluOp = 4'b1111;
            DIVU   : aluOp = 4'b1111;
            MULT   : aluOp = 4'b1111;
            MULTU  : aluOp = 4'b1111;
            AND    : aluOp = 4'b0010;
            ANDI   : aluOp = 4'b0010;
            LUI    : aluOp = 4'b1101;
            NOR    : aluOp = 4'b0100;
            OR     : aluOp = 4'b0011;
            ORI    : aluOp = 4'b0011;
            XOR    : aluOp = 4'b0101;
            XORI   : aluOp = 4'b0101;
            SLL    : aluOp = 4'b0110;
            SLLV   : aluOp = 4'b0110;
            SRA    : aluOp = 4'b0111;
            SRAV   : aluOp = 4'b0111;
            SRL    : aluOp = 4'b1000;
            SRLV   : aluOp = 4'b1000;
         /*   BEQ    :
            BNE    :
            BGEZ   :
            BGTZ   :
            BLEZ   :
            BLTZ   :
            BLTZAL :
            BGEZAL :
            J      :
            JAL    :
            JR     :
            JALR   :
            MFHI   :
            MFLO   :
            MTHI   :
            MTLO   :
            BREAK  :
            SYSCALL:*/
            LB     : aluOp = 4'b0000;
            LBU    : aluOp = 4'b0000;
            LH     : aluOp = 4'b0000;
            LHU    : aluOp = 4'b0000;
            LW     : aluOp = 4'b0000;
            SB     : aluOp = 4'b0000;
            SH     : aluOp = 4'b0000;
            SW     : aluOp = 4'b0000;
         /*   ERET   :
            MFC0   :
            MTC0   :*/
            default: aluOp = 4'b1111;
        endcase

endmodule // 