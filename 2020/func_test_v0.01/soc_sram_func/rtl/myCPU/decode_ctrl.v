/**
 * decode ctrl模块
 * 主要用于指令在decode阶段控制信号的生成 主要生成 regDst jump branch extType 四个信号
 * @author AshinZ
 * @time   2020-5-27
*/

module decode_ctrl(inst_name,instruction,CP0_12,CP0_14,read_data1,if_work,jump,branch,regDst,extType,aluSrc,sll_info,jump_reg,sys,bp,eret,if_npc_wrong,soft_input);
    input [7:0] inst_name;
    input [31:0] instruction;
    input          CP0_12;
    input  [31:0]  CP0_14;
    input [31:0] read_data1;//rs寄存器值
    input       if_work;
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
    output wire         sll_info ;
    // sll=1 寄存器1数据使用[10,6]  sll=0 寄存器1用读取出来的数据 用于sll sra srl
    output wire         jump_reg;
    output             eret;
    output             if_npc_wrong;
    output               soft_input;
    //指定跳转对象 如果是1说明是寄存器rs里的值 否则是正常立即数拓展的值
    output           sys;
    output           bp;
    `include "decode_list.v"

    reg [4:0] decode_ctrl_info;
    assign {regDst,extType,aluSrc} = decode_ctrl_info;
    assign sys  = (inst_name == SYSCALL)?1:0;
    assign bp = (inst_name == BREAK)?1:0;
    assign eret = (if_work==0&&inst_name == ERET)?1:0;
    always @(*)
        if(if_work==1)
            decode_ctrl_info = 5'b00000;
        else
        case (inst_name)
            ADD    :  decode_ctrl_info = 5'b00_00_0;
            ADDI   :  decode_ctrl_info = 5'b01_00_1;
            ADDU   :  decode_ctrl_info = 5'b00_00_0;
            ADDIU  :  decode_ctrl_info = 5'b01_00_1;
            SUB    :  decode_ctrl_info = 5'b00_00_0;
            SUBU   :  decode_ctrl_info = 5'b00_00_0;
            SLT    :  decode_ctrl_info = 5'b00_00_0;
            SLTI   :  decode_ctrl_info = 5'b01_00_1;
            SLTU   :  decode_ctrl_info = 5'b00_00_0;
            SLTIU  :  decode_ctrl_info = 5'b01_00_1;
            DIV    :  decode_ctrl_info = 5'b00_00_0;
            DIVU   :  decode_ctrl_info = 5'b00_00_0;
            MULT   :  decode_ctrl_info = 5'b00_00_0;
            MULTU  :  decode_ctrl_info = 5'b00_00_0;
            AND    :  decode_ctrl_info = 5'b00_00_0;
            ANDI   :  decode_ctrl_info = 5'b01_01_1;
            LUI    :  decode_ctrl_info = 5'b01_00_1;
            NOR    :  decode_ctrl_info = 5'b00_00_0;
            OR     :  decode_ctrl_info = 5'b00_00_0;
            ORI    :  decode_ctrl_info = 5'b01_01_1;
            XOR    :  decode_ctrl_info = 5'b00_00_0;
            XORI   :  decode_ctrl_info = 5'b01_01_1;
            SLL    :  decode_ctrl_info = 5'b00_00_0;
            SLLV   :  decode_ctrl_info = 5'b00_00_0;
            SRA    :  decode_ctrl_info = 5'b00_00_0;
            SRAV   :  decode_ctrl_info = 5'b00_00_0;
            SRL    :  decode_ctrl_info = 5'b00_00_0;
            SRLV   :  decode_ctrl_info = 5'b00_00_0;
            BEQ    :  decode_ctrl_info = 5'b00_00_0;
            BNE    :  decode_ctrl_info = 5'b00_00_0;
            BGEZ   :  decode_ctrl_info = 5'b00_00_0;
            BGTZ   :  decode_ctrl_info = 5'b00_00_0;
            BLEZ   :  decode_ctrl_info = 5'b00_00_0;
            BLTZ   :  decode_ctrl_info = 5'b00_00_0;
            BLTZAL :  decode_ctrl_info = 5'b10_00_0;
            BGEZAL :  decode_ctrl_info = 5'b10_00_0;
            J      :  decode_ctrl_info = 5'b00_00_0;
            JAL    :  decode_ctrl_info = 5'b10_00_0;
            JR     :  decode_ctrl_info = 5'b00_00_0;
            JALR   :  decode_ctrl_info = 5'b10_00_0;
            MFHI   :  decode_ctrl_info = 5'b00_00_0;
            MFLO   :  decode_ctrl_info = 5'b00_00_0;
            MTHI   :  decode_ctrl_info = 5'b00_00_0;
            MTLO   :  decode_ctrl_info = 5'b00_00_0;
        //    BREAK  :  
        //    SYSCALL:
            LB     :  decode_ctrl_info = 5'b01_00_1;
            LBU    :  decode_ctrl_info = 5'b01_00_1;
            LH     :  decode_ctrl_info = 5'b01_00_1;
            LHU    :  decode_ctrl_info = 5'b01_00_1;
            LW     :  decode_ctrl_info = 5'b01_00_1;
            SB     :  decode_ctrl_info = 5'b00_00_1;
            SH     :  decode_ctrl_info = 5'b00_00_1;
            SW     :  decode_ctrl_info = 5'b00_00_1;
            ERET   :  decode_ctrl_info = 5'b00_00_0;
            MFC0   :  decode_ctrl_info = 5'b01_00_0;
            MTC0   :  decode_ctrl_info = 5'b00_00_0;
            default:  decode_ctrl_info = 5'b00_00_0;
        endcase
    
        assign jump=(if_work==0)?((inst_name[7:4] == 4'b0100) ?1:0):0;
        assign if_npc_wrong =((jump&&read_data1[1:0]!=2'b00)||inst_name==ERET&&CP0_14[1:0]!=2'b00)?1:0;
        //3'b000 不跳转   3'b010 相等时跳转    3'b011 不相等时跳转    3'b100大于时跳转 
        //3'b101小于时跳转  3'b110 大于等于时跳转 3'b111小于等于时跳转
        assign branch = (if_work)?3'b000:
                        ((inst_name == BEQ ) ? 3'b010:
                        (inst_name == BNE ) ? 3'b011:
                        (inst_name == BGEZ || inst_name == BGEZAL) ? 3'b110:
                        (inst_name == BGTZ) ? 3'b100:
                        (inst_name == BLEZ) ? 3'b111:
                        (inst_name == BLTZ || inst_name == BLTZAL) ? 3'b101:
                        3'b000);
        assign sll_info = (if_work==0&&(inst_name == SLL || inst_name == SRA || inst_name == SRL)) ? 1:0;
        assign jump_reg = (if_work==0&&(inst_name == JR  || inst_name == JALR)) ? 1 : 0 ;
        assign soft_input = (CP0_12==0&&inst_name == MTC0&&instruction[15:11]==5'b01101&&read_data1[9:8]!=2'b00)?1:0;
endmodule // 