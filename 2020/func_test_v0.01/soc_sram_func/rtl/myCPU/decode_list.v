  //57条指令分布： 
    // 算数运算指令             14  +：4  -：2  slt：4  ×：2  /：2
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

    //数据移动指令 begin 主要是LO和HI两个寄存器
    parameter MFHI = 8'b0101_0000 ,MFLO = 8'b0101_0001 ;
    parameter MTHI = 8'b0101_0010 ,MTLO = 8'b0101_0011 ;
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
    // nop指令 end