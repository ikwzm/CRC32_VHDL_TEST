-- vim: ts=4 sw=4 expandtab

-- THIS IS GENERATED VHDL CODE.
-- https://bues.ch/h/crcgen
-- 
-- This code is Public Domain.
-- Permission to use, copy, modify, and/or distribute this software for any
-- purpose with or without fee is hereby granted.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
-- WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
-- MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
-- SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER
-- RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
-- NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE
-- USE OR PERFORMANCE OF THIS SOFTWARE.

-- CRC polynomial coefficients: x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1
--                              0xEDB88320 (hex)
-- CRC width:                   32 bits
-- CRC shift direction:         right (little endian)
-- Input word width:            32 bits

library IEEE;
use IEEE.std_logic_1164.all;

entity crc32_0032 is
    port (
        c: in std_logic_vector(31 downto 0);
        d: in std_logic_vector(31 downto 0);
        o: out std_logic_vector(31 downto 0)
    );
end entity crc32_0032;

architecture Behavioral of crc32_0032 is
begin
    o(0) <= (c(0) xor c(1) xor c(2) xor c(3) xor c(4) xor c(6) xor c(7) xor c(8) xor c(16) xor c(20) xor c(22) xor c(23) xor c(26) xor d(0) xor d(1) xor d(2) xor d(3) xor d(4) xor d(6) xor d(7) xor d(8) xor d(16) xor d(20) xor d(22) xor d(23) xor d(26));
    o(1) <= (c(1) xor c(2) xor c(3) xor c(4) xor c(5) xor c(7) xor c(8) xor c(9) xor c(17) xor c(21) xor c(23) xor c(24) xor c(27) xor d(1) xor d(2) xor d(3) xor d(4) xor d(5) xor d(7) xor d(8) xor d(9) xor d(17) xor d(21) xor d(23) xor d(24) xor d(27));
    o(2) <= (c(0) xor c(2) xor c(3) xor c(4) xor c(5) xor c(6) xor c(8) xor c(9) xor c(10) xor c(18) xor c(22) xor c(24) xor c(25) xor c(28) xor d(0) xor d(2) xor d(3) xor d(4) xor d(5) xor d(6) xor d(8) xor d(9) xor d(10) xor d(18) xor d(22) xor d(24) xor d(25) xor d(28));
    o(3) <= (c(1) xor c(3) xor c(4) xor c(5) xor c(6) xor c(7) xor c(9) xor c(10) xor c(11) xor c(19) xor c(23) xor c(25) xor c(26) xor c(29) xor d(1) xor d(3) xor d(4) xor d(5) xor d(6) xor d(7) xor d(9) xor d(10) xor d(11) xor d(19) xor d(23) xor d(25) xor d(26) xor d(29));
    o(4) <= (c(2) xor c(4) xor c(5) xor c(6) xor c(7) xor c(8) xor c(10) xor c(11) xor c(12) xor c(20) xor c(24) xor c(26) xor c(27) xor c(30) xor d(2) xor d(4) xor d(5) xor d(6) xor d(7) xor d(8) xor d(10) xor d(11) xor d(12) xor d(20) xor d(24) xor d(26) xor d(27) xor d(30));
    o(5) <= (c(0) xor c(3) xor c(5) xor c(6) xor c(7) xor c(8) xor c(9) xor c(11) xor c(12) xor c(13) xor c(21) xor c(25) xor c(27) xor c(28) xor c(31) xor d(0) xor d(3) xor d(5) xor d(6) xor d(7) xor d(8) xor d(9) xor d(11) xor d(12) xor d(13) xor d(21) xor d(25) xor d(27) xor d(28) xor d(31));
    o(6) <= (c(0) xor c(2) xor c(3) xor c(9) xor c(10) xor c(12) xor c(13) xor c(14) xor c(16) xor c(20) xor c(23) xor c(28) xor c(29) xor d(0) xor d(2) xor d(3) xor d(9) xor d(10) xor d(12) xor d(13) xor d(14) xor d(16) xor d(20) xor d(23) xor d(28) xor d(29));
    o(7) <= (c(1) xor c(3) xor c(4) xor c(10) xor c(11) xor c(13) xor c(14) xor c(15) xor c(17) xor c(21) xor c(24) xor c(29) xor c(30) xor d(1) xor d(3) xor d(4) xor d(10) xor d(11) xor d(13) xor d(14) xor d(15) xor d(17) xor d(21) xor d(24) xor d(29) xor d(30));
    o(8) <= (c(0) xor c(2) xor c(4) xor c(5) xor c(11) xor c(12) xor c(14) xor c(15) xor c(16) xor c(18) xor c(22) xor c(25) xor c(30) xor c(31) xor d(0) xor d(2) xor d(4) xor d(5) xor d(11) xor d(12) xor d(14) xor d(15) xor d(16) xor d(18) xor d(22) xor d(25) xor d(30) xor d(31));
    o(9) <= (c(0) xor c(2) xor c(4) xor c(5) xor c(7) xor c(8) xor c(12) xor c(13) xor c(15) xor c(17) xor c(19) xor c(20) xor c(22) xor c(31) xor d(0) xor d(2) xor d(4) xor d(5) xor d(7) xor d(8) xor d(12) xor d(13) xor d(15) xor d(17) xor d(19) xor d(20) xor d(22) xor d(31));
    o(10) <= (c(0) xor c(2) xor c(4) xor c(5) xor c(7) xor c(9) xor c(13) xor c(14) xor c(18) xor c(21) xor c(22) xor c(26) xor d(0) xor d(2) xor d(4) xor d(5) xor d(7) xor d(9) xor d(13) xor d(14) xor d(18) xor d(21) xor d(22) xor d(26));
    o(11) <= (c(1) xor c(3) xor c(5) xor c(6) xor c(8) xor c(10) xor c(14) xor c(15) xor c(19) xor c(22) xor c(23) xor c(27) xor d(1) xor d(3) xor d(5) xor d(6) xor d(8) xor d(10) xor d(14) xor d(15) xor d(19) xor d(22) xor d(23) xor d(27));
    o(12) <= (c(2) xor c(4) xor c(6) xor c(7) xor c(9) xor c(11) xor c(15) xor c(16) xor c(20) xor c(23) xor c(24) xor c(28) xor d(2) xor d(4) xor d(6) xor d(7) xor d(9) xor d(11) xor d(15) xor d(16) xor d(20) xor d(23) xor d(24) xor d(28));
    o(13) <= (c(0) xor c(3) xor c(5) xor c(7) xor c(8) xor c(10) xor c(12) xor c(16) xor c(17) xor c(21) xor c(24) xor c(25) xor c(29) xor d(0) xor d(3) xor d(5) xor d(7) xor d(8) xor d(10) xor d(12) xor d(16) xor d(17) xor d(21) xor d(24) xor d(25) xor d(29));
    o(14) <= (c(0) xor c(1) xor c(4) xor c(6) xor c(8) xor c(9) xor c(11) xor c(13) xor c(17) xor c(18) xor c(22) xor c(25) xor c(26) xor c(30) xor d(0) xor d(1) xor d(4) xor d(6) xor d(8) xor d(9) xor d(11) xor d(13) xor d(17) xor d(18) xor d(22) xor d(25) xor d(26) xor d(30));
    o(15) <= (c(1) xor c(2) xor c(5) xor c(7) xor c(9) xor c(10) xor c(12) xor c(14) xor c(18) xor c(19) xor c(23) xor c(26) xor c(27) xor c(31) xor d(1) xor d(2) xor d(5) xor d(7) xor d(9) xor d(10) xor d(12) xor d(14) xor d(18) xor d(19) xor d(23) xor d(26) xor d(27) xor d(31));
    o(16) <= (c(1) xor c(4) xor c(7) xor c(10) xor c(11) xor c(13) xor c(15) xor c(16) xor c(19) xor c(22) xor c(23) xor c(24) xor c(26) xor c(27) xor c(28) xor d(1) xor d(4) xor d(7) xor d(10) xor d(11) xor d(13) xor d(15) xor d(16) xor d(19) xor d(22) xor d(23) xor d(24) xor d(26) xor d(27) xor d(28));
    o(17) <= (c(2) xor c(5) xor c(8) xor c(11) xor c(12) xor c(14) xor c(16) xor c(17) xor c(20) xor c(23) xor c(24) xor c(25) xor c(27) xor c(28) xor c(29) xor d(2) xor d(5) xor d(8) xor d(11) xor d(12) xor d(14) xor d(16) xor d(17) xor d(20) xor d(23) xor d(24) xor d(25) xor d(27) xor d(28) xor d(29));
    o(18) <= (c(0) xor c(3) xor c(6) xor c(9) xor c(12) xor c(13) xor c(15) xor c(17) xor c(18) xor c(21) xor c(24) xor c(25) xor c(26) xor c(28) xor c(29) xor c(30) xor d(0) xor d(3) xor d(6) xor d(9) xor d(12) xor d(13) xor d(15) xor d(17) xor d(18) xor d(21) xor d(24) xor d(25) xor d(26) xor d(28) xor d(29) xor d(30));
    o(19) <= (c(0) xor c(1) xor c(4) xor c(7) xor c(10) xor c(13) xor c(14) xor c(16) xor c(18) xor c(19) xor c(22) xor c(25) xor c(26) xor c(27) xor c(29) xor c(30) xor c(31) xor d(0) xor d(1) xor d(4) xor d(7) xor d(10) xor d(13) xor d(14) xor d(16) xor d(18) xor d(19) xor d(22) xor d(25) xor d(26) xor d(27) xor d(29) xor d(30) xor d(31));
    o(20) <= (c(0) xor c(3) xor c(4) xor c(5) xor c(6) xor c(7) xor c(11) xor c(14) xor c(15) xor c(16) xor c(17) xor c(19) xor c(22) xor c(27) xor c(28) xor c(30) xor c(31) xor d(0) xor d(3) xor d(4) xor d(5) xor d(6) xor d(7) xor d(11) xor d(14) xor d(15) xor d(16) xor d(17) xor d(19) xor d(22) xor d(27) xor d(28) xor d(30) xor d(31));
    o(21) <= (c(0) xor c(2) xor c(3) xor c(5) xor c(12) xor c(15) xor c(17) xor c(18) xor c(22) xor c(26) xor c(28) xor c(29) xor c(31) xor d(0) xor d(2) xor d(3) xor d(5) xor d(12) xor d(15) xor d(17) xor d(18) xor d(22) xor d(26) xor d(28) xor d(29) xor d(31));
    o(22) <= (c(2) xor c(7) xor c(8) xor c(13) xor c(18) xor c(19) xor c(20) xor c(22) xor c(26) xor c(27) xor c(29) xor c(30) xor d(2) xor d(7) xor d(8) xor d(13) xor d(18) xor d(19) xor d(20) xor d(22) xor d(26) xor d(27) xor d(29) xor d(30));
    o(23) <= (c(0) xor c(3) xor c(8) xor c(9) xor c(14) xor c(19) xor c(20) xor c(21) xor c(23) xor c(27) xor c(28) xor c(30) xor c(31) xor d(0) xor d(3) xor d(8) xor d(9) xor d(14) xor d(19) xor d(20) xor d(21) xor d(23) xor d(27) xor d(28) xor d(30) xor d(31));
    o(24) <= (c(2) xor c(3) xor c(6) xor c(7) xor c(8) xor c(9) xor c(10) xor c(15) xor c(16) xor c(21) xor c(23) xor c(24) xor c(26) xor c(28) xor c(29) xor c(31) xor d(2) xor d(3) xor d(6) xor d(7) xor d(8) xor d(9) xor d(10) xor d(15) xor d(16) xor d(21) xor d(23) xor d(24) xor d(26) xor d(28) xor d(29) xor d(31));
    o(25) <= (c(1) xor c(2) xor c(6) xor c(9) xor c(10) xor c(11) xor c(17) xor c(20) xor c(23) xor c(24) xor c(25) xor c(26) xor c(27) xor c(29) xor c(30) xor d(1) xor d(2) xor d(6) xor d(9) xor d(10) xor d(11) xor d(17) xor d(20) xor d(23) xor d(24) xor d(25) xor d(26) xor d(27) xor d(29) xor d(30));
    o(26) <= (c(2) xor c(3) xor c(7) xor c(10) xor c(11) xor c(12) xor c(18) xor c(21) xor c(24) xor c(25) xor c(26) xor c(27) xor c(28) xor c(30) xor c(31) xor d(2) xor d(3) xor d(7) xor d(10) xor d(11) xor d(12) xor d(18) xor d(21) xor d(24) xor d(25) xor d(26) xor d(27) xor d(28) xor d(30) xor d(31));
    o(27) <= (c(0) xor c(1) xor c(2) xor c(6) xor c(7) xor c(11) xor c(12) xor c(13) xor c(16) xor c(19) xor c(20) xor c(23) xor c(25) xor c(27) xor c(28) xor c(29) xor c(31) xor d(0) xor d(1) xor d(2) xor d(6) xor d(7) xor d(11) xor d(12) xor d(13) xor d(16) xor d(19) xor d(20) xor d(23) xor d(25) xor d(27) xor d(28) xor d(29) xor d(31));
    o(28) <= (c(0) xor c(4) xor c(6) xor c(12) xor c(13) xor c(14) xor c(16) xor c(17) xor c(21) xor c(22) xor c(23) xor c(24) xor c(28) xor c(29) xor c(30) xor d(0) xor d(4) xor d(6) xor d(12) xor d(13) xor d(14) xor d(16) xor d(17) xor d(21) xor d(22) xor d(23) xor d(24) xor d(28) xor d(29) xor d(30));
    o(29) <= (c(0) xor c(1) xor c(5) xor c(7) xor c(13) xor c(14) xor c(15) xor c(17) xor c(18) xor c(22) xor c(23) xor c(24) xor c(25) xor c(29) xor c(30) xor c(31) xor d(0) xor d(1) xor d(5) xor d(7) xor d(13) xor d(14) xor d(15) xor d(17) xor d(18) xor d(22) xor d(23) xor d(24) xor d(25) xor d(29) xor d(30) xor d(31));
    o(30) <= (c(3) xor c(4) xor c(7) xor c(14) xor c(15) xor c(18) xor c(19) xor c(20) xor c(22) xor c(24) xor c(25) xor c(30) xor c(31) xor d(3) xor d(4) xor d(7) xor d(14) xor d(15) xor d(18) xor d(19) xor d(20) xor d(22) xor d(24) xor d(25) xor d(30) xor d(31));
    o(31) <= (c(0) xor c(1) xor c(2) xor c(3) xor c(5) xor c(6) xor c(7) xor c(15) xor c(19) xor c(21) xor c(22) xor c(25) xor c(31) xor d(0) xor d(1) xor d(2) xor d(3) xor d(5) xor d(6) xor d(7) xor d(15) xor d(19) xor d(21) xor d(22) xor d(25) xor d(31));
end architecture Behavioral;
