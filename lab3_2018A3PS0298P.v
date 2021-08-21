//Tanvi Shewale 2018A3PS0298P

// JOHNSON COUNTER

module johnson(count, clk, rst);
input clk,rst;
output wire [3:0] count;
wire [3:0] Qbreg;
wire [3:0] Qreg;

jk JK0 (.J(Qbreg[3]), .K(Qreg[3]), .clk(clk), .Q(Qreg[0]), .Q_bar(Qbreg[0]), .rst(rst));
jk JK1 (.J(Qreg[0]), .K(Qbreg[0]), .clk(clk), .Q(Qreg[1]), .Q_bar(Qbreg[1]), .rst(rst));
jk JK2 (.J(Qreg[1]), .K(Qbreg[1]), .clk(clk), .Q(Qreg[2]), .Q_bar(Qbreg[2]), .rst(rst));
jk JK3 (.J(Qreg[2]), .K(Qbreg[2]), .clk(clk), .Q(Qreg[3]), .Q_bar(Qbreg[3]), .rst(rst));

assign count = Qreg;

endmodule


module jk(J, K, clk, Q, Q_bar, rst);

  input J, K, clk,rst;
  output reg Q, Q_bar;
  
	
  always @(posedge clk or posedge rst)
  begin 
	if (rst==1)
      begin 
	  Q = 1'b0;
	  Q_bar = 1'b1; 
	  end
	else
	    
    case({J, K})
      2'b00:  begin 
				Q <= Q;
				Q_bar <= Q_bar; 
			  end 
      2'b01:  begin
				Q <= 1'b0;
				Q_bar <= 1'b1; 
			  end
      2'b10:  begin 
				Q <= 1'b1;
	            Q_bar = 1'b0; end
      2'b11:  begin 
				Q <= ~Q;
	            Q_bar <= ~Q_bar; 
			  end 
    endcase
  end	
endmodule

`timescale 1ns/1ns
//`include "johnson.v"

module johnson_tb();
reg clk;
reg rst;
wire [3:0]count;

johnson uut (.clk(clk), .count(count), .rst(rst));

always #5 clk = ~clk;

initial begin
clk = 1'b0;
rst = 1'b1;
end

initial begin
$dumpfile("johnson_tb.vcd");
$dumpvars(0,johnson_tb);
#10
rst = 1'b0;
#50
rst = 1'b1;
#20
rst = 1'b0;

#300

$finish;
end

endmodule

// RIPPLE CARRY ADDER

module FA( a,b,cin,cout,sum);
 input a;
 input b;
 input cin;
 output sum;
 output cout;
 
 assign sum = a^b^cin;
 assign cout = (a&b)| cin & (a^b);
 
 endmodule
 
 module ripple(A, B, Cin, S, Cout);

input [3:0] A;
input [3:0] B;
input Cin;
output [3:0] S;
output Cout;
wire [2:0] C;

FA FA1(.a(A[0]), .b(B[0]), .cin(Cin), .sum(S[0]), .cout(C[0]));
FA FA2(.a(A[1]), .b(B[1]), .cin(C[0]), .sum(S[1]), .cout(C[1]));
FA FA3(.a(A[2]), .b(B[2]), .cin(C[1]), .sum(S[2]), .cout(C[2]));
FA FA4(.a(A[3]), .b(B[3]), .cin(C[2]), .sum(S[3]), .cout(Cout));

endmodule

`timescale 1ns/1ns
//`include "ripple.v"

module ripple_tb();

reg [3:0]A;
reg [3:0]B;
reg Cin;
wire [3:0]S;
wire Cout;

ripple uut(.A(A), .B(B), .Cin(Cin), .S(S), .Cout(Cout));

initial begin
$dumpfile("ripple_tb.vcd");
$dumpvars(0,ripple_tb);

A = 4'b0000;
B = 4'b0000;
Cin = 4'b0;

#10
A    = 4'b1011;
B    = 4'b0100;
Cin  = 4'b0;

#10
A    = 4'b1111;
B    = 4'b0100;
Cin  = 4'b1;

#10
A    = 4'b1001;
B    = 4'b0110;
Cin  = 4'b0;

#10
A    = 4'b1111;
B    = 4'b0101;
Cin  = 4'b1;
#50
$finish;
end
endmodule


// MULTIPLIER

module multiplier(a,b,prod);

input [5:0] a;
input [5:0] b;
output [11:0] prod;

wire zero;
wire cf0, ce0, cd0, cc0, cb0, ca0;
wire se0, sd0, sc0, sb0, sa0;
wire cf1, ce1, cd1, cc1, cb1, ca1;
wire se1, sd1, sc1, sb1, sa1;
wire cf2, ce2, cd2, cc2, cb2, ca2;
wire se2, sd2, sc2, sb2, sa2;
wire cf3, ce3, cd3, cc3, cb3, ca3;
wire se3, sd3, sc3, sb3, sa3;
wire cf4, ce4, cd4, cc4, cb4, ca4;
wire se4, sd4, sc4, sb4, sa4;
wire cf5, ce5, cd5, cc5, cb5, ca5;
wire se5, sd5, sc5, sb5, sa5;
wire cf6, ce6, cd6, cc6, cb6, ca6;

assign zero = 1'b0;


