/**
 * 计算next pc
 * @author AshinZ
 * @time   2020-4-18 
*/

module npc(clk,resetn,if_jump,execode,PC,instruction,instruction_offset,compare_data1,compare_data2,branch,jump,jump_reg,Exc_pc,if_exc,if_epc,NPC,fourPC,flush);
    input          clk;
    input          resetn;
    input          if_jump;//如果该条是jump类（应该跳转类）并且地址有误 阻塞一周期 判断下个周期是否是syscall
    input  [31:0]  PC; //当前pc
    input  [25:0]  instruction;//指令的后26位 在j指令的时候使用
    input  [15:0]  instruction_offset;//beq指令用到的地址中的偏移量
    input   [4:0]  execode;
    input  [31:0]  compare_data1;
    input  [31:0]  compare_data2;
    input  [2:0]   branch; //是否是beq
    input          jump;//是否为j指令
    input          jump_reg;
    input  [31:0]  Exc_pc;
    input          if_exc; //产生了异常
    input          if_epc; //结束异常
    output [31:0]  NPC; //next pc
    output         flush;
    output [31:0]  fourPC;//pc+4 用来针对jr指令
    reg   [31:0]   NPC;
    reg   [31:0]   fourPC;
    wire  [31:0]   beq_target =PC + {{14{instruction_offset[15]}},instruction_offset[15:0],2'b00};
  /*  always @(posedge clk)
        begin
             fourPC <= PC + 32'b100;
        end*/
    reg  [31:0]  jump_pc;
    reg          clk0;//jump异常置1

    always @(*) begin
        //    fourPC <= PC + 32'b100;
            if(if_exc)  //有异常
            begin
                if(clk0==1)
                    begin
                    NPC <= 32'hbfc0_0380;   
                    clk0<=0;
                    end
                else if(clk0==0&&if_jump==1)
                begin
                    clk0<=1;
                    NPC<=PC+32'b100;
                end
                else 
                    NPC <= 32'hbfc0_0380;
            end
            else
            begin
                if(jump)
                NPC <= (jump_reg)?compare_data1:{PC[31:28],instruction,2'b00};

            else 
            begin
            if(branch!=3'b000)  //branch指令成立
                begin
                    case (branch)
                        3'b010: NPC <= (compare_data1 == compare_data2) ? beq_target:PC + 32'b100;
                        3'b011: NPC <= (compare_data1 != compare_data2) ? beq_target:PC + 32'b100;
                        3'b100: NPC <= ($signed(compare_data1) > 0 ) ? beq_target:PC + 32'b100;
                        3'b101: NPC <= ($signed(compare_data1) < 0 ) ? beq_target:PC + 32'b100;
                        3'b110: NPC <= ($signed(compare_data1) >= 0) ? beq_target:PC + 32'b100;
                        3'b111: NPC <= ($signed(compare_data1) <= 0) ? beq_target:PC + 32'b100;
                        default: NPC <= PC + 32'b100;
                    endcase
                end
            else
            begin 
                if(if_epc)
                NPC <= Exc_pc;
               else 
                    NPC <= PC + 32'b100;
         //       end
            end
            end
            end
        end

        assign  flush = (NPC != fourPC) ? 1 : 0 ;//跳转则冲刷指令
      //  assign  if_npc_wrong = (jump_pc[1:0]!=2'b00)?1:0;
endmodule 
