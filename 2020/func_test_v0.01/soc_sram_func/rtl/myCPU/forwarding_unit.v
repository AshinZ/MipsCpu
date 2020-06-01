/**
 * 转发模块  处理数据冒险
 * @author AshinZ
 * @time   2020-5-4 
 * @param
 * @return 
*/

module forwarding_unit_alu(ID_EX_Rs,ID_EX_Rt,EX_MEM_Rd,MEM_WB_Rd,EX_MEM_regWrite,MEM_WB_regWrite,Forward_A,Forward_B);
      input [4:0] ID_EX_Rs;
      input [4:0] ID_EX_Rt;
      input [4:0] EX_MEM_Rd;
      input [4:0] MEM_WB_Rd;
      input       EX_MEM_regWrite;
      input       MEM_WB_regWrite;

      output reg [1:0] Forward_A;
      output reg [1:0] Forward_B;
        //如果我们先�?�虑ex冒险 mem冒险只会在ex冒险失败的时候成�? 因为相对而言 ex的数据比较新 �?以我们先判断ex冒险
      always @(*) begin
      if (EX_MEM_regWrite && EX_MEM_Rd!=5'b0 && EX_MEM_Rd == ID_EX_Rs)  //forward_A 的设�?
            Forward_A = 2'b10;//EX冒险
      else if (MEM_WB_regWrite && MEM_WB_Rd!=5'b0 && MEM_WB_Rd == ID_EX_Rs)
            Forward_A = 2'b01;//MEM冒险
      else
            Forward_A = 2'b00;


      if (EX_MEM_regWrite && EX_MEM_Rd!=5'b0 && EX_MEM_Rd == ID_EX_Rt)  //forward_B 的设�?
            Forward_B = 2'b10;
      else if (MEM_WB_regWrite && MEM_WB_Rd!=5'b0 && MEM_WB_Rd == ID_EX_Rt)
            Forward_B = 2'b01;
      else
            Forward_B = 2'b00;
      end
endmodule


//处理beq前移造成的数据冒险的转发
module forwarding_unit_branch(IF_ID_Rs,IF_ID_Rt,EX_MEM_Rd,EX_MEM_regWrite,ID_EX_Rd,ID_EX_regWrite,Forward_Rs,Forward_Rt);
      input       [4:0]   IF_ID_Rs ;  
      input       [4:0]   IF_ID_Rt ;
      input       [4:0]   EX_MEM_Rd;
      input               EX_MEM_regWrite;
      input       [4:0]   ID_EX_Rd;
      input               ID_EX_regWrite;

      output wire  [1:0]  Forward_Rs;
      output wire  [1:0]  Forward_Rt;

      assign      Forward_Rs = (ID_EX_regWrite && ID_EX_Rd == IF_ID_Rs)?2'b01:((EX_MEM_regWrite && EX_MEM_Rd == IF_ID_Rs)?2'b10:2'b00);  //Rs寄存器的数据来自于mem阶段 
      assign      Forward_Rt = (ID_EX_regWrite && ID_EX_Rd == IF_ID_Rt)?2'b01:((EX_MEM_regWrite && EX_MEM_Rd == IF_ID_Rt)?2'b10:2'b00);  //Rt寄存器的数据来自于mem阶段

endmodule


module forwarding_unit_mfto_branch(ID_Rs,ID_Rt,ID_inst_name,EX_inst_name,MEM_inst_name,EX_data,MEM_data,EX_rd,MEM_Rd,if_forward,forward_data);
      input  [7:0]  ID_inst_name;
      input  [7:0]  EX_inst_name;
      input  [4:0]  ID_Rt;
      input  [4:0]  ID_Rs;
      input  [7:0]  MEM_inst_name;
      input  [31:0] EX_data;
      input  [31:0] MEM_data;
      input  [4:0]  EX_rd;
      input  [4:0]  MEM_Rd;
      output reg [1:0]  if_forward;
      output reg [31:0] forward_data;

      always @ (*)
            begin
                  if(ID_inst_name[7:4] == 4'b0011)//是转发类指令
                        begin
                        if(EX_inst_name == 8'b0101_0000||EX_inst_name ==8'b0101_0001) //ex是mfhi 和mflo
                              begin
                                    if(EX_rd == ID_Rt || EX_rd == ID_Rs) //出现转发
                                          begin
                                                if_forward = 2'b01; //01表示ex转发mfhi mflo
                                                forward_data = EX_data;
                                          end
                                    else
                                          if_forward = 2'b00;
                              end
                       else if(MEM_inst_name == 8'b0101_0000||MEM_inst_name ==8'b0101_0001) //mem是mfhi和mflo
                              begin
                                    if(MEM_Rd == ID_Rt || MEM_Rd == ID_Rs)//出现转发
                                          begin
                                                if_forward = 2'b10;//10表示mem转发mfhimflo
                                                forward_data = MEM_data;
                                          end
                                    else
                                          if_forward = 2'b00;
                              end
                        end
                  else 
                        if_forward = 2'b00;
            end

endmodule