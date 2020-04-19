/**
 * 控制器模块
 * @author AshinZ
 * @time   2020-4-18 
 * @param
 * @return 
*/

module control(
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
);

    parameter no_jump = 2'b00 , J = 2'b01 , Jr=2'b10 , jal=2'b11;
    parameter no_branch = 2'b00 , beq = 2'b10 , bne = 2'b11;
    parameter signedext = 2'b00 , unsignedext = 2'b01 , lui_ext = 2'b10;


    reg [13:0]  controlInfo;
    //根据传入的指令对各个控制指令进行赋值
    assign {regDst,jump,branch,memRead,memToReg,aluOp,memWrite,aluSrc,regWrite,extType} = controlInfo;

    always @(*)
        case (opcode)
            6'b000000://如果是R指令
                controlInfo <= 14'b0_0_1_0_0_1000_0_0_0_10
            6'b001000: controls <= 14'b0_0_1_0_0_1000_0_0_0_10 ;//addi
            6'b001001: controls <= 14'b0_0_1_0_0_1000_0_0_0_10 ;//addiu
            6'b001101: controls <= 14'b0_0_1_0_0_1000_0_0_0_10 ;//ori
            6'b000100: controls <= 14'b0_0_1_0_0_1000_0_0_0_10 ;//beq
            6'b000010: controls <= 14'b0_0_1_0_0_1000_0_0_0_10 ;//j
            6'b000011: controls <= 14'b0_0_1_0_0_1000_0_0_0_10 ;//jal
            6'b100011: controls <= 14'b0_0_1_0_0_1000_0_0_0_10 ;//lw
            6'b101011: controls <= 14'b0_0_1_0_0_1000_0_0_0_10 ;//sw
            6'b001111: controls <= 14'b0_0_1_0_0_1000_0_0_0_10 ;//lui
            default:controls <= 14'bxxxxxxxxxxxxxx ;//undefined instruction 
        endcase
endmodule //