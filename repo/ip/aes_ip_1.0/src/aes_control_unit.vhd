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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity aes_control_unit is
	port (
		dma_test : in std_logic;
		clk : in std_logic;
		reset_n: in std_logic;
		tdata_in_aes: in std_logic_vector(127 downto 0);
		tdata_in_test: in std_logic_vector(127 downto 0);
		tvalid_in: in std_logic;
		tready_in: in std_logic;
		tsrtb_in: in std_logic_vector(15 downto 0);
		tlast_in: in std_logic;
		tkeep_in: in std_logic_vector(15 downto 0);
		enable_core: out std_logic;
		tvalid_out:out std_logic;
		tdata_out:out std_logic_vector(127 downto 0);
		tready_out:out std_logic;
		tsrtb_out:out std_logic_vector(15 downto 0);
		tlast_out:out std_logic;
		tkeep_out:out std_logic_vector(15 downto 0)
	);
	
end entity aes_control_unit;

architecture Behavioral of aes_control_unit is
	
	type fifo_memory_type1 is array (60 downto 0) of std_logic_vector(15 downto 0);
	type fifo_memory_type2 is array (60 downto 0) of std_logic_vector(127 downto 0);

	signal tlast_reg : std_logic_vector(60 downto 0);
	signal tvalid_reg : std_logic_vector(60 downto 0);
	signal tkeep_reg : fifo_memory_type1;
	signal tsrtb_reg : fifo_memory_type1;
	signal tdata_test_reg : fifo_memory_type2;	
begin
	
	shift_reg : process(reset_n,clk,tready_in) is
	begin
		if reset_n='0' then
			tlast_reg<=(others=>'0');
			tvalid_reg<=(others=>'0');
			tkeep_reg<=(others => (others => '0'));
			tsrtb_reg<=(others => (others => '0'));
			tdata_test_reg<=(others => (others => '0'));
		elsif rising_edge(clk) then
			if tready_in='1' then
				tlast_reg <= tlast_in & tlast_reg(tlast_reg'left downto 1);
				tvalid_reg <= tvalid_in & tvalid_reg(tvalid_reg'left downto 1);
				tkeep_reg <= tkeep_in & tkeep_reg(tkeep_reg'left downto 1);
				tsrtb_reg <= tsrtb_in & tsrtb_reg(tsrtb_reg'left downto 1);
				tdata_test_reg <= tdata_in_test & tdata_test_reg(tdata_test_reg'left downto 1);
			end if;
		end if;
	end process shift_reg;
	
	tlast_out<=tlast_reg(0);
	tvalid_out<=tvalid_reg(0);
	tkeep_out<=tkeep_reg(0);
	tsrtb_out<=tsrtb_reg(0);
	
	enable_core<=tready_in;
	tready_out<=tready_in;
	
	tdata_out<=tdata_test_reg(0) when dma_test='1' else tdata_in_aes;

end Behavioral;
