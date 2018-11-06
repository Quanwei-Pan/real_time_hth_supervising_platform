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

entity tb_aes_control_unit is
end entity tb_aes_control_unit;

architecture behavior of tb_aes_control_unit is

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

	--Inputs
	signal clk : std_logic;
	signal reset_n : std_logic;
	signal dma_test : std_logic;
	signal tdata_in_aes : std_logic_vector(127 downto 0);
	signal tdata_in_test : std_logic_vector(127 downto 0);
	signal tvalid_in : std_logic;
	signal tready_in : std_logic;
	signal tsrtb_in : std_logic_vector(15 downto 0);
	signal tkeep_in : std_logic_vector(15 downto 0);
	signal tlast_in : std_logic;
	
	--Outputs
	signal enable_core : std_logic;
	signal tvalid_out : std_logic;
	signal tdata_out : std_logic_vector(127 downto 0);
	signal tready_out : std_logic;
	signal tsrtb_out : std_logic_vector(15 downto 0);
	signal tkeep_out : std_logic_vector(15 downto 0);
	signal tlast_out : std_logic;
	
begin

	core:component aes_control_unit
		port map(
			dma_test      => dma_test,
			clk           => clk,
			reset_n       => reset_n,
			tdata_in_aes  => tdata_in_aes,
			tdata_in_test => tdata_in_test,
			tvalid_in     => tvalid_in,
			tready_in     => tready_in,
			tsrtb_in      => tsrtb_in,
			tlast_in      => tlast_in,
			tkeep_in      => tkeep_in,
			enable_core   => enable_core,
			tvalid_out    => tvalid_out,
			tdata_out     => tdata_out,
			tready_out    => tready_out,
			tsrtb_out     => tsrtb_out,
			tlast_out     => tlast_out,
			tkeep_out     => tkeep_out
		);

	stim_proc: process
	begin
		reset_n<='0';
		wait for 10 ns;
		dma_test<='1';
		tvalid_in<='0';
		tdata_in_aes<=(others=>'0');
		tdata_in_test<=(others=>'0');
		tkeep_in<=(others=>'0');
		tsrtb_in<=(others=>'0');
		tlast_in<='0';
		reset_n<='1';
		tready_in<='0';
		clk<='0';
		wait for 10 ns;
		
		clk<='1';
		wait for 10 ns;
		clk<='0';
		wait for 10 ns;
		tvalid_in<='1';
		tdata_in_aes<=(others=>'1');
		tdata_in_test<=(others=>'1');
		tkeep_in<=(others=>'1');
		tsrtb_in<=(others=>'1');
		tlast_in<='1';
		
		for i in 1 to 60 loop
			clk<='1';
			wait for 10 ns;
			clk<='0';
			wait for 10 ns;
		end loop;
		
		assert tdata_out = (tdata_out'range=>'0') report "failure" severity failure;
		assert tkeep_out = (tkeep_out'range=>'0') report "failure" severity failure;
		assert tsrtb_out = (tsrtb_out'range=>'0') report "failure" severity failure;
		assert tlast_out = '0' report "failure" severity failure;
		assert tready_out = '0' report "failure" severity failure;
		assert tvalid_out = '0' report "failure" severity failure;
		
		clk<='1';
		wait for 10 ns;
		clk<='0';
		wait for 10 ns;
		
		assert tdata_out = (tdata_out'range=>'1') report "failure" severity failure;
		assert tkeep_out = (tkeep_out'range=>'1') report "failure" severity failure;
		assert tsrtb_out = (tsrtb_out'range=>'1') report "failure" severity failure;
		assert tlast_out = '1' report "failure" severity failure;
		assert tvalid_out = '1' report "failure" severity failure;
		
		clk<='1';
		wait for 10 ns;
		clk<='0';
		wait for 10 ns;
		
		wait;
	
	
	end process;

end;
