--Copyright (c) 2016, Alexandre Schnegg
--
--All rights reserved.
--
--Redistribution and use in source and binary forms, with or without
--modification, are permitted provided that the following conditions are met:
--
--1. Redistributions of source code must retain the above copyright notice, this
--   list of conditions and the following disclaimer.
--2. Redistributions in binary form must reproduce the above copyright notice,
--   this list of conditions and the following disclaimer in the documentation
--   and/or other materials provided with the distribution.
--
--THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
--ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
--WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
--DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
--ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
--(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
--LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
--ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
--(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
--SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity aes_ip_v1_0 is
	generic (
		-- Users to add parameters here

		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 4;

		-- Parameters of Axi Master Bus Interface M00_AXIS
		C_M00_AXIS_TDATA_WIDTH	: integer	:= 128;
		C_M00_AXIS_START_COUNT	: integer	:= 32;

		-- Parameters of Axi Slave Bus Interface S00_AXIS
		C_S00_AXIS_TDATA_WIDTH	: integer	:= 128
	);
	port (
		-- Users to add ports here
		
		m00_axis_tkeep: out std_logic_vector(15 downto 0);
		s00_axis_tkeep: in std_logic_vector(15 downto 0);

		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic;

		-- Ports of Axi Master Bus Interface M00_AXIS
		m00_axis_aclk	: in std_logic;
		m00_axis_aresetn	: in std_logic;
		m00_axis_tvalid	: out std_logic;
		m00_axis_tdata	: out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
		m00_axis_tstrb	: out std_logic_vector((C_M00_AXIS_TDATA_WIDTH/8)-1 downto 0);
		m00_axis_tlast	: out std_logic;
		m00_axis_tready	: in std_logic;

		-- Ports of Axi Slave Bus Interface S00_AXIS
		s00_axis_aclk	: in std_logic;
		s00_axis_aresetn	: in std_logic;
		s00_axis_tready	: out std_logic;
		s00_axis_tdata	: in std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0);
		s00_axis_tstrb	: in std_logic_vector((C_S00_AXIS_TDATA_WIDTH/8)-1 downto 0);
		s00_axis_tlast	: in std_logic;
		s00_axis_tvalid	: in std_logic
	);

end aes_ip_v1_0;

architecture arch_imp of aes_ip_v1_0 is

	-- component declaration
	component aes_ip_v1_0_S00_AXI
		generic(C_S_AXI_DATA_WIDTH : integer := 32;
			    C_S_AXI_ADDR_WIDTH : integer := 4);
		port(key           : out std_logic_vector(127 downto 0);
			 load_key      : out std_logic;
			 encrypt       : out std_logic;
			 key_ready     : in  std_logic;
			 dmatest       : out std_logic;
			 S_AXI_ACLK    : in  std_logic;
			 S_AXI_ARESETN : in  std_logic;
			 S_AXI_AWADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
			 S_AXI_AWPROT  : in  std_logic_vector(2 downto 0);
			 S_AXI_AWVALID : in  std_logic;
			 S_AXI_AWREADY : out std_logic;
			 S_AXI_WDATA   : in  std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
			 S_AXI_WSTRB   : in  std_logic_vector((C_S_AXI_DATA_WIDTH / 8) - 1 downto 0);
			 S_AXI_WVALID  : in  std_logic;
			 S_AXI_WREADY  : out std_logic;
			 S_AXI_BRESP   : out std_logic_vector(1 downto 0);
			 S_AXI_BVALID  : out std_logic;
			 S_AXI_BREADY  : in  std_logic;
			 S_AXI_ARADDR  : in  std_logic_vector(C_S_AXI_ADDR_WIDTH - 1 downto 0);
			 S_AXI_ARPROT  : in  std_logic_vector(2 downto 0);
			 S_AXI_ARVALID : in  std_logic;
			 S_AXI_ARREADY : out std_logic;
			 S_AXI_RDATA   : out std_logic_vector(C_S_AXI_DATA_WIDTH - 1 downto 0);
			 S_AXI_RRESP   : out std_logic_vector(1 downto 0);
			 S_AXI_RVALID  : out std_logic;
			 S_AXI_RREADY  : in  std_logic);
	end component aes_ip_v1_0_S00_AXI;
	
	component aes_ip_v1_0_M00_AXIS
		generic(C_M_AXIS_TDATA_WIDTH : integer := 32;
			    C_M_START_COUNT      : integer := 32);
		port(M_AXIS_TKEEP   : out std_logic_vector(15 downto 0);
			 M_AXIS_ACLK    : in  std_logic;
			 M_AXIS_ARESETN : in  std_logic;
			 M_AXIS_TVALID  : out std_logic;
			 M_AXIS_TDATA   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH - 1 downto 0);
			 M_AXIS_TSTRB   : out std_logic_vector((C_M_AXIS_TDATA_WIDTH / 8) - 1 downto 0);
			 M_AXIS_TLAST   : out std_logic;
			 M_AXIS_TREADY  : in  std_logic);
	end component aes_ip_v1_0_M00_AXIS;

	component aes_ip_v1_0_S00_AXIS
		generic(C_S_AXIS_TDATA_WIDTH : integer := 32);
		port(S_AXIS_TKEEP   : in  std_logic_vector(15 downto 0);
			 S_AXIS_ACLK    : in  std_logic;
			 S_AXIS_ARESETN : in  std_logic;
			 S_AXIS_TREADY  : out std_logic;
			 S_AXIS_TDATA   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH - 1 downto 0);
			 S_AXIS_TSTRB   : in  std_logic_vector((C_S_AXIS_TDATA_WIDTH / 8) - 1 downto 0);
			 S_AXIS_TLAST   : in  std_logic;
			 S_AXIS_TVALID  : in  std_logic);
	end component aes_ip_v1_0_S00_AXIS;
	
	component aes_core
		port(clk       : in  std_logic;
			 reset_n   : in  std_logic;
			 encrypt   : in  std_logic;
			 data_in   : in  std_logic_vector(127 downto 0);
			 load_key  : in  std_logic;
			 key       : in  std_logic_vector(127 downto 0);
			 key_ready : out std_logic;
			 data_out  : out std_logic_vector(127 downto 0);
			 enable    : in  std_logic);
	end component aes_core;
	
	component aes_control_unit
		port(dma_test      : in  std_logic;
			 clk           : in  std_logic;
			 reset_n       : in  std_logic;
			 tdata_in_aes  : in  std_logic_vector(127 downto 0);
			 tdata_in_test : in  std_logic_vector(127 downto 0);
			 tvalid_in     : in  std_logic;
			 tready_in     : in  std_logic;
			 tsrtb_in      : in  std_logic_vector(15 downto 0);
			 tlast_in      : in  std_logic;
			 tkeep_in      : in  std_logic_vector(15 downto 0);
			 enable_core   : out std_logic;
			 tvalid_out    : out std_logic;
			 tdata_out     : out std_logic_vector(127 downto 0);
			 tready_out    : out std_logic;
			 tsrtb_out     : out std_logic_vector(15 downto 0);
			 tlast_out     : out std_logic;
			 tkeep_out     : out std_logic_vector(15 downto 0));
	end component aes_control_unit;
	
    signal data_out:std_logic_vector(127 downto 0);
    signal key:std_logic_vector(127 downto 0);
    signal load_key:std_logic;
    signal encrypt:std_logic;
    signal key_ready:std_logic;
    signal dmatest : std_logic;
    signal enable_core: std_logic;
    
    function reverseBytes (input: in std_logic_vector(127 downto 0)) return std_logic_vector(127 downto 0) is
		  variable output: std_logic_vector(127 downto 0);
	begin
		  for i in 1 to 16 loop
		    output((i*8)-1 downto (i-1)*8) := input(((17-i)*8)-1 downto ((17-i)-1)*8);
		  end loop;
		  return output;
	end;
	
