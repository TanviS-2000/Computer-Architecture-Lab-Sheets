// Tanvi Shewale 2018A3PS0298P

//MOORE MACHINE

module palindrome_moore(clk, rst, in, op);
input clk, rst, in;
output op;
reg [4:0] current_state;
reg [4:0] next_state;
reg op;

always @(posedge clk)
begin
 if(rst == 1) 
 current_state <= 4'b0000;
 else
 current_state <= next_state; 
end

always @(current_state,in)
begin
	case(current_state) 
		4'b0000:begin
				if(in==1)
				next_state = 4'b0011;
				else
				next_state = 4'b0010;
				end
		4'b0001:begin
				if(in==1)
				next_state = 4'b0101;
				else
				next_state = 4'b0100;
				end	
		4'b0010:begin
				if(in==1)
				next_state = 4'b0011;
				else
				next_state = 4'b0110;
				end			
		4'b0011:begin
				if(in==1)
				next_state = 4'b0101;
				else
				next_state = 4'b0111;
				end
		4'b0100:begin
				if(in==1)
				next_state = 4'b1000;
				else
				next_state = 4'b0010;
				end	
		4'b0101:begin
				if(in==1)
				next_state = 4'b1001;
				else
				next_state = 4'b0100;
				end	
		4'b0110:begin
				if(in==1)
				next_state = 4'b0001;
				else
				next_state = 4'b0000;
				end	
		4'b0111:begin
				if(in==1)
				next_state = 4'b0001;
				else
				next_state = 4'b0000;
				end	
		4'b1000:begin
				if(in==1)
				next_state = 4'b0001;
				else
				next_state = 4'b0000;
				end	
		4'b1001:begin
				if(in==1)
				next_state = 4'b0001;
				else
				next_state = 4'b0000;
				end			
 default:next_state = 4'b0000;
 endcase
end

always @(current_state)
begin 
 case(current_state) 
 4'b0000:   op = 0;
 4'b0001:   op = 0;
 4'b0010:   op = 0;
 4'b0011:   op = 0;
 4'b0100:   op = 0;
 4'b0101:   op = 0;
 4'b0110:   op = 1;
 4'b0111:   op = 1;
 4'b1000:   op = 1;
 4'b1001:   op = 1;
 default:  op = 0;
 endcase
end 
endmodule


`timescale 1ns/1ns

module moore_tb();
reg clk, rst, in;
wire op;
integer i;

palindrome_moore uut (.clk(clk), .rst(rst), .in(in), .op(op));

initial begin
$dumpfile("moore.vcd");
$dumpvars(0,moore_tb);

clk = 1'b0;
rst = 1'b1;
#5 rst = 1'b0;

for (i = 0; i<=31; i = i + 1 )
begin 
in = $random %2;
#2 clk = 1;
#2 clk = 0; 
end
#200
$finish;
end

endmodule 

//MEALY MACHINE 
module palindrome_mealy(clk, rst, in, op);
input clk, rst, in;
output op;
reg [2:0] state;
reg op;

always @ (posedge clk)
	begin 
		if(rst) begin 
		state <= 3'b000;
		op <= 0;
		end
		
		else begin
		case (state)
		3'b000: begin 
				if (in)
				begin
				state <= 3'b010;
				op <= 0;
				end
				else 
				begin 
				state <= 3'b001;
				op <= 0;
				end
				end
		3'b001: begin
				if (in)
				begin 
				state <= 3'b100;
				op <= 0;
				end
				else 
				begin 
				state <= 3'b011;
				op <= 0;
				end
				end
		3'b010: begin
				if (in)
				begin 
				state <= 3'b110;
				op <= 0;
				end
				else 
				begin 
				state <= 3'b101;
				op <= 0;
				end
				end
        3'b011: begin
				if (in)
				begin 
				state <= 3'b100;
				op <= 0;
				end
				else 
				begin 
				state <= 3'b011;
				op <= 1;
				end
				end	
		3'b100: begin
				if (in)
				begin 
				state <= 3'b110;
				op <= 0;
				end
				else 
				begin 
				state <= 3'b101;
				op <= 1;
				end
				end
		3'b101: begin
				if (in)
				begin 
				state <= 3'b100;
				op <= 1;
				end
				else 
				begin 
				state <= 3'b011;
				op <= 0;
				end
				end
		3'b110: begin
				if (in)
				begin 
				state <= 3'b110;
				op <= 1;
				end
				else 
				begin 
				state <= 3'b101;
				op <= 0;
				end
				end		
		default: begin
				state <= 3'b000;
				op <= 0;
				end
		endcase
		end	
	end	
endmodule				

`timescale 1ns/1ns

module mealy_tb();
reg clk, rst, in;
wire op;
integer i;

palindrome_mealy uut (.clk(clk), .rst(rst), .in(in), .op(op));

initial begin
$dumpfile("mealy.vcd");
$dumpvars(0,mealy_tb);

clk = 1'b0;
rst = 1'b1;
#5 rst = 1'b0;

for (i = 0; i<=31; i = i + 1 )
begin 
in = $random %2;
#2 clk = 1;
#2 clk = 0; 
end
#200
$finish;
end

endmodule 

//MEMORY IMPLEMENTATION

module mem_64 (dout, din, adr, ren, wen, clk);

output reg [7:0]dout; 
input [7:0]din;
input [5:0]adr;
input ren, wen, clk;

reg [7:0] my_mem [0:63] ;

initial begin 
 $readmemb("dummy.dat", my_mem);
 end

always @ (ren, adr)
begin
if(!ren)
begin
dout <= my_mem[adr];
end
else 
dout <= 8'b0000000;
end

always @(negedge clk)
begin
if (wen)
my_mem[adr] <=din;
end

endmodule 

`timescale 1ns/1ns

module mem_tb();
wire [7:0]dout; 
reg [7:0]din;
reg [5:0]adr;
reg ren, wen, clk;
//$writememh ("dummy.dat", my_mem);
mem_64 uut(.dout(dout), .din(din), .adr(adr), .ren(ren), .wen(wen), .clk(clk));

integer i;

always  begin #1 clk = ~clk;
end

always begin 
for (i = 0; i<=63; i = i+ 1)
begin 
adr = i;
wen = 0;
ren = 1;
#2 
wen = 1;
ren = 0;
din[7] = dout[7];
din[6] = dout[7] ^ dout[6];
din[5] = dout[7] ^ dout[6] ^ dout[5];
din[4] = dout[7] ^ dout[6] ^ dout[5] ^ dout[4];
din[3] = dout[7] ^ dout[6] ^ dout[5] ^ dout[4] ^ dout[3];
din[2] = dout[7] ^ dout[6] ^ dout[5] ^ dout[4] ^ dout[3] ^ dout[2];
din[1] = dout[7] ^ dout[6] ^ dout[5] ^ dout[4] ^ dout[3] ^ dout[2] ^ dout[1];
din[0] = dout[7] ^ dout[6] ^ dout[5] ^ dout[4] ^ dout[3] ^ dout[2] ^ dout[1] ^ dout[0];
end
#100
$finish;
end
endmodule