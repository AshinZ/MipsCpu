/**
 * CP0模块
 * @author AshinZ
 * @time    2020-5-27
*/

module cp0(clk,pause,sys,if_in_delay_dolt,Exe_code,pc0,eret,addr_e,int,if_Exc,if_write,input_data,register_id,BadVAddr,Count,Status,Cause,EPC,out_data,EXP_PC,if_epc);

    input          clk;
    input          pause; //判断是否在异常发生的时间段里
    input          sys;//判断是否为sys这类强开的异常
    input          if_in_delay_dolt; //判断是否在延迟槽内
    input  [4:0]   Exe_code; //异常�?
    input  [31:0]  pc0;  //异常pc
    input          eret;  //是否有eret
    input  [31:0]  addr_e; //地址错例外的地址
    input  [5:0]   int;  //系统终端
    input          if_Exc;//是否异常
    input          if_write;
    input  [31:0]  input_data;
    input  [4:0]   register_id;
    output  [31:0]        BadVAddr; //输出值
    output  [31:0]   Count;
    output  [31:0]  Status;
    output  [31:0]  Cause;
    output  [31:0]   EPC;
    output  [31:0]   out_data;

    output [31:0]  EXP_PC;//跳转正常的pc

    reg    [31:0]  BadVAddr; //出错地址  8 
    reg    [31:0]  Count ;  //处理器内部计数器  9
    reg    [31:0]  Status;  //处理器状态与控制寄存�?  12
    reg    [31:0]  Cause;  //上一次例外原�? 13 
    reg    [31:0]  EPC;   //上一次例外指令的pc  14

    reg             clk0;    
    reg    [31:0]   pc;
    output          if_epc; //是否结束异常
    initial
    begin
        clk0=0;
        BadVAddr=32'b0;
        Count=32'b0;   
        Status=32'b0000_0000_0100_0000_0000_0000_0000_0000;  
        Cause=32'b0;   
        EPC=32'b0; 
        pc=0;    
    end

    assign  EXP_PC = EPC;

/*(1) 当CP0.Status.EXL�?0时，更新CP0.EPC：将例外处理返回后重新开始执行的指令PC填入到CP0.EPC寄存器寄存器中�?�如果发生例外的指令不在分支延迟槽中，则重新�?始执行的指令PC就等于发生例外的指令的PC；否则重新开始执行的指令PC等于发生例外的指令的PC-4（即该延迟槽对应的分支指令的PC），
(2) 当EXL�?0时，更新CP0.Cause寄存器的BD位：如果发生例外的指令在分支延迟槽中，则将CP0.Cause.BD置为1�?
(3) 更新CP0.Status.EXL位：将其置为1�?
(4) 进入约定的例外入口重新取指，软件�?始执行例外处理程序�??
当软件完成例外处理程序的执行后，通常会使用ERET指令从例外处理程序返回，ERET指令的作用是�?
(1) 将CP0.Status.EXL清零�?
从CP0.EPC寄存器取出重新执行的PC值，然后从该PC值处继续取指执行�?*/
    always @(posedge clk0)
        begin
        Count = Count +32'b1; 
        end
    
    
    always @(posedge clk)
        begin 
            if(if_Exc)  //产生了异�?
      //          if(Status[1]==0) 
                    begin
                    EPC = pc0;
                    Status[1]=1;
                    Cause[6:2] = Exe_code;
                    if(Exe_code==5'b00100||Exe_code==5'b00101)//地址错例�?
                        BadVAddr = addr_e;
                    end
         /*   else
            begin
                if(sys==1)
                begin
                EPC = pc0;
                Cause[6:2] = Exe_code;
                end*/
                else
                Status[31]=0;
         //   end

            if(eret==1&&if_Exc==0)
                begin
                    Cause[31] = 0;
                    Status[1]=0;
                end
            else  
                Status[31]=0;


            
            if(if_in_delay_dolt)
                Cause[31] = 1;
            else 
                Status[31]=0;
        end

        always @(*)
            begin
            if(if_write==1)  //写指令
                begin
                    case (register_id)
                     //   5'b01000:
                        5'b01001:Count <= input_data;
                        5'b01100:begin 
                                    Status[15:8] <= input_data[15:8];
                                    Status[0] <= input_data[0];
                                end
                        5'b01101: Cause[9:8] <= input_data[9:8];
                        5'b01110: begin
                                    if(pause==0) 
                                    EPC<=input_data;
                                    else 
                                    EPC<=EPC;
                                end
                        default:EPC<=EPC;
                    endcase
                end
            else if(if_write==0||pause==1)
                EPC<=EPC;
            end

    assign if_epc = (eret)?1:0;
    assign  out_data=(register_id==5'b01000)?BadVAddr:
                          (register_id==5'b01001)?Count:
                          (register_id==5'b01100)?Status:
                          (register_id==5'b01101)?Cause:
                          (register_id==5'b01110)?EPC:32'b0;
















        endmodule

