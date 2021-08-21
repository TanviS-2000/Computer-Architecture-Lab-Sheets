//Tanvi Shewale 2018A3PS0298P

// D FLIP FLOP SYNCHRONOUS

module d_ff_sync(D, Q, clk, reset);

input D, clk, reset;
output reg Q;
  
always @ (posedge clk)
    begin
      if(reset==1)
        Q <= 1'b0;
      else
        Q <= D;
    end
endmodule

// D FLIP FLOP SYNCHRONOUS TEST BENCH

`timescale 1ns/1ns
// `include "d_ff_sync.v"

module d_ff_sync_tb;

reg D, reset, clk;
wire Q;

d_ff_sync uut (.D(D), .Q(Q), .clk(clk), .reset(reset));


always 
#5 clk = ~clk;

initial begin
$dumpfile("d_ff_sync_tb.vcd");
$dumpvars(0,d_ff_sync_tb);

D = 1'b0;
clk = 1'b0;
reset = 1'b0;
#5
D = 1'b1; reset = 1'b0;
#5
D = 1'b1; reset = 1'b1;
#5
D = 1'b1; reset = 1'b1;
#5
D =1'b1; reset = 1'b0;
#5
D =1'b1; reset = 1'b0;
#5
D =1'b1; reset = 1'b0;
#5
D =1'b1; reset = 1'b0;
#5
D =1'b0; reset = 1'b1;
#5
D =1'b1; reset = 1'b0;
#5
D =1'b1; reset = 1'b0;
#5
D =1'b0; reset = 1'b0;
#5
D =1'b0; reset = 1'b0;
#50
$finish;
end

endmodule

// D FLIP FLOP ASYNCHRONOUS 

module d_ff_async(D, Q, clk, reset);

input D, clk, reset;
output reg Q;

always @ (posedge clk or posedge reset)
begin
      if(reset==1)
        Q <= 1'b0;
      else
        Q <= D;
    end
endmodule

// D FLIP FLOP ASYNCHRONOUS TEST BENCH

`timescale 1ns/1ns
// `include "d_ff_async.v"

module d_ff_async_tb;

reg D, reset, clk;
wire Q;

d_ff_async uut (.D(D), .Q(Q), .clk(clk), .reset(reset));

always 
#5 clk = ~clk;

initial begin
$dumpfile("d_ff_async_tb.vcd");
$dumpvars(0,d_ff_async_tb);

D = 1'b0;
clk = 1'b0;
reset = 1'b0;
#5
D = 1'b1; reset = 1'b0;
#5
D = 1'b1; reset = 1'b1;
#5
D = 1'b1; reset = 1'b1;
#5
D =1'b1; reset = 1'b0;
#5
D =1'b1; reset = 1'b0;
#5
D =1'b1; reset = 1'b0;
#5
D =1'b1; reset = 1'b0;
#5
D =1'b0; reset = 1'b1;
#5
D =1'b1; reset = 1'b0;
#5
D =1'b1; reset = 1'b0;
#5
D =1'b0; reset = 1'b0;
#5
D =1'b0; reset = 1'b0;
#50
$finish;
end

endmodule

// MOD 10 COUNTER

module counter(clk, reset, count);

input clk;
input reset;
output reg [3:0] count;

