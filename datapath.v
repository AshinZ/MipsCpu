/**
 * datapath模块
 * @author AshinZ
 * @time   2020-4-18 
 * @param
 * @return 
*/

module datapath(clk,rst,regDst,jump,branch,memRead,memToReg,aluOp,memWrite,aluSrc,regWrite,extType,instruction);

    input          clk;
    input          rst;
    input  [1:0]   regDst;
    input  [1:0]   jump;
    input  [1:0]   branch;
    input          memRead;
    input  [1:0]   memToReg;
    input  [2:0]   aluOp;
    input          memWrite;
    input          aluSrc;
    input          regWrite;
    input  [1:0]   extType;
    output [31:0]  instruction;
/*  alu
    input  [2:0]    aluOp;
    input  [31:0]   data1,data2;
    output          zero;
    output [31:0]   result;
*/
    wire [31:0]  data1,data2;
    wire         zero;
    wire [31:0]  result;
    alu Alu(aluOp,data1,data2,zero,result);
/*  dm
     input   [11:2]  addr;   
    input           we;     
    input           clk;    
    input   [31:0]  din;    
    output  [31:0]  dout;   
*/
    wire [31:0] writeData;
    wire [31:0] dout;
    dm_4k Dm(result[11:2],memWrite,clk,readData2,dout);
/*  im    
    input   [11:2]   addr;//address bus
    output  [31:0]  dout;//32-bit memory output
*/
    wire [31:0]  instruction;
    im_4k Im(PC[11:2],instruction);
/*  npc
    input  [31:2]  PC; //当前pc
    input  [25:0]  instruction;//指令的后26位 在j指令的时候使用
    input  [31:0]  beqInstruction;//beq指令用到的地址 这里是经过了左移两位的
    input  [1:0]   branch; //是否是beq
    input  [1:0]   jump;//是否为j指令
    input          zero;//alu计算出来的是否符合条件
    output [31:2]  NPC; //next pc
    output [31:2]  fourPc;//pc+4 用来针对jr指令
*/
    wire [31:2]  PC;
    wire [31:0]  beqInstruction;
    wire [31:2]  NPC;
    wire [31:2]  fourPc;
/*   pc
    input [31:2]   NPC;
    input          clk;
    input          rst;
    output [31:2]  PC;
    */
    pc Pc(NPC,clk,rst,PC);
    npc Npc(PC,instruction[25:0],beqInstruction,branch,jump,zero,NPC,fourPc);
/*   regfile
    input  [4:0]   readRegister1,readRegister2,writeRegister;
    input  [32:0]  writeData;
    input          regWrite;
    input          clk;
    input          rst;
    output [31:0]  readData1,readData2;
*/
    wire [31:0] readData2;
    regfile Regfile(instruction[25:21],instruction[20:16],writeRegister,writeData,regWrite,clk,rst,data1,readData2);
/*  sl2
    input  [31:0]  data;//输入数据
    output [31:0]  slData;//输出左移两位后的数据
*/
/*  signext
    input  [15:0]   instruction;
    input  [1:0]    extType;
    output [31:0]   signExtNumber;
    */
    wire [31:0] signExtNumber;
    signext Signext(instruction[15:0],extType,signExtNumber);
    sl2 sl2_1(signExtNumber,beqInstruction);  //beq指令下 地址拓展两位
    mux2_32 Mux2_32_1(readData2,signExtNumber,aluSrc,data2);  //送入alu的数据的选择 是i指令还是r指令
    //符号拓展模块

/*  剩下的mux模块 */
    wire [4:0] writeRegister;
    mux3_5 Mux3_5_1(instruction[20:16],instruction[15:11],5'b11111,regDst,writeRegister); //寄存器前面的那个选择器
    mux3_32 Mux2_32_2(dout,result,{fourPc,2'b00},memToReg,writeData); //dm后面那个mux

endmodule