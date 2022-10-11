`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2022 12:41:25 PM
// Design Name: 
// Module Name: seqd
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


module seqd(clk, rst, w, z);
    input clk, rst, w;
    output reg z = 0;
    reg[1:0] state, nextstate;
    parameter [1:0] A=2'b00, B = 2'b01, C= 2'b10;
    always @ (w or state) begin
        case (state)
            A: if(w) nextstate = B;
            else nextstate = A;
            B: if(w) nextstate = B;
            else nextstate = C;
            C: begin
            z = 1;
            if(w) nextstate = B;
            else nextstate = A;
            end
            default: nextstate = A;
        endcase
    end
    always @ (clk) begin
        z = (state == C);
    end
    always @ (posedge clk, posedge rst) begin
        if (rst)
            state <= A;
        else
            state <= nextstate;
    end
endmodule