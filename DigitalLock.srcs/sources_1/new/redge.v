`timescale 1ns / 1ps

module redge(clk, rst, w, z);
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
        z = (state == B);
    end
    always @ (posedge clk, posedge rst) begin
        if (rst)
            state <= A;
        else
            state <= nextstate;
    end
endmodule



module debouncer(in, clk, out);
input in, clk;
output out; 
reg Q1, Q2, Q3;
always @ (posedge clk) begin
Q1 <= in;
Q2 <= Q1;
Q3 <= Q2;
end
assign out = Q1 & Q2 & Q3;
endmodule



module metastat(input sig, clk, output sig1);
reg Q1, Q2, Q3;
always @ (posedge clk) begin
Q1 <= sig;
Q2 <= Q1;
Q3 <= Q2;
end
assign sig1 = Q3;
endmodule

module bcd( input in, output reg [6:0] seg);
    always@ (in) begin
        case (in)
        0 : seg = 7'b1110001;
        1 : seg = 7'b1000001;
        default : seg = 7'b1111111;        
        endcase
    end
endmodule

module lock(input A, B, C, D, rst, clk, output [6:0] BCD);
wire ad, bd, cd, dd, ae, be, ce, de, am, bm, cm, dm;

metastat m1 (A, clk, am);
metastat m2 (B, clk, bm);
metastat m3 (C, clk, cm);
metastat m4 (D, clk, dm);

debouncer d1 (am, clk, ad); 
debouncer d2 (bm, clk, bd); 
debouncer d3 (cm, clk, cd); 
debouncer d4 (dm, clk, dd); 

redge r1(clk, rst, ad, ae);
redge r2(clk, rst, bd, be);
redge r3(clk, rst, cd, ce);
redge r4(clk, rst, dd, de);

reg [2:0] state, nextstate;
parameter [2:0] S0 = 3'b000, S1=3'b001, S2 = 3'b010, S3= 3'b011, S4= 3'b100;
reg [1:0] seq;

always @ (ae or be or ce or de) begin
    if (ae) seq = 2'b00;
    else if (be) seq = 2'b01;
    else if (ce) seq = 2'b10;
    else if (de) seq = 2'b11;
end

always @ (seq or state) begin
    case (state)
        S0: if(seq == 0) nextstate = S1;
        else nextstate = S0;
        S1: begin 
        if(seq == 0) nextstate = S1;
        else if ( seq == 1) nextstate = S2;
        else nextstate = S0;
        end
        S2:  begin 
           if(seq == 0) nextstate = S1;
           else if ( seq == 2) nextstate = S2;
           else nextstate = S0;
       end
        S3:  begin 
           if(seq == 0) nextstate = S1;
           else if ( seq == 1) nextstate = S2;
           else nextstate = S0;
       end
        S4:  begin 
          if(seq == 0) nextstate = S1;
          else if ( seq == 1) nextstate = S2;
          else nextstate = S0;
      end
        default: nextstate = A;
    endcase
end

always @ (posedge clk, posedge rst) begin
    if (rst)
        state <= A;
    else
        state <= nextstate;
end

endmodule