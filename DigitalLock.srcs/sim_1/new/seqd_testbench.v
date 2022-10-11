`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2022 12:49:54 PM
// Design Name: 
// Module Name: seqd_testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module seqd_testbench();
   reg clk, rst, w;
   wire z;
   seqd ud(clk, rst, w, z);
   initial begin
       clk = 0;
       forever #5 clk = ~clk;
   end
   initial begin
        w = 1;
        rst = 1;
        #90
        rst = 0;
        #80
        w = 1;
        #50
        w = 0;
        #50
        w = 1;
        #50
        w = 1;
        #50
        w = 0;
        #50
        w = 1;
        #50
        w = 0;
        #50
        w = 1;
   end
endmodule
