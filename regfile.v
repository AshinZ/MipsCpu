/**
 * 寄存器模块
 * @author AshinZ
 * @time   2020-4-18 
*/

module (
    input  [4:0]   readRegister1,readRegister2,writeRegister;
    input  [32:0]  writeData;
    input          regWrite;
    input          clk;
    input          rst;
    output [31:0]  readData1,readData2;
);

    wire  regWrite;  //是否写入
    reg   [31:0]  registers[31:0]; //32个寄存器
    integer i；

    //如果rs rt不为空 我们就设置readData 为0的时候一般是j指令
    assign readData1 = (readRegister1 != 0) ? registers[readRegister1] : 0 ;
    assign readData2 = (readRegister1 != 0) ? registers[readRegister2] : 0 ;

    //考虑rst
    always @(negedge clk or posedge rst) begin
        if(rst) //如果rst真 那么要还原所有的寄存器
            for ( i = 0;i < 32;i=i+1) begin
                registers[i] = 32'b0;//还原为0
            end
        else if(regWrite) //需要向寄存器中写入数据
            registers[writeRegister] <= writeData;
    end
endmodule 