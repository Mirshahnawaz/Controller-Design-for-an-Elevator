`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2023 01:28:58 AM
// Design Name: 
// Module Name: elevator
// Project Name: FPGA Controller Design for an Elevator
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module elevator(clk,  reset, BG, BF1, BF2, BF3, reqG, reqF1, reqF2, reqF3, overload, firealarm,
an, seg, door_open, door_closed, prox, FAout, OLout 
);
 input clk, reset, BG, BF1, BF2, BF3, reqG, reqF1, reqF2, reqF3, 
overload, firealarm;
  
 output reg [1:0] prox;
 output reg OLout, FAout;
 output [6:0] seg;
 output reg door_open , door_closed ;
 output [7:0] an;
 
 parameter openG = 5'b00000, closedG = 5'b00001, openF1 = 5'b00010, closedF1 = 
 5'b00011, openF2 = 5'b00100, closedF2 = 5'b00101, openF3 = 5'b00110, closedF3 = 
 5'b00111, idle = 5'b01000; 
 parameter OLG = 5'b01001, OLF1 = 5'b01010, OLF2 = 5'b01011, 
 OLF3 = 5'b01100, FAG = 5'b01101, FA1 = 5'b01110, FA2 = 
 5'b01111, FA3 = 5'b10000;

 reg[4:0] state, next_state;
 
 reg [25:0] counter;
 reg clk1hz;
 reg [17:0] countr;
 reg clk250hz;

 
 initial begin
 counter = 0;
 clk1hz = 1;
 countr = 0;
 clk250hz = 1;
 end
 
 
 
 
 
 //Module for generating 1 Hz of clock from the 100Mhz of clock
 
 always @(posedge clk)
 begin
 if(counter == 49_999999)
 begin counter <= 0;
 clk1hz <= ~clk1hz; 
 end
 else
 begin
 clk1hz <= clk1hz;
 counter <= counter + 1; end
 end
 
 
 
 
 
 
 
 
 // memory element of MOORE FSM
 
 always@(posedge clk1hz or posedge reset) 
 begin
 if(reset==1)
 state <= idle;
 else
 state <= next_state;
 end
 
 
 
 
 // Combinational logic for next state of MOORE FSM
 
 always @(*)
 begin
 case (state)
 
 idle: begin
    if (firealarm == 0)
    begin
    if ((BG==1 || reqG==1) & overload == 0)
        next_state = idle;
    else if ((BF1==1 || reqF1==1) & overload == 0)
        next_state = openF1;
    else if ((BF2==1 || reqF2==1) & overload == 0)
        next_state = openF2;
    else if ((BF3==1 || reqF3==1)& overload == 0)
        next_state = openF3;
    else if ((BG==1 || reqG==1) || (BF1==1 || reqF1==1) || (BF2==1 || reqF2==1) || (BF3==1 || reqF3==1) & overload == 1)
        next_state = OLG;
    else
        next_state = idle;
    end
    else
        next_state = FAG;
    end
 openG: begin
    if (firealarm == 0)
    begin
    if ((BG==1 || reqG==1))
        next_state = openG;
    else if ( (BF1==1 || reqF1==1) || (BF2==1 || reqF2==1) || (BF3==1 || reqF3==1)& overload == 0) 
        next_state = closedG;
    else if ((BG==1 || reqG==1) || (BF1==1 || reqF1==1) || (BF2==1 || reqF2==1) || (BF3==1 || reqF3==1) & overload == 1)
        next_state = OLG;
    else
        next_state = openG;
    end
    else
        next_state = FAG;
    end
 closedG: begin
    if (firealarm == 0)
    begin
    if ((BG==1||reqG==1)) 
        next_state = openG;
    else if ((BF1==1 || reqF1==1) || (BF2==1 || reqF2==1) || (BF3==1 || reqF3==1)& overload == 0)
        next_state = closedF1;
    else if ((BG==1 || reqG==1) || (BF1==1 || reqF1==1) || (BF2==1 || reqF2==1) || (BF3==1 || reqF3==1) & overload == 1)
        next_state = OLG;
    else 
        next_state = openG;
    end 
    else
        next_state = FAG;
    end
 openF1: begin
    if(firealarm == 0)
    begin
    if ((BG==1 || reqG==1) & overload == 0)
        next_state = closedF1;
    else if ((BF1==1 || reqF1==1) & overload == 0)
        next_state = openF1;
    else if ((BF2==1 || reqF2==1) & overload == 0)
        next_state = closedF1;
    else if ((BF3==1 || reqF3==1) & overload == 0 )
        next_state = closedF1;
    else if ((BG==1 || reqG==1) || (BF1==1 || reqF1==1) || (BF2==1 || reqF2==1) || (BF3==1 || reqF3==1) & overload == 1)
        next_state = OLF1;
    else
        next_state = openF1;
    end
    else 
        next_state = FA1;
    end
 closedF1: begin
    if (firealarm == 0)
    begin
    if ((BG==1 || reqG==1) & overload == 0)
        next_state = closedG;
    else if ((BF1==1 || reqF1==1) & overload == 0)
        next_state = openF1; 
    else if ((BF2==1 || reqF2==1) & overload == 0)
        next_state = closedF2;
    else if ((BF3==1 || reqF3==1) & overload == 0)
        next_state = closedF2;
    else if ((BG==1 || reqG==1) || (BF1==1 || reqF1==1) || (BF2==1 || reqF2==1) || (BF3==1 || reqF3==1) & overload == 1)
        next_state = OLF1; 
    else
        next_state = openF1 ;
    end
    else
        next_state = FA1;
    end
 openF2: begin
    if(firealarm == 0)
    begin
    if ((BG==1 || reqG==1) & overload == 0)
        next_state = closedF2;
    else if ((BF1==1 || reqF1==1) & overload == 0)
        next_state = closedF2;
    else if ((BF2==1 || reqF2 ==1) & overload == 0)
        next_state = openF2;
    else if ((BF3==1 || reqF3==1) & overload == 0)
        next_state = closedF2;
    else if ((BG==1 || reqG==1) || (BF1==1 || reqF1==1) || (BF2==1 || reqF2==1) || (BF3==1 || reqF3==1) & overload == 1)
        next_state = OLF2;
    else
        next_state = openF2;
    end
    else
        next_state = FA2;
    end
 closedF2: begin
    if (firealarm==0)
    begin
    if ((BG==1 || reqG==1) & overload == 0)
        next_state = closedF1;
    else if ((BF1==1 || reqF1==1) & overload == 0 )
        next_state = closedF1;
    else if ((BF2==1 || reqF2 ==1) & overload == 0 ) 
        next_state = openF2;
    else if ((BF3==1 || reqF3==1) & overload == 0 )
        next_state = closedF3;
    else if ((BG==1 || reqG==1) || (BF1==1 || reqF1==1) || (BF2==1 || reqF2==1) || (BF3==1 || reqF3==1) & overload == 1 )
        next_state = OLF2;
    else
        next_state = openF2;
    end
    else
        next_state = FA2;
    end
 openF3: begin
    if(firealarm == 0)
    begin
    if ((BG==1 || reqG==1) & overload == 0)
        next_state = closedF3;
    else if ((BF1==1 || reqF1==1) & overload == 0) 
        next_state = closedF3;
    else if ((BF2==1 || reqF2 ==1) & overload == 0)
        next_state = closedF3;
    else if ((BF3==1 || reqF3==1) & overload == 0)
        next_state = openF3;
    else if ((BG==1 || reqG==1) || (BF1==1 || reqF1==1) || (BF2==1 || reqF2==1) || (BF3==1 || reqF3==1) & overload == 1)
        next_state = OLF3; 
    else
        next_state = openF3;
    end
    else
        next_state = FA3;
    end
 closedF3: begin
    if(firealarm == 0)
    begin
    if ((BG==1 || reqG==1) & overload == 0)
        next_state = closedF2;
    else if ((BF1==1 || reqF1==1) & overload == 0)
        next_state = closedF2;
    else if ((BF2==1 || reqF2 ==1) & overload == 0)
        next_state = closedF2;
    else if ((BF3==1 || reqF3==1) & overload == 0)
        next_state = openF3;
    else if ((BG==1 || reqG==1) || (BF1==1 || reqF1==1) || (BF2==1 || reqF2==1) || (BF3==1 || reqF3==1) & overload == 1)
        next_state = OLF3;
    else
        next_state = openF3;
    end
    else
        next_state = FA3;
    end   
 OLG: next_state = openG;
 
 OLF1: next_state = openF1;
 
 OLF2: next_state = openF2;
 
 OLF3: next_state = openF3;
 
 FAG: next_state = openG;
 
 FA1: next_state = FAG;
 
 FA2: next_state = FA1;
 
 FA3: next_state = FA2;
 
 default : next_state = state;
 endcase
 end
 
 
 
 
 
 // output logic for MOORE FSM
 
 always @(state)
 begin 
 door_open = 1; door_closed = 0;
 prox = 0;
 FAout = 0;
 OLout = 0;
 
 case (state) // door = 0 means it is open, door = 1 means it is closed
 
 idle: begin 
    door_open = 1; 
    door_closed = 0; 
    prox = 0; 
    FAout= 0 ; 
    OLout = 0; 
    end
 
 openG: begin 
    door_open = 1; 
    door_closed = 0; 
    prox = 0; 
    FAout = 0; 
    OLout = 0;
    end
 
 closedG: begin 
    door_open = 0; 
    door_closed = 1; 
    prox =0; 
    FAout = 0; 
    OLout = 0; 
    end
 
 openF1: begin 
    door_open = 1; 
    door_closed = 0; 
    prox =1; 
    FAout = 0; 
    OLout = 0;
    end
 
 closedF1: begin 
    door_open = 0; 
    door_closed = 1; 
    prox =1; 
    FAout = 0; 
    OLout = 0;
    end
 
 openF2: begin 
    door_open = 1; 
    door_closed = 0; 
    prox =2; FAout = 0; 
    OLout = 0;
    end
 closedF2: begin 
   door_open = 0; 
   door_closed = 1; 
   prox =2; 
   FAout = 0; 
   OLout = 0;
 end
 
 openF3: begin 
    door_open = 1; 
    door_closed = 0; 
    prox =3; 
    FAout = 0; 
    OLout = 0;
    end
 
 closedF3: begin 
    door_open = 0; 
    door_closed = 1; 
    prox =3; 
    FAout = 0; 
    OLout = 0;
    end
 
 OLG: begin 
    door_open = 1; 
    door_closed = 0; 
    prox =0; 
    FAout = 0; 
    OLout = 1;
    end
 
 OLF1: begin 
    door_open = 1; 
    door_closed = 0; 
    prox =1; 
    FAout = 0; 
    OLout = 1;
    end
 
 OLF2: begin 
    door_open = 1; 
    door_closed = 0; 
    prox =2; 
    FAout = 0; 
    OLout = 1;
    end
 
 OLF3: begin 
    door_open = 1; 
    door_closed = 0; 
    prox =3; 
    FAout = 0; 
    OLout = 1;
    end
 
 FAG: begin 
    door_open = 1; 
    door_closed = 0; 
    prox =0; 
    FAout = 1; 
    OLout = 0;
    end
 
 FA1: begin 
    door_open = 0; 
    door_closed = 1; 
    prox =1; 
    FAout = 1; 
    OLout = 0;
    end
 
 FA2: begin 
    door_open = 0; 
    door_closed = 1; 
    prox =2; 
    FAout = 1; 
    OLout = 0;
    end
 
 FA3: begin 
    door_open = 0; 
    door_closed = 1; 
    prox =3; 
    FAout = 1; 
    OLout = 0;
    end
 endcase
 end
 
 
 
 always @(posedge clk)
 begin
 if(countr == 199999)
    begin 
    countr <= 0;
    clk250hz <= ~clk250hz; 
    end
 else
    begin
    clk250hz <= clk250hz;
    countr <= countr + 1;
    end
 end

 reg [3:0] FA_status1, FA_status2, OL_status1, OL_status2, position;
 
 
 
 always @(clk250hz)
 begin 
 position <= prox;
 if(FAout == 1)
    begin
    FA_status1 <= 4'hA;
    FA_status2 <= 4'hF;
    end
 else
    begin
    FA_status1 <= 0;
    FA_status2 <= 0;
    end
 
 if (OLout == 1)
    begin
    OL_status1 <= 4'h9;
    OL_status2 <= 4'h0;
    end
 else
    begin
    OL_status1 <= 0;
    OL_status2 <= 0;
    end
 end
 
 
 
 
 
 
 
 
 seven_segment s7 (.clk(clk), .in0(FA_status1), .in1(FA_status2), 
.in2(), .in3(), .in4(OL_status1), .in5(OL_status2), .in6(), 
.in7(position), .seg(seg), .an(an));

 








 

endmodule


// seven segment driver
module seven_segment(clk,in0, in1, in2, in3,in4,in5,in6,in7,seg,an); 
input [3:0] in0;
input [3:0] in1;
input [3:0] in2;
input [3:0] in3;
input [3:0] in4;
input [3:0] in5;
input [3:0] in6;
input [3:0] in7;
input clk;
wire [6:0] d0, d1, d2, d3, d4, d5, d6, d7;
output reg [6:0] seg;
output reg [7:0] an;
reg [17:0] count;
reg clk250hz;

initial begin
count = 0;
 clk250hz = 1;
end
always @(posedge clk)
begin
 if(count == 199999)
 begin count <= 0;
 clk250hz <= ~clk250hz; end
 else
 begin
 clk250hz <= clk250hz;
 count <= count + 1; end
end
reg [3:0] pstate,next;
initial begin
 pstate = 0;
 next = 0;
end
always @ (posedge clk250hz)
begin
 pstate <= next;
end
always @ (pstate)
begin
 case(pstate)
 0: begin next <= 1; an <= 8'b11111110; seg <= d0; end
 1: begin next <= 2; an <= 8'b11111101; seg <= d1; end
 2: begin next <= 3; an <= 8'b11111011; seg <= d2; end
 3: begin next <= 4; an <= 8'b11110111; seg <= d3; end
 4: begin next <= 5; an <= 8'b11101111; seg <= d4; end
 5: begin next <= 6; an <= 8'b11011111; seg <= d5; end
 6: begin next <= 7; an <= 8'b10111111; seg <= d6; end
 7: begin next <= 0; an <= 8'b01111111; seg <= d7; end
 default: begin next <= 0; an <= 8'b00000000; seg <= 7'b111_1111; end
 endcase
end

segdecoder D0(d0, in0);
segdecoder D1(d1, in1);
segdecoder D2(d2, in2);
segdecoder D3(d3, in3);
segdecoder D4(d4, in4);
segdecoder D5(d5, in5);
segdecoder D6(d6, in6);
segdecoder D7(d7, in7);

endmodule







// seven segment decoder
module segdecoder(out,in); 
output reg [6:0] out;
input [3:0]in;
always @(in)
begin
 case(in)
 0: out = 7'b1000000;
 1: out = 7'b1111001;
 2: out = 7'b0100100;
 3: out = 7'b0110000;
 4: out = 7'b0001101;
 5: out = 7'b0100100;
 6: out = 7'b0000010;
 7: out = 7'b1111000;
 8: out = 7'b0000000;
 9: out = 7'b1000111; // to display L of OL (overload condition)
 10: out = 7'b0001000; // to display A of FA (firealarm)
 11: out = 7'b0000000;
 15: out = 7'b0001110; // to display F of FA (firealarm)
 default: out = 7'b1111111;
 endcase
end

endmodule

