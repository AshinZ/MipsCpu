/**
 * 符号拓展模块
 * @author AshinZ
 * @time   2020-4-18 
 * @param
 * @return 
*/

module signext(
    input  [15:0]   instruction;
    input  [1:0]    extType;
    output [31:0]   signExtNumber;
);

    wire   [31:0]  signExtNumber;
    parameter signedext = 2'b00 , unsignedext = 2'b01 , lui_ext = 2'b10;

    mux3_32 Mux3_32(
    {16{instruction[15]},instruction[15:0]},
    {16'b0,instruction[15:0]},
    {instruction[15:0],16'b0},
    extType,
    signExtNumber);

endmodule 
