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
use work.types.all;

entity tb_keyexpander is
end entity tb_keyexpander;

architecture behavior of tb_keyexpander is

	component keyexpander
		generic(rcon_in : integer);
		port(key_in  : in  STD_LOGIC_VECTOR(127 downto 0);
			 key_out : out STD_LOGIC_VECTOR(127 downto 0);
			 reset_n : in  STD_LOGIC;
			 clk     : in  STD_LOGIC);
	end component keyexpander;
	
	--Inputs
	signal reset_n : std_logic;
	signal clk : std_logic;
	signal key_in : std_logic_vector(127 downto 0);

	--Outputs
	signal key_out : std_logic_vector(127 downto 0);

begin

	r1: keyexpander
		generic map(
			rcon_in => 1
		)
		port map(
			key_in  => key_in,
			key_out => key_out,
			reset_n => reset_n,
			clk     => clk
		);

stim_proc: process
begin
	--Data from http://ece-research.unm.edu/jimp/HOST/DES_AES_VHDL/AESvhdl.pdf
	reset_n<='0';
	wait for 10 ns;
	key_in <= x"000102030405060708090a0b0c0d0e0f";
	reset_n<='1';
	clk<='0';
	wait for 10 ns;
	clk<='1';
	wait for 10 ns;
	assert key_out = x"d6aa74fdd2af72fadaa678f1d6ab76fe" report "failure" severity failure;
	reset_n<='0';
	wait for 10 ns;
	assert key_out = (key_out'range =>'0') report "failure" severity failure;

	wait;


end process;

end;
