/**
 * multiply模块
 * @author AshinZ
 * @time    2020-5-27
*/

module multiply (mult,div,unsign,data1,data2,out_data1,out_data2);
    input             mult;
    input             div ;
    input             unsign;
    input  [31:0]     data1;
    input  [31:0]     data2;
    
    output reg [31:0]     out_data1; //积的前32位或者商
    output reg [31:0]     out_data2; //积的后32位或者余数


    reg  [63:0]  temp;
  /*  assign    temp = (unsign)?(data1 * data2):($signed(data1)*$signed(data2));
    assign    out_data2 = (unsign)?
                          ((mult) ? temp[63:32]:   //hi寄存器
                          (div)  ?  data1 % data2 :
                          32'b0):
                          ((mult) ? temp[63:32]:   //hi寄存器
                          (div)  ?  $signed(data1)%$signed(data2) :
                          32'b0);
    assign    out_data1 = (unsign)?
                          ((mult) ? temp[31:0]:   //lo寄存器
                          (div)  ?  data1 / data2 :
                          32'b0):
                          ((mult) ? temp[31:0]:   //lo寄存器
                          (div)  ?  $signed(data1)/$signed(data2) :
                          32'b0);*/
    always @(*)
        begin
            if(unsign==1) //无符号运算
                begin
                if(mult)
                    begin
                    assign temp = data1 * data2;
                    assign out_data1 = temp [31:0];
                    assign out_data2 = temp [63:32];
                    end
                else if(div)
                    begin
                    assign out_data2 = data1 % data2 ;
                    assign out_data1 = data1 / data2 ;
                    end
                end
            else   
                begin
                if(mult)
                    begin
                    assign temp = $signed(data1) * $signed(data2);
                    assign out_data1 = temp [31:0];
                    assign out_data2 = temp [63:32];
                    end
                else if(div)
                    begin
                    assign out_data2 = $signed(data1) % $signed(data2) ;
                    assign out_data1 = $signed(data1) / $signed(data2) ;
                    end
                end
        end

endmodule