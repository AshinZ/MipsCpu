/**
 * 控制器模块
 * @author AshinZ
 * @time   2020-4-18 
 * @param
 * @return 
*/

module control(opcode,funct,regDst,jump,branch,memRead,memToReg,aluOp,memWrite,aluSrc,regWrite,extType);
    input  [5:0]  opcode;   
    input  [5:0]  funct;
    output [1:0]  regDst;
    output [1:0]  jump;
    output [1:0]  branch;
    output        memRead;
    output [1:0]  memToReg;
    output [2:0]  aluOp;
    output        memWrite;
    output        aluSrc;
    output        regWrite;
    output [1:0]  extType;
    parameter no_jump = 2'b00 , J = 2'b01 , Jr=2'b10 , jal=2'b11; //判断j指令类型
    parameter no_branch = 2'b00 , beq = 2'b10 , bne = 2'b11;      //判断branch指令类型
    parameter signedext = 2'b00 , unsignedext = 2'b01 , lui_ext = 2'b10;  //拓展类型 
    parameter Add = 3'b000 , Sub = 3'b001 , Or = 3'b010 , Slt = 3'b011 , And = 3'b100, Xor = 3'b101;   //给alu的计算下指令
    //第一个是往寄存器写入dm数据 即ld 第二个是将alu的运算结果放入寄存器 第三个是将pc放入寄存器  memToReg
    parameter READDATA = 2'b00 , ALURESULT = 2'b01 , RAREGISTER = 2'b10; 
    parameter RDWrite = 2'b01 , RTWrite = 2'b00 , RA = 2'b10;//regDst  RDWrite是R指令 RTWrite是i指令 RA是将数据写入到31号寄存器 即$ra
    reg [16:0]  controlInfo;
    //根据传入的指令对各个控制指令进行赋值
    assign {regDst,jump,branch,memRead,memToReg,aluOp,memWrite,aluSrc,regWrite,extType} = controlInfo;

    always @(*)
        case (opcode)
            6'b000000://如果是R指令
                case ( funct )
                    6'b000000: controlInfo <= 17'b00_00_00_0_00_000_0_0_0_00;
                    6'b100000: controlInfo <= 17'b01_00_00_0_01_000_0_0_1_00;//add
      //              6'b100001://addu
                    6'b100010: controlInfo <= 17'b01_00_00_0_01_001_0_0_1_00;//sub
      //              6'b100011://subu
                    6'b100100: controlInfo <= 17'b01_00_00_0_01_100_0_0_1_00;//and
                    6'b100101: controlInfo <= 17'b01_00_00_0_01_010_0_0_1_00;//or
                    6'b101010: controlInfo <= 17'b01_00_00_0_01_011_0_0_1_00;//slt
                    6'b100110: controlInfo <= 17'b01_00_00_0_01_101_0_0_1_00;//xor
                    default: controlInfo <= 17'bxx_xx_xx_x_xx_xxx_x_x_x_xx ;
                endcase
    //assign {regDst,jump,branch,memRead,memToReg,aluOp,memWrite,aluSrc,regWrite,extType} = controlInfo;
            6'b001000: controlInfo <= 17'b00_00_00_0_01_000_0_1_1_00 ;//addi
            6'b001001: controlInfo <= 17'b00_00_00_0_01_000_0_1_1_01 ;//addiu
            6'b001101: controlInfo <= 17'b00_00_00_0_01_010_0_1_1_01 ;//ori
            6'b000100: controlInfo <= 17'b01_00_10_0_01_001_0_0_0_00 ;//beq
            6'b000010: controlInfo <= 17'b00_01_00_0_00_000_0_0_0_00 ;//j
        //    6'b000011: controlInfo <= 17'b00_00_10_0_00_100_0_0_0_10 ;//jal
            6'b100011: controlInfo <= 17'b00_00_00_1_00_000_0_1_1_00 ;//lw
            6'b101011: controlInfo <= 17'b00_00_00_0_00_000_1_1_0_00 ;//sw
            6'b001111: controlInfo <= 17'b00_00_00_0_01_000_0_1_1_10 ;//lui
            default:controlInfo <= 17'bxx_xx_xx_x_xx_xxx_x_x_x_xx ;//undefined instruction 
        endcase
endmodule 