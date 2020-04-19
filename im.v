/**
 * instruction memory module 
 * @author AshinZ
 * @time   2020-4-18 
 * @param  addr=>instruction address
 * @return dout=>instruction
*/
module im_4k(addr,dout);
    input   [11:2]   addr;//address bus
    output  [31:0]  dout;//32-bit memory output
    
    reg   [31:0]   im[1023:0];
    
    initial
       $readmemh("code.txt",im);
     
    assign   dout = im[addr];
    
endmodule