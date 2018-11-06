`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/11 21:44:57
// Design Name: 
// Module Name: central_controller
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


module top_central_controller
#(parameter TS = 11'd1249)
(
    input wire clk,
    input wire ena,
    input wire rst_n,          
    output wire clk_out,
    output wire ena_0, 
    output wire ena_1, 
    output wire ena_2,
    output wire ena_3, 
    output wire ena_4, 
    output wire ena_5, 
    output wire ena_6, 
    output wire ena_7,
    output wire round,
    output wire rst_n_out,
    output wire round_clk,
    output wire timer_clk,
    output wire time_up,
    output wire time_down,
    output wire count_signal,
    output wire dout_signal
);
    
  wire [7:0] ena_out;
  wire _count_signal, _dout_signal, _time_down;
  assign {ena_0, ena_1, ena_2, ena_3, ena_4, ena_5, ena_6, ena_7} = ena_out[7:0];
  assign count_signal = (ena_out != 8'b0000_0000) ? _count_signal : 1'b0 ;
   assign dout_signal = (ena_out != 8'b0000_0000) ? _dout_signal : 1'b0 ;
  assign time_down = (ena_out != 8'b0000_0000) ? _time_down : 1'b0 ;
  assign   clk_out = clk;
  assign   rst_n_out  = rst_n;
  
  sm8_gen inst_sm8(.clk(round_clk), .ena(ena), .rst_n(rst_n), .out(ena_out));
  round_gen #(TS) inst_round_gen(.clk(clk), .ena(ena), .rst_n(rst_n), 
    .round(round), .round_clk(round_clk), .time_up(time_up), .time_down(_time_down), 
    .timer_clk(timer_clk), .count_signal(_count_signal), .dout_signal(_dout_signal));
  
endmodule