always @ (posedge clk) 
  begin  
    if (reset) begin  
      count <= 4'b0000;  
    end 
	else begin  
      if (count == 4'b1001)  
        count <= 4'b0000;  
      else  
        count <= count + 4'b0001;  
    end  
  end  
endmodule  

// MOD 10 COUNTER TEST BENCH

`timescale 1ns/1ns
// `include "counter.v"

module counter_tb;

reg clk, reset;
wire [3:0] count;  

counter uut (.clk(clk),.reset(reset),.count(count));  

always 
#5 clk = ~clk;

initial begin
 
$dumpfile("counter_tb.vcd");
$dumpvars(0,counter_tb);

clk = 1'b0; reset = 1'b1;
#10 reset = 1'b0;
#40 reset = 1'b1;
#15 reset = 1'b0;
#300
$finish; 

end


endmodule  

// DECODER

module decoder(data_in, data_out, en);

input [1:0] data_in;
input en;
output reg [3:0] data_out;

always @(data_in or en)
 begin
 if (en == 1'b1)
  begin
  case(data_in)
  2'b00 : data_out = 4'b0001;
  2'b01 : data_out = 4'b0010;
  2'b10 : data_out = 4'b0100;
  2'b11 : data_out = 4'b1000;
  default : data_out = 4'b0000;
  endcase
  end
 else 
  data_out = 4'b0000;
 end

endmodule 
 
 
 // DECODER TEST BENCH
 
`timescale 1ns/1ns
// `include "decoder.v"

module decoder_tb();

wire [3:0] data_out;
reg en;
reg [1:0] data_in;

decoder uut ( .data_in(data_in), .data_out(data_out), .en(en));

initial begin 

$dumpfile("decoder_tb.vcd");
$dumpvars(0,decoder_tb);

en = 1'b1; data_in = 2'b00;
#10 en = 1'b1; data_in = 2'b10;
#10 en = 1'b1; data_in = 2'b01;
#10 en = 1'b0; data_in = 2'b11;
#10 en = 1'b1; data_in = 2'b11;
#10 en = 1'b0; data_in = 2'b00;
#100
$finish;

end

endmodule

// SHIFT REGISTER

module shift_reg(val, inp, clk, ls);

input ls,clk;
input [7:0] inp;
output reg [7:0] val;

always @ (posedge clk)
 begin
    if (ls == 1)
	  val <= inp[7:0];
	else if (ls == 0)
	begin
      val <= {val[0],val[7:1]} ;
	end
 end
endmodule  

// SHIFT REGISTER TEST BENCH

`timescale 1ns/1ns
// `include "shift_reg.v"

module shift_reg_tb();

reg [7:0] inp ;
reg clk, ls;
wire [7:0] val;

shift_reg uut (.inp(inp), .ls(ls), .clk(clk), .val(val));

always 
#5 clk = ~clk;

initial 
begin

$dumpfile("shift_reg_tb.vcd");
$dumpvars(0,shift_reg_tb);

inp = 4'b1101;
clk = 1'b0;
ls = 1'b1;
#20
ls = 1'b0;
inp = 4'b1111;
#5
ls = 1'b0;
#10
ls = 1'b1;
#10
ls = 1'b0;
#100
$finish;
end

endmodule


// MOD 60 BCD COUNTER

module bcd_counter(clk, reset, count);

input clk;
input reset;
output reg [7:0] count;

always @ (posedge clk) 
  begin  
    if (reset == 1'b1)  
      count <= 8'b00000000;  
    else if(count == 8'b001001)
	  count <= 8'b00010000;
	else if(count == 8'b00011001)
      count <= 8'b00100000;
	else if (count == 8'b00101001)
      count <= 8'b00110000;
	else if (count == 8'b00111001)
      count <= 8'b01000000;
    else if (count == 8'b01001001)
      count <= 8'b01010000;
    else if (count ==8'b01011001)
      count <= 8'b00000000;	
	else  
      count <= count + 4'b0001;  
      
  end  
endmodule 

`timescale 1ns/1ns
// `include "bcd_counter.v"

module bcd_counter_tb;

reg clk, reset;
wire [7:0] count;  

bcd_counter uut (.clk(clk),.reset(reset),.count(count));  

always 
#5 clk = ~clk;

initial begin
 
$dumpfile("bcd_counter_tb.vcd");
$dumpvars(0,bcd_counter_tb);

clk = 1'b0; reset = 1'b1;
#10 reset = 1'b0;
#40 reset = 1'b1;
#15 reset = 1'b0;
#800
$finish; 

end


endmodule  
