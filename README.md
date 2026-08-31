**Verilog Vending Machine**

A simple FSM-based vending machine controller and datapath, written in Verilog. The design lets a user pick a product, choose a quantity, insert 5-unit coins, and press "buy" — the machine checks the balance, dispenses the product, and returns change.

**Features**
Product selection (Product A or Product B) with configurable per-unit pricing
Quantity entry
Coin insertion in fixed 5-unit increments
Automatic balance-vs-price comparison
Product dispensing once balance is sufficient
Change calculation and return
Clean separation between control logic (FSM) and datapath (registers/arithmetic)
Architecture

**The design follows a classic FSM + Datapath split:**

controller.v — A Moore-style finite state machine that sequences the transaction and drives all datapath control signals (ld_*, clr_*, dispense_enable, give_change).
data_path.v — Wires together the individual datapath components into a single module.
data_path_components.v — The datapath building blocks:
product_reg — latches the selected product
qty_reg — latches the requested quantity
balance_reg — accumulates inserted coins (+5 per coin)
price_calc — computes total price from product + quantity
balance_comparator — flags whether balance ≥ price
change_calculator — computes change to return (balance − price)
dispense_product — latches the dispensed item and quantity
top.v — Top-level module that instantiates controller and data_path and connects them.
vending_tb.v — Testbench that drives a full purchase sequence for two products and monitors key signals.

**FSM States**

State	Name	Behavior
S0	        Idle / Select Product	Waits for a valid product_in (A or B), loads it, moves to S1
S1         	Select Quantity	Waits for qty_in, loads it, moves to S2
S2        	Insert Coins	Accepts coin_5 pulses to accumulate balance; waits for buy_btn to proceed to S3
S3        	Check Balance	Moves to S4 if sufficent_bal, otherwise back to S2 to insert more coins
S4        	Dispense	Asserts dispense_enable, moves to S5
S5	        Change & Reset	Asserts give_change, clears balance/product/quantity registers, returns to S0


**Pricing**
Set in price_calc (data_path_components.v):

Product A: 10 units per item (8'b00_001_010 = 10)
Product B: 15 units per item (8'b00_001_111 = 15)
Total price = unit price × quantity
Coins are inserted in increments of 5 units (coin_5).

**Simulation**


The testbench (vending_tb.v) exercises two full purchase cycles:

Selects Product A, quantity of 1, inserts 5 coins (25 units), presses buy, waits for dispense/change.
Resets, selects Product B, quantity of 1, inserts 6 coins (30 units), presses buy, waits for dispense/change
