/**
 * mux模块 
 * @author AshinZ
 * @time   2020-4-18 
*/

module mux2_32(a,b,sel,y);//2 input 32-bit mux
    input   [31:0]   a ;
    input   [31:0]   b ;
    input            sel ;
    output  [31:0]   y;
    
    reg   [31:0]   y;
    
    always @(*)
       if (sel == 0)
          y <= a ;
       else y <= b ;
endmodule

module mux2_11(a,b,sel,y);//2 input 17-bit mux
    input   [10:0]   a ;
    input   [10:0]   b ;
    input            sel ;
    output  [10:0]   y;
    
    reg   [10:0]   y;
    
    always @(*)
       if (sel == 0)
          y <= a ;
       else y <= b ;
endmodule

module mux2_30(a,b,sel,y);//2 input 30-bit mux
    input   [31:2]   a ;
    input   [31:2]   b ;
    input            sel ;
    output  [31:2]   y;
    
    reg   [31:2]   y;
    
    always @(*)
       if (sel == 0)
          y <= a ;
       else y <= b ;
endmodule

module mux2_5(a,b,sel,y);//2 input 30-bit mux
    input   [4:0]   a ;
    input   [4:0]   b ;
    input   [5:0]   sel ;
    output  [4:0]   y;
    
    reg   [4:0]   y;
    
    always @(*)
       if (sel == 6'b0)
          y <= a ;
       else y <= b ;
endmodule

module mux3_5(a,b,c,sel,y);   //3 input 5-bit mux
    input   [4:0]   a ;
    input   [4:0]   b ;
    input   [4:0]   c ;
    input   [1:0]   sel ;
    output  [4:0]   y;
    
    reg   [4:0]   y;
    
    always @(*)
       if (sel == 2'b00)
          y <= a ;
       else if (sel == 2'b01)
                y <= b ;
            else y <= c;
endmodule

module mux3_32(a,b,c,sel,y);   //3 input 32-bit mux
    input   [31:0]   a ;
    input   [31:0]   b ;
    input   [31:0]   c ;
    input   [1:0]    sel ;
    output  [31:0]   y;
    
    reg   [31:0]   y;
    
    always @(*)
    begin
       if (sel == 2'b00)
          y <= a ;
       else 
          begin
             if (sel == 2'b01)
                y <= b ;
             else y <= c;
          end
    end
endmodule

module mux4_32(a,b,c,d,sel,y);   //3 input 32-bit mux
    input   [31:0]   a ;
    input   [31:0]   b ;
    input   [31:0]   c ;
    input   [31:0]   d ;
    input   [1:0]    sel ;
    output  [31:0]   y;
    
    reg   [31:0]   y;
    
    always @(*)
    begin
       if (sel == 2'b00)
          y <= a ;
       else 
          begin
             if (sel == 2'b01)
                y <= b ;
             else
               begin 
                  if(sel == 2'b10)
                     y <= c;
                  else 
                     y <= d;
               end
          end
    end
endmodule

