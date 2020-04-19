/**
 * datapath模块
 * @author AshinZ
 * @time   2020-4-18 
 * @param
 * @return 
*/

module datapath(
    input          clk;
    input          rst;
    input  [1:0]   regDst;
    input  [1:0]   jump;
    input  [1:0]   branch;
    input          memRead;
    input  [1:0]   memToReg;
    input  [2:0]   aluOp;
    input          memWrite;
    input          aluSrc;
    input          regWrite;
    input  [1:0]   extType;
    output [31:0]  instruction;
    );

