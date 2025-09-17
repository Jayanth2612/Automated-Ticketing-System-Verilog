// Ticket Selection Module
module TicketSelection(
input wire RD, CLK,
input wire path_1, path_2,
input wire pri_3, pri_4, pri_5,
input wire qua_1, qua_2,
output reg [1: 0] PATH,
output reg [3: 0] COST,
output reg [1: 0] QUA,
output reg [2: 0] PRI
);
always @(posedge CLK or posedge RD) begin
if (RD) begin
PATH <= 2'b00;
COST <= 4'b0000;
QUA <= 2'b00;
PRI <= 3'b000;
end else begin
// Line selection
if (path_1) PATH <= 2'b01;
else if (path_2) PATH <= 2'b10;
// Ticket price selection
if (pri_3) PRI <= 3'b010; // Price 3
else if (pri_4) PRI <= 3'b011; // Price 4
else if (pri_5) PRI <= 3'b100; // Price 5
// Quantity selection
if (qua_1) QUA <= 2'b01;
else if (qua_2) QUA <= 2'b10;
// Calculate total cost
if (QUA != 2'b00 && PRI != 3'b000)
COST <= QUA * PRI;
else
COST <= 4'b0000; // Default to zero if invalid inputs
end
end
endmodule
// Coin Calculation Module
module CoinCalculation(
input wire RD, CLK,
input wire COIN_5, COIN_10,
output reg [3: 0] COINH, COINL,
output reg [7: 0] COIN
);
always @(posedge CLK or posedge RD) begin
if (RD) begin
COINH <= 4'b0000;
COINL <= 4'b0000;
COIN <= 8'b00000000;
end else begin
if (COIN_5) COIN <= COIN + 8'd5;
if (COIN_10) COIN <= COIN + 8'd10;
// Update the high and low digits
COINL <= COIN % 10;
COINH <= COIN / 10;
end
end
endmodule
// Change Processing Module
module ChangeProcessing(
input wire RD, CLK, FINISH,
input wire [7: 0] COIN_IN,
input wire [3:0] COST_IN,
output reg [7: 0] REST,
output reg TICKET_ISSUED
);
always @(posedge CLK or posedge RD) begin
if (RD) begin
REST <= 8'b00000000;
TICKET_ISSUED <= 1'b0;
end else if (FINISH) begin
if (COIN_IN >= COST_IN) begin
REST <= COIN_IN - COST_IN;
TICKET_ISSUED <= 1'b1;
end else begin
REST <= 8'b00000000;
TICKET_ISSUED <= 1'b0;
end
end
end
endmodule
// Display Interface Module
module DisplayInterface(
input wire [1: 0] PATH,
input wire [3: 0] COST,
input wire [7: 0] REST,
input wire [1: 0] QUA,
output reg [6: 0] SEG_DISPLAY // 7-segment display output
);
// A simple decoder to drive a 7-segment display
always @(*) begin
// Display COST on the 7-segment display
case (COST)
4'b0000: SEG_DISPLAY = 7'b1111110; // 0
4'b0001: SEG_DISPLAY = 7'b0110000; // 1
4'b0010: SEG_DISPLAY = 7'b1101101; // 2
4'b0011: SEG_DISPLAY = 7'b1111001; // 3
4'b0100: SEG_DISPLAY = 7'b0110011; // 4
4'b0101: SEG_DISPLAY = 7'b1011011; // 5
4'b0110: SEG_DISPLAY = 7'b1011111; // 6
4'b0111: SEG_DISPLAY = 7'b1110000; // 7
4'b1000: SEG_DISPLAY = 7'b1111111; // 8
4'b1001: SEG_DISPLAY = 7'b1111011; // 9
default: SEG_DISPLAY = 7'b0000000; // Blank
endcase
end
endmodule
