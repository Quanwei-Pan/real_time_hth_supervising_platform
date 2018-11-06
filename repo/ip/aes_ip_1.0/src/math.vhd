--Copyright (c) 2014, Angelo Haller
--Copyright (c) 2014, Felix Kubicek
--Copyright (c) 2014, Lauri Võsandi
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
use work.types.all;

package math is

	function mul2(din : byte) return byte;
	function mul3(din : byte) return byte;
	function mul9(din : byte) return byte;
	function mulb(din : byte) return byte;
	function muld(din : byte) return byte;
	function mule(din : byte) return byte;

end math;

package body math is

	function mul2(din : byte) return byte is
		variable ret : byte;
	begin
		ret(0) := din(7);
		ret(1) := din(0) xor din(7);
		ret(2) := din(1);
		ret(3) := din(2) xor din(7);
		ret(4) := din(3) xor din(7);
		ret(5) := din(4);
		ret(6) := din(5);
		ret(7) := din(6);

		return ret;
	end mul2;

	function mul3(din : byte) return byte is
		variable ret : byte;
	begin
		ret(0) := din(0) xor din(7);
		ret(1) := din(0) xor din(1) xor din(7);
		ret(2) := din(1) xor din(2);
		ret(3) := din(2) xor din(3) xor din(7);
		ret(4) := din(3) xor din(4) xor din(7);
		ret(5) := din(4) xor din(5);
		ret(6) := din(5) xor din(6);
		ret(7) := din(6) xor din(7);

		return ret;
	end mul3;

	function mul9(din : byte) return byte is
		variable ret : byte;
	begin
		ret(0) := din(0) xor din(5);
		ret(1) := din(1) xor din(5) xor din(6);
		ret(2) := din(2) xor din(6) xor din(7);
		ret(3) := din(0) xor din(3) xor din(5) xor din(7);
		ret(4) := din(1) xor din(4) xor din(5) xor din(6);
		ret(5) := din(2) xor din(5) xor din(6) xor din(7);
		ret(6) := din(3) xor din(6) xor din(7);
		ret(7) := din(4) xor din(7);

		return ret;
	end mul9;

	function mulb(din : byte) return byte is
		variable ret : byte;
	begin
		ret(0) := din(0) xor din(5) xor din(7);
		ret(1) := din(0) xor din(1) xor din(5) xor din(6) xor din(7);
		ret(2) := din(1) xor din(2) xor din(6) xor din(7);
		ret(3) := din(0) xor din(2) xor din(3) xor din(5);
		ret(4) := din(1) xor din(3) xor din(4) xor din(5) xor din(6) xor din(7);
		ret(5) := din(2) xor din(4) xor din(5) xor din(6) xor din(7);
		ret(6) := din(3) xor din(5) xor din(6) xor din(7);
		ret(7) := din(4) xor din(6) xor din(7);

		return ret;
	end mulb;

	function muld(din : byte) return byte is
		variable ret : byte;
	begin
		ret(0) := din(0) xor din(5) xor din(6);
		ret(1) := din(1) xor din(5) xor din(7);
		ret(2) := din(0) xor din(2) xor din(6);
		ret(3) := din(0) xor din(1) xor din(3) xor din(5) xor din(6) xor din(7);
		ret(4) := din(1) xor din(2) xor din(4) xor din(5) xor din(7);
		ret(5) := din(2) xor din(3) xor din(5) xor din(6);
		ret(6) := din(3) xor din(4) xor din(6) xor din(7);
		ret(7) := din(4) xor din(5) xor din(7);

		return ret;
	end muld;

	function mule(din : byte) return byte is
		variable ret : byte;
	begin
		ret(0) := din(5) xor din(6) xor din(7);
		ret(1) := din(0) xor din(5);
		ret(2) := din(0) xor din(1) xor din(6);
		ret(3) := din(0) xor din(1) xor din(2) xor din(5) xor din(6);
		ret(4) := din(1) xor din(2) xor din(3) xor din(5);
		ret(5) := din(2) xor din(3) xor din(4) xor din(6);
		ret(6) := din(3) xor din(4) xor din(5) xor din(7);
		ret(7) := din(4) xor din(5) xor din(6);

		return ret;
	end mule;

end math;
