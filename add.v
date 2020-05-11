/**
 * 与门
 * @author AshinZ
 * @time   2020-4-18 
 * @param
 * @return 
*/

module add(Branch,zero,PCSrc);
    input   [1:0]  Branch;
    input          zero;
    
    output wire    PCSrc;
  //  assign PCSrc = 0;
    assign PCSrc = ((Branch == 2'b10 && zero ==0 ) ||(Branch == 2'b11 && zero ==1 ))?1:0;
    
endmodule 