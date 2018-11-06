`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/11 21:46:05
// Design Name: 
// Module Name: round_gen
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

module round_gen
#(parameter TS = 11'd1249)
(   input wire clk,
    input wire ena,
	input wire rst_n,
	output wire round,
	output reg round_clk,
	output wire time_up,
	output wire time_down,
	output wire timer_clk,
	output wire count_signal,
	output wire dout_signal
);

    reg round_stp;
    reg [3:0] counter;
    reg count_signal_0, count_signal_1;
    wire _time_up, _time_down;
    
    initial round_clk <= 1'b0;
    
    assign dout_signal = count_signal_0 ^ count_signal_1;
    assign count_signal  = ~dout_signal;
    assign round = (round_stp == 1'b1) ? time_up : 1'b0;
    assign time_up = _time_up;
    assign time_down = _time_down;
    
    _timer_ #(TS) inst_timer(.clk(clk), .ena(ena), .rst_n(rst_n), .timer_clk(timer_clk), .time_up(_time_up), .time_down(_time_down));
   
    always @(posedge timer_clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 1'b0;
        else if(ena && counter == 4'd7) 
            counter <= 1'b0;
        else if(ena)
            counter <= counter + 1'b1;
        else if(!ena)
            counter <= 1'b0;
        else; 
    end
    
    always @(posedge timer_clk or negedge rst_n) begin
        if (!rst_n)
            round_clk <= 1'b0;
        else if(ena && counter == 4'd4)
            round_clk <= ~round_clk;          
        else if(ena && counter == 4'd0)
            round_clk <= ~round_clk;
        else if(!ena)
            round_clk <= 1'b0;
        else;
    end
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            round_stp <= 1'b0;
        else if(ena && counter == 4'd0)
            round_stp <= 1'b1;
        else if(!ena)
            round_stp <= 1'b0;
        else
            round_stp <= 1'b0;
    end
    
    always @(negedge _time_up or negedge rst_n) begin
        if(!rst_n)
            count_signal_0 <= 1'b0;
        else
            count_signal_0 <= count_signal_0 + 1'b1;
    end
    
    always @(posedge _time_down or negedge rst_n) begin
        if(!rst_n)
            count_signal_1 <= 1'b0;
        else
            count_signal_1 <= count_signal_1 + 1'b1;
    end
    
endmodule

module _timer_
#(parameter TS = 11'd1249)
(	input wire clk,
    input wire ena,
	input wire rst_n,
	output reg timer_clk,
    output reg time_up,
	output reg time_down
);
        localparam HALF_TS = ( TS >> 1);  // for CLK = 125MHz
        reg [10:0] counter;
        
        initial begin
        counter = 1'b0;
        timer_clk = 1'b0;
        time_up = 1'b0;
		time_down = 1'b0;
        end
        
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n)
                counter <= 1'b0;
            else if(ena && counter == TS) 
                counter <= 1'b0;
            else if(ena)
                counter <= counter + 1'b1;
            else if(!ena)
                counter <= 1'b0;
            else; 
        end
        
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n)
                timer_clk <= 1'b0;
            else if(ena && counter == HALF_TS)
                timer_clk <= ~timer_clk;          
            else if(ena && counter == TS)
                timer_clk <= ~timer_clk;
            else if(!ena)
                timer_clk <= 1'b0;
            else; 
        end
        
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n)
                time_up <= 1'b0;
            else if(ena && counter == HALF_TS)
                time_up <= 1'b1;
            else if(!ena)
                time_up <= 1'b0;
            else
                time_up <= 1'b0;
        end
		
		always @(posedge clk or negedge rst_n) begin
            if (!rst_n)
                time_down <= 1'b0;
            else if(ena && counter == (HALF_TS - 10))
                time_down <= 1'b1;
            else if(!ena)
                time_down <= 1'b0;
            else
                time_down <= 1'b0;
        end
      
endmodule
