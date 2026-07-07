//top
`timescale 1ns / 1ps
module top (
 input clk,rst,
 input coin_5, qty_in, buy_btn,
 input [1:0] product_in,
 output [7:0] change_out,
 output [1:0] dispense_item,
 output [3:0] dispense_qty
);
 wire sufficient_bal;
 wire give_change;
 wire ld_product, ld_coin, ld_qty;
 wire clr_product, clr_balance, clr_qty;
 wire dispense_enable;
 controller C (
 .clk(clk), .rst(rst),
 .sufficient_bal(sufficient_bal),
 .coin_5(coin_5), .product_in(product_in), .qty_in(qty_in),
 .buy_btn(buy_btn),
 .ld_product(ld_product), .ld_coin(ld_coin), .ld_qty(ld_qty),
 .clr_product(clr_product), .clr_balance(clr_balance), .clr_qty(clr_qty),
 .dispense_enable(dispense_enable),
 .give_change(give_change)
 );
 data_path DP (
 .clk(clk), .rst(rst),
 .product_in(product_in), .qty_in(qty_in), .coin_5(coin_5),
 .ld_product(ld_product), .clr_product(clr_product),
 .ld_qty(ld_qty), .clr_qty(clr_qty),
 .ld_coin(ld_coin), .clr_balance(clr_balance),
 .dispense_enable(dispense_enable),
 .give_change(give_change),
 .sufficient_bal(sufficient_bal),
 .dispense_item(dispense_item),
 .dispense_qty(dispense_qty),
 .change_out(change_out)
 );
endmodule
