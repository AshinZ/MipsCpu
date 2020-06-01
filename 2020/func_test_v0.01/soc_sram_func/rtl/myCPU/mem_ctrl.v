/**
 * mem ctrl模块
 * 主要用于指令在mem阶段控制信号的生成 主要生成 memRead memWrite readDataSelect writeDataSelect 两个信号
 * @author AshinZ
 * @time   2020-5-27
*/

module mem_ctrl(inst_name,if_work,data_ext_type,memRead,memWrite,data_size);
    input [7:0] inst_name;
    input  if_work;
    output wire         memRead ;
    output wire         memWrite ;
    output wire         data_ext_type; //判断是否是无符号拓展
    output wire  [1:0]  data_size;
    //考虑到后面两个使用的也不多 也采取单独赋值
    `include "decode_list.v"

    assign  data_size=(if_work==0)?((inst_name == SW||inst_name==LW)?2'b10:
                       (inst_name == SH || inst_name==LH||inst_name==LHU)?2'b01:
                       2'b00):2'b00;
    assign  memRead = (if_work==0)?((inst_name[7:3] == 5'b0111_0)? 1 : 0):0;
    assign  memWrite = (if_work==0)?((inst_name[7:3] == 5'b0111_1)?1 : 0):0;
    assign  data_ext_type = (inst_name == LBU || inst_name == LHU)? 1 : 0;
   /* wire    [1:0]   mem_ctrl_info;
    assign   {memRead,memWrite} = mem_ctrl_info;
    always @(*)
        case (inst_name)
            ADD    : assign mem_ctrl_info = 2'b00 ;
            ADDI   : assign mem_ctrl_info = 2'b00 ;
            ADDU   : assign mem_ctrl_info = 2'b00 ;
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
        endcase  */

endmodule // 