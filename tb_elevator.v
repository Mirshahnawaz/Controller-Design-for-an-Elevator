`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2023 02:57:26 PM
// Design Name: 
// Module Name: tb_elevator
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


module tb_elevator();
 reg clk, reset, BG, BF1, BF2, BF3, reqG, reqF1, reqF2, reqF3, overload, firealarm;
 wire door_closed, door_open;
 wire [1:0] prox;
 
 
 
 
 elevator dut (.clk(clk),.reset(reset),.BG(BG),.BF1(BF1),.BF2(BF2),.BF3(BF3),.reqG(reqG),.reqF1(reqF1),.reqF2(reqF2),
 .reqF3(reqF3),.overload(overload),.firealarm(firealarm),.door_open(door_open),.door_closed(door_closed),.prox(prox));
 
 
initial begin
clk = 0;
end
always #10 clk = ~clk;
initial begin
firealarm = 0;
overload = 0;
reset = 0; 
#5 reset = 1;
#5 reset = 0;
#20 BG = 0; BF1 = 0; BF2 = 1; BF3 = 0; reqG = 0; 
reqF1 = 0; reqF2 = 0; reqF3 = 0;
#20 BG = 0; BF1 = 0; BF2 = 0; BF3 = 0; reqG = 0; 
reqF1 = 0; reqF2 = 0; reqF3 = 0;
#20 overload = 1;
#20 BG = 0; BF1 = 0; BF2 = 0; BF3 = 0; reqG = 1; 
reqF1 = 0; reqF2 = 0; reqF3 = 0;
#20 BG = 0; BF1 = 0; BF2 = 0; BF3 = 0; reqG = 0; 
reqF1 = 0; reqF2 = 0; reqF3 = 0;
#40 overload = 0;
#100 reqF1 =1;
#40 reqF1 = 0;
#100 firealarm = 1;
#20 BF1 =1;
#20 BF1=0;
#160 firealarm = 0;
#40 BF3=1;
#80 BF3=0;
end



endmodule
