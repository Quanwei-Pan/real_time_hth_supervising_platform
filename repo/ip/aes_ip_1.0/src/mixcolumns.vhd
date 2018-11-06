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

entity mixcolumns is
	port(
		clk      : in  std_logic;
		reset_n  : in  std_logic;
		enable   : in  std_logic;
		data_in  : in  std_logic_vector(127 downto 0);
		data_out : out std_logic_vector(127 downto 0);
		reg_enable: in std_logic
	);
end entity mixcolumns;

architecture RTL of mixcolumns is
	type ttemp_t is array (0 to 7, 0 to 3) of byte;
	signal tin   : matrix;
	signal tin2  : matrix;
	signal tout  : matrix;
	signal ttemp : ttemp_t;

begin
	tin <= to_matrix(data_in);

	p1 : process(clk, tin, tout, ttemp,reg_enable) is
	begin
		if reset_n <= '0' then
			ttemp <= (others => (others => (others => '0')));
		else
			if rising_edge(clk) then
				if reg_enable='1' then
					tin2 <= tin;
					--Based on https://github.com/szanni/aeshw/blob/master/aes-core/cipher.vhd
					for col in 0 to 3 loop
						ttemp(0, col) <= mul2(tin(0, col));
						ttemp(1, col) <= mul3(tin(1, col));
						ttemp(2, col) <= mul2(tin(1, col));
						ttemp(3, col) <= mul3(tin(2, col));
						ttemp(4, col) <= mul2(tin(2, col));
						ttemp(5, col) <= mul3(tin(3, col));
						ttemp(6, col) <= mul3(tin(0, col));
						ttemp(7, col) <= mul2(tin(3, col));
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
				tout(0, col) <= ttemp(0, col) xor ttemp(1, col) xor tin2(2, col) xor tin2(3, col);
				tout(1, col) <= tin2(0, col) xor ttemp(2, col) xor ttemp(3, col) xor tin2(3, col);
				tout(2, col) <= tin2(0, col) xor tin2(1, col) xor ttemp(4, col) xor ttemp(5, col);
				tout(3, col) <= ttemp(6, col) xor tin2(1, col) xor tin2(2, col) xor ttemp(7, col);
			end loop;
		end if;
	end process p2;

	data_out <= to_state(tout) when enable = '1' and reset_n='1' else data_in when enable = '0' and reset_n='1' else (others => '0');

end architecture RTL;
