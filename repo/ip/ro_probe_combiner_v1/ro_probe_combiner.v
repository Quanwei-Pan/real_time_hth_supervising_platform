`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/05/16 23:00:00
// Design Name: 
// Module Name: ro_probe_combiner
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


module ro_probe_combiner_v1_0 
(
	// Ports of Axi Slave Bus Interface S00_AXIS
	input wire [31:0] s00_axis_tdata,
	input wire  s00_axis_tvalid,
	output wire  s00_axis_tready,
	// Ports of Axi Slave Bus Interface S01_AXIS
	input wire [31:0] s01_axis_tdata,
	input wire  s01_axis_tvalid,
	output wire  s01_axis_tready,
	// Ports of Axi Slave Bus Interface S02_AXIS
	input wire [31:0] s02_axis_tdata,
	input wire  s02_axis_tvalid,
	output wire  s02_axis_tready,
	// Ports of Axi Slave Bus Interface S03_AXIS
	input wire [31:0] s03_axis_tdata,
	input wire  s03_axis_tvalid,
	output wire  s03_axis_tready,
	// Ports of Axi Slave Bus Interface S04_AXIS
	input wire [31:0] s04_axis_tdata,
	input wire  s04_axis_tvalid,
	output wire  s04_axis_tready,
	// Ports of Axi Slave Bus Interface S05_AXIS
	input wire [31:0] s05_axis_tdata,
	input wire  s05_axis_tvalid,
	output wire  s05_axis_tready,
	// Ports of Axi Slave Bus Interface S06_AXIS
	input wire [31:0] s06_axis_tdata,
	input wire  s06_axis_tvalid,
	output wire  s06_axis_tready,
	// Ports of Axi Slave Bus Interface S07_AXIS
	input wire [31:0] s07_axis_tdata,
	input wire  s07_axis_tvalid,
	output wire  s07_axis_tready,
	// Clock and reset
	input wire  aclk,
	input wire  aresetn,
	// Enable
	input wire ena_0, ena_1, ena_2, ena_3, ena_4, ena_5, ena_6, ena_7,
	// Ports of Axi Master Bus Interface M00_AXIS
	output wire  m00_axis_tvalid,
	output wire [31:0] m00_axis_tdata,
	input wire  m00_axis_tready
);

	assign m00_axis_tvalid = 	(ena_0 == 1'b1) ? s00_axis_tvalid :
								(ena_1 == 1'b1) ? s01_axis_tvalid :
								(ena_2 == 1'b1) ? s02_axis_tvalid :
								(ena_3 == 1'b1) ? s03_axis_tvalid :
								(ena_4 == 1'b1) ? s04_axis_tvalid :
								(ena_5 == 1'b1) ? s05_axis_tvalid :
								(ena_6 == 1'b1) ? s06_axis_tvalid :
								(ena_7 == 1'b1) ? s07_axis_tvalid : 1'b0;
								
	assign m00_axis_tdata = 	(ena_0 == 1'b1) ? s00_axis_tdata :
								(ena_1 == 1'b1) ? s01_axis_tdata :
								(ena_2 == 1'b1) ? s02_axis_tdata :
								(ena_3 == 1'b1) ? s03_axis_tdata :
								(ena_4 == 1'b1) ? s04_axis_tdata :
								(ena_5 == 1'b1) ? s05_axis_tdata :
								(ena_6 == 1'b1) ? s06_axis_tdata :
								(ena_7 == 1'b1) ? s07_axis_tdata : 32'b0;
								
	assign  s00_axis_tready = m00_axis_tready;
	assign	s01_axis_tready = m00_axis_tready;
	assign	s02_axis_tready = m00_axis_tready;
	assign	s03_axis_tready = m00_axis_tready;
	assign	s04_axis_tready = m00_axis_tready;
	assign	s05_axis_tready = m00_axis_tready;
	assign	s06_axis_tready = m00_axis_tready;
	assign	s07_axis_tready = m00_axis_tready;
	
endmodule
