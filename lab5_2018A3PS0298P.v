// Tanvi Shewale 2018A3PS0298P

//*****************************SINGLE CYCLE**************************************************

`timescale 1ns/1ns

module single_cycle(A,B,op,clk,rst);
input [7:0] A;
input [7:0] B;
input clk;
input rst;
output reg [15:0] op;

reg [3:0] A0;
reg [3:0] A1;
reg [3:0] B0;
reg [3:0] B1;

reg [7:0] M0;
reg [7:0] M1;
reg [7:0] M2;
reg [7:0] M3;

reg [15:0] S0;
reg [15:0] S1;
reg [15:0] S2;
reg [15:0] S3;

always @ (posedge clk) begin
if (rst == 1)
op = 16'b0000000000000000;
else begin
A0 = {A[3:0]};
A1 = {A[7:4]};
B0 = {B[3:0]};
B1 = {B[7:4]};
M0 = A0 * B0;
M1 = A0 * B1;
M2 = A1 * B0;
M3 = A1 * B1;
S0 = {8'b00000000,M0};
S1 = {4'b0000,M1,4'b0000};
S2 = {4'b0000,M2,4'b0000};
S3 = {M3,8'b00000000};


op = S0 + S1 + S2 + S3;
end
end
endmodule 



module tb_single();
reg clk, rst;
reg [7:0] A;
reg [7:0] B;
wire [15:0] op;

single_cycle uut (.clk(clk), .rst(rst), .A(A), .B(B), .op(op));


initial begin
clk = 1'b0;
rst = 1'b1;
end

always #20 clk = ~clk;

initial begin
$dumpfile("single_cycle.vcd");
$dumpvars(0);
#30
rst = 1'b0;
A = 8'b00000100;
B = 8'b00010001;
#40
A = 8'b11000100;
B = 8'b10010011;
#40
A = 8'b11110100;
B = 8'b10100011;
#40
A = 8'b11110110;
B = 8'b10000001;

#100
$finish;
end

endmodule


// **************************************************MULTICYCLE *************************************************

module multicycle(A,B,op,clk,rst);

input [7:0] A;
input [7:0] B;
input clk;
input rst;
output reg [15:0] op;

reg [3:0] A0;
reg [3:0] A1;
reg [3:0] B0;
reg [3:0] B1;

reg [1:0] cont;
reg [15:0] acc;
reg [7:0] M;
reg [15:0] S;

initial begin 
acc = 16'b0000000000000000;
cont = 2'b11;
end

always @ (posedge clk) begin

if (rst == 1)
op = 16'b0000000000000000;
else begin
case(cont)
2'b11: begin
		M = A1 * B1;
		S = {M,8'b00000000};
		acc = acc + S;
		end
2'b10: begin
		M = A1 * B0;
		S = {4'b0000,M,4'b0000};
		acc = acc + S;
		end
2'b01: begin
		M = A0 * B1;
		S = {4'b0000,M,4'b0000};
		acc = acc + S;
		end	
2'b00: begin
		M = A0 * B0;
		S = {8'b00000000,M};
		op = acc + S;
		acc = 16'b0000000000000000;
		A0 = {A[3:0]};
		A1 = {A[7:4]};
		B0 = {B[3:0]};
		B1 = {B[7:4]};
		cont = 2'b11;
		end		
default: op = 16'b0000000000000000;
		
endcase

cont = cont - 1;
end
end

endmodule		


module tb_multi();
reg clk, rst;
reg [7:0] A;
reg [7:0] B;
wire [15:0] op;

multicycle uut (.clk(clk), .rst(rst), .A(A), .B(B), .op(op));


initial begin
clk = 1'b0;
rst = 1'b1;
end

always #40 clk = ~clk;

initial begin
$dumpfile("multicycle.vcd");
$dumpvars(0);
rst = 1'b0;
A = 8'b00000100;
B = 8'b00010001;
#320
A = 8'b11000100;
B = 8'b10010011;
#320
A = 8'b00000010;
B = 8'b10000111;
#320
A = 8'b00000010;
B = 8'b00000011;
#400
$finish;
end

endmodule

//********************************************PIPELINE***********************************************

module pipeline(A,B,op,clk,rst);

input [7:0] A;
input [7:0] B;
input clk;
input rst;
output reg [15:0] op;

reg [7:0] A0;
reg [7:0] A1;
reg [7:0] A2;
reg [7:0] A3;

reg [7:0] B0;
reg [7:0] B1;
reg [7:0] B2;
reg [7:0] B3;

reg [7:0] M0;
reg [7:0] M1;
reg [7:0] M2;
reg [7:0] M3;

reg [15:0] S0;
reg [15:0] S1;
reg [15:0] S2;
reg [15:0] S3;

always @ (posedge clk) begin
if (rst == 1)
op = 16'b0000000000000000;
else begin
	fork
	begin
	A0 = A;
	B0 = B;
	M0 = A[3:0] * B[3:0];
	S0 = {8'b00000000,M0};
	end
	
	begin
	#1
	A1 = A0;
	B1 = B0;
	M1 = A[3:0] * B[7:4];
	S1 = S0 + {4'b0000,M1,4'b0000};
	end
	
	begin
	#2
	A2 = A1;
	B2 = B1;
	M2 = A[7:4] * B[3:0];
	S2 = S1 + {4'b0000,M2,4'b0000};
	end
	
	begin
	#3
	A3 = A2;
	B3 = B2;
	M3 = A[7:4] * B[7:4];
	S3 = S2 + {M3,8'b00000000};
	end
	join
	
	op = S3;
	end
end
endmodule
	


module tb_pipeline();
reg clk, rst;
reg [7:0] A;
reg [7:0] B;
wire [15:0] op;

pipeline uut (.clk(clk), .rst(rst), .A(A), .B(B), .op(op));


initial begin
clk = 1'b0;
rst = 1'b1;
end

always #200 clk = ~clk;

initial begin
$dumpfile("pipeline.vcd");
$dumpvars(0);
rst = 1'b0;
A = 8'b00000100;
B = 8'b00010001;
#400
A = 8'b11000100;
B = 8'b10010011;
#400
A = 8'b00000010;
B = 8'b10000111;
#400
A = 8'b00000010;
B = 8'b00000011;
#400
A = 8'b11111111;
B = 8'b00000011;
#400
$finish;
end

endmodule