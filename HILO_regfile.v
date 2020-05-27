/**
 * hilo模块 例化两次 分别用于hi和lo
 * @author AshinZ
 * @time   2020-5-27
*/

module HILO_regfile(HILO_write,HILO_input,HILO_output);
    input          HILO_write;
    input  [31:0]  HILO_input;
    output [31:0]  HILO_output;

    reg   [31:0]     HILO_info = 32'b0;//存数据
    always @(*)
        begin
            HILO_info = (HILO_write) ? HILO_input : HILO_output;
        end

    assign       HILO_output = HILO_info ;
endmodule // 