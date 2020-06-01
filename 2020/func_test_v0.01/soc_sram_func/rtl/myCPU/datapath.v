/**
 * datapath模块
 * @author AshinZ
 * @time   2020-4-18 
 * @param
 * @return 
*/

module mycpu_top(clk,resetn,int,
inst_sram_en,inst_sram_wen,inst_sram_addr,inst_sram_wdata,inst_sram_rdata,
data_sram_en,data_sram_wen,data_sram_addr,data_sram_wdata,data_sram_rdata,
debug_wb_pc,debug_wb_rf_wen,debug_wb_rf_wnum,debug_wb_rf_wdata);


    input          clk;
    input          resetn;
    input  [5:0]   int;

    output             inst_sram_en;  //ram使能信号，高电平有效
    output   [3:0]     inst_sram_wen; //ram字节写使能信号，高电平有�??
    output   [31:0]    inst_sram_addr; //ram读写地址，字节寻�??
    output   [31:0]    inst_sram_wdata;  //ram写数�??

    output             data_sram_en; //ram使能信号，高电平有效
    output   [3:0]     data_sram_wen; //ram字节写使能信号，高电平有�??
    output   [31:0]    data_sram_addr; //ram读写地址，字节寻�??
    output   [31:0]    data_sram_wdata; //ram写数�??

    input  [31:0]    inst_sram_rdata; //ram读数�??
    input  [31:0]    data_sram_rdata; //ram读数�??

    output  [31:0]   debug_wb_pc;  //写回级（多周期最后一级）的PC，因而需要mycpu里将PC�??路带到写回级
    output  [3:0]    debug_wb_rf_wen; //写回级写寄存器堆(regfiles)的写使能，为字节写使能，如果mycpu写regfiles为单字节写使能，则将写使能扩展成4位即可�??
    output  [4:0]    debug_wb_rf_wnum;//写回级写regfiles的目的寄存器�??
    output  [31:0]   debug_wb_rf_wdata; //写回级写regfiles的写数据


//进行四个流水线寄存器的变量声�??
//变量命名规则 对于例如IF_ID模块 在其输出变量上加ID 输入加IF
//�??以往�??其输入是由上个部分声�?? �??以声明输出即�??
//IF_ID寄存�??
    wire  [31:0] ID_fourPC;
    wire  [31:0] ID_instruction;
    wire  [31:0] out_ID_instruction;

//ID_EX寄存�??
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

//EX_MEM寄存�??
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

//MEM_WB寄存�??
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

//decode阶段解码得到信号
    wire  [7:0]   inst_name;
    wire          jump;
    wire  [2:0]   branch;
    wire  [1:0]   regDst;
    wire  [1:0]   extType;
    wire          aluSrc;
    wire          sll_info;
    wire          jump_reg;
//decode阶段目标写入寄存�?
    wire [4:0]    register_d;//目标寄存�??



//hazard detection
    wire          PCSrc;  //判断是否为branch                 
    wire          PC_write;//pc修改指令
    wire          IF_ID_write; //ifid更新指令
    wire          stall_info; //阻塞指令 用于control出来的数据�?�择�??

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


/*  signext模块
    input  [15:0]   instruction;
    input  [1:0]    extType;
    output [31:0]   signExtNumber;
    */
    wire [31:0] signExtNumber;


//npc
    wire  [31:0]  Exc_pc ;  //异常传来pc
    wire          if_exc ;   //是否发生异常
    wire          if_epc ; //结束异常
    wire          flush;  //冲刷数据指令 

// branch的比较数
    wire [31:0]  Compare_Data1;
    wire [31:0]  Compare_Data2;


//根据指令选择出传给流水寄存器的两个数?
    wire [31:0]  alu_data1;
    wire [31:0]  alu_data2;

//exe模块 解码信号
    wire    [3:0]    aluOp;
    wire             mult;
    wire             div;
//alu信号
    wire         overflow;//alu的溢出信�?
    wire [31:0]  mux_data;
    wire [31:0]  data1;
    wire [31:0]  data2;
    wire [31:0]  aluResult;


// 乘除器信�?
    
    wire    [31:0]   HI_data;
    wire    [31:0]   LO_data;



