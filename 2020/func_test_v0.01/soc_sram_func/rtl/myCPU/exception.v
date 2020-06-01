/**
 * exception�?测模�? 处理和cp0交互
 * 主要用于�?测整个流水线的异�?
 * @author AshinZ
 * @time   2020-5-28
*/


module  exception_det(clk,pause,if_eret_error,IF_pc,ID_pc,EX_pc,MEM_pc,WB_pc,Adel,Ades,Sys,Bp,Ri,soft_input,
Ov,error_addr,error_pc,out_error_addr,Execode,out_stall_info,if_exc);
    input  clk;
    input          pause;
    input          if_eret_error;
    input  [31:0]  IF_pc;
    input  [31:0]  ID_pc;
    input  [31:0]  EX_pc;
    input  [31:0]  MEM_pc;
    input  [31:0]  WB_pc;
    input  [1:0]   Adel;//取地�?错误 2'b00无错�? 2'b10 取指令错�? 
    // 2'b11取数地址错误
    input          Ades; //写地�?错误
    input          Sys; //syscall
    input          Bp; //break
    input          Ri; //例外指令
    input           soft_input;//软件中断
    input          Ov; //overflow
    input  [31:0]  error_addr;

    output reg [31:0]  error_pc;
    output reg [31:0]  out_error_addr;

    output reg [4:0]   Execode;
    reg        [3:0]   stall_info;
    output reg [3:0]   out_stall_info;

    output reg         if_exc;
   reg   [2:0] test;
    initial 
    begin
        stall_info = 4'b0000;
        if_exc = 0;
        test=3'b000;
    end

    always @( *)
        begin
            if(Adel==2'b00&&Ades==0&&Ri==0&&Ov==0&&soft_input==0&&Sys==0&&Bp==0&&pause!=0)
                begin
                stall_info<=4'b0000;
                if_exc<=0;
                end
            else
            begin
                if(Adel==2'b11)//取数地址错误
                        begin 
                        Execode <= 5'b00100;
                        error_pc <= MEM_pc;
                        stall_info <= 4'b1111;
                        out_error_addr<=error_addr;
                        if_exc<=1;
                        test <= 3'b111;
                        end
            else
            begin 
                if(Ades) //写数地址错误
                        begin   
                            Execode <= 5'b00101;
                            error_pc <= MEM_pc;
                            stall_info <= 4'b1111;
                            out_error_addr<=error_addr;
                            if_exc<=1;
                        end
            else 
                begin
                    if(Ov) //overflow
                            begin 
                                Execode <= 5'b01100;
                                error_pc <= EX_pc;
                                stall_info <= 4'b1110;
                                if_exc<=1;
                                end
                    else 
                        begin
                        if(Adel==2'b10) //pc错误
                                begin
                                out_error_addr <= error_addr;
                                if_exc<=1;
                                Execode <= 5'b00100;
                                error_pc <= error_addr;//因为对于该类处理的结果是通过在地址上+凑成4来找到下一个值 所以这里设置成地址
                                if(if_eret_error==1)
                                    stall_info<=4'b1100;
                                else
                                    stall_info<=4'b0000;
                               
                                end
                            else 
                                begin
                                    if(Ri) //例外指令
                                    begin 
                                        Execode <= 5'b01010;
                                        error_pc<= ID_pc;
                                        stall_info <= 4'b1100;
                                        if_exc<=1;
                                    end
                                else 
                                    begin
                                    if(Bp) //break指令
                                        begin
                                            Execode <= 5'b01001;
                                            error_pc<= ID_pc;
                                            stall_info <= 4'b1100;
                                            if_exc<=1;
                                        end
                                    else 
                                        begin
                                          if(soft_input==1)
                                            begin
                                            Execode <= 5'b00000;
                                            error_pc <= ID_pc+32'b100;
                                            stall_info<=4'b1100;
                                            if_exc<=1;
                                            end



                                        else
                                            begin 
                                                 if(Sys)  //syscall
                                                    begin 
                                                        Execode <= 5'b01000;
                                                        error_pc <= ID_pc;
                                                        stall_info <= 4'b1100;
                                                        if_exc<=1;
                                                    end

                                                else
                                                    begin
                                                    if_exc <= 0;
                                                    stall_info<= 4'b0000;
                                                    end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

            end
        end

    reg     clock;

    always @(posedge clk) //每过�?个周期就少阻塞一个周�? 阻塞也跟�?流水�?
        begin
            if(stall_info!=4'b0000)
                begin   
                    out_stall_info = stall_info;
                end
            else
            out_stall_info = {0,out_stall_info[3:1]};
        end
    always @(posedge clk)
        begin  
            if(if_exc==1)
                if_exc=0;
        end

endmodule