FA f0(.a(a[0]&b[0]), .b(zero), .cin(zero), .sum(prod[0]), .cout(cf0));
FA e0(.a(a[1]&b[0]), .b(zero), .cin(zero), .sum(se0), .cout(ce0));
FA d0(.a(a[2]&b[0]), .b(zero), .cin(zero), .sum(sd0), .cout(cd0));
FA c0(.a(a[3]&b[0]), .b(zero), .cin(zero), .sum(sc0), .cout(cc0));
FA b0(.a(a[4]&b[0]), .b(zero), .cin(zero), .sum(sb0), .cout(cb0));
FA a0(.a(a[5]&b[0]), .b(zero), .cin(zero), .sum(sa0), .cout(ca0));

FA f1(.a(a[0]&b[1]), .b(se0), .cin(cf0), .sum(prod[1]), .cout(cf1));
FA e1(.a(a[1]&b[1]), .b(sd0), .cin(ce0), .sum(se1), .cout(ce1));
FA d1(.a(a[2]&b[1]), .b(sc0), .cin(cd0), .sum(sd1), .cout(cd1));
FA c1(.a(a[3]&b[1]), .b(sb0), .cin(cc0), .sum(sc1), .cout(cc1));
FA b1(.a(a[4]&b[1]), .b(sa0), .cin(cb0), .sum(sb1), .cout(cb1));
FA a1(.a(a[5]&b[1]), .b(zero), .cin(ca0), .sum(sa1), .cout(ca1));

FA f2(.a(a[0]&b[2]), .b(se1), .cin(cf1), .sum(prod[2]), .cout(cf2));
FA e2(.a(a[1]&b[2]), .b(sd1), .cin(ce1), .sum(se2), .cout(ce2));
FA d2(.a(a[2]&b[2]), .b(sc1), .cin(cd1), .sum(sd2), .cout(cd2));
FA c2(.a(a[3]&b[2]), .b(sb1), .cin(cc1), .sum(sc2), .cout(cc2));
FA b2(.a(a[4]&b[2]), .b(sa1), .cin(cb1), .sum(sb2), .cout(cb2));
FA a2(.a(a[5]&b[2]), .b(zero), .cin(ca1), .sum(sa2), .cout(ca2));

FA f3(.a(a[0]&b[3]), .b(se2), .cin(cf2), .sum(prod[3]), .cout(cf3));
FA e3(.a(a[1]&b[3]), .b(sd2), .cin(ce2), .sum(se3), .cout(ce3));
FA d3(.a(a[2]&b[3]), .b(sc2), .cin(cd2), .sum(sd3), .cout(cd3));
FA c3(.a(a[3]&b[3]), .b(sb2), .cin(cc2), .sum(sc3), .cout(cc3));
FA b3(.a(a[4]&b[3]), .b(sa2), .cin(cb2), .sum(sb3), .cout(cb3));
FA a3(.a(a[5]&b[3]), .b(zero), .cin(ca2), .sum(sa3), .cout(ca3));

FA f4(.a(a[0]&b[4]), .b(se3), .cin(cf3), .sum(prod[4]), .cout(cf4));
FA e4(.a(a[1]&b[4]), .b(sd3), .cin(ce3), .sum(se4), .cout(ce4));
FA d4(.a(a[2]&b[4]), .b(sc3), .cin(cd3), .sum(sd4), .cout(cd4));
FA c4(.a(a[3]&b[4]), .b(sb3), .cin(cc3), .sum(sc4), .cout(cc4));
FA b4(.a(a[4]&b[4]), .b(sa3), .cin(cb3), .sum(sb4), .cout(cb4));
FA a4(.a(a[5]&b[4]), .b(zero), .cin(ca2), .sum(sa4), .cout(ca4));

FA f5(.a(a[0]&b[5]), .b(se4), .cin(cf4), .sum(prod[5]), .cout(cf5));
FA e5(.a(a[1]&b[5]), .b(sd4), .cin(ce4), .sum(se5), .cout(ce5));
FA d5(.a(a[2]&b[5]), .b(sc4), .cin(cd4), .sum(sd5), .cout(cd5));
FA c5(.a(a[3]&b[5]), .b(sb4), .cin(cc4), .sum(sc5), .cout(cc5));
FA b5(.a(a[4]&b[5]), .b(sa4), .cin(cb4), .sum(sb5), .cout(cb5));
FA a5(.a(a[5]&b[5]), .b(zero), .cin(ca4), .sum(sa5), .cout(ca5));

FA f6(.a(zero), .b(se5), .cin(cf5), .sum(prod[6]), .cout(cf6));
FA e6(.a(cf6), .b(sd5), .cin(ce5), .sum(prod[7]), .cout(ce6));
FA d6(.a(ce6), .b(sc5), .cin(cd5), .sum(prod[8]), .cout(cd6));
FA c6(.a(cd6), .b(sb5), .cin(cc5), .sum(prod[9]), .cout(cc6));
FA b6(.a(cc6), .b(sa5), .cin(cb5), .sum(prod[10]), .cout(cb6));
FA a6(.a(cb6), .b(zero), .cin(ca5), .sum(prod[11]), .cout(ca6));

endmodule

`timescale 1ns/1ns
//`include "multiplier.v"

module multiplier_tb();

reg [5:0]a;
reg [5:0]b;
wire [11:0] prod;

multiplier uut(.a(a), .b(b), .prod(prod));

initial begin
$dumpfile("multiplier_tb.vcd");
$dumpvars(0,multiplier_tb);

a = 6'b100010;
b = 6'b000001;
#20
a = 6'b111010;
b = 6'b110001;
#20
a = 6'b111111;
b = 6'b010101;
#20
a = 6'b000000;
b = 6'b010101;
#100
$finish;
end
endmodule