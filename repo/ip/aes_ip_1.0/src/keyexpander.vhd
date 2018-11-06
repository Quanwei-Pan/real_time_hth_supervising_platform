--Original work Copyright (c) 2014, Angelo Haller
--Original work Copyright (c) 2014, Felix Kubicek
--Original work Copyright (c) 2014, Lauri Võsandi
--Modified work Copyright (c) 2016, Alexandre Schnegg
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
use ieee.numeric_std.all;
use work.sbox_lut.all;

entity keyexpander is
	generic ( rcon_in : integer ); 
    Port ( key_in : in STD_LOGIC_VECTOR (127 downto 0);
           key_out : out STD_LOGIC_VECTOR (127 downto 0);
           reset_n : in STD_LOGIC;
           clk : in STD_LOGIC);
    
	function rcon(d_in : integer ) return byte is
	   constant rcon_lut : lut := (
			x"8D", x"01", x"02", x"04", x"08", x"10", x"20", x"40", x"80", x"1B", x"36", x"6C", x"D8", x"AB", x"4D", x"9A", 
         x"2F", x"5E", x"BC", x"63", x"C6", x"97", x"35", x"6A", x"D4", x"B3", x"7D", x"FA", x"EF", x"C5", x"91", x"39", 
         x"72", x"E4", x"D3", x"BD", x"61", x"C2", x"9F", x"25", x"4A", x"94", x"33", x"66", x"CC", x"83", x"1D", x"3A", 
         x"74", x"E8", x"CB", x"8D", x"01", x"02", x"04", x"08", x"10", x"20", x"40", x"80", x"1B", x"36", x"6C", x"D8", 
         x"AB", x"4D", x"9A", x"2F", x"5E", x"BC", x"63", x"C6", x"97", x"35", x"6A", x"D4", x"B3", x"7D", x"FA", x"EF", 
         x"C5", x"91", x"39", x"72", x"E4", x"D3", x"BD", x"61", x"C2", x"9F", x"25", x"4A", x"94", x"33", x"66", x"CC", 
         x"83", x"1D", x"3A", x"74", x"E8", x"CB", x"8D", x"01", x"02", x"04", x"08", x"10", x"20", x"40", x"80", x"1B", 
         x"36", x"6C", x"D8", x"AB", x"4D", x"9A", x"2F", x"5E", x"BC", x"63", x"C6", x"97", x"35", x"6A", x"D4", x"B3", 
         x"7D", x"FA", x"EF", x"C5", x"91", x"39", x"72", x"E4", x"D3", x"BD", x"61", x"C2", x"9F", x"25", x"4A", x"94", 
         x"33", x"66", x"CC", x"83", x"1D", x"3A", x"74", x"E8", x"CB", x"8D", x"01", x"02", x"04", x"08", x"10", x"20", 
         x"40", x"80", x"1B", x"36", x"6C", x"D8", x"AB", x"4D", x"9A", x"2F", x"5E", x"BC", x"63", x"C6", x"97", x"35", 
         x"6A", x"D4", x"B3", x"7D", x"FA", x"EF", x"C5", x"91", x"39", x"72", x"E4", x"D3", x"BD", x"61", x"C2", x"9F", 
         x"25", x"4A", x"94", x"33", x"66", x"CC", x"83", x"1D", x"3A", x"74", x"E8", x"CB", x"8D", x"01", x"02", x"04", 
         x"08", x"10", x"20", x"40", x"80", x"1B", x"36", x"6C", x"D8", x"AB", x"4D", x"9A", x"2F", x"5E", x"BC", x"63", 
         x"C6", x"97", x"35", x"6A", x"D4", x"B3", x"7D", x"FA", x"EF", x"C5", x"91", x"39", x"72", x"E4", x"D3", x"BD", 
         x"61", x"C2", x"9F", x"25", x"4A", x"94", x"33", x"66", x"CC", x"83", x"1D", x"3A", x"74", x"E8", x"CB", x"8D"
		);
	begin
		return rcon_lut(d_in);
	end rcon;
	
	function sub_word (d_in : word) return word is
		variable t_in, t_out : w_list;
	begin
		t_in := to_w_list(d_in);
		
		for i in 0 to 3 loop
			t_out(i):= sbox_lut(t_in(i));
		end loop;
		return to_word(t_out);
	end sub_word;
	
	function rot_word (d_in : word) return word is
		variable t_in, t_out : w_list;
	begin		
		t_in := to_w_list(d_in);

		t_out := w_list(t_in(1 to 3) & t_in(0));
		return to_word(t_out);
	end rot_word;
	
end keyexpander;

architecture Behavioral of keyexpander is
	
	signal col_0, col_1, col_2, col_3 : word;
	signal col_0_new, col_1_new, col_2_new, col_3_new : word;
	signal tmp : word;
	signal reg : std_logic_vector(127 downto 0);
	
begin
	
	col_0 <= state_column(key_in, 0);
	col_1 <= state_column(key_in, 1);
	col_2 <= state_column(key_in, 2);
	col_3 <= state_column(key_in, 3);
	
	tmp <=  sub_word(rot_word(col_3)) xor (rcon(rcon_in) & x"000000");
	
	col_0_new <= tmp xor col_0;
	col_1_new <= col_0_new xor col_1;
	col_2_new <= col_1_new xor col_2;
    col_3_new <= col_2_new xor col_3;
    
    regist : process (reset_n, clk, reg)
	begin
			if reset_n = '0' then
				reg <= (others => '0');
			elsif rising_edge(clk) then
				reg <= col_0_new & col_1_new & col_2_new & col_3_new;
			end if;
	end process regist;
	
	key_out <= reg;

end Behavioral;
