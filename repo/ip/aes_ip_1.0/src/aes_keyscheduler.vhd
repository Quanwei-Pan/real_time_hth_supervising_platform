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
use work.types.all;
use IEEE.NUMERIC_STD.all;

entity aes_keyscheduler is
    Port ( key : in STD_LOGIC_VECTOR (127 downto 0);
           reset_n : in STD_LOGIC;
           clk : in STD_LOGIC;
           load : in STD_LOGIC;
           encrypt : in STD_LOGIC;
           ready : out STD_LOGIC;
           subkey1 : out STD_LOGIC_VECTOR (127 downto 0);
           subkey2 : out STD_LOGIC_VECTOR (127 downto 0);
           subkey3 : out STD_LOGIC_VECTOR (127 downto 0);
           subkey4 : out STD_LOGIC_VECTOR (127 downto 0);
           subkey5 : out STD_LOGIC_VECTOR (127 downto 0);
           subkey6 : out STD_LOGIC_VECTOR (127 downto 0);
           subkey7 : out STD_LOGIC_VECTOR (127 downto 0);
           subkey8 : out STD_LOGIC_VECTOR (127 downto 0);
           subkey9 : out STD_LOGIC_VECTOR (127 downto 0);
           subkey10 : out STD_LOGIC_VECTOR (127 downto 0);
           subkey11 : out STD_LOGIC_VECTOR (127 downto 0));
end aes_keyscheduler;

architecture Behavioral of aes_keyscheduler is
	
	component keyselect
		port(encrypt  : in  STD_LOGIC;
			 r1       : in  STD_LOGIC_VECTOR(127 downto 0);
			 r2       : in  STD_LOGIC_VECTOR(127 downto 0);
			 r3       : in  STD_LOGIC_VECTOR(127 downto 0);
			 r4       : in  STD_LOGIC_VECTOR(127 downto 0);
			 r5       : in  STD_LOGIC_VECTOR(127 downto 0);
			 r6       : in  STD_LOGIC_VECTOR(127 downto 0);
			 r7       : in  STD_LOGIC_VECTOR(127 downto 0);
			 r8       : in  STD_LOGIC_VECTOR(127 downto 0);
			 r9       : in  STD_LOGIC_VECTOR(127 downto 0);
			 r10      : in  STD_LOGIC_VECTOR(127 downto 0);
			 r11      : in  STD_LOGIC_VECTOR(127 downto 0);
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
	end component keyselect;
	
	component keyexpander
		generic(rcon_in : integer);
		port(key_in  : in  STD_LOGIC_VECTOR(127 downto 0);
			 key_out : out STD_LOGIC_VECTOR(127 downto 0);
			 reset_n : in  STD_LOGIC;
			 clk     : in  STD_LOGIC);
	end component keyexpander;
	
	component controlunit
		port(load    : in  STD_LOGIC;
			 reset_n : in  std_logic;
			 clk     : in  std_logic;
			 ready   : out STD_LOGIC);
	end component controlunit;
	
	type key_t is array(0 to 9) of std_logic_vector(127 downto 0);
	signal keys : key_t;
	 

begin
	
	cu: controlunit
		port map(
			load    => load,
			reset_n => reset_n,
			clk     => clk,
			ready   => ready
		);
		
	keyexps : for i in 0 to 9 generate
		first : if i = 0 generate
			u0 : keyexpander
				generic map(
					rcon_in => 1
				)
				port map(
					key_in  => key,
					key_out => keys(0),
					reset_n => reset_n,
					clk     => clk
				);
		end generate first;
	
		other : if i > 0 generate
			ux : keyexpander
				generic map(
					rcon_in => i+1
				)
				port map(
					key_in  => keys(i - 1),
					key_out => keys(i),
					reset_n => reset_n,
					clk     => clk
				);
		end generate other;
	end  generate keyexps;
	
	ks: keyselect
		port map(
			encrypt  => encrypt,
			r1       => key,
			r2       => keys(0),
			r3       => keys(1),
			r4       => keys(2),
			r5       => keys(3),
			r6       => keys(4),
			r7       => keys(5),
			r8       => keys(6),
			r9       => keys(7),
			r10      => keys(8),
			r11      => keys(9),
			subkey1  => subkey1,
			subkey2  => subkey2,
			subkey3  => subkey3,
			subkey4  => subkey4,
			subkey5  => subkey5,
			subkey6  => subkey6,
			subkey7  => subkey7,
			subkey8  => subkey8,
			subkey9  => subkey9,
			subkey10 => subkey10,
			subkey11 => subkey11
		);
		
	
end Behavioral;
