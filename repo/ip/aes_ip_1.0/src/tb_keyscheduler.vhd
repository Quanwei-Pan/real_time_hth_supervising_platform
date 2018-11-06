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

entity tb_aes_keyscheduler is
end entity tb_aes_keyscheduler;

architecture behavior of tb_aes_keyscheduler is

	component aes_keyscheduler
		port(key      : in  STD_LOGIC_VECTOR(127 downto 0);
			 reset_n  : in  STD_LOGIC;
			 clk      : in  STD_LOGIC;
			 load     : in  STD_LOGIC;
			 encrypt  : in  STD_LOGIC;
			 ready    : out STD_LOGIC;
			 subkey1  : out STD_LOGIC_VECTOR(127 downto 0);
			 subkey2  : out STD_LOGIC_VECTOR(127 downto 0);
			 subkey3  : out STD_LOGIC_VECTOR(127 downto 0);
			 subkey4  : out STD_LOGIC_VECTOR(127 downto 0);
			 subkey5  : out STD_LOGIC_VECTOR(127 downto 0);
			 subkey6  : out STD_LOGIC_VECTOR(127 downto 0);
			 subkey7  : out STD_LOGIC_VECTOR(127 downto 0);
			 subkey8  : out STD_LOGIC_VECTOR(127 downto 0);
			 subkey9  : out STD_LOGIC_VECTOR(127 downto 0);
			 subkey10 : out STD_LOGIC_VECTOR(127 downto 0));
	end component aes_keyscheduler;

	--Inputs
	signal key : std_logic_vector(127 downto 0);
	signal reset_n : std_logic;
	signal clk : std_logic;
	signal load : std_logic;
	signal encrypt : std_logic;
	
	--Outputs
	signal ready : std_logic;
	signal subkey1 : std_logic_vector(127 downto 0);
	signal subkey2 : std_logic_vector(127 downto 0);
	signal subkey3 : std_logic_vector(127 downto 0);
	signal subkey4 : std_logic_vector(127 downto 0);
	signal subkey5 : std_logic_vector(127 downto 0);
	signal subkey6 : std_logic_vector(127 downto 0);
	signal subkey7 : std_logic_vector(127 downto 0);
	signal subkey8 : std_logic_vector(127 downto 0);
	signal subkey9 : std_logic_vector(127 downto 0);
	signal subkey10 : std_logic_vector(127 downto 0);	

begin

	sched: aes_keyscheduler
		port map(
			key      => key,
			reset_n  => reset_n,
			clk      => clk,
			load     => load,
			encrypt  => encrypt,
			ready    => ready,
			subkey1  => subkey1,
			subkey2  => subkey2,
			subkey3  => subkey3,
			subkey4  => subkey4,
			subkey5  => subkey5,
			subkey6  => subkey6,
			subkey7  => subkey7,
			subkey8  => subkey8,
			subkey9  => subkey9,
			subkey10 => subkey10
		);

stim_proc: process
begin
	--Data from http://ece-research.unm.edu/jimp/HOST/DES_AES_VHDL/AESvhdl.pdf
	reset_n<='0';
	wait for 10 ns;
	key<=x"000102030405060708090a0b0c0d0e0f";
	encrypt<='1';
	load<='1';
	reset_n<='1';
	clk<='0';
	wait for 10 ns;
	clk<='1';
	wait for 10 ns;
	clk<='0';
	wait for 10 ns;
	clk<='1';
	wait for 10 ns;
	clk<='0';
	wait for 10 ns;
	clk<='1';
	wait for 10 ns;
	clk<='0';
	wait for 10 ns;
	clk<='1';
	wait for 10 ns;
	clk<='0';
	wait for 10 ns;
	clk<='1';
	wait for 10 ns;
	clk<='0';
	wait for 10 ns;
	clk<='1';
	wait for 10 ns;
	clk<='0';
	wait for 10 ns;
	clk<='1';
	wait for 10 ns;
	clk<='0';
	wait for 10 ns;
	clk<='1';
	wait for 10 ns;
	clk<='0';
	wait for 10 ns;
	clk<='1';
	wait for 10 ns;
	clk<='0';
	wait for 10 ns;
	clk<='1';
	wait for 10 ns;
	assert subkey1 = x"d6aa74fdd2af72fadaa678f1d6ab76fe" report "failure" severity failure;
	assert subkey2 = x"b692cf0b643dbdf1be9bc5006830b3fe" report "failure" severity failure;
	assert subkey3 = x"b6ff744ed2c2c9bf6c590cbf0469bf41" report "failure" severity failure;
	assert subkey4 = x"47f7f7bc95353e03f96c32bcfd058dfd" report "failure" severity failure;
	assert subkey5 = x"3caaa3e8a99f9deb50f3af57adf622aa" report "failure" severity failure;
	assert subkey6 = x"5e390f7df7a69296a7553dc10aa31f6b" report "failure" severity failure;
	assert subkey7 = x"14f9701ae35fe28c440adf4d4ea9c026" report "failure" severity failure;
	assert subkey8 = x"47438735a41c65b9e016baf4aebf7ad2" report "failure" severity failure;
	assert subkey9 = x"549932d1f08557681093ed9cbe2c974e" report "failure" severity failure;
	assert subkey10 = x"13111d7fe3944a17f307a78b4d2b30c5" report "failure" severity failure;
	clk<='0';
	wait for 10 ns;
	clk<='1';
	wait for 10 ns;
	reset_n<='0';
	wait for 10 ns;
	assert subkey1 = (subkey1'range =>'0') report "failure" severity failure;

	wait;


end process;

end;
