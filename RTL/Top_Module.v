`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/16/2025 03:01:34 AM
// Design Name: 
// Module Name: Top_Module
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


module Top_Module(
input clk,
input btnU, //reset
input btnC, //buy
input btnR, //25 cents
input btnL, //100 cents, $1
input btnD, //return change
input [7:0] sw, //first four switches for selecting the product, remiander of switches to load the product
output [7:0] led, //product purchased [3:0] and outofstock [7:4]
output [6:0] seg,
output [3:0] an);

wire [11:0] money;
wire deb_btnC, deb_btnR, deb_btnL, deb_btnD;

Debounce dbnC(clk, btnC, deb_btnC);//buy
Debounce dbnR(clk, btnR, deb_btnR);//quarter
Debounce dbnL(clk, btnL, deb_btnL);//dollar
Debounce dbnD(clk, btnD, deb_btnD);//return

wire[3:0] thos, huns, tens, ones;

Binary_to_BCD BCD(money, thos, huns, tens, ones);
Seven_Seg_Driver SSD(clk,deb_btnC, thos, huns, tens, ones, seg, an);

Vending_Machine VM(clk, btnU, deb_btnR, deb_btnL, sw[3:0], deb_btnC, sw[7:4],deb_btnD, money, led[3:0], led[7:4]);

endmodule