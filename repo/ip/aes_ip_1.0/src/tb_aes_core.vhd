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

entity tb_aes_core is
end entity tb_aes_core;

architecture behavior of tb_aes_core is

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

	--Inputs
	signal clk : std_logic;
	signal reset_n : std_logic;
	signal encrypt : std_logic;
	signal data_in : std_logic_vector(127 downto 0);
	signal load_key : std_logic;
	signal key : std_logic_vector(127 downto 0);
	signal enable: std_logic;

	--Outputs
	signal key_ready : std_logic;
	signal data_out : std_logic_vector(127 downto 0);	
	
begin

	core:component aes_core
		port map(
			clk            => clk,
			reset_n        => reset_n,
			encrypt        => encrypt,
			data_in        => data_in,
			load_key       => load_key,
			key            => key,
			key_ready      => key_ready,
			data_out       => data_out,
			enable	=> enable
		);

	stim_proc: process
	begin
		--Data from http://ece-research.unm.edu/jimp/HOST/DES_AES_VHDL/AESvhdl.pdf
		reset_n<='0';
		data_in<=(others=>'0');
		wait for 10 ns;
		enable<='1';
		encrypt<='1';
		key<=x"139a35422f1d61de3c91787fe0507afd";
		load_key<='1';
		reset_n<='1';
		clk<='0';
		wait for 10 ns;
		
		for i in 1 to 10 loop
			clk<='1';
			wait for 10 ns;
			clk<='0';
			wait for 10 ns;
		end loop;
		
		assert key_ready = '1' report "failure" severity failure;
		data_in<=x"b9145a768b7dc489a096b546f43b231f";
		clk<='1';
		wait for 10 ns;
		data_in<=x"0da1b56ba11c1a5500e95583c0eac913";
		clk<='0';
		wait for 10 ns;
		clk<='1';
		wait for 10 ns;
		data_in<=x"6c0667f85d61e81e1d3268922187081a";
		clk<='0';
		wait for 10 ns;
		clk<='1';
		wait for 10 ns;
		data_in<=(others=>'0');
		clk<='0';
		wait for 10 ns;
		clk<='1';
		wait for 10 ns;
		data_in<=x"2d6777ae242d3ff67e112db05954e08a";
		clk<='0';
		wait for 10 ns;
		clk<='1';
		wait for 10 ns;
		data_in<=x"39bd922da8d1c4c42505c51490192b6f";
		clk<='0';
		wait for 10 ns;
		clk<='1';
		wait for 10 ns;
		clk<='0';
		wait for 10 ns;

		for i in 1 to 55 loop
			clk<='1';
			wait for 10 ns;
			clk<='0';
			wait for 10 ns;
		end loop;
		
		assert data_out = x"0da1b56ba11c1a5500e95583c0eac913" report "failure" severity failure;
		clk<='1';
		wait for 10 ns;
		clk<='0';
		wait for 10 ns;		
		assert data_out = x"6c0667f85d61e81e1d3268922187081a" report "failure" severity failure;
		clk<='1';
		wait for 10 ns;
		clk<='0';
		wait for 10 ns;
		assert data_out = x"2d6777ae242d3ff67e112db05954e08a" report "failure" severity failure;
		clk<='1';
		wait for 10 ns;
		clk<='0';
		wait for 10 ns;
		clk<='1';
		wait for 10 ns;
		clk<='0';
		wait for 10 ns;	
		assert data_out = x"39bd922da8d1c4c42505c51490192b6f" report "failure" severity failure;
		clk<='1';
		wait for 10 ns;
		clk<='0';
		wait for 10 ns;
		assert data_out = x"b9e49ec4a5c196c0dba1b830267fa156" report "failure" severity failure;
		
		encrypt<='0';
		key<=x"139a35422f1d61de3c91787fe0507afd";
		load_key<='1';
		
		for i in 1 to 10 loop
			clk<='1';
			wait for 10 ns;
			clk<='0';
			wait for 10 ns;
		end loop;
		
		data_in<=x"0da1b56ba11c1a5500e95583c0eac913";
		clk<='1';
		wait for 10 ns;
		data_in<=x"6c0667f85d61e81e1d3268922187081a";
		clk<='0';
		wait for 10 ns;
		clk<='1';
		wait for 10 ns;
		data_in<=x"2d6777ae242d3ff67e112db05954e08a";
		clk<='0';
		wait for 10 ns;
		clk<='1';
		wait for 10 ns;
		data_in<=x"39bd922da8d1c4c42505c51490192b6f";
		clk<='0';
		wait for 10 ns;
		clk<='1';
		wait for 10 ns;
		data_in<=(others=>'0');
		clk<='0';
		wait for 10 ns;
		clk<='1';
		wait for 10 ns;
		clk<='0';
		wait for 10 ns;
		clk<='1';
		wait for 10 ns;
		data_in<=x"b9e49ec4a5c196c0dba1b830267fa156";
		clk<='0';
		wait for 10 ns;
		clk<='1';
		wait for 10 ns;
		clk<='0';
		wait for 10 ns;
		
		for i in 1 to 54 loop
			clk<='1';
			wait for 10 ns;
			clk<='0';
			wait for 10 ns;
		end loop;
		
		
		assert data_out = x"b9145a768b7dc489a096b546f43b231f" report "failure" severity failure;
		clk<='1';
		wait for 10 ns;
		clk<='0';
		wait for 10 ns;		
		assert data_out = x"0da1b56ba11c1a5500e95583c0eac913" report "failure" severity failure;
		clk<='1';
		wait for 10 ns;
		clk<='0';
		wait for 10 ns;
		assert data_out = x"6c0667f85d61e81e1d3268922187081a" report "failure" severity failure;
		clk<='1';
		wait for 10 ns;
		clk<='0';
		wait for 10 ns;
		assert data_out = x"2d6777ae242d3ff67e112db05954e08a" report "failure" severity failure;
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
		assert data_out = x"39bd922da8d1c4c42505c51490192b6f" report "failure" severity failure;
		
		clk<='1';
		wait for 10 ns;
		clk<='0';
		wait for 10 ns;
		
		reset_n<='0';
		wait for 10 ns;
--		assert d_out = (d_out'range =>'0') report "failure" severity failure;
	
		wait;
	
	
	end process;

end;
