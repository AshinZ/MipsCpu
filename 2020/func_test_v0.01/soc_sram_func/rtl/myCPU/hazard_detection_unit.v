/**
 * 冒险�?测模�? 处理lw指令 添加阻塞
 * @author AshinZ
 * @time   2020-5-4
 * @param
 * @return 
*/

module hazard_detection(rst,branch,ID_EX_Rt,IF_ID_Rs,IF_ID_Rt,MEM_rd,inst_name,EX_rd,
MEM_inst_name,EX_inst_name,ID_EX_memRead,EX_MEM_Rt,EX_MEM_memRead,pipe_stall_info,PC_write,IF_ID_write,stall_info);
        input        rst;
        input [2:0]  branch;
        input [4:0]  EX_MEM_Rt;
        input [4:0]  ID_EX_Rt;
        input [4:0]  IF_ID_Rs;
        input [4:0]  IF_ID_Rt;
        input [4:0]  MEM_rd;
        input [7:0]  inst_name;
        input [4:0]  EX_rd;
        input        EX_MEM_memRead;
        input        ID_EX_memRead;
        input  [7:0]  MEM_inst_name;
        input  [7:0]  EX_inst_name;
        input         pipe_stall_info;     
        output wire   PC_write ;
        output wire   IF_ID_write ;
        output wire   stall_info ;
        reg   [2:0]  all_info;
        assign {PC_write,IF_ID_write,stall_info} = all_info;
        initial 
          begin
          all_info = 3'b110;
          end
   /*     assign all_info = 
        (
          ((ID_EX_memRead==1 && ((ID_EX_Rt == IF_ID_Rs) || (ID_EX_Rt == IF_ID_Rt))))
       ||(EX_MEM_memRead==1 && ((EX_MEM_Rt == IF_ID_Rs)||(EX_MEM_Rt == IF_ID_Rt))))
        ?3'b001:3'b110;*/


        always @(*) begin
        if(pipe_stall_info==1)
          all_info = 3'b110;
        else
        begin
        if ((ID_EX_memRead==1 && ((ID_EX_Rt == IF_ID_Rs) || (ID_EX_Rt == IF_ID_Rt))) 
        ||(EX_MEM_memRead==1 && ((EX_MEM_Rt == IF_ID_Rs)||(EX_MEM_Rt == IF_ID_Rt)))
   //     ||(inst_name[7:4] == 4'b0011 &&(MEM_inst_name[7:1] == 7'b0101_000))
   //    ||(inst_name[7:4] == 4'b0011 &&EX_inst_name[7:1] == 7'b0101_000)
     ) begin
           //  PC_write = 0;
          //   IF_ID_write = 0;
          //   stall_info = 1;
          all_info = 3'b001;
        end
 /*       else if((rst)&&(branch!= 3'b000)&&(IF_ID_Rs==MEM_rd&&MEM_rd!=5'b0)&&(MEM_inst_name!=8'b1111_1111))
        begin
       //      PC_write = 0;
       //      IF_ID_write = 0;
        //     stall_info = 1;
              all_info = 3'b001;
        end*/

        else
          begin
       //   PC_write = 1;
      //    IF_ID_write = 1;
      //    stall_info = 0;
              all_info = 3'b110;
          end
        end
        end


endmodule 