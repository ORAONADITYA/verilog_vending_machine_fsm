//data path
`timescale 1ns / 1ps
module data_path (
 input clk,rst,
 input [1:0] product_in,
 input qty_in, coin_5,//user
 input ld_product,clr_product,ld_qty,clr_qty,ld_coin,clr_balance,
 input dispense_enable,
 input give_change,
 output [1:0] dispense_item,
 output [3:0] dispense_qty,
 output [7:0] change_out,
 output sufficient_bal
);
 wire [7:0] balance_out;
 wire [3:0] qty_out;
 wire [1:0] product_out;
 wire [7:0] price_out;
 product_reg PR(.clk(clk),.rst(rst),.product_in(product_in),.ld_product(ld_product),
 .clr_product(clr_product),.product_out(product_out));
 qty_reg
QR(.clk(clk),.rst(rst),.qty_in(qty_in),.ld_qty(ld_qty),.clr_qty(clr_qty),.qty_out(qty_out));
 balance_reg BR(.clk(clk),.rst(rst),.coin_5(coin_5),.ld_coin(ld_coin),
 .clr_balance(clr_balance),.balance_out(balance_out));
 price_calc
PC(.clk(clk),.rst(rst),.product_out(product_out),.qty_out(qty_out),.price_out(price_out)
);
 balance_comparator BC(.clk(clk),.rst(rst),.balance_out(balance_out),
 .price_out(price_out),.sufficient_bal(sufficient_bal));
 change_calculator
CH(.clk(clk),.rst(rst),.balance_out(balance_out),.price_out(price_out),

.change_out(change_out),.sufficient_bal(sufficient_bal),.give_change(give_change));

 dispense_product DP(.clk(clk),.rst(rst),.sufficient_bal(sufficient_bal),.product_out(product_out),.qty_out(qty_out),

.dispense_enable(dispense_enable),.dispense_item(dispense_item),.dispense_qty(dispense_qty));
endmodule
