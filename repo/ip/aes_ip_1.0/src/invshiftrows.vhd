--Copyright (c) 2016, Alexandre Schnegg
--Based on the work of Rajender Manteena seed http://ece-research.unm.edu/jimp/HOST/DES_AES_VHDL/AESvhdl.pdf
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

entity invshiftrows is
	port (
		data_in : in std_logic_vector(127 downto 0);
		data_out : out std_logic_vector(127 downto 0)
	);
end entity invshiftrows;

architecture RTL of invshiftrows is
	
begin
	data_out(127 downto 120) <= data_in(127 downto 120); 
	data_out(119 downto 112) <= data_in(23 downto 16); 
	data_out(111 downto 104) <= data_in(47 downto 40); 
	data_out(103 downto 96) <= data_in(71 downto 64); 
	data_out(95 downto 88) <= data_in(95 downto 88); 
	data_out(87 downto 80) <= data_in(119 downto 112); 
	data_out(79 downto 72) <= data_in(15 downto 8); 
	data_out(71 downto 64) <= data_in(39 downto 32); 
	data_out(63 downto 56) <= data_in(63 downto 56); 
	data_out(55 downto 48) <= data_in(87 downto 80); 
	data_out(47 downto 40) <= data_in(111 downto 104); 
	data_out(39 downto 32) <= data_in(7 downto 0); 
	data_out(31 downto 24) <= data_in(31 downto 24); 
	data_out(23 downto 16) <= data_in(55 downto 48); 
	data_out(15 downto 8) <= data_in(79 downto 72); 
	data_out(7 downto 0) <= data_in(103 downto 96); 

end architecture RTL;