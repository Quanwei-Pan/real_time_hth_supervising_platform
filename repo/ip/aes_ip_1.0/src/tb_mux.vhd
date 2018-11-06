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

entity tb_mux is
end entity tb_mux;

architecture behavior of tb_mux is

	component mux
		port(data_in_enc : in  std_logic_vector(127 downto 0);
			 data_in_dec : in  std_logic_vector(127 downto 0);
			 encrypt     : in  std_logic;
			 data_out    : out std_logic_vector(127 downto 0));
	end component mux;

	--Inputs
	signal d_in_enc : std_logic_vector(127 downto 0) := (others => '0');
	signal d_in_dec : std_logic_vector(127 downto 0) := (others => '0');
	signal enc : std_logic;
	

	--Outputs
	signal d_out : std_logic_vector(127 downto 0);

begin

	uut: mux port map(
		data_in_enc => d_in_enc,
		data_in_dec => d_in_dec,
		encrypt     => enc,
		data_out    => d_out
	);

stim_proc: process
begin
	--Data from http://ece-research.unm.edu/jimp/HOST/DES_AES_VHDL/AESvhdl.pdf
	d_in_enc <= x"4197ee88fff2dd57c211e6dcd2c8cc28";
	d_in_dec <= (others=>'0');
	enc<='1';
	wait for 10 ns;
	assert d_out = x"4197ee88fff2dd57c211e6dcd2c8cc28" report "failure" severity failure;
	enc<='0';
	wait for 10 ns;
	assert d_out = (d_out'range=>'0') report "failure" severity failure;

	wait;

end process;

end;
