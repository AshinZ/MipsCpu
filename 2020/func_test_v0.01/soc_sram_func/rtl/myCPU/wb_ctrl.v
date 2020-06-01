/**
 * wb ctrl模块
 * 主要用于指令在wb阶段控制信号的生成 主要生成 aluOp aluSrc 两个信号
 * @author AshinZ
 * @time   2020-5-27
*/

module wb_ctrl(inst_name,if_work,memToReg,regwrite,HI_read,HI_write,LO_read,LO_write);
    input [7:0] inst_name;
    input  if_work;
    output wire [1:0]   memToReg;
    // 2'b00 memdata  2'b01 hi lo寄存器  2‘b10 pc  2'b11 CP0寄存器
    output wire         regwrite;
    // 1写回寄存器  0不写
    output wire         HI_read ;
    // 是否读 认为读就是把hi的数读取到regfile
    output wire         HI_write;
    // 是否写到hi 和lo
    output wire         LO_read;
    // 是否读 认为读就是把lo的数读取到regfile
    output wire         LO_write; 
    //是否写到hi和lo

    `include "decode_list.v"
    reg   [2:0]    wb_ctrl_info ;
    assign {memToReg,regwrite} = wb_ctrl_info;

    assign HI_read = (inst_name == MFHI&&if_work==0)?1:0;
    assign HI_write= ((if_work==0)&&(inst_name == MTHI||inst_name[7:2]==6'b000011))?1:0;
    assign LO_read = (inst_name == MFLO&&if_work==0)?1:0;
    assign LO_write= (if_work==0&&(inst_name == MTLO||inst_name[7:2]==6'b000011))?1:0;


    always @(*)
        if(if_work==1)
            wb_ctrl_info = 3'b000;
        else
        case (inst_name)
            ADD    : wb_ctrl_info = 3'b001;
            ADDI   : wb_ctrl_info = 3'b001;
            ADDU   : wb_ctrl_info = 3'b001;
            ADDIU  : wb_ctrl_info = 3'b001;
            SUB    : wb_ctrl_info = 3'b001;
            SUBU   : wb_ctrl_info = 3'b001;
            SLT    : wb_ctrl_info = 3'b001;
            SLTI   : wb_ctrl_info = 3'b001;
            SLTU   : wb_ctrl_info = 3'b001;
            SLTIU  : wb_ctrl_info = 3'b001;
            DIV    : wb_ctrl_info = 3'b000;
            DIVU   : wb_ctrl_info = 3'b000;
            MULT   : wb_ctrl_info = 3'b000;
            MULTU  : wb_ctrl_info = 3'b000;
            AND    : wb_ctrl_info = 3'b001;
            ANDI   : wb_ctrl_info = 3'b001;
            LUI    : wb_ctrl_info = 3'b001;
            NOR    : wb_ctrl_info = 3'b001;
            OR     : wb_ctrl_info = 3'b001;
            ORI    : wb_ctrl_info = 3'b001;
            XOR    : wb_ctrl_info = 3'b001;
            XORI   : wb_ctrl_info = 3'b001;
            SLL    : wb_ctrl_info = 3'b001;
            SLLV   : wb_ctrl_info = 3'b001;
            SRA    : wb_ctrl_info = 3'b001;
            SRAV   : wb_ctrl_info = 3'b001;
            SRL    : wb_ctrl_info = 3'b001;
            SRLV   : wb_ctrl_info = 3'b001;
            BEQ    : wb_ctrl_info = 3'b000;
            BNE    : wb_ctrl_info = 3'b000;
            BGEZ   : wb_ctrl_info = 3'b000;
            BGTZ   : wb_ctrl_info = 3'b000;
            BLEZ   : wb_ctrl_info = 3'b000;
            BLTZ   : wb_ctrl_info = 3'b000;
            BLTZAL : wb_ctrl_info = 3'b101;
            BGEZAL : wb_ctrl_info = 3'b101;
            J      : wb_ctrl_info = 3'b000;
            JAL    : wb_ctrl_info = 3'b101;
            JR     : wb_ctrl_info = 3'b000;
            JALR   : wb_ctrl_info = 3'b101;
            MFHI   : wb_ctrl_info = 3'b011;
            MFLO   : wb_ctrl_info = 3'b011;
            MTHI   : wb_ctrl_info = 3'b000;
            MTLO   : wb_ctrl_info = 3'b000;
        //   BREAK  :
        //    SYSCALL:
            LB     : wb_ctrl_info = 3'b001;
            LBU    : wb_ctrl_info = 3'b001;
            LH     : wb_ctrl_info = 3'b001;
            LHU    : wb_ctrl_info = 3'b001;
            LW     : wb_ctrl_info = 3'b001;
            SB     : wb_ctrl_info = 3'b000;
            SH     : wb_ctrl_info = 3'b000;
            SW     : wb_ctrl_info = 3'b000;
            ERET   : wb_ctrl_info = 3'b000;
            MFC0   : wb_ctrl_info = 3'b111;
            MTC0   : wb_ctrl_info = 3'b000;
            default: wb_ctrl_info = 3'b000;
        endcase

endmodule // 