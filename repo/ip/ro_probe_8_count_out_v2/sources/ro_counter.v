`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/07 19:07:48
// Design Name: 
// Module Name: ro_counter
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


module  ro_counter(	input wire clk,
					input wire freq,
					input wire ena,
					input wire rst_n,
                    input wire time_up,
                    //input wire time_down,
					input wire count_signal,
					input wire dout_signal,
					output wire [23:0] dout
	);
	
	(*DONT_TOUCH="TRUE"*) reg [23:0] counter;	
	assign dout = (dout_signal == 1'b1) ? counter : 24'b0;
	always @(posedge freq or negedge rst_n) begin
		if (!rst_n) begin
            counter <= 24'b0;
        end
		else if (ena && count_signal)
			    counter <= counter + 1'b1;
		else if(time_up == 1'b1)
                counter <= 24'b0;
		else;
	end
	
//	always @(posedge clk or negedge rst_n) begin
//		if(!rst_n)
//		    dout <= 24'b0;
//		else if(dout_signal == 1'b1)
//			dout <= counter;
//		else;
////			dout <= 24'b0;
//	end
	
endmodule
