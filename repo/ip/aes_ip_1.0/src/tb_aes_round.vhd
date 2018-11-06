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

entity tb_aes_round is
end entity tb_aes_round;

architecture behavior of tb_aes_round is

	component aes_round
		port(encrypt           : in  STD_LOGIC;
			 reset_n           : in  STD_LOGIC;
			 clk               : in  STD_LOGIC;
			 enable_mixcolumns : in  STD_LOGIC;
			 data_in           : in  STD_LOGIC_VECTOR(127 downto 0);
			 key               : in  std_logic_vector(127 downto 0);
			 data_out          : out STD_LOGIC_VECTOR(127 downto 0);
			 enable            : in  std_logic);
	end component aes_round;

	--Inputs
	signal enc : std_logic;
	signal reset_n : std_logic;
	signal clk : std_logic;
	signal en_mix : std_logic;
	signal data_in : std_logic_vector(127 downto 0);
	signal key : std_logic_vector(127 downto 0);
	signal enable : std_logic;

	--Outputs
	signal d_out : std_logic_vector(127 downto 0);

begin

	r1: aes_round
		port map(
			encrypt           => enc,
			reset_n           => reset_n,
			clk               => clk,
			enable_mixcolumns => en_mix,
			data_in           => data_in,
			key               => key,
			data_out          => d_out,
			enable => enable
		);

stim_proc: process
begin
	--Data from http://ece-research.unm.edu/jimp/HOST/DES_AES_VHDL/AESvhdl.pdf
	reset_n<='0';
	wait for 10 ns;
	data_in <= x"00102030405060708090a0b0c0d0e0f0";
	key<=x"d6aa74fdd2af72fadaa678f1d6ab76fe";
	enc<='1';
	en_mix<='1';
	reset_n<='1';
	enable<='1';
	
	for i in 0 to 4 loop
		clk<='0';
		wait for 10 ns;
		clk<='1';
		wait for 10 ns;
	end loop;	

	assert d_out = x"89d810e8855ace682d1843d8cb128fe4" report "failure" severity failure;
	enc<='0';
	en_mix<='1';
	key<=x"14f9701ae35fe28c440adf4d4ea9c026";
	data_in <= x"3e1c22c0b6fcbf768da85067f6170495";
	for i in 0 to 4 loop
		clk<='0';
		wait for 10 ns;
		clk<='1';
		wait for 10 ns;
	end loop;
	assert d_out = x"b458124c68b68a014b99f82e5f15554c" report "failure" severity failure;
	reset_n<='0';
	wait for 10 ns;
	assert d_out = (d_out'range =>'0') report "failure" severity failure;

	wait;


end process;

end;
