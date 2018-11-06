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

entity keyselect is
    Port ( encrypt : in STD_LOGIC;
           r1 : in STD_LOGIC_VECTOR (127 downto 0);
           r2 : in STD_LOGIC_VECTOR (127 downto 0);
           r3 : in STD_LOGIC_VECTOR (127 downto 0);
           r4 : in STD_LOGIC_VECTOR (127 downto 0);
           r5 : in STD_LOGIC_VECTOR (127 downto 0);
           r6 : in STD_LOGIC_VECTOR (127 downto 0);
           r7 : in STD_LOGIC_VECTOR (127 downto 0);
           r8 : in STD_LOGIC_VECTOR (127 downto 0);
           r9 : in STD_LOGIC_VECTOR (127 downto 0);
           r10 : in STD_LOGIC_VECTOR (127 downto 0);
           r11 : in STD_LOGIC_VECTOR (127 downto 0);
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
end keyselect;

architecture Behavioral of keyselect is

begin
	
	subkey1		<= r1 	when encrypt='1' else r11;
	subkey2		<= r2 	when encrypt='1' else r10;
	subkey3		<= r3 	when encrypt='1' else r9;
	subkey4		<= r4 	when encrypt='1' else r8;
	subkey5		<= r5 	when encrypt='1' else r7;
	subkey6		<= r6 	when encrypt='1' else r6;
	subkey7		<= r7 	when encrypt='1' else r5;
	subkey8		<= r8 	when encrypt='1' else r4;
	subkey9		<= r9 	when encrypt='1' else r3;
	subkey10	<= r10 	when encrypt='1' else r2;
	subkey11	<= r11 	when encrypt='1' else r1;

end Behavioral;