begin

-- Instantiation of Axi Bus Interface S00_AXI
aes_ip_v1_0_S00_AXI_inst : aes_ip_v1_0_S00_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready,
		key				=> key,
		load_key		=> load_key,
		encrypt			=> encrypt,
		key_ready		=> key_ready,
		dmatest			=> dmatest
	);

-- Instantiation of Axi Bus Interface M00_AXIS
aes_ip_v1_0_M00_AXIS_inst : aes_ip_v1_0_M00_AXIS
	generic map (
		C_M_AXIS_TDATA_WIDTH	=> C_M00_AXIS_TDATA_WIDTH,
		C_M_START_COUNT	=> C_M00_AXIS_START_COUNT
	)
	port map (
		M_AXIS_ACLK	=> m00_axis_aclk,
		M_AXIS_ARESETN	=> m00_axis_aresetn,
		M_AXIS_TVALID	=> m00_axis_tvalid,
		M_AXIS_TDATA	=> m00_axis_tdata,
		M_AXIS_TSTRB	=> m00_axis_tstrb,
		M_AXIS_TLAST	=> m00_axis_tlast,
		M_AXIS_TREADY	=> m00_axis_tready,
		M_AXIS_TKEEP	=> m00_axis_tkeep
	);

-- Instantiation of Axi Bus Interface S00_AXIS
aes_ip_v1_0_S00_AXIS_inst : aes_ip_v1_0_S00_AXIS
	generic map (
		C_S_AXIS_TDATA_WIDTH	=> C_S00_AXIS_TDATA_WIDTH
	)
	port map (
		S_AXIS_ACLK	=> s00_axis_aclk,
		S_AXIS_ARESETN	=> s00_axis_aresetn,
		S_AXIS_TREADY	=> s00_axis_tready,
		S_AXIS_TDATA	=> s00_axis_tdata,
		S_AXIS_TSTRB	=> s00_axis_tstrb,
		S_AXIS_TLAST	=> s00_axis_tlast,
		S_AXIS_TVALID	=> s00_axis_tvalid,
		S_AXIS_TKEEP	=> s00_axis_tkeep
	);

	-- Add user logic here
	
	aes_core_inst : aes_core
        port map (
            key             => key,
            load_key        => load_key,
            encrypt         => encrypt,
            key_ready       => key_ready,
            clk             => s00_axis_aclk,
            reset_n         => s00_axis_aresetn,
            data_in         => reverseBytes(s00_axis_tdata),
            data_out        => data_out,
            enable			=> enable_core
        );
        
    aes_control_unit_inst: component aes_control_unit
    	port map(
    		dma_test      => dmatest,
    		clk           => s00_axis_aclk,
    		reset_n       => s00_axis_aresetn,
    		tdata_in_aes  => reverseBytes(data_out),
    		tdata_in_test => s00_axis_tdata,
    		tvalid_in     => s00_axis_tvalid,
    		tready_in     => m00_axis_tready,
    		tsrtb_in      => s00_axis_tstrb,
    		tlast_in      => s00_axis_tlast,
    		tkeep_in      => s00_axis_tkeep,
    		enable_core   => enable_core,
    		tvalid_out    => m00_axis_tvalid,
    		tdata_out     => m00_axis_tdata,
    		tready_out    => s00_axis_tready,
    		tsrtb_out     => m00_axis_tstrb,
    		tlast_out     => m00_axis_tlast,
    		tkeep_out     => m00_axis_tkeep
    	);
        
	-- User logic ends

end arch_imp;
