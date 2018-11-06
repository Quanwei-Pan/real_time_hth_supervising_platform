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

entity tb_mixcolumns is
end entity tb_mixcolumns;

architecture behavior of tb_mixcolumns is

	component mixcolumns
		port(clk        : in  std_logic;
			 reset_n    : in  std_logic;
			 enable     : in  std_logic;
			 data_in    : in  std_logic_vector(127 downto 0);
			 data_out   : out std_logic_vector(127 downto 0);
			 reg_enable : in  std_logic);
	end component mixcolumns;

	--Inputs
	signal d_in : std_logic_vector(127 downto 0) := (others => '0');
	signal clk : std_logic;
	signal reset_n : std_logic;
	signal en 	: std_logic;
	signal reg_enable 	: std_logic;

	--Outputs
	signal d_out : std_logic_vector(127 downto 0);

begin

	uut: mixcolumns
		port map(
			clk      => clk,
			reset_n  => reset_n,
			enable   => en,
			data_in  => d_in,
			data_out => d_out,
			reg_enable => reg_enable
		);

stim_proc: process
begin
	--Data from http://ece-research.unm.edu/jimp/HOST/DES_AES_VHDL/AESvhdl.pdf
	d_in <= x"6353e08c0960e104cd70b751bacad0e7";
	reset_n<='1';
	reg_enable<='1';
	en<='1';
	clk<='0';
	wait for 10 ns;
	clk<='1';
	wait for 10 ns;
	assert d_out = x"5f72641557f5bc92f7be3b291db9f91a" report "failure" severity failure;
	en<='0';
	clk<='0';
	wait for 10 ns;
	clk<='1';
	wait for 10 ns;
	assert d_out = x"6353e08c0960e104cd70b751bacad0e7" report "failure" severity failure;
	reset_n<='0';
	wait for 10 ns;
	assert d_out = (d_out'range=>'0') report "failure" severity failure;

	wait;

end process;

end;
