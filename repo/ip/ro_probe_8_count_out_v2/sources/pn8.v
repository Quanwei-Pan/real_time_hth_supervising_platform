`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/07 18:34:11
// Design Name: 
// Module Name: pn8
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

module pn8
#(parameter PROBE_GROUP = 0
)
(	input wire[2:0] ports,
	output wire[7:0] ro_index,
	output reg freq 
);
	
	wire [7:0] outs;
	reg [7:0] ena;
	reg [7:0] probe_num;
	
	assign ro_index = 	(PROBE_GROUP == 3'd0) ? (8'd0 + probe_num) :
                        (PROBE_GROUP == 3'd1) ? (8'd8 + probe_num) :
                        (PROBE_GROUP == 3'd2) ? (8'd16 + probe_num) :
                        (PROBE_GROUP == 3'd3) ? (8'd24 + probe_num) :
                        (PROBE_GROUP == 3'd4) ? (8'd32 + probe_num) :
                        (PROBE_GROUP == 3'd5) ? (8'd40 + probe_num) :
                        (PROBE_GROUP == 3'd6) ? (8'd48 + probe_num) :
                        (PROBE_GROUP == 3'd7) ? (8'd56 + probe_num) : 8'd0;
	

		ro_probe probe_0(.enable(ena[0]), .out(outs[0]));
		ro_probe probe_1(.enable(ena[1]), .out(outs[1]));
		ro_probe probe_2(.enable(ena[2]), .out(outs[2]));
		ro_probe probe_3(.enable(ena[3]), .out(outs[3]));
		ro_probe probe_4(.enable(ena[4]), .out(outs[4]));
		ro_probe probe_5(.enable(ena[5]), .out(outs[5]));
		ro_probe probe_6(.enable(ena[6]), .out(outs[6])); 
		ro_probe probe_7(.enable(ena[7]), .out(outs[7]));

		
	always @(*) begin
            case(ports)
                3'b000:  begin ena = 8'b0000_0001;    freq = outs[0]; probe_num = 8'd0; end
                3'b001:  begin ena = 8'b0000_0010;    freq = outs[1]; probe_num = 8'd1; end
                3'b010:  begin ena = 8'b0000_0100;    freq = outs[2]; probe_num = 8'd2; end
                3'b011:  begin ena = 8'b0000_1000;    freq = outs[3]; probe_num = 8'd3; end
                3'b100:  begin ena = 8'b0001_0000;    freq = outs[4]; probe_num = 8'd4; end
                3'b101:  begin ena = 8'b0010_0000;    freq = outs[5]; probe_num = 8'd5; end
                3'b110:  begin ena = 8'b0100_0000;    freq = outs[6]; probe_num = 8'd6; end
                3'b111:  begin ena = 8'b1000_0000;    freq = outs[7]; probe_num = 8'd7; end
                default: begin ena = 8'b0000_0000;    freq = 1'b0;    probe_num = 8'd0; end
            endcase
     end
		
endmodule

module pn8_test
#(parameter PROBE_GROUP = 3'd0
)
(   input wire[2:0] ports,
    input wire ro_clk,
    output wire[7:0] ro_index,
	output reg freq
);
	wire [7:0] ro_freq;
	
    reg [7:0] ena;	   
	reg [7:0] probe_num;
	
	assign ro_index = 	(PROBE_GROUP == 3'd0) ? (8'd0 + probe_num) :
						(PROBE_GROUP == 3'd1) ? (8'd8 + probe_num) :
						(PROBE_GROUP == 3'd2) ? (8'd16 + probe_num) :
						(PROBE_GROUP == 3'd3) ? (8'd24 + probe_num) :
						(PROBE_GROUP == 3'd4) ? (8'd32 + probe_num) :
	                    (PROBE_GROUP == 3'd5) ? (8'd40 + probe_num) :
						(PROBE_GROUP == 3'd6) ? (8'd48 + probe_num) :
	                    (PROBE_GROUP == 3'd7) ? (8'd56 + probe_num) : 8'd0;

		assign ro_freq[0] = ro_clk;
		assign ro_freq[1] = ro_clk;
		assign ro_freq[2] = ro_clk; 
		assign ro_freq[3] = ro_clk; 
		assign ro_freq[4] = ro_clk;
		assign ro_freq[5] = ro_clk; 
		assign ro_freq[6] = ro_clk;
		assign ro_freq[7] = ro_clk;
						
	always @(*) begin
		case(ports)
			3'b000: begin ena = 8'b0000_0001; freq = ro_freq[0]; probe_num = 8'd0; end
			3'b001: begin ena = 8'b0000_0010; freq = ro_freq[1]; probe_num = 8'd1; end
			3'b010: begin ena = 8'b0000_0100; freq = ro_freq[2]; probe_num = 8'd2; end
			3'b011: begin ena = 8'b0000_1000; freq = ro_freq[3]; probe_num = 8'd3; end
			3'b100: begin ena = 8'b0001_0000; freq = ro_freq[4]; probe_num = 8'd4; end
			3'b101: begin ena = 8'b0010_0000; freq = ro_freq[5]; probe_num = 8'd5; end
			3'b110: begin ena = 8'b0100_0000; freq = ro_freq[6]; probe_num = 8'd6; end
			3'b111: begin ena = 8'b1000_0000; freq = ro_freq[7]; probe_num = 8'd7; end
			default:begin ena = 8'b0000_0000; freq = 1'b0;       probe_num = 8'd0; end
		endcase
	end
		
endmodule
