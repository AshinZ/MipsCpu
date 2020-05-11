/**
 * 寄存器模块
 * @author AshinZ
 * @time   2020-4-18 
*/

module regfile(readRegister1,readRegister2,writeRegister,writeData,regWrite,clk,rst,readData1,readData2);
    input  [4:0]   readRegister1,readRegister2,writeRegister;
    input  [31:0]  writeData;
    input          regWrite;
    input          clk;
    input          rst;
    output   [31:0]  readData1,readData2;

    
    wire  regWrite;  //是否写入
    reg   [31:0]  registers[31:0]; //32个寄存器
    integer i ;


    //考虑rst
    always @(posedge clk or posedge rst) begin
        if(rst) //如果rst真 那么要还原所有的寄存器
            for ( i = 0;i < 32;i=i+1) begin
                registers[i] <= 32'b0;//还原为0
            end
    end
    always @(negedge clk) begin
        if(regWrite) //需要向寄存器中写入数据
            registers[writeRegister] <= writeData;
    end



 //   always @(negedge clk) begin
    assign readData1 = (readRegister1 != 5'b00000) ? registers[readRegister1] : 32'b0 ;
    assign readData2 = (readRegister2 != 5'b00000) ? registers[readRegister2] : 32'b0 ;
  //  end
     //如果rs rt不为空 我们就设置readData 为0的时候一般是j指令
endmodule 