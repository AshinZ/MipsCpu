/**
 * 算数逻辑模块 
 * @author AshinZ
 * @time   2020-4-18 
*/

module alu(aluOp,data1,data2,overflow,result);
    input  [3:0]    aluOp;
    input  [31:0]   data1,data2;
    output         overflow;
    output [31:0]   result;


    reg   [31:0]  result;
    reg   [32:0]  test_result;
    wire          zero;
    // 4'b0000  +   4'b0001 -  4'b0010 and 4'b0011 or    4'b0100 nor
    // 4'b0101  xor  4'b0110 sll左移  4'b0111 sra   4'b1000  srl
    // 4'b1001  u+    4'b1010 u-  4'b1011 slt   s'b1100 无符号比较
    // 4'b1101 lui
    parameter ADD = 4'b0000 , SUB = 4'b0001 , AND = 4'b0010 , OR = 4'b0011;
    parameter NOR = 4'b0100 , XOR = 4'b0101 , SLL = 4'b0110 , SRA = 4'b0111;//SRA算数右移 补符号位
    parameter SRL = 4'b1000 , ADDU= 4'b1001 , SUBU= 4'b1010 , SLT = 4'b1011;
    parameter SLTU= 4'b1100 , LUI = 4'b1101 ;

    wire [63:0] temp;
    always @(*)
        case(aluOp[3:0])
            ADD : begin 
                    result = data1 + data2 ;test_result = {data1[31],data1} + {data2[31],data2} ; 
               /*     if(test_result[31]^test_result[32]) 
                    overflow=1; 
                    else
                    overflow=0;*/
                    end 
            SUB : begin 
                   result = data1 - data2 ;test_result = {data1[31],data1} - {data2[31],data2} ;   
              /*      if(test_result[31]^test_result[32])
                        overflow=1;
                    else
                        overflow=0;*/
                end 
            AND : result = data1 & data2 ;
            OR  : result = data1 | data2 ;
            NOR : result = ~(data1 | data2);
            XOR : result = data1 ^ data2 ;
            SLL : result = data2 << data1[4:0]; 
            SRA : result = (data2[31] == 1'b0) ? (data2 >> data1[4:0]):~((~data2)>>data1[4:0]) ;
            SRL : result = data2 >> data1[4:0];
            ADDU: result = data1 + data2 ;
            SUBU: result = data1 - data2 ;
            SLTU: result = (data1 < data2) ? 32'b01 : 32'b0 ;
            SLT : result = ($signed(data1)<$signed(data2))?32'b01:32'b0;
            LUI : result = {data2[15:0],16'b0};
        endcase

        assign overflow = ((aluOp== ADD &&(test_result[31]^test_result[32]))||(aluOp == SUB && (test_result[31]^test_result[32])))?1:0;

endmodule 