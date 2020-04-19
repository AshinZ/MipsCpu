/**
 * 主进入模块 
 * @author AshinZ
 * @time   2020-4-18 
 * @param  clk(clock),rst(reset)
*/

module mips(clk,rst);
    input clk;
    input rst;
    //从这里调用datapath和control 所以我们要设置datapath和control的参数
    //设置control的参数

    wire [31:0]   instruction;  //指令
    wire [5:0]    opcode;       //操作码
    wire [5:0]    funct;        //功能码 此处我们将aluCrtl和Control合到一起 根据输入的opcode来进行判断分类
    wire [1:0]    jump;         //是否为j指令
    wire [1:0]    branch;       //判断是否为branch指令
    wire          memRead;      //是否允许读取数据
    wire [1:0]    memToReg;     //选择是要alu计算出的数据 还是从dm取出的数据
    wire [2:0]    aluOp;        //alu的指令
    wire          memWrite;     //是否允许往dm写入数据
    wire          aluSrc;       //用于alu前面的那个mux 判断选择哪个数据
    wire          regWrite;     //是否允许数据写入到寄存器
    wire [1:0]    regDst;       //用于reg前面的那个寄存器的选择 其实是判断是r指令还是i指令
    wire [1:0]    extType;      //符号拓展的类型 有符号无符号等
    //设置给control传入的两个数据的值
    assign opcode = instruction[31:26];
    assign funct  = instruction[5:0];

    //数据传入control和datapath
    control Control(opcode,funct,regDst,jump,branch,memRead,memToReg,aluOp,memWrite,aluSrc,regWrite,extType);
    datapath Datapath(clk,rst,regDst,jump,branch,memRead,memToReg,aluOp,memWrite,aluSrc,regWrite,extType,instruction);

endmodule

