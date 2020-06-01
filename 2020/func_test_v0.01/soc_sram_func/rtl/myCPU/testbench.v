/**
 * 测试模块
 * @author AshinZ
 * @time   2020-4-18 
*/
`timescale 1ns / 1ps
module testbench();
    reg    clk ;
    reg    rst ;
    
    //instantiate module of mips
    mips MIPS(clk,rst);

    //initialize test
    initial 
       begin
           clk <= 1 ;
           rst <= 1 ;
           #100 rst <= 0 ;
           
           #60000 $stop ;
       end
        
   
    //generate clock
    always
       #10 clk=~clk ;
    
endmodule