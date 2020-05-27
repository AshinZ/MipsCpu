/**
 * decode ctrl模块
 * 主要用于指令在decode阶段控制信号的生成 主要生成 regDst jump branch extType 四个信号
 * @author AshinZ
 * @time   2020-5-27
*/

module decode_ctrl(inst_name,jump,branch,regDst,extType,aluSrc,sll_info);
    input [7:0] inst_name;

    output wire         jump    ; //1 跳转 0 不跳转
    output wire [2:0]   branch  ; 
    //3'b000 不跳转   3'b010 相等时跳转    3'b011 不相等时跳转    3'b100大于时跳转 
    //3'b101小于时跳转  3'b110 大于等于时跳转 3'b111小于等于时跳转
    output wire [1:0]   regDst  ;
    //2'b00 R指令 2'b01 I指令 2'b10  31号寄存器 2'b11  0号寄存器
    output wire [1:0]   extType ;
    //2'b00 符号拓展  2'b01 无符号拓展 2'b10 高位拓展
    output wire         aluSrc  ;
    //0的时候选择寄存器读取数据 1的时候选择立即数拓展
    output wire         sll_info;
    // sll=1 寄存器1数据使用[10,6]  sll=0 寄存器1用读取出来的数据
    `include "decode_list.v"

    wire [9:0] decode_ctrl_info;
    assign {jump,branch,regDst,extType,aluSrc,sll_info} = decode_ctrl_info;

    always @(*)
        case (inst_name)
            ADD    :  assign  decode_ctrl_info = 10'b
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