//Tanvi Shewale 2018A3PS0298P

// FULL ADDER 

module full_adder(a,b,c_in,s,c_out);

input a;
input b;
input c_in;
output s;
output c_out;

assign s = a ^ b ^ c_in;
assign c_out = (a & b) | ( (a ^ b) & c_in );

endmodule

// FULL ADDER TESTBENCH

`timescale 1ns/1ns
`include "full_adder.v"

module full_adder_tb;

reg a;
reg b;
reg c_in;
wire s;
wire c_out;

full_adder uut(
.a(a),
.b(b),
.c_in(c_in),
.s(s),
.c_out(c_out));

initial begin

$dumpfile("full_adder_tb.vcd");
$dumpvars(0,full_adder_tb);

a = 0;
b = 0;
c_in = 0;
#20;

a = 0;
b = 1;
c_in = 0;
#20;

a = 1;
b = 1;
c_in = 0;
#20;

a = 1;
b = 0;
c_in = 0;
#20;

a = 0;
b = 0;
c_in = 1;
#20;

a = 0;
b = 1;
c_in = 1;
#20;

a = 1;
b = 1;
c_in = 1;
#20;

a = 1;
b = 0;
c_in = 1;
#20;

$display("Test completed");
end 
 
endmodule

// 4:1 MUX

module mux_4_1(a0,a1,a2,a3,s0,s1,op);
input a0,a1,a2,a3;
input s0,s1;
output op;

assign op = s1?(s0?a3:a2):(s0?a1:a0);

endmodule

// 4:1 MUX TESTBENCH

`timescale 1ns/1ns
`include "mux_4_1.v"

module mux_4_1_tb;

reg a0,a1,a2,a3;
reg s0,s1;
wire op;

mux_4_1 uut(
.a0(a0),
.a1(a1),
.a2(a2),
.a3(a3),
.s0(s0),
.s1(s1),
.op(op));

initial begin

$dumpfile("mux_4_1_tb_tb.vcd");
$dumpvars(0,mux_4_1_tb);

a0=0;
a1=1;
a2=1;
a3=1;

s0=0;
s1=0;
#20;

s0=0;
s1=1;
#20;

s0=1;
s1=1;
#20

s0=1;
s1=0;
#20


$display("Test completed");

end

endmodule

// COMBINATIONAL CIRCUIT WITH OPCODE

module comb_cir(a,opc,val);

input [7:0] a;
input [2:0] opc;
output [7:0] val;

assign val = opc[2:0] == 3'b001 ? {a[6:0],1'b0} : ( opc[2:0] == 3'b100 ? {1'b0, a[7:1]} : ( opc[2:0] == 3'b101 ? {a[7], a[7:1]} : ( opc[2:0] == 3'b010 ? {a[6:0],a[7]} : ( opc[2:0] == 3'b110 ? {a[0], a[7:1]} : {a[7:0]}))));

endmodule

// COMBINATIONAL CIRCUIT WITH OPCODE TESTBENCH

`timescale 1ns/1ns
`include "comb_cir.v"

module comb_cir_tb;

reg [7:0] a;
reg [2:0] opc;
wire [7:0] val;

comb_cir uut(
.a(a),
.opc(opc),
.val(val));

initial begin 

$dumpfile("comb_cir_tb.vcd");
$dumpvars(0,comb_cir_tb);

a = 8'b01101010;

opc = {1'b0,1'b0,1'b0};
#20;

opc = {1'b0,1'b0,1'b1};
#20;

opc = {1'b1,1'b0,1'b0};
#20;

opc = {1'b1,1'b0,1'b1};
#20;

opc = {1'b0,1'b1,1'b0};
#20;

opc = {1'b1,1'b1,1'b0};
#20;


$display("Test completed");

end

endmodule 

// BCD MULTIPLIER 

module bcd_mult(A_hex,B_hex,OP_hex,OP_dec,A_dec,B_dec);

input [7:0] A_hex;
input [7:0] B_hex;
output [15:0] OP_hex;
output [15:0] OP_dec;
output [7:0] A_dec;
output [7:0] B_dec;

wire [15:0] temp1;
wire [15:0] temp2;
wire [15:0] temp3;
wire [15:0] temp4;
wire [15:0] temp5;
wire [7:0] temp6;
wire [7:0] temp7;
wire [7:0] temp8;
wire [7:0] temp9;


assign temp1 = A_hex * B_hex;
assign temp2 = temp1 % 16'd10;
assign OP_dec[3:0] = {temp2[3:0]};
assign temp3 = (temp1 % 16'd100 )/16'd10;
assign OP_dec[7:4] = {temp3[3:0]};
assign temp4 = (temp1 % 16'd1000) / 16'd100;
assign OP_dec[11:8] = {temp4[3:0]};
assign temp5 = temp1 / 16'd1000;
assign OP_dec[15:12] = {temp5[3:0]};

assign OP_hex = {temp1[15:0]};

assign temp6 = A_hex % 8'd10;
assign A_dec[3:0] = {temp6[3:0]};
assign temp7 = A_hex / 8'd10;
assign A_dec[7:4] = {temp7[3:0]};

assign temp8 = B_hex % 8'd10;
assign B_dec[3:0] = {temp8[3:0]};
assign temp9 = B_hex / 8'd10;
assign B_dec[7:4] = {temp9[3:0]};


endmodule

// BCD MULTIPLIER TESTBENCH

`timescale 1ns/1ns
`include "bcd_mult.v"

module bcd_mult_tb;

reg [7:0] a_hex;
reg [7:0] b_hex;
wire [15:0] op_dec;
wire [15:0] op_hex;
wire [7:0] a_dec;
wire [7:0] b_dec;

bcd_mult uut(
.A_hex(a_hex),
.B_hex(b_hex),
.OP_dec(op_dec),
.OP_hex(op_hex),
.A_dec(a_dec),
.B_dec(b_dec));

initial begin 

$dumpfile("bcd_mult_tb.vcd");
$dumpvars(0,bcd_mult_tb);

a_hex = 8'h23;
b_hex = 8'h02;
#20;

a_hex = 8'h25;
b_hex = 8'h08;
#20;

a_hex = 8'h32;
b_hex = 8'h05;
#20;

a_hex = 8'h11;
b_hex = 8'h10;
#20;

$display("Test completed");

end

endmodule
