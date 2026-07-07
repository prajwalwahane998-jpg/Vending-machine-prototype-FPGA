`timescale 1ns / 1ps



module Vending_Machine(
input clk, //Basys 3 Board Clock, 100 MHz
input reset,
input quarter,//25 cents
input dollar,//100 cents
input [3:0] select, //select the product/item from stock, we'll carry 4 trays in this machine, 
//one each for each product, each tray can carry upto 15 items
input buy, //buying product
input [3:0] load, //load means, load tray, stock items when you run out, (A total of 15 items/product)
 input return_money,
output reg [11:0] money = 0, //money that will be withdrawn from the vending machine
output reg [3:0] products=0, // product that is being dispensed ([1]25 cents for gum, [2]75 cents for chocolates,
//[3] 150 cents ($1.5) for bag of chips, and [4] 200 cents ($2) for a drink)
output reg [3:0] out_of_stock=0 //initially vending machine is full of stock
);

reg quarter_prev, dollar_prev;
reg buy_prev;
//initially the stock is full
reg [3:0] stock0=4'b1111; //each tray will carry upto 15 items, product 0 (gum), 25cents
reg [3:0] stock1=4'b1111; //each tray will carry upto 15 items, product 1 (chocolate), 75 cents
reg [3:0] stock2=4'b1111; //each tray will carry upto 15 items, product 2 (chips), $1.5
reg [3:0] stock3=4'b1111; //each tray will carry upto 15 items, product 3 (drinks), $2

always@(posedge clk)
begin
quarter_prev <=quarter;
dollar_prev <=dollar;
buy_prev <=buy;

if (reset==1)//make the display on the segment set to zero
money<=1'b0;

else if (quarter_prev == 1'b0 && quarter==1'b1) //If quarter is inserted
money<=money+12'd25; //money inserted increases by 25 cents

else if (dollar_prev ==1'b0 && dollar==1'b1) //If dollar bill is inserted
money<=money+12'd100; //money inserted increases by 100 cents

else if (return_money == 1'b1)
    money <= 12'd0; // Clear stored money

else if (buy_prev ==1'b0 && buy==1'b1) //If money has been deposited, user likes to buy a product


//here we code for what product needs to be dispensed, money that needs to be return, and updating #items in stock
case (select)

4'b0001: //user likes to buy a gum

if (money>=12'd25 && stock0>0)
begin
products[0] <=1'b1; //product is despensed if above statement is true
stock0<=stock0-1'b1; //means now we have 15-1 = 14 gums available in the machine
money<=money-12'd25; //machine withdraws price of the product from the total money/credit
end

4'b0010: //user likes to buy a chocolate, 75 cents

if (money>=12'd75 && stock1>0)
begin
products[1] <=1'b1; //product is despensed if above statement is true
stock1<=stock1-1'b1; //means now we have 15-1 = 14 chocolates available in the machine
money<=money-12'd75; //machine withdraws price of the product from the total money/credit
end

4'b0100: //user likes to buy a chips

if (money>=12'd150 && stock2>0)
begin
products[2] <=1'b1; //product is despensed if above statement is true
stock2<=stock2-1'b1; //means now we have 15-1 = 14 chips available in the machine
money<=money-12'd150; //machine withdraws price of the product from the total money/credit
end

4'b1000: //user likes to buy a drink
if (money>=12'd200 && stock3>0)
begin
products[3] <=1'b1; //product is despensed if above statement is true
stock3<=stock3-1'b1; //means now we have 15-1 = 14 drinks available in the machine
money<=money-12'd200; //machine withdraws price of the product from the total money/credit
end

endcase

else if (buy_prev ==1'b1 && buy ==1'b0) //If user doesn't hit the buy button then no product is dispensed
begin
products [0] <=1'b0;
products [1] <=1'b0;
products [2] <=1'b0;
products [3] <=1'b0;
end

////items in [3:0]stock run out, [3:0]out of stock led goes high
else begin
if (stock0==4'b0000)
out_of_stock[0]<=1'b1; 
else out_of_stock[0] <=1'b0;

if (stock1==4'b0000)
out_of_stock[1]<=1'b1;
else out_of_stock[1] <=1'b0;

if (stock2==4'b0000)
out_of_stock[2]<=1'b1;
else out_of_stock[2] <=1'b0;

if (stock3==4'b0000)
out_of_stock[3]<=1'b1;
else out_of_stock[3] <=1'b0;

///if product 0 is being stocked, when refilling the items in the stock, #items in stock changes to 15
case (load) 
4'b0001: stock0<=4'b1111;//15
4'b0010: stock1<=4'b1111;
4'b0100: stock2<=4'b1111;
4'b1000: stock3<=4'b1111;
endcase
end
end

endmodule
