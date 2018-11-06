`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/06/07 18:14:46
// Design Name: 
// Module Name: sm8
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


module sm8(  	input wire clk,
                input wire ena,
				input wire rst_n,
				output reg[2:0] out			
);

parameter 	IDLE = 3'b000, ST0 = 3'b001, ST1 = 3'b010,
			 ST2 = 3'b011, ST3 = 3'b100, ST4 = 3'b101,
			 ST5 = 3'b110, ST6 = 3'b111;

reg [2:0] c_state, n_state;

always @(c_state or rst_n) begin
    if(!rst_n)
	   n_state = ST0;
	else 
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
		out <= IDLE;
	else
		case(c_state)
		  IDLE: out <= IDLE;
		  ST0: 	out <= ST0;
		  ST1: 	out <= ST1;
		  ST2: 	out <= ST2;
		  ST3: 	out <= ST3;
		  ST4: 	out <= ST4;
		  ST5: 	out <= ST5;
		  ST6: 	out <= ST6;
		  default:out <= IDLE;
	   endcase
end

endmodule
