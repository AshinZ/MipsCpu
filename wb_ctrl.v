/**
 * wb ctrl模块
 * 主要用于指令在wb阶段控制信号的生成 主要生成 aluOp aluSrc 两个信号
 * @author AshinZ
 * @time   2020-5-27
*/

module wb_ctrl(inst_name,memToReg,regwrite,HI_read,HI_write,LO_read,LO_write);
    input [7:0] inst_name;

    output wire [1:0]   memToReg;
    // 2'b00 memdata  2'b01 hi lo寄存器  2‘b10 pc  2'b11 CP0寄存器
    output wire         regwrite;
    output wire         HI_read ;
    output wire         HI_write;
    output wire         LO_read;
    output wire         LO_write; 

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