`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/11 22:16:20
// Design Name: 
// Module Name: sm8_gen
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


module sm8_gen( input wire clk,
                input wire ena,
				input wire rst_n,
				output wire[7:0] out			
);

parameter 	IDLE = 7'b000_0000, ST0 = 7'b000_0001, ST1 = 7'b000_0010,
			 ST2 = 7'b000_0100, ST3 = 7'b000_1000, ST4 = 7'b001_0000,
			 ST5 = 7'b010_0000, ST6 = 7'b100_0000;

reg [6:0] c_state, n_state;
reg [7:0] out_state;

assign out = out_state;

always @(*) begin
    if(!rst_n)
	   n_state = ST0;
	else if(ena)
	   case(c_state)
		  IDLE: n_state = ST0;
		  ST0: 	n_state = ST1;
		  ST1: 	n_state = ST2;
		  ST2: 	n_state = ST3;
		  ST3: 	n_state = ST4;
		  ST4: 	n_state = ST5;
		  ST5: 	n_state = ST6;
		  ST6: 	n_state = IDLE;
		  default:n_state = IDLE;
	   endcase
	else;
end

always @ (posedge clk or negedge rst_n) begin
	if(!rst_n)
		c_state <= IDLE;
	else if (ena)
		c_state <= n_state;
	else;
end

always @(*) begin
	if(!rst_n) 
		out_state <= 8'b0000_0000;
	else if(ena)
		case(c_state)
		  IDLE: out_state <= 8'b1000_0000;
		  ST0: 	out_state <= 8'b0100_0000;
		  ST1: 	out_state <= 8'b0010_0000;
		  ST2: 	out_state <= 8'b0001_0000;
		  ST3: 	out_state <= 8'b0000_1000;
		  ST4: 	out_state <= 8'b0000_0100;
		  ST5: 	out_state <= 8'b0000_0010;
		  ST6: 	out_state <= 8'b0000_0001;
		  default:out_state <= 8'b0000_0000;
	   endcase
	else;
end

endmodule
