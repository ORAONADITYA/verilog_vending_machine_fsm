//controller
`timescale 1ns / 1ps
module controller (
 input clk,rst,
 input sufficient_bal,//input from data path
 input coin_5, qty_in, buy_btn,
 input [1:0] product_in,
 output reg ld_product, ld_coin, ld_qty,
 output reg clr_product, clr_balance, clr_qty,
 output reg dispense_enable, give_change
);
 reg [2:0] state, next_state;
 parameter S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100, S5=3'b101;
 // State register
 always @(posedge clk or posedge rst) begin
 if (rst) state <= S0;
 else state <= next_state;
 end
 // Next-state and output logic (combinational)
 always @(*) begin
 // defaults - avoid latches
 ld_product=0; ld_coin=0; ld_qty=0;
 clr_product=0; clr_balance=0; clr_qty=0;
 dispense_enable=0; give_change=0;
 next_state = state;
 case (state)
 S0: begin
 if (product_in==2'b01 || product_in==2'b10) begin
 ld_product = 1'b1;
 next_state = S1;
 end
 end
 S1: begin
 if (qty_in) begin
 ld_qty = 1'b1;
 next_state = S2;
 end
 end
 S2: begin
 if (coin_5) begin
 ld_coin = 1'b1;
 end
 if (buy_btn) begin
 next_state = S3;
 end
 end
 S3: begin
 if (sufficient_bal)
 next_state = S4;
 else
 next_state = S2;
 end
 S4: begin
 dispense_enable = 1'b1;
 next_state = S5;
 end
 S5: begin
 give_change = 1'b1;
 clr_balance = 1'b1;
 clr_product = 1'b1;
 clr_qty = 1'b1;
 next_state = S0;
 end
 default: next_state = S0;
 endcase
 end
endmodule
