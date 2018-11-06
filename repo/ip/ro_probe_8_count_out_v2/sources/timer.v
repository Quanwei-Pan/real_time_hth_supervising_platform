`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/07 20:50:25
// Design Name: 
// Module Name: timer
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


module timer
#(parameter TS = 11'd1249)
(	input wire clk,
    input wire ena,
	input wire rst_n,
	output reg timer_clk,
    output reg time_up
);
        localparam HALF_TS = ( TS >> 1);  // for CLK = 125MHz
        reg [10:0] counter;
        
        initial begin
        counter = 1'b0;
        timer_clk = 1'b0;
        time_up = 1'b0;
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
      
endmodule