//cp0异常处理相关信号
    wire  [1:0]   Adel;//取地�?错误 2'b00无错�? 2'b10 取指令错�? 
    // 2'b11取数地址错误
    wire          Ades; //写地�?错误
    wire          Sys; //syscall
    wire          Bp; //break
    wire          Ri; //例外指令
    wire          soft_intput;//软件中断
    wire  [31:0]  error_addr;

    wire [31:0]  error_pc;
    wire [31:0]  out_error_addr;

    wire [4:0]   Execode;   //异常种类
    wire  [3:0]       pipe_stall_info; //阻塞信号
    wire         if_in_delay_dolt; //是否在延迟槽

    wire      eret;
    wire      pause;  
    wire      if_npc_wrong;
    
    wire     CP0_write;
    wire     CP0_read;
    wire  [31:0]   CP0_input_data;
    wire  [31:0]   CP0_out_data;
    wire  [4:0]    CP0_rd;
    wire   [31:0]   CP0_8;
    wire   [31:0]   CP0_9;
    wire  [31:0]   CP0_12;
    wire  [31:0]   CP0_13;
    wire  [31:0]   CP0_14;


wire [31:0] MEM_forward_data;//mem级的转发数据 解决第四阶段有mfhi的情�?




//---------fetch模块------ begin
/*  im    
    input   [11:2]   addr;//address bus
    output  [31:0]  dout;//32-bit memory output
*/
    wire [31:0]  instruction;
    wire [31:0]  mux_instruction;

/*  npc
    input  [31:2]  PC; //当前pc
    input  [25:0]  instruction;//指令的后26�?? 在j指令的时候使�??
    input  [31:0]  beqInstruction;//beq指令用到的地�?? 这里是经过了左移两位�??
    input  [1:0]   branch; //是否是beq
    input  [1:0]   jump;//是否为j指令
    input          zero;//alu计算出来的是否符合条�??
    output [31:2]  NPC; //next pc
    output [31:2]  fourPc;//pc+4 用来针对jr指令
*/
    wire [31:0]  PC;
    wire [31:0]  NPC;
    wire [31:0]  fourPc;
/*   pc
    input [31:2]   NPC;
    input          clk;
    input          rst;
    output [31:2]  PC;
    */
    pc Pc(NPC,clk,resetn,PC_write,if_exc,pipe_stall_info,PC);

    assign inst_sram_en = (resetn)?1:0;
    assign inst_sram_wen=  4'b0000;
    assign inst_sram_addr = PC;
//------fetch模块------end













