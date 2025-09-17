module Tcs_tb;
// Signals for TicketSelection
reg RD, CLK;
reg path_1, path_2;
reg pri_3, pri_4, pri_5;
reg qua_1, qua_2;
wire [1: 0] PATH;
wire [3: 0] COST;
wire [1: 0] QUA;
wire [2: 0] PRI;
// Signals for CoinCalculation
reg COIN_5, COIN_10;
wire [3: 0] COINH, COINL;
wire [7: 0] COIN;
// Signals for ChangeProcessing
reg FINISH;
wire [7: 0] REST;
wire TICKET_ISSUED;
// Signals for DisplayInterface
wire [6: 0] SEG_DISPLAY;
// Instantiate the modules
TicketSelection ticketSelection(
.RD(RD),
.CLK(CLK),
.path_1(path_1),
.path_2(path_2),
.pri_3(pri_3),
.pri_4(pri_4),
.pri_5(pri_5),
.qua_1(qua_1),
.qua_2(qua_2),
.PATH(PATH),
.COST(COST),
.QUA(QUA),
.PRI(PRI)
);
CoinCalculation coinCalculation(
.RD(RD),
.CLK(CLK),
.COIN_5(COIN_5),
.COIN_10(COIN_10),
.COINH(COINH),
.COINL(COINL),
.COIN(COIN)
);
ChangeProcessing changeProcessing(
.RD(RD),
.CLK(CLK),
.FINISH(FINISH),
.COIN_IN(COIN),
.COST_IN(COST),
.REST(REST),
.TICKET_ISSUED(TICKET_ISSUED)
);
DisplayInterface displayInterface(
.PATH(PATH),
.COST(COST),
.REST(REST),
.QUA(QUA),
.SEG_DISPLAY(SEG_DISPLAY)
);
// Clock generation
always begin
#5 CLK = ~CLK; // Toggle CLK every 5 time units
end
initial begin
// Initialization
CLK = 0;
RD = 1; // Reset
path_1 = 0; path_2 = 0;
pri_3 = 0; pri_4 = 0; pri_5 = 0;
qua_1 = 0; qua_2 = 0;
COIN_5 = 0; COIN_10 = 0;
FINISH = 0;
// Release reset
#10 RD = 0;
// Test Case 1: Select path_2, pri_4, qua_1, insert 10 coins
#10 path_2 = 1; // Select path_2
#10 path_2 = 0; pri_4 = 1; // Select price 4
#10 pri_4 = 0; qua_1 = 1; // Select quantity 1
#10 qua_1 = 0; COIN_10 = 1; // Insert 10 coins
#10 COIN_10 = 0; FINISH = 1; // Finish transaction
#10 FINISH = 0;
// Test Case 1: Select path_1, pri_3, qua_2, insert 25 coins
#10 path_1 = 1;
#10 path_1 = 0; pri_3 = 1;
#10 pri_3 = 0; qua_2 = 1;
#10 qua_2 = 0; COIN_5 = 1;
#10 COIN_5 = 0; COIN_5 = 1;
#10 COIN_5 = 0; COIN_5 = 1;
#10 COIN_5 = 0; COIN_10 = 1;
#10 COIN_10 = 0; FINISH = 1;
#10 FINISH = 0;
// Wait for a bit before stopping the simulation
#30 $stop;
// End of simulation
#30 $stop;
end
endmodule
