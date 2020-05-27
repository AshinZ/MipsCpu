/**
 * multiply模块
 * @author AshinZ
 * @time    2020-5-27
*/

module multiply (mult,div,data1,data2,out_data1,out_data2);
    input             mult;
    input             div ;
    input  [31:0]     data1;
    input  [31:0]     data2;
    
    output [31:0]     out_data1; //积的前32位或者商
    output [31:0]     out_data2; //积的后32位或者余数

    wire  [63:0]  temp   result;
    assign    temp = data1 * data2;
    assign    out_data1 = (mult) ? temp[63:32]:   //lo寄存器
                          (div)  ?  data1 % data2 :
                          32'b0;
    assign    out_data2 = (mult) ? temp[31:0]:    //hi寄存器
                          (div)  ?  data1 / data2 :
                          32'b0;

endmodule