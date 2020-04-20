/**
 * 算数逻辑模块 
 * @author AshinZ
 * @time   2020-4-18 
*/

module alu(aluOp,data1,data2,zero,result);
    input  [2:0]    aluOp;
    input  [31:0]   data1,data2;
    output          zero;
    output [31:0]   result;


    reg   [31:0]  result;
    wire          zero;

    parameter Add = 3'b000 , Sub = 3'b001 , Or = 3'b010 , Slt = 3'b011 , And = 3'b100 , Xor = 3'b101;

    always @(*)
        case(aluOp[2:0])
            3'b000: result = data1 + data2 ;
            3'b001: result = data1 - data2 ;
            3'b010: result = data1 | data2 ;
            3'b100: result = data1 & data2 ;
            3'b101: result = data1 ^ data2 ;
            3'b011: 
                begin
                    if ( data1 < data2 )
                    result <= 8'h0000_0001;
                    else result <= 8'h0000_0000;
                end
        endcase

    assign   zero = (result == 32'b0);  

endmodule 