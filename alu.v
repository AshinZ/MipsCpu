/**
 * 算数逻辑模块 
 * @author AshinZ
 * @time   2020-4-18 
*/

module (
    input  [2:0]    aluOp;
    input  [31:0]   data1,data2;
    output          zero;
    output [31:0]   result;
);

    reg   [31:0]  result;
    wire          zero;

    parameter Add = 3'b000 , Sub = 3'b001 , Or = 3'b010 , Slt = 3'b011;

    always @(*)
        case(aluop[1:0])
            2'b000: result = data1 + data2 ;
            2'b001: result = data1 - data2 ;
            2'b010: result = data1 | data2 ;
            2'b011: 
                begin
                    if ( data1 < data2 )
                    result <= 1;
                    else result <= 0;
                end
        endcase

    assign   zero = (result == 32'b0);  

endmodule 