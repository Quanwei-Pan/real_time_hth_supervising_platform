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
use work.sbox_lut.all;

entity sbox is
    Port ( clk : in STD_LOGIC;
           reset_n : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (7 downto 0);
           data_out : out STD_LOGIC_VECTOR (7 downto 0);
           encrypt:in std_logic;
           enable: in std_logic
          );
end sbox;

architecture Behavioral of sbox is
	
	signal lut1_out : std_logic_vector(7 downto 0);
	signal lut2_out : std_logic_vector(7 downto 0);
	signal lut3_out : std_logic_vector(7 downto 0);
	signal lut4_out : std_logic_vector(7 downto 0);
	signal temp : std_logic_vector(1 downto 0);
	

begin
	
	p1 : process(clk,reset_n,temp,encrypt,enable) is
	begin
		if reset_n<='0' then
			lut1_out<=(others=>'0');
			lut2_out<=(others=>'0');
			lut3_out<=(others=>'0');
			lut4_out<=(others=>'0');
			temp<=(others=>'0');
		elsif rising_edge(clk) then
			if enable='1' then
				temp<=data_in(7 downto 6);
				if encrypt='1' then
					lut1_out<=sbox_lut_1(data_in);
					lut2_out<=sbox_lut_2(data_in);
					lut3_out<=sbox_lut_3(data_in);
					lut4_out<=sbox_lut_4(data_in);
				else
					lut1_out<=inv_sbox_lut_1(data_in);
					lut2_out<=inv_sbox_lut_2(data_in);
					lut3_out<=inv_sbox_lut_3(data_in);
					lut4_out<=inv_sbox_lut_4(data_in);
				end if;
			end if;
		end if;
		
	end process p1;
	
	data_out <= lut1_out when temp="00" else
				lut2_out when temp="01" else
				lut3_out when temp="10" else
				lut4_out when temp="11" else
				(others=>'0');

end Behavioral;
