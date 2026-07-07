//DATA_PATH_COMPONENTS
`timescale 1ns / 1ps
module product_reg (
 input clk,rst,
 input [1:0] product_in,//user
 input ld_product,clr_product,//control
 output reg[1:0] product_out
);
 always @( posedge clk or posedge rst) begin
 if(rst) product_out<=0;
 else if (clr_product) product_out<=0;
 else if (ld_product) product_out<= product_in;
 end
endmodule
// quantity of the product required
module qty_reg (
 input clk,rst,
 input qty_in,//user
 input ld_qty,clr_qty,//controller
 output reg [3:0] qty_out
);
 always @(posedge clk or posedge rst) begin
 if (rst) qty_out<=0;
 else if (clr_qty) qty_out<=0;
 else if (ld_qty) qty_out<=qty_in;
 end
endmodule
module balance_reg (
 input clk,rst,
 input coin_5,//user input
 input ld_coin,clr_balance,//controller
 output reg [7:0] balance_out
);
 always @(posedge clk or posedge rst) begin
 if (rst) balance_out<=0;
 else if (clr_balance) balance_out<=0;
 else if (ld_coin) balance_out<=balance_out+8'd5;
 end
endmodule
//price of products
module price_calc (
 input clk,rst,
 input [3:0]qty_out,
 input [1:0] product_out,
 output reg [7:0]price_out
);
 parameter A = 2'b01;
 parameter B = 2'b10;
 always @(posedge clk) begin
 if (rst) price_out<=0;
 else if (qty_out && product_out) begin
 case (product_out)
 A: price_out<=qty_out*8'b00_001_010 ;
 B: price_out<=qty_out*8'b00_001_111 ;
 default: price_out<=0;
 endcase
 end
 end
endmodule
module balance_comparator (
 input clk,rst,
 input [7:0] balance_out,
 input [7:0] price_out,
 output reg sufficient_bal
);
 always @(posedge clk or posedge rst) begin
 if (rst) sufficient_bal<=0;
 else if(balance_out && price_out)
 sufficient_bal<=(balance_out>=price_out)? 1'b1 : 1'b0 ;
 end
endmodule
module change_calculator (
 input clk,rst,
 input [7:0] balance_out,
 input [7:0] price_out,
 input give_change,
 input sufficient_bal,
 output reg [7:0] change_out
);
 always @(posedge clk or posedge rst) begin
 if(rst) begin
 change_out<=0;
 end
 else if (give_change && sufficient_bal) begin
 change_out<=balance_out-price_out;
 end
 end
endmodule
module dispense_product (
 input clk,rst,
 input sufficient_bal,
 input [1:0]product_out,
 input [3:0]qty_out,
 input dispense_enable,
 output reg [1:0]dispense_item,
 output reg [3:0]dispense_qty
);
 always @(posedge clk or posedge rst ) begin
 if (rst) begin
 dispense_item<=2'b00;
 dispense_qty<=0;
 end
 else if (dispense_enable && sufficient_bal) begin
 dispense_item<=product_out;
 dispense_qty<=qty_out;
 end
 end
endmodule