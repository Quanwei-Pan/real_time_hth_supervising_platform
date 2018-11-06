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

entity subbytes is
	port (
		clk : in std_logic;
		reset_n : in std_logic;
		encrypt: in std_logic;
		data_in: in std_logic_vector(127 downto 0);
		data_out: out std_logic_vector(127 downto 0);
		enable: in std_logic
	);
end entity subbytes;

architecture RTL of subbytes is
	
	component sbox
		port(clk      : in  STD_LOGIC;
			 reset_n  : in  STD_LOGIC;
			 data_in  : in  STD_LOGIC_VECTOR(7 downto 0);
			 data_out : out STD_LOGIC_VECTOR(7 downto 0);
			 encrypt  : in  std_logic;
			 enable   : in  std_logic);
	end component sbox;
	
begin
	
generate_label : for i in 1 to 16 generate
begin
	sboxinst:component sbox
		port map(
			clk      => clk,
			reset_n  => reset_n,
			data_in  => data_in((i*8)-1 downto (i-1)*8),
			data_out => data_out((i*8)-1 downto (i-1)*8),
			encrypt => encrypt,
			enable	=> enable
		);
end generate generate_label;

end architecture RTL;