//------IF_ID寄存�??------begin
    reg  [31:0]     test_instruction;
    if_id If_id(clk,resetn,PC+32'b0100,mux_instruction,IF_ID_write,ID_fourPC,out_ID_instruction);
    assign ID_instruction =(stall_info==0)?inst_sram_rdata:test_instruction;
    always @ (*)
        begin
        test_instruction <= ID_instruction;
        end
//------IF_ID寄存�??------end

















//------decode模块------begin

    regfile Regfile(ID_instruction[25:21],ID_instruction[20:16],WB_writeDataReg,writeData,WB_regWrite,clk,resetn,readData1,readData2);

// 符号拓展部分
    signext Signext(ID_instruction[15:0],extType,signExtNumber);

// decode级控制器模块 
    //npc部分
    npc Npc(clk,resetn,if_npc_wrong,Execode,PC,ID_instruction[25:0],ID_instruction[15:0],Compare_Data1,Compare_Data2,branch,
    jump,jump_reg,Exc_pc,if_exc,if_epc,NPC,fourPc,flush);
   


//解码
    decode Decode(ID_instruction[31:0],inst_name,stall_info,pipe_stall_info[3]);
    //inst_name数据传入decode级control
    //control Control(opcode,funct,regDst,jump,branch,memRead,memToReg,aluOp,memWrite,aluSrc,regWrite,extType);
    decode_ctrl Decode_ctrl(inst_name,ID_instruction,CP0_12[1],CP0_14,Compare_Data1,pipe_stall_info[3],jump,branch,
    regDst,extType,aluSrc,sll_info,jump_reg,Sys,Bp,eret,if_npc_wrong,soft_intput);

    //携带该寄存器�??直往下走 这样在遇到冒险的时�?? 对于目标寄存器也比较好�?�择�??
    mux3_5 Mux3_5_1(ID_instruction[15:11],ID_instruction[20:16],5'b11111,regDst,register_d); 


    mux2_32 Mux2_32_2(readData1,{27'b0,ID_instruction[10:6]},sll_info,alu_data1);
    //判断是寄存器�??读出的数�?? 还是五位偏移�??   
/*
//ctrl_result 是控制器前面的�?�择器的输出
    wire [11:0] ctrl_result;
    mux2_11 Mux_2_11_1({regDst,memRead,memToReg,aluOp,
    memWrite,aluSrc,regWrite},11'b0,stall_info,ctrl_result);*/
// ------decode模块------end













//------ID_EX寄存�??------begin
    wire   [31:0]  EX_signExtNumber;
    id_ex Id_ex(clk,resetn,ID_fourPC,alu_data1,readData2,
    ID_instruction,inst_name,register_d,aluSrc,signExtNumber,
    EX_alu_data1,EX_alu_data2,EX_fourPC,
    EX_instruction,EX_inst_name,EX_register_d,
    EX_aluSrc,EX_signExtNumber);
//------ID_EX寄存�??-----end


















//------exe模块------begin
  //  wire    EX_memRead;
  //  wire    EX_memWrite;
    wire    EX_data_ext_type;
    wire    unsign;
    exe_ctrl Exe_ctrl (EX_inst_name,pipe_stall_info[2],aluOp,mult,div,unsign);
    mem_ctrl EXE_Mem_ctrl (EX_inst_name,0,EX_data_ext_type,EX_memRead,EX_memWrite);
/*  alu
    input  [2:0]    aluOp;
    input  [31:0]   data1,data2;
    output          zero;
    output [31:0]   result;
*/
    alu Alu(aluOp,data1,alu_data2,overflow,aluResult);
    mux2_32 Mux2_32_3(data2,EX_signExtNumber,EX_aluSrc,alu_data2);
    multiply Multiply (mult,div,unsign,data1,alu_data2,LO_data,HI_data);

   // wire         EX_memToReg;
   // wire         EX_regWrite;
    wire         EX_HI_read;
    wire         EX_HI_write;
    wire         EX_LO_read;
    wire         EX_LO_write;
    wb_ctrl  EX_Wb_ctrl(EX_inst_name,0,EX_memToReg,EX_regWrite,
    EX_HI_read,EX_HI_write,EX_LO_read,EX_LO_write); //在mem阶段调用wb译码�?
    
//------exe模块------end






















//-----EX_MEM寄存�??------begin
    wire [31:0]  MEM_readData1;
    ex_mem Ex_mem(clk,resetn,EX_fourPC,aluResult,data2,data1,
    EX_register_d,EX_instruction,EX_inst_name,
    HI_data,LO_data,
    MEM_aluResult,MEM_readData2,MEM_readData1,MEM_writeDataReg,MEM_fourPC
    ,MEM_instruction,MEM_inst_name,
    MEM_HI_data,MEM_LO_data);
//-----EX_MEM寄存�??------end













//------mem模块------begin
    //控制信号生成
   // wire         MEM_memRead;
   // wire         MEM_memWrite;
    wire         data_ext_type;
    wire [1:0]   MEM_data_size; //8bit 16bit or 32bit
    mem_ctrl Mem_ctrl (MEM_inst_name,pipe_stall_info[1],data_ext_type,MEM_memRead,MEM_memWrite,MEM_data_size);

   // wire         MEM_memToReg;
   // wire         MEM_regWrite;
    wire         MEM_HI_read;
    wire         MEM_HI_write;
    wire         MEM_LO_read;
    wire         MEM_LO_write;
    wb_ctrl  MEM_Wb_ctrl(MEM_inst_name,0,MEM_memToReg,MEM_regWrite,
    MEM_HI_read,MEM_HI_write,MEM_LO_read,MEM_LO_write); //在mem阶段调用wb译码�?

    wire [31:0] in_mem_HI_data; //在这里进行是寄存器数据还是div/mul的计算结果的分析
    wire [31:0] in_mem_LO_data;

    assign in_mem_HI_data = (MEM_inst_name == 8'b0101_0010)?MEM_readData1:MEM_HI_data;
    assign in_mem_LO_data = (MEM_inst_name == 8'b0101_0011)?MEM_readData1:MEM_LO_data;

    //计算 32 16 8 bit的数�? 这里先把他们进行取位扩充
    wire  [31:0]  MEM_half_data;
    wire  [31:0]  MEM_byte_data;

    assign  MEM_half_data = (MEM_aluResult[1:0]==2'b00)?{16'b0,MEM_readData2[15:0]}:
                            {MEM_readData2[15:0],16'b0};
    assign  MEM_byte_data = (MEM_aluResult[1:0]==2'b00)?{24'b0,MEM_readData2[7:0]}:
                            (MEM_aluResult[1:0]==2'b01)?{16'b0,MEM_readData2[7:0],8'b0}:
                            (MEM_aluResult[1:0]==2'b10)?{8'b0,MEM_readData2[7:0],16'b0}:
                            {MEM_readData2[7:0],24'b0};


    wire [31:0]  dm_write_data;
    wire [3:0]  dm_write_en_type;
    assign    dm_write_data =  (MEM_data_size==2'b10)?MEM_readData2:  //word
                               (MEM_data_size==2'b01)?MEM_half_data:
                               MEM_byte_data;                 //half word     
                               

    assign   dm_write_en_type = (MEM_data_size==2'b10)?4'b1111:
                             (MEM_data_size==2'b01)?
                             ((MEM_aluResult[1:0]==2'b00)?4'b0011:4'b1100): //16位情�?
                             ((MEM_aluResult[1:0]==2'b00)?4'b0001: //8位情�?
                                (MEM_aluResult[1:0]==2'b01)?4'b0010:
                                (MEM_aluResult[1:0]==2'b10)?4'b0100:
                                4'b1000);
    assign   data_sram_en = ((MEM_memRead || MEM_memWrite)&&Adel==2'b00&&Ades==0)?1:0; //ram使能信号，高电平有效
    assign   data_sram_wen = (MEM_memWrite)?dm_write_en_type:4'b0000;
    assign   data_sram_addr = {3'b0,MEM_aluResult[28:0]}; //ram读写地址，字节寻�??
    assign   data_sram_wdata = dm_write_data; //ram写数�??



//------mem模块------end















//------MEM_WB寄存�??------begin
    //加入MEM_WB寄存�??
    wire [31:0]      WB_HI_data;
    wire [31:0]      WB_LO_data;
    wire [31:0]      WB_readData1;
    wire [31:0]      WB_readData2;
    mem_wb Mem_wb(clk,resetn,MEM_fourPC,MEM_aluResult,MEM_readData2,
    MEM_writeDataReg,MEM_instruction,MEM_inst_name,
    in_mem_HI_data,in_mem_LO_data,
    WB_aluResult,WB_readData2,WB_writeDataReg,
    WB_fourPC,WB_instruction,WB_inst_name,
    WB_HI_data,WB_LO_data);
//-----MEM_WB寄存�??------end



















//------wb模块------end
    wire         WB_data_ext_type;
    wire  [1:0]  WB_data_size;
    mem_ctrl WB_Mem_ctrl (WB_inst_name,0,WB_data_ext_type,WB_memRead,WB_memWrite,WB_data_size);

    wire     [31:0]  dm_data_read;




    assign    dm_data_read = (WB_data_ext_type)? //无符号拓�?
                             ((WB_data_size==2'b10)?data_sram_rdata:
                             (WB_data_size==2'b01)?
                             ((WB_aluResult[1:0]==2'b00)?{16'b0,data_sram_rdata[15:0]}:{16'b0,data_sram_rdata[31:16]}): //16位情�?
                             ((WB_aluResult[1:0]==2'b00)?{24'b0,data_sram_rdata[7:0]}: //8位情�?
                                (WB_aluResult[1:0]==2'b01)?{24'b0,data_sram_rdata[15:8]}:
                                (WB_aluResult[1:0]==2'b10)?{24'b0,data_sram_rdata[23:16]}:
                                {24'b0,data_sram_rdata[31:24]}))
                             :
                             ((WB_data_size==2'b10)?data_sram_rdata:
                             (WB_data_size==2'b01)?
                             ((WB_aluResult[1:0]==2'b00)?{{16{data_sram_rdata[15]}},data_sram_rdata[15:0]}:{{16{data_sram_rdata[31]}},data_sram_rdata[31:16]}): //16位情�?
                             ((WB_aluResult[1:0]==2'b00)?{{24{data_sram_rdata[7]}},data_sram_rdata[7:0]}: //8位情�?
                                (WB_aluResult[1:0]==2'b01)?{{24{data_sram_rdata[15]}},data_sram_rdata[15:8]}:
                                (WB_aluResult[1:0]==2'b10)?{{24{data_sram_rdata[23]}},data_sram_rdata[23:16]}:
                                {{24{data_sram_rdata[31]}},data_sram_rdata[31:24]}));


    wire [31:0]  write_data;//判断是取数据指令还是计算指令
    mux2_32 Mux_2_32_1(WB_aluResult,dm_data_read,WB_memRead,write_data);



  

    assign  CP0_read = (WB_inst_name==8'b1000_0010)?1:0;  //mfco写回寄存器
    assign  CP0_write= (WB_inst_name==8'b1000_0011)?1:0;

    assign  CP0_input_data = WB_readData2;
    assign  CP0_rd =(CP0_write||CP0_read)? WB_instruction[20:16]:WB_instruction[15:11];

  //  wire   [1:0]        WB_memToReg;
  //  wire         WB_regWrite;
    wire         WB_HI_read ;
    wire         WB_HI_write;
    wire         WB_LO_read;
    wire         WB_LO_write; 
    wb_ctrl Wb_ctrl(WB_inst_name,pipe_stall_info[0],WB_memToReg,WB_regWrite,
    WB_HI_read,WB_HI_write,WB_LO_read,WB_LO_write);

    wire  [31:0]   out_HI_data;
    wire  [31:0]   out_LO_data;

    HILO_regfile HI_regfile(WB_HI_write,WB_HI_data,out_HI_data);
    HILO_regfile LO_regfile(WB_LO_write,WB_LO_data,out_LO_data);

    wire [31:0]  HILO_data;
    mux2_32 MUX_2_32_2(out_LO_data,out_HI_data,WB_HI_read,HILO_data);

    wire [31:0]  save_pc;
    assign save_pc = WB_fourPC + 4;
    mux4_32 Mux_4_32_1(write_data,HILO_data,save_pc,CP0_out_data,WB_memToReg,writeData);
//------wb模块------end


    //添加debug信息 begin
    assign debug_wb_pc = WB_fourPC-4;
    assign debug_wb_rf_wen = (WB_regWrite)?4'b1111:4'b0000; //ram字节写使能信号，高电平有�??
    assign debug_wb_rf_wnum=WB_writeDataReg;
    assign debug_wb_rf_wdata=writeData;
    //添加debug信息 end











//------解决冒险模块------begin
//加入forward 模块
    wire [1:0]  forward_A;
    wire [1:0]  forward_B;
   // wire [4:0]  EX_MEM_Rd;
    //wire [4:0]  MEM_WB_Rd;
    //mux2_5 Mux2_5_1(MEM_instruction[15:11],MEM_instruction[20:16],MEM_instruction[31:26],EX_MEM_Rd);
    //mux2_5 Mux2_5_2(WB_instruction[15:11],WB_instruction[20:16],WB_instruction[31:26],MEM_WB_Rd);
   // forwarding_unit_alu Forwarding_unit(EX_instruction[25:21],EX_instruction[20:16],EX_MEM_Rd,MEM_WB_Rd,
   // MEM_regWrite,WB_regWrite,forward_A,forward_B);
    forwarding_unit_alu Forwarding_unit(EX_instruction[25:21],EX_instruction[20:16],MEM_writeDataReg,WB_writeDataReg,
    MEM_regWrite,WB_regWrite,forward_A,forward_B);
    //这个转发要注�?? 判断的条�?? 后面两个流水寄存器的目标寄存�?? 并不�??定是20:16  �??以要加一个mux
    mux3_32 Mux_3_32_3(EX_alu_data1,writeData,MEM_forward_data,forward_A,data1);
    mux3_32 Mux_3_32_4(EX_alu_data2,writeData,MEM_forward_data,forward_B,data2);

//加入beq前移的相关模�??
//转发模块
    wire [1:0]   Forward_Rs;
    wire [1:0]   Forward_Rt;
  //  wire [31:0]  Branch_Forward_Data;
  //  wire  [4:0]   ID_EX_Rd;
  //  mux2_5 Mux2_5_3 (EX_instruction[15:11],EX_instruction[20:16],EX_instruction[31:26],ID_EX_Rd);
  //  forwarding_unit_branch Forwarding_unit_branch (ID_instruction[25:21],ID_instruction[20:16]
  //  ,EX_MEM_Rd,MEM_regWrite,ID_EX_Rd,EX_regWrite,Forward_Rs,Forward_Rt);
    forwarding_unit_branch Forwarding_unit_branch (ID_instruction[25:21],ID_instruction[20:16]
    ,MEM_writeDataReg,MEM_regWrite,EX_register_d,EX_regWrite,Forward_Rs,Forward_Rt);


    wire  [31:0]   CP0_forward_data_alu;
    assign   CP0_forward_data_alu=(MEM_instruction[15:11]==5'b01000)?CP0_8:
                          (MEM_instruction[15:11]==5'b01001)?CP0_9:
                          (MEM_instruction[15:11]==5'b01100)?CP0_12:
                          (MEM_instruction[15:11]==5'b01101)?CP0_13:
                          CP0_14;
    assign  MEM_forward_data = (MEM_HI_read)?out_HI_data://第四阶段�? 用第五阶段收�?
                                (MEM_LO_read)?out_LO_data:
                                (MEM_inst_name==8'b1000_0010)?CP0_forward_data_alu:
                                MEM_aluResult;
    //解决第三阶段有mfhi的情�?
    wire [31:0]  EXE_forward_data;
    wire [31:0]   CP0_forward_data;
    assign   CP0_forward_data=(EX_instruction[15:11]==5'b01000)?CP0_8:
                          (EX_instruction[15:11]==5'b01001)?CP0_9:
                          (EX_instruction[15:11]==5'b01100)?CP0_12:
                          (EX_instruction[15:11]==5'b01101)?CP0_13:
                          CP0_14;
    assign  EXE_forward_data = (EX_HI_read&&!MEM_HI_write)?out_HI_data:  //3�?4不写
                                (EX_LO_read&&!MEM_LO_write)?out_LO_data:  //3�?4不写
                                (EX_HI_read&&MEM_HI_write)?in_mem_HI_data: //3�?4写直接用4的数�?
                                (EX_LO_read&&MEM_LO_write)?in_mem_LO_data:
                                (EX_inst_name==8'b1000_0010)?((MEM_inst_name==8'b1000_0011)?MEM_readData2:CP0_forward_data):  //mfc0
                                aluResult;
    mux3_32 Mux3_32_5(readData1,EXE_forward_data,MEM_forward_data,Forward_Rs,Compare_Data1);
    mux3_32 Mux3_32_6(readData2,EXE_forward_data,MEM_forward_data,Forward_Rt,Compare_Data2);



// hazard detection模块
    //hazard_detection Hazard_detection(jump,EX_instruction[20:16],ID_instruction[25:21],ID_instruction[20:16],
    //EX_memRead,MEM_instruction[20:16],MEM_memRead,PCSrc,PC_write,IF_ID_write,stall_info,flush);
    hazard_detection Hazard_detection(resetn,branch,EX_instruction[20:16],ID_instruction[25:21],ID_instruction[20:16],MEM_writeDataReg,inst_name,EX_register_d,
    MEM_inst_name,EX_inst_name,
    EX_memRead,MEM_instruction[20:16],MEM_memRead,pipe_stall_info[3],PC_write,IF_ID_write,stall_info);
//------冒险解决模块-----end


 /*   //实现branch-mfhi的转�?
    wire  [1:0]   if_forward;
    wire  [31:0]  hilo_branch_data;
    wire  [31:0]  ex_data;
    wire  [31:0]  mem_data;
    assign ex_data=(EX_inst_name==8'b0101_0000)?      //mfhi在exe阶段 
                    ((MEM_HI_write)?in_mem_HI_data:        //第四阶段要写入hi
                    out_HI_data):
                    ((MEM_LO_write)?in_mem_LO_data:         //第四阶段要写入lo
                    out_LO_data);
    assign mem_data=(MEM_inst_name==8'b0101_0000)?
                    out_HI_data:out_LO_data;
    forwarding_unit_mfto_branch Forwarding_unit_mfto_branch(ID_instruction[25:21],ID_instruction[20:16],inst_name,EX_inst_name,MEM_inst_name,
    ex_data,mem_data,EX_register_d,MEM_writeDataReg,if_forward,hilo_branch_data);
*/



    assign  Adel=(if_npc_wrong)?2'b10:
                 (((MEM_memRead&&MEM_data_size==2'b10&&MEM_aluResult[1:0]!=2'b00)||(MEM_memRead&&MEM_data_size==2'b01&&MEM_aluResult[0]!=1'b0))?2'b11:
                 2'b00);

    assign  Ades = (MEM_memWrite!=1)?0:
                    ((MEM_data_size==2'b10&&MEM_aluResult[1:0]!=2'b00)||(MEM_data_size==2'b01&&MEM_aluResult[0]==1'b1))?1:
                    0;
    assign  Ri = (inst_name == 8'b11111110 && ID_instruction!=32'b0)?1:0;

    assign  error_addr = (if_npc_wrong)?((CP0_14[1:0]!=2'b00)?CP0_14:Compare_Data1):MEM_aluResult;

    wire  [31:0] IF_pc;
    wire  [31:0] ID_pc;
    wire  [31:0] EX_pc;
    wire  [31:0] MEM_pc;
    assign  IF_pc = (inst_name[7:4]==4'b0011||inst_name[7:4]==4'b0100)?PC-32'b0100:PC;
    assign  ID_pc = (EX_inst_name[7:4]==4'b0011||EX_inst_name[7:4]==4'b0100)?ID_fourPC-32'b1000:ID_fourPC-32'b100;
    assign  EX_pc = (MEM_inst_name[7:4]==4'b0011||MEM_inst_name[7:4]==4'b0100)?EX_fourPC-32'b1000:EX_fourPC-32'b100;
    assign  MEM_pc= (WB_inst_name[7:4]==4'b0011||WB_inst_name[7:4]==4'b0100)?MEM_fourPC-32'b1000:MEM_fourPC-32'b100;

    assign    if_in_delay_dolt = (((EX_inst_name[7:4]==4'b0011||EX_inst_name[7:4]==4'b0100)&&(Adel==2'b10||Sys||Bp||Ri||soft_intput)) //第二阶段异常第三阶段是branch
                        ||((MEM_inst_name[7:4]==4'b0011||MEM_inst_name[7:4]==4'b0100)&&(overflow ))      //第三阶段异常
                        ||((WB_inst_name[7:4]==4'b0011||WB_inst_name[7:4]==4'b0100)&&(Adel==2'b11||Ades)))?1:0;  //第四阶段异常


    exception_det  Exception_det(clk,CP0_12[1],eret,IF_pc,ID_pc,EX_pc,MEM_pc,WB_fourPC-32'b100,Adel,Ades,Sys,Bp,Ri,soft_intput,
overflow,error_addr,error_pc,out_error_addr,Execode,pipe_stall_info,if_exc);

    wire  force_exception;
    assign force_exception = (Sys||Bp)?1:0;
    assign pause = (pipe_stall_info==4'b0000)?0:1;//如果是第二阶段syscall 第三阶段j 都产生异常 则需要写入
    cp0  CP0 (clk,pause,force_exception,if_in_delay_dolt,Execode,error_pc,eret,out_error_addr,int,if_exc,CP0_write,CP0_input_data,WB_instruction[15:11],CP0_8,
    CP0_9,CP0_12,CP0_13,CP0_14,CP0_out_data,Exc_pc,if_epc);


endmodule