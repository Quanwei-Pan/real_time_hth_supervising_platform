`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/07 18:10:43
// Design Name: 
// Module Name: ro_probe_count_out
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

module ro_probe_count_out
#(parameter PROBE_GROUP  	= 0)
(   input wire clk,
   // input wire ro_clk,
	input wire ena,
	input wire rst_n,
	input wire tready,
    input wire timer_clk,
    input wire time_up,
	input wire time_down,
    input wire count_signal,
    input wire dout_signal,
	output wire[31:0] tdata,
	output wire tvalid
);

    
	wire ro_freq;
	wire [23:0] data_tmp;
	wire [2:0] ro_ports;
    wire [7:0] ro_index;

	assign tvalid = (tready == 1'b1) ? time_down : 1'b0;
    assign tdata = {ro_index, data_tmp};
    
	pn8 #(.PROBE_GROUP(PROBE_GROUP)) inst_pn8(.ports(ro_ports), .ro_index(ro_index), .freq(ro_freq));
    //pn8_test #(PROBE_GROUP) inst_pn8(.ports(ro_ports), .ro_clk(ro_clk), .ro_index(ro_index), .freq(ro_freq));
	sm8 inst_sm8(.clk(timer_clk), .ena(ena), .rst_n(rst_n), .out(ro_ports));
	ro_counter inst_ro_counter(.clk(clk), .freq(ro_freq), .ena(ena), .rst_n(rst_n), .time_up(time_up),
		.count_signal(count_signal), .dout_signal(dout_signal), .dout(data_tmp));
	
//	always @( posedge clk or negedge rst_n) begin
//        if(!rst_n) begin
//            tdata <= {ro_index, 24'b0};
//        end
//        else if(ena  && dout_signal)
//			tdata <= {ro_index, data_tmp};
//        else 
//			tdata <= {ro_index, 24'hff_ffff};
//    end
 
endmodule
