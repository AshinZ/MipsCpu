/**
 * 控制冒险 进行beq两个数据的比较
 * @author AshinZ
 * @time   2020-5-10
 * @param
 * @return 
*/

module compare(compare_data1,compare_data2,zero);
    input [31:0] compare_data1;
    input [31:0] compare_data2;
    output       zero;

    wire       zero;

    assign zero = compare_data1 ^ compare_data2;
    //进行异或操作  如果zero是0则相等 否则不相等

endmodule // 