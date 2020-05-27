/**
 * datapath模块
 * @author AshinZ
 * @time   2020-4-18 
 * @param
 * @return 
*/

module datapath(clk,rst);

    input          clk;
    input          rst;

//进行四个流水线寄存器的变量声明
//变量命名规则 对于例如IF_ID模块 在其输出变量上加ID 输入加IF
//所以往往其输入是由上个部分声明 所以声明输出即可
//IF_ID寄存器
    wire  [31:0] ID_fourPC;
    wire  [31:0] ID_instruction;

//ID_EX寄存器
    wire  [31:0] EX_fourPC;
    wire  [1:0]  EX_regDst;
    wire  [1:0]  EX_jump;
    wire  [1:0]  EX_branch;
    wire         EX_memRead;
    wire  [1:0]  EX_memToReg;
    wire  [2:0]  EX_aluOp;
    wire         EX_memWrite;
    wire         EX_aluSrc;
    wire         EX_regWrite;
    wire [31:0]  EX_alu_data1;
    wire [31:0]  EX_alu_data2;
    wire [4:0]   EX_instruction1;
    wire [4:0]   EX_instruction2;
    wire [1:0]   EX_extType;
    wire [31:0]  EX_extNumber;
    wire [31:0]  EX_instruction;
    wire [7:0]   EX_inst_name;
    wire [4:0]   EX_register_d;

//EX_MEM寄存器
    wire [31:0]   MEM_fourPC;
    wire [1:0]    MEM_jump;
    wire [1:0]    MEM_branch;
    wire          MEM_memRead;
    wire [1:0]    MEM_memToReg;
    wire          MEM_memWrite;
    wire          MEM_regWrite;
    wire          MEM_zero;
    wire [31:0]   MEM_aluResult;
    wire [31:0]   MEM_readData2;
    wire [4:0]    MEM_writeDataReg;
    wire [31:0]   MEM_instruction;
    wire [7:0]    MEM_inst_name;
    wire [31:0]   MEM_HI_data;
    wire [31:0]   MEM_LO_data;

//MEM_WB寄存器
    wire [31:0]   WB_fourPC;
    wire [1:0]    WB_jump;
    wire [1:0]    WB_branch;
    wire          WB_memRead;
    wire [1:0]    WB_memToReg;
    wire          WB_memWrite;
    wire          WB_regWrite;
    wire [31:0]   WB_aluResult;
    wire [31:0]   WB_write_Data;
    wire [4:0]    WB_writeDataReg;
    wire [31:0]   WB_instruction;
    wire [7:0]    WB_inst_name;

//---------fetch模块------ begin
/*  im    
    input   [11:2]   addr;//address bus
    output  [31:0]  dout;//32-bit memory output
*/
    wire [31:0]  instruction;
    wire [31:0]  mux_instruction;
    im_4k Im(PC[11:2],instruction);
    mux2_32 Mux2_32_1(instruction,32'b0,flush,mux_instruction);

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
    wire [31:0]  PC;
    wire [31:0]  temp_beqInstruction1;  
    wire [31:0]  temp_beqInstruction2; 
    wire [31:2]  beqInstruction;
    wire [31:0]  NPC;
    wire [31:0]  fourPc;
/*   pc
    input [31:2]   NPC;
    input          clk;
    input          rst;
    output [31:2]  PC;
    */
    pc Pc(NPC,clk,rst,PC_write,PC);
    npc Npc(PC,ID_instruction[25:0],beqInstruction,PCSrc,jump,NPC,fourPc);
    signext Signext_1(ID_instruction[15:0],2'b00,temp_beqInstruction1);
    sl2 Sl2(temp_beqInstruction1,temp_beqInstruction2);
    assign beqInstruction =  ID_fourPC + temp_beqInstruction2[31:0];
//------fetch模块------end














//------IF_ID寄存器------begin
    if_id If_id(clk,rst,PC+32'b0100,mux_instruction,IF_ID_write,ID_fourPC,ID_instruction);
//------IF_ID寄存器------end

















//------decode模块------begin
/*   regfile模块
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
    regfile Regfile(ID_instruction[25:21],ID_instruction[20:16],WB_writeDataReg,writeData,WB_regWrite,clk,rst,readData1,readData2);

/*  signext模块
    input  [15:0]   instruction;
    input  [1:0]    extType;
    output [31:0]   signExtNumber;
    */
    wire [31:0] signExtNumber;
    signext Signext(ID_instruction[15:0],extType,signExtNumber);

// decode级控制器模块 
//设置给control传入的两个数据的值
 /*   wire [5:0]    opcode;       //操作码
    wire [5:0]    funct;        //功能码 此处我们将aluCrtl和Control合到一起 根据输入的opcode来进行判断分类
    assign opcode = ID_instruction[31:26];
    assign funct  = ID_instruction[5:0];*/

    //添加解码器 将指令翻译成inst_name的八位信号
    wire  [7:0]   inst_name;
    wire          jump;
    wire  [2:0]   branch;
    wire  [1:0]   regDst;
    wire  [1:0]   extType;
    wire          aluSrc;
    wire          sll_info;
    decode Decode(ID_instruction[31:0],inst_name);
    //inst_name数据传入decode级control
    //control Control(opcode,funct,regDst,jump,branch,memRead,memToReg,aluOp,memWrite,aluSrc,regWrite,extType);
    decode_ctrl Decode_ctrl(inst_name,jump,branch,regDst,extType,aluSrc,sll_info);

    wire [4:0]    register_d;//目标寄存器
    //携带该寄存器一直往下走 这样在遇到冒险的时候 对于目标寄存器也比较好选择！
    mux3_5 Mux3_5_1(ID_instruction[15:11],ID_instruction[20:16],5'b11111,regDst,register_d); 

    wire [31:0]  alu_data1;
    wire [31:0]  alu_data2;//根据指令选择出传给流水寄存器的两个数据

    mux2_32 Mux2_32_2(readData1,{ID_instruction[10:6],27'b0},sll_info,alu_data1);
    mux2_32 Mux2_32_3(readData2,signExtNumber,aluSrc,alu_data2);
    //判断是寄存器一读出的数据 还是五位偏移量   
/*
//ctrl_result 是控制器前面的选择器的输出
    wire [11:0] ctrl_result;
    mux2_11 Mux_2_11_1({regDst,memRead,memToReg,aluOp,
    memWrite,aluSrc,regWrite},11'b0,stall_info,ctrl_result);*/
// ------decode模块------end













//------ID_EX寄存器------begin
    id_ex Id_ex(clk,rst,ID_fourPC,alu_data1,alu_data2,
    ID_instruction,inst_name,register_d,
    EX_alu_data1,EX_alu_data2,EX_fourPC,
    EX_instruction,EX_inst_name,EX_register_d);
//------ID_EX寄存器-----end


















//------exe模块------begin
    wire    [3:0]    aluOp;
    wire             mult;
    wire             div;
    exe_ctrl Exe_ctrl (EX_inst_name,aluOp,mult,div);

    wire    [31:0]   HI_data;
    wire    [31:0]   LO_data;
    multiply Multiply (mult,div,data1,data2,LO_data,HI_data);
/*  alu
    input  [2:0]    aluOp;
    input  [31:0]   data1,data2;
    output          zero;
    output [31:0]   result;
*/
    wire [31:0]  mux_data;
    wire [31:0]  data1;
    wire [31:0]  data2;
    wire [31:0]  aluResult;
    alu Alu(EX_aluOp,data1,data2,zero,aluResult);
    
//------exe模块------end






















//-----EX_MEM寄存器------begin
    ex_mem Ex_mem(clk,rst,EX_fourPC,aluResult,mux_data,
    EX_register_d,EX_instruction,EX_inst_name,
    LO_data,HI_data,
    MEM_aluResult,MEM_readData2,MEM_writeDataReg,MEM_fourPC
    ,MEM_instruction,MEM_inst_name,
    MEM_HI_data,MEM_LO_data);
//-----EX_MEM寄存器------end













//------mem模块------begin
    //控制信号生成
    wire         memRead;
    wire         memWrite;
    wire  [1:0]  readDataSelect;
    wire  [1:0]  writeDataSelect;
    mem_ctrl Mem_ctrl (MEM_inst_name,memRead,memWrite,readDataSelect,writeDataSelect);


    /*  dm
     input   [11:2]  addr;   
    input           we;     
    input           clk;    
    input   [31:0]  din;    
    output  [31:0]  dout;   
*/
    wire [31:0] dout;
    dm_4k Dm(MEM_aluResult[11:2],memWrite,clk,MEM_readData2,dout);

    wire [31:]  Write_data;//判断是取数据指令还是计算指令
    mux2_32 Mux_2_32_1(MEM_aluResult,dout,memRead,Write_data);
//------mem模块------end















//------MEM_WB寄存器------begin
    //加入MEM_WB寄存器
    wire [31:0]      WB_HI_data;
    wire [31:0]      WB_LO_data;
    mem_wb Mem_wb(clk,rst,MEM_fourPC,Write_data,
    MEM_writeDataReg,MEM_instruction,MEM_inst_name,
    MEM_HI_data,MEM_LO_data,
    WB_memToReg,WB_write_Data,WB_writeDataReg,WB_regWrite,
    WB_fourPC,WB_instruction,WB_inst_name
    WB_HI_data,WB_LO_data);
//-----MEM_WB寄存器------end



















//------wb模块------end
    wire   [1:0]        memToReg;
    wire         regWrite;
    wire         HI_read ;
    wire         HI_write;
    wire         LO_read;
    wire         LO_write; 
    wb_ctrl Wb_ctrl(WB_inst_name,memToReg,regWrite,
    HI_read,HI_write,LO_read,LO_write);

    wire  [31:0]   out_Hi_data;
    wire  [31:0]   out_LO_data;

    HILO_regfile HI_regfile(HI_write,WB_HI_data,out_Hi_data);
    HILO_regfile LO_regfile(LO_write,WB_LO_data,out_LO_data);

    wire [31:0]  HILO_data;
    mux2_32 MUX_2_32_2(out_Hi_data,out_LO_data,HI_read,HILO_data);


    mux4_32 Mux_4_32_1(WB_write_Data,HILO_data,save_pc,cp0,memToReg,writeData)
//------wb模块------end















//------解决冒险模块------begin
//加入forward 模块
    wire [1:0]  forward_A;
    wire [1:0]  forward_B;
    wire [4:0]  EX_MEM_Rd;
    wire [4:0]  MEM_WB_Rd;
    mux2_5 Mux2_5_1(MEM_instruction[15:11],MEM_instruction[20:16],MEM_instruction[31:26],EX_MEM_Rd);
    mux2_5 Mux2_5_2(WB_instruction[15:11],WB_instruction[20:16],WB_instruction[31:26],MEM_WB_Rd);
   // forwarding_unit_alu Forwarding_unit(EX_instruction[25:21],EX_instruction[20:16],EX_MEM_Rd,MEM_WB_Rd,
   // MEM_regWrite,WB_regWrite,forward_A,forward_B);
    forwarding_unit_alu Forwarding_unit(EX_instruction[25:21],EX_instruction[20:16],EX_register_d,MEM_writeDataReg,
    MEM_regWrite,WB_regWrite,forward_A,forward_B);
    //这个转发要注意 判断的条件 后面两个流水寄存器的目标寄存器 并不一定是20:16  所以要加一个mux
    mux3_32 Mux_3_32_3(EX_alu_data1,writeData,MEM_aluResult,forward_A,data1);
    mux3_32 Mux_3_32_4(EX_alu_data2,writeData,MEM_aluResult,forward_B,data2);

//加入beq前移的相关模块
//转发模块
    wire [1:0]   Forward_Rs;
    wire [1:0]   Forward_Rt;
  //  wire [31:0]  Branch_Forward_Data;
    wire [31:0]  Compare_Data1;
    wire [31:0]  Compare_Data2;
    wire         branch_zero;
    wire  [4:0]   ID_EX_Rd;
    mux2_5 Mux2_5_3 (EX_instruction[15:11],EX_instruction[20:16],EX_instruction[31:26],ID_EX_Rd);
  //  forwarding_unit_branch Forwarding_unit_branch (ID_instruction[25:21],ID_instruction[20:16]
  //  ,EX_MEM_Rd,MEM_regWrite,ID_EX_Rd,EX_regWrite,Forward_Rs,Forward_Rt);
    forwarding_unit_branch Forwarding_unit_branch (ID_instruction[25:21],ID_instruction[20:16]
    ,MEM_writeDataReg,MEM_regWrite,EX_register_d,EX_regWrite,Forward_Rs,Forward_Rt);

    mux3_32 Mux3_32_5(readData1,aluResult,MEM_aluResult,Forward_Rs,Compare_Data1);
    mux3_32 Mux3_32_6(readData2,aluResult,MEM_aluResult,Forward_Rt,Compare_Data2);
    compare Compare(Compare_Data1,Compare_Data2,branch_zero);
    add Add(branch,branch_zero,PCSrc);
// hazard detection模块
    wire          PCSrc;  //判断是否为branch
    wire          flush;  //冲刷数据指令                    
    wire          PC_write;//pc修改指令
    wire          IF_ID_write; //ifid更新指令
    wire          stall_info; //阻塞指令 用于control出来的数据选择器
    //hazard_detection Hazard_detection(jump,EX_instruction[20:16],ID_instruction[25:21],ID_instruction[20:16],
    //EX_memRead,MEM_instruction[20:16],MEM_memRead,PCSrc,PC_write,IF_ID_write,stall_info,flush);
    hazard_detection Hazard_detection(jump,EX_instruction[20:16],ID_instruction[25:21],ID_instruction[20:16],
    EX_memRead,MEM_instruction[20:16],MEM_memRead,PCSrc,PC_write,IF_ID_write,stall_info,flush);
//------冒险解决模块-----end


endmodule