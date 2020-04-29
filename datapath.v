/**
 * datapath模块
 * @author AshinZ
 * @time   2020-4-18 
 * @param
 * @return 
*/

module datapath(clk,rst,regDst,jump,branch,memRead,memToReg,aluOp,memWrite,aluSrc,regWrite,extType,ID_instruction);

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
    input  [1:0]   extType; //control的结果
    output [31:0]  ID_instruction;

//进行四个流水线寄存器的变量声明
//变量命名规则 对于例如IF_ID模块 在其输出变量上加ID 输入加IF
//所以往往其输入是由上个部分声明 所以声明输出即可
//IF_ID寄存器
    wire  [31:2] ID_fourPC;
    wire  [31:0] ID_instruction;

//ID_EX寄存器
    wire  [31:2] EX_fourPC;
    wire  [1:0]  EX_regDst;
    wire  [1:0]  EX_jump;
    wire  [1:0]  EX_branch;
    wire         EX_memRead;
    wire  [1:0]  EX_memToReg;
    wire  [2:0]  EX_aluOp;
    wire         EX_memWrite;
    wire         EX_aluSrc;
    wire         EX_regWrite;
    wire [31:0]  EX_readData1;
    wire [31:0]  EX_readData2;
    wire [5:0]   EX_instruction1;
    wire [5:0]   EX_instruction2;
    wire [31:0]  EX_extNumber;

//EX_MEM寄存器
    wire [31:2]   MEM_fourPC;
    wire [1:0]    MEM_jump;
    wire [1:0]    MEM_branch;
    wire          MEM_memRead;
    wire [1:0]    MEM_memToReg;
    wire          MEM_memWrite;
    wire          MEM_regWrite;
    wire [31:0]   MEM_beqInstruction;
    wire          MEM_zero;
    wire [31:0]   MEM_aluResult;
    wire [31:0]   MEM_readData2;
    wire [5:0]    MEM_writeDataReg;

//MEM_WB寄存器
    wire [31:2]   WB_fourPC;
    wire [1:0]    WB_jump;
    wire [1:0]    WB_branch;
    wire          WB_memRead;
    wire [1:0]    WB_memToReg;
    wire          WB_memWrite;
    wire          WB_regWrite;
    wire [31:0]   WB_aluResult;
    wire [31:0]   WB_readData;
    wire [5:0]    WB_writeDataReg;

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
    npc Npc(PC,25'b0,beqInstruction,MEM_branch,MEM_jump,MEM_zero,NPC,fourPc);

//加入IF_ID寄存器
    if_id If_id(clk,rst,PC + 1,instruction,ID_fourPC,ID_instruction);


/*   regfile
    input  [4:0]   readRegister1,readRegister2,writeRegister;
    input  [32:0]  writeData;
    input          regWrite;
    input          clk;
    input          rst;
    output [31:0]  readData1,readData2;
*/
    wire [31:0] writeData;
    wire [31:0] readData1;
    wire [31:0] readData2;
    regfile Regfile(ID_instruction[25:21],ID_instruction[20:16],MEM_writeDataReg,writeData,MEM_regWrite,clk,rst,readData1,readData2);

/*  signext
    input  [15:0]   instruction;
    input  [1:0]    extType;
    output [31:0]   signExtNumber;
    */
    wire [31:0] signExtNumber;
    signext Signext(ID_instruction[15:0],extType,signExtNumber);

//加入ID_EX寄存器

    id_ex Id_ex(clk,rst,ID_fourPC,regDst,jump,branch,memRead,memToReg,aluOp,
    memWrite,aluSrc,regWrite,readData1,readData2,ID_instruction[20:16],
    ID_instruction[15:11],signExtNumber,EX_regDst,EX_jump,EX_branch,EX_memRead,
    EX_memToReg,EX_aluOp,EX_aluSrc,EX_regWrite,EX_memWrite,EX_readData1,EX_readData2,
    EX_extNumber,EX_instruction1,EX_instruction2,EX_fourPC);


/*  sl2
    input  [31:0]  data;//输入数据
    output [31:0]  slData;//输出左移两位后的数据
*/
    wire [31:0]  temp_beq_ins;
    sl2 sl2_1(EX_extNumber,temp_beq_ins);  //beq指令下 地址拓展两位

/*  alu
    input  [2:0]    aluOp;
    input  [31:0]   data1,data2;
    output          zero;
    output [31:0]   result;
*/
    wire [31:0]  data2;
    wire         zero;
    wire [31:0]  aluResult;
    mux2_32 Mux2_32_1(EX_readData2,EX_extNumber,EX_aluSrc,data2);  //送入alu的数据的选择 是i指令还是r指令
    alu Alu(EX_aluOp,EX_readData1,data2,zero,aluResult);

    wire [4:0] writeRegister;//写入的寄存器地址
    mux3_5 Mux3_5_1(EX_instruction1,EX_instruction2,5'b11111,EX_regDst,writeRegister); //寄存器前面的那个选择器

//加入EX_MEM寄存器
    assign beqInstruction = temp_beq_ins[31:2] + EX_fourPC;
    ex_mem Ex_mem(clk,rst,EX_fourPC,EX_jump,EX_branch,EX_memRead,EX_memToReg,
    EX_memWrite,EX_regWrite,beqInstruction,zero,aluResult,EX_readData2,
    writeRegister,MEM_jump,MEM_branch,MEM_memRead,MEM_memToReg,MEM_memWrite,MEM_regWrite,//往后传输的数据
    MEM_beqInstruction,MEM_zero,MEM_aluResult,MEM_readData2,MEM_writeDataReg,MEM_fourPC);

/*  dm
     input   [11:2]  addr;   
    input           we;     
    input           clk;    
    input   [31:0]  din;    
    output  [31:0]  dout;   
*/
    wire [31:0] dout;
    dm_4k Dm(MEM_aluResult[11:2],MEM_memWrite,clk,MEM_readData2,dout);

//加入MEM_WB寄存器
    mem_wb Mem_wb(clk,rst,MEM_fourPC,MEM_jump,MEM_memToReg,dout,MEM_aluResult,
    MEM_writeDataReg,WB_jump,WB_memToReg,//往后传输的数据
    WB_readData,WB_aluResult,WB_writeDataReg,WB_fourPC);

    mux3_32 Mux2_32_2(WB_readData,WB_aluResult,{WB_fourPC,2'b00},WB_memToReg,writeData); //dm后面那个mux



endmodule