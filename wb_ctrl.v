/**
 * wb ctrl模块
 * 主要用于指令在wb阶段控制信号的生成 主要生成 aluOp aluSrc 两个信号
 * @author AshinZ
 * @time   2020-5-27
*/

module wb_ctrl(inst_name,jump,branch,regDst,extType);
    input [7:0] inst_name;

    output wire [3:0]   aluOp  ;
    output wire         aluSrc ; 

    `include "decode_list.v"

    always @(*)
        case (inst_name)
            ADD    :
            ADDI   :
            ADDU   :
            ADDIU  :
            SUB    :
            SUBU   :
            SLT    :
            SLTI   :
            SLTU   :
            SLTIU  :
            DIV    :
            DIVU   :
            MULT   :
            MULTU  :
            AND    :
            ANDI   :
            LUI    :
            NOR    :
            OR     :
            ORI    :
            XOR    :
            XORI   :
            SLL    :
            SLLV   :
            SRA    :
            SRAV   :
            SRL    :
            SRLV   :
            BEQ    :
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
            SYSCALL:
            LB     :
            LBU    :
            LH     :
            LHU    :
            LW     :
            SB     :
            SH     :
            SW     :
            ERET   :
            MFC0   :
            MTC0   :
            default: 
        endcase

endmodule // 