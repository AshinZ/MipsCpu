/**
 * decode模块
 * 主要用于将指令对应成add对应的二进制�? 便于后面的分布式控制器的控制信号获取
 * @author AshinZ
 * @time   2020-5-27
*/

module decode(instruction,inst_name,stall_info,if_work);
    input  [31:0]  instruction; 
    input          stall_info;
    output reg  [7:0]   inst_name;
    input        if_work;
    /*
    //57条指令分布： 
    // 算数运算指令             14  +�?4  -�?2  slt�?4  ×�?2  /�?2
    // 逻辑运算指令             8 
    // 移位指令                 6
    // 分支跳转(branch)         8
    // 分支跳转(j)              4
    // 数据移动指令             4
    // 自陷指令 (break syscall) 2
    // 访存指令                 8
    // 自陷指令(处理异常指令)    3

    //于是我们将九种指令编码格式定义为 [7:4]指令种类 [3:0]指令种类
    //算数运算指令  begin
    parameter ADD = 8'b0000_0000 ,ADDI = 8'b0000_0001 , ADDU = 8'b0000_0010 , ADDIU = 8'b0000_0011;
    parameter SUB = 8'b0000_0100 ,SUBU = 8'b0000_0101 ;
    parameter SLT = 8'b0000_1000 ,SLTI = 8'b0000_1001 , SLTU = 8'b0000_1010 , SLTIU = 8'b0000_1011;
    parameter DIV = 8'b0000_1100 ,DIVU = 8'b0000_1101 ;
    parameter MULT= 8'b0000_1110 ,MULTU= 8'b0000_1111 ;
    //算数运算指令 end

    //逻辑运算指令 begin
    parameter AND = 8'b0001_0000 ,ANDI = 8'b0001_0001 ;
    parameter LUI = 8'b0001_0010 ,NOR  = 8'b0001_0011 ;
    parameter OR  = 8'b0001_0100 ,ORI  = 8'b0001_0101 ;
    parameter XOR = 8'b0001_0110 ,XORI = 8'b0001_0111 ;
    //逻辑运算指令 end

    //移位指令 begin
    parameter SLL = 8'b0010_0000 ,SLLV = 8'b0010_0001 ;
    parameter SRA = 8'b0010_0010 ,SRAV = 8'b0010_0011 ;
    parameter SRL = 8'b0010_0100 ,SRLV = 8'b0010_0101 ;
    //移位指令 end


    //branch类分支跳转begin
    parameter BEQ  = 8'b0011_0000 ,BNE  = 8'b0011_0001 ;
    parameter BGEZ = 8'b0011_0010 ,BGTZ = 8'b0011_0011 ;
    parameter BLEZ = 8'b0011_0100 ,BLTZ = 8'b0011_0101 ;
    parameter BLTZAL=8'b0011_0110 ,BGEZAL=8'b0011_0111 ;
    //branch类分支跳转end
 
    //j类分支指令begin
    parameter J  =  8'b0100_0000 ,JAL = 8'b0100_0001 ;
    parameter JR =  8'b0100_0010 ,JALR= 8'b0100_0011 ;
    //j类分支指令end

    //数据移动指令 begin 主要是LO和HI两个寄存�?
    parameter MFHI = 8'b0101_0000 ,MFLO = 8'b0101_0001 ;
    parameter MTHI = 8'b0101_0010 ,MFLO = 8'b0101_0010 ;
    //数据移动指令 end

    //自陷指令 begin 两个除法异常指令
    parameter BREAK = 8'b0110_0000 , SYSCALL = 8'b0110_0001 ;
    //自陷指令 end

    // 访存指令 begin
    parameter LB  = 8'b0111_0000 , LBU = 8'b0111_0001 ;
    parameter LH  = 8'b0111_0010 , LHU = 8'b0111_0011 ;
    parameter LW  = 8'b0111_0100 ;
    parameter SB  = 8'b0111_1000 , SH  = 8'b0111_1001 ;
    parameter SW  = 8'b0111_1010 ;
    // 访存指令 end

    // 自陷指令 begin
    parameter ERET = 8'b1000_0000;
    parameter MFC0 = 8'b1000_0010 , MTC0 = 8'b1000_0011 ;
    // 自陷指令 end

    // nop指令 begin
    parameter NOP = 8'b1111_1111;
    // nop指令 end*/

    `include "decode_list.v"
    //至此，我们完成了指令与二进制的羁�?
    //下面进行对二进制32位指令与指令的羁绊链�?

    always @(*)
        if(stall_info == 1||if_work == 1) 
                begin
                if(instruction[31:26]==6'b000000&&instruction[5:0]==6'b001100)
                        inst_name = SYSCALL;
                else if(instruction[31:26]==6'b000000&&instruction[5:0]==6'b001101)
                        inst_name = BREAK;
                else
                inst_name = NOP ;
                end
        else
     /*   if(stall_info==1)
                inst_name = NOP ;
        else*/
        case (instruction[31:26])
            6'b000000://R指令
                case(instruction[5:0])
                        6'b100000: inst_name = ADD   ;    //add 
                        6'b100001: inst_name = ADDU  ;    //addu
                        6'b100010: inst_name = SUB   ;    //sub
                        6'b100011: inst_name = SUBU  ;    //subu
                        6'b101010: inst_name = SLT   ;    //slt
                        6'b101011: inst_name = SLTU  ;    //sltu
                        6'b011010: inst_name = DIV   ;    //div
                        6'b011011: inst_name = DIVU  ;    //divu
                        6'b011000: inst_name = MULT  ;    //mult
                        6'b011001: inst_name = MULTU ;    //multu
                        //R类�?�辑运算
                        6'b100100: inst_name = AND   ;    //and
                        6'b100111: inst_name = NOR   ;    //nor
                        6'b100101: inst_name = OR    ;    //or
                        6'b100110: inst_name = XOR   ;    //xor
                        //R类移位指�?
                        6'b000000: inst_name = (instruction == 32'b0)?NOP:SLL   ;
                        6'b000100: inst_name = SLLV  ;    //sllv
                        6'b000111: inst_name = SRAV  ;    //srav
                        6'b000011: inst_name = SRA   ;    //sra
                        6'b000110: inst_name = SRLV  ;    //srlv
                        6'b000010: inst_name = SRL   ;    //srl
                        //R类跳转指�?
                        6'b001000: inst_name = JR    ;    //jr
                        6'b001001: inst_name = JALR  ;    //jalr 
                        //R类数据移动指�?
                        6'b010000: inst_name = MFHI  ;    //mfhi
                        6'b010010: inst_name = MFLO  ;    //mflo
                        6'b010001: inst_name = MTHI  ;    //mthi
                        6'b010011: inst_name = MTLO  ;    //mtlo
                        //自陷指令
                        6'b001101: inst_name = BREAK ;    //break
                        6'b001100: inst_name =SYSCALL;    //syscall
                        default: inst_name = 8'b1111_1110 ;
                    endcase
            //I类指�?
            6'b001000: inst_name = ADDI  ; //addi
            6'b001001: inst_name = ADDIU ; //addiu
            6'b001010: inst_name = SLTI  ; //slti
            6'b001011: inst_name = SLTIU ; //sltiu
            6'b001100: inst_name = ANDI  ; //andi
            6'b001111: inst_name = LUI   ; //lui
            6'b001101: inst_name = ORI   ; //ori
            6'b001110: inst_name = XORI  ; //xori
            //I类跳转指�?
            6'b000100: inst_name = BEQ   ; //beq
            6'b000101: inst_name = BNE   ; //bne
            6'b000001: 
                    case(instruction[20:16])
                            5'b00001: inst_name = BGEZ  ; //bgez
                            5'b00000: inst_name = BLTZ  ; //bltz
                            5'b10001: inst_name = BGEZAL; //bgezal
                            5'b10000: inst_name = BLTZAL; //bltzal
                            default: inst_name = 8'b1111_1110 ;
                    endcase
            6'b000111: inst_name = BGTZ  ; //bgtz
            6'b000110: inst_name = BLEZ  ; //blez
            //J指令
            6'b000010: inst_name = J     ; //J
            6'b000011: inst_name = JAL   ; //jal
            //访存指令
            6'b100000: inst_name = LB    ; //lb
            6'b100100: inst_name = LBU   ; //lbu
            6'b100001: inst_name = LH    ; //lh
            6'b100101: inst_name = LHU   ; //lhu
            6'b100011: inst_name = LW    ; //lw
            6'b101000: inst_name = SB    ; //sb
            6'b101001: inst_name = SH    ; //sh
            6'b101011: inst_name = SW    ; //sw
            //特权指令
            6'b010000: inst_name = (instruction[25]==1)?ERET:((instruction[25:21] == 5'b0) ?MFC0 : MTC0) ; //mfc0 mtc0
            default: inst_name = 8'b1111_1110 ;
        endcase


endmodule

