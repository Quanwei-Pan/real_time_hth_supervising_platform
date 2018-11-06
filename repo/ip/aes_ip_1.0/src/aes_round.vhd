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

entity aes_round is
    Port ( encrypt : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           clk : in STD_LOGIC;
           enable_mixcolumns : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (127 downto 0);
           key : in std_logic_vector(127 downto 0);
           data_out : out STD_LOGIC_VECTOR (127 downto 0);
           enable: in std_logic
           );
end aes_round;

architecture Behavioral of aes_round is
	
	component subbytes
		port(clk      : in  std_logic;
			 reset_n  : in  std_logic;
			 encrypt  : in  std_logic;
			 data_in  : in  std_logic_vector(127 downto 0);
			 data_out : out std_logic_vector(127 downto 0);
			 enable   : in  std_logic);
	end component subbytes;
	
	component reg
		port(clk      : in  std_logic;
			 reset_n  : in  std_logic;
			 data_in  : in  std_logic_vector(127 downto 0);
			 data_out : out std_logic_vector(127 downto 0);
			 enable   : in  std_logic);
	end component reg;
	
	component shiftrows
		port(data_in  : in  std_logic_vector(127 downto 0);
			 data_out : out std_logic_vector(127 downto 0));
	end component shiftrows;
	
	component mixcolumns
		port(clk        : in  std_logic;
			 reset_n    : in  std_logic;
			 enable     : in  std_logic;
			 data_in    : in  std_logic_vector(127 downto 0);
			 data_out   : out std_logic_vector(127 downto 0);
			 reg_enable : in  std_logic);
	end component mixcolumns;
	
	component addkey
		port(data_in  : in  std_logic_vector(127 downto 0);
			 key      : in  std_logic_vector(127 downto 0);
			 data_out : out std_logic_vector(127 downto 0));
	end component addkey;
	
	component invshiftrows
		port(data_in  : in  std_logic_vector(127 downto 0);
			 data_out : out std_logic_vector(127 downto 0));
	end component invshiftrows;
	
	component invmixcolumns
		port(clk        : in  std_logic;
			 reset_n    : in  std_logic;
			 enable     : in  std_logic;
			 data_in    : in  std_logic_vector(127 downto 0);
			 data_out   : out std_logic_vector(127 downto 0);
			 reg_enable : in  std_logic);
	end component invmixcolumns;
	
	component mux
		port(data_in_enc : in  std_logic_vector(127 downto 0);
			 data_in_dec : in  std_logic_vector(127 downto 0);
			 encrypt     : in  std_logic;
			 data_out    : out std_logic_vector(127 downto 0));
	end component mux;
	
	signal data_1 : std_logic_vector(127 downto 0);
	signal data_2 : std_logic_vector(127 downto 0);
	
	signal data_3_enc : std_logic_vector(127 downto 0);
	signal data_3_dec : std_logic_vector(127 downto 0);
	
	signal data_4_enc : std_logic_vector(127 downto 0);
	signal data_4_dec : std_logic_vector(127 downto 0);
	
	signal data_5_enc : std_logic_vector(127 downto 0);
	signal data_5_dec : std_logic_vector(127 downto 0);
	
	signal data_6_enc : std_logic_vector(127 downto 0);
	signal data_6_dec : std_logic_vector(127 downto 0);
	
	signal data_7_enc : std_logic_vector(127 downto 0);
	signal data_7_dec : std_logic_vector(127 downto 0);
	

begin
	
	sub: subbytes
		port map(
			clk      => clk,
			reset_n  => reset_n,
			encrypt  => encrypt,
			data_in  => data_in,
			data_out => data_1,
			enable => enable
		);

	reg1: reg
		port map(
			clk      => clk,
			reset_n  => reset_n,
			data_in  => data_1,
			data_out => data_2,
			enable	=> enable
		);
		
	shift: shiftrows
		port map(
			data_in  => data_2,
			data_out => data_3_enc
		);
		
	invshift: invshiftrows
		port map(
			data_in  => data_2,
			data_out => data_3_dec
		);
		
	mix: mixcolumns
		port map(
			clk      => clk,
			reset_n  => reset_n,
			enable   => enable_mixcolumns,
			data_in  => data_3_enc,
			data_out => data_4_enc,
			reg_enable => enable
		);
		
	add_dec: addkey
		port map(
			data_in  => data_3_dec,
			key      => key,
			data_out => data_4_dec
		);
		
	reg_2_enc: reg
		port map(
			clk      => clk,
			reset_n  => reset_n,
			data_in  => data_4_enc,
			data_out => data_5_enc,
			enable	=> enable
		);

	reg_2_dec: reg
		port map(
			clk      => clk,
			reset_n  => reset_n,
			data_in  => data_4_dec,
			data_out => data_5_dec,
			enable	=> enable
		);
		
	add_enc:addkey
		port map(
			data_in  => data_5_enc,
			key      => key,
			data_out => data_6_enc
		);
		
	reg_3_enc:reg
		port map(
			clk      => clk,
			reset_n  => reset_n,
			data_in  => data_6_enc,
			data_out => data_7_enc,
			enable	=> enable
		);		
		
	invmix:invmixcolumns
		port map(
			clk      => clk,
			reset_n  => reset_n,
			enable   => enable_mixcolumns,
			data_in  => data_5_dec,
			data_out => data_6_dec,
			reg_enable => enable
		);
		
	reg_3_dec:reg
		port map(
			clk      => clk,
			reset_n  => reset_n,
			data_in  => data_6_dec,
			data_out => data_7_dec,
			enable	=> enable
		);
		
	mu:mux
		port map(
			data_in_enc => data_7_enc,
			data_in_dec => data_7_dec,
			encrypt     => encrypt,
			data_out    => data_out
		);
		
end Behavioral;
