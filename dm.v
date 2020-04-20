/**
 * data memory模块
 * @author AshinZ
 * @time   2020-4-18 
 * @param  addr=>address din=>writeData we=>memWrite clk=>clock
 * @return dout=>readData
*/

module dm_4k(addr,we,clk,din,dout);
    input   [11:2]  addr;   
    input           we;     
    input           clk;    
    input   [31:0]  din;    
    output  [31:0]  dout;   
    
    wire  [31:0]   dout;
    reg   [31:0]   dm[1023:0];
    
    initial
       $readmemh("E:\\nuaacs\\ComputerOrganization\\data.txt",dm);  //打开文件
       
  
    always @(negedge clk)  //下降沿
       if (we)             //写信号为真
          dm[addr] <= din; //写入数据
          
 
    assign   dout = dm[addr];  //读出相应地址的数据
    
endmodule