/**
 * 左移两位模块
 * @author AshinZ
 * @time   2020-4-18 
 * @param  instruction
 * @return <<instruction 
*/

module (
    input  [31:0]  data;//输入数据
    output [31:0]  slData;//输出左移两位后的数据
);

    wire  [31:0] slData;
    assign  slData = {data[29:0],2'b00};
endmodule 