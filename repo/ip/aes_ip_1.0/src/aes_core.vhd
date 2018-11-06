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

entity aes_core is
	port (
		clk : in std_logic;
		reset_n : in std_logic;
		encrypt: in std_logic;
		data_in:in std_logic_vector(127 downto 0);
		load_key:in std_logic;
		key: in std_logic_vector(127 downto 0);
		key_ready:out std_logic;
		data_out: out std_logic_vector(127 downto 0);
		enable:in std_logic
	);
end entity aes_core;

architecture Behavioral of aes_core is
	
	component addkey
		port(data_in  : in  std_logic_vector(127 downto 0);
			 key      : in  std_logic_vector(127 downto 0);
			 data_out : out std_logic_vector(127 downto 0));
	end component addkey;
	
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
			 subkey10 : out STD_LOGIC_VECTOR(127 downto 0);
			 subkey11 : out STD_LOGIC_VECTOR(127 downto 0));
	end component aes_keyscheduler;
	
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
	
	component reg
		port(clk      : in  std_logic;
			 reset_n  : in  std_logic;
			 data_in  : in  std_logic_vector(127 downto 0);
			 data_out : out std_logic_vector(127 downto 0);
			 enable   : in  std_logic);
	end component reg;
	
	component datavalid_gen
		port(reset_n        : in  STD_LOGIC;
			 data_valid_in  : in  STD_LOGIC;
			 data_valid_out : out STD_LOGIC;
			 clk            : in  STD_LOGIC);
	end component datavalid_gen;
	
	type data_t is array(0 to 9) of std_logic_vector(127 downto 0);
	signal round_in : data_t;
	signal round_out : data_t;
	signal temp : std_logic_vector(127 downto 0);
	signal temp2 : std_logic_vector(127 downto 0);
	
	type key_t is array(0 to 9) of std_logic_vector(127 downto 0);
	signal keys : key_t;
	
	signal subkey1 : std_logic_vector(127 downto 0);
	

begin
	
	sched:aes_keyscheduler
		port map(
			key      => key,
			reset_n  => reset_n,
			clk      => clk,
			load     => load_key,
			encrypt  => encrypt,
			ready    => key_ready,
			subkey1	=> subkey1,
			subkey2  => keys(0),
			subkey3  => keys(1),
			subkey4  => keys(2),
			subkey5  => keys(3),
			subkey6  => keys(4),
			subkey7  => keys(5),
			subkey8  => keys(6),
			subkey9  => keys(7),
			subkey10  => keys(8),
			subkey11 => keys(9)
		);
		
	reg0:reg
		port map(
			clk      => clk,
			reset_n  => reset_n,
			data_in  => data_in,
			data_out => temp2,
			enable	=> enable
		);

	add:addkey
		port map(
			data_in  => temp2,
			key      => subkey1,
			data_out => temp
		);
		
	reg1:reg
		port map(
			clk      => clk,
			reset_n  => reset_n,
			data_in  => temp,
			data_out => round_in(0),
			enable	=> enable
		);
		
	rounds : for i in 0 to 9 generate
		first : if i = 0 generate
			round1 : aes_round
				port map(
					encrypt           => encrypt,
					reset_n           => reset_n,
					clk               => clk,
					enable_mixcolumns => '1',
					data_in           => round_in(0),
					key               => keys(0),
					data_out          => round_out(0),
					enable => enable
				);
			reg1: reg
				port map(
					clk      => clk,
					reset_n  => reset_n,
					data_in  => round_out(0),
					data_out => round_in(1),
					enable	=> enable
				);
		end generate first;
		
		last : if i = 9 generate
			round10 : aes_round
				port map(
					encrypt           => encrypt,
					reset_n           => reset_n,
					clk               => clk,
					enable_mixcolumns => '0',
					data_in           => round_in(9),
					key               => keys(9),
					data_out          => round_out(9),
					enable => enable
				);
				
			reg10: reg
				port map(
					clk      => clk,
					reset_n  => reset_n,
					data_in  => round_out(9),
					data_out => data_out,
					enable	=> enable
				);
		end generate last;
	
		other : if i > 0 and i<9 generate
			roundx : aes_round
				port map(
					encrypt           => encrypt,
					reset_n           => reset_n,
					clk               => clk,
					enable_mixcolumns => '1',
					data_in           => round_in(i),
					key               => keys(i),
					data_out          => round_out(i),
					enable => enable
				);
			regx: reg
				port map(
					clk      => clk,
					reset_n  => reset_n,
					data_in  => round_out(i),
					data_out => round_in(i+1),
					enable	=> enable
				);				
		end generate other;
	end  generate rounds;

end Behavioral;
