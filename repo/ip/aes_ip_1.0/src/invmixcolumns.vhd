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
use work.math.all;

entity invmixcolumns is
	port(
		clk      : in  std_logic;
		reset_n  : in  std_logic;
		enable   : in  std_logic;
		data_in  : in  std_logic_vector(127 downto 0);
		data_out : out std_logic_vector(127 downto 0);
		reg_enable: in std_logic
	);
end entity invmixcolumns;

architecture RTL of invmixcolumns is
	type ttemp_t is array (0 to 15, 0 to 3) of byte;
	signal tin            : matrix;
	signal tin2            : matrix;
	signal tout           : matrix;
	signal ttemp          : ttemp_t;
begin
	
	tin <= to_matrix(data_in);

	p1 : process(clk, tin, tout, ttemp) is
	begin
		if reset_n='0' then
			ttemp<=(others=>(others=>(others=>'0')));
		else
			if rising_edge(clk) then
				if reg_enable='1' then
					tin2<=tin;
					--Based on https://github.com/szanni/aeshw/blob/master/aes-core/cipher.vhd
					for col in 0 to 3 loop
						ttemp(0, col) <= mule(tin(0, col));
						ttemp(1, col) <= mulb(tin(1, col));
						ttemp(2, col) <= muld(tin(2, col));
						ttemp(3, col) <= mul9(tin(3, col));
		
						ttemp(4, col) <= mul9(tin(0, col));
						ttemp(5, col) <= mule(tin(1, col));
						ttemp(6, col) <= mulb(tin(2, col));
						ttemp(7, col) <= muld(tin(3, col));
		
						ttemp(8, col)  <= muld(tin(0, col));
						ttemp(9, col)  <= mul9(tin(1, col));
						ttemp(10, col) <= mule(tin(2, col));
						ttemp(11, col) <= mulb(tin(3, col));
		
						ttemp(12, col) <= mulb(tin(0, col));
						ttemp(13, col) <= muld(tin(1, col));
						ttemp(14, col) <= mul9(tin(2, col));
						ttemp(15, col) <= mule(tin(3, col));
					end loop;
				end if;
			end if;
		end if;
	end process p1;

	p2 : process(clk, tin2, tout, ttemp) is
	begin
		if reset_n <= '0' then
			tout <= (others => (others => (others => '0')));
		else
			--Based on https://github.com/szanni/aeshw/blob/master/aes-core/cipher.vhd
			for col in 0 to 3 loop
				tout(0, col) <= ttemp(0, col) xor ttemp(1, col) xor ttemp(2, col) xor ttemp(3, col);
				tout(1, col) <= ttemp(4, col) xor ttemp(5, col) xor ttemp(6, col) xor ttemp(7, col);
				tout(2, col) <= ttemp(8, col) xor ttemp(9, col) xor ttemp(10, col) xor ttemp(11, col);
				tout(3, col) <= ttemp(12, col) xor ttemp(13, col) xor ttemp(14, col) xor ttemp(15, col);
			end loop;
		end if;
	end process p2;

	data_out <= to_state(tout) when enable = '1' and reset_n='1' else data_in when enable = '0' and reset_n='1' else (others => '0');

end architecture RTL;
