/**
 * 冒险�?测模�? 处理lw指令 添加阻塞
 * @author AshinZ
 * @time   2020-5-4
 * @param
 * @return 
*/

module hazard_detection(jump,ID_EX_Rt,IF_ID_Rs,IF_ID_Rt,ID_EX_memRead,EX_MEM_Rt,EX_MEM_memRead,PCSrc,PC_write,IF_ID_write,stall_info,flush);
        input [4:0]  EX_MEM_Rt;
        input [4:0]  ID_EX_Rt;
        input [4:0]  IF_ID_Rs;
        input [4:0]  IF_ID_Rt;
        input [1:0]  jump;
        input        EX_MEM_memRead;
        input        ID_EX_memRead;
        input        PCSrc;//0代表不进行跳转 1代表跳转 无论是jump还是beq

        output wire   flush;
        output wire   PC_write;
        output wire   IF_ID_write;
        output wire   stall_info;

        wire [2:0] all_info ;
        assign {PC_write,IF_ID_write,stall_info} = all_info ;
        assign all_info = 
        (
          ((ID_EX_memRead==1 && ((ID_EX_Rt == IF_ID_Rs) || (ID_EX_Rt == IF_ID_Rt))))
       ||(EX_MEM_memRead==1 && ((EX_MEM_Rt == IF_ID_Rs)||(EX_MEM_Rt == IF_ID_Rt))))
        ?3'b001:3'b110;

        assign flush = (PCSrc||jump!=2'b00)?1:0;

   /*     always @(*) begin
        flush <= 0;
        PC_write <= 1;
        IF_ID_write <= 1;
        stall_info <= 0;
        if(PCSrc == 1)
             flush <= 1;
        if (ID_EX_memRead==1&&((ID_EX_Rt == IF_ID_Rs) || (ID_EX_Rt == IF_ID_Rt) )) begin
             PC_write <= 0;
             IF_ID_write <= 0;
             stall_info <= 1;
        end
        end*/

endmodule // 