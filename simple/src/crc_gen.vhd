-----------------------------------------------------------------------------------
--!     @file    crcgen.vhd
--!     @brief   CRCGEN :
--!     @version 0.0.1
--!     @date    2021/12/16
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>
-----------------------------------------------------------------------------------
--
--      Copyright (C) 2021 Ichiro Kawazome
--      All rights reserved.
--
--      Redistribution and use in source and binary forms, with or without
--      modification, are permitted provided that the following conditions
--      are met:
--
--        1. Redistributions of source code must retain the above copyright
--           notice, this list of conditions and the following disclaimer.
--
--        2. Redistributions in binary form must reproduce the above copyright
--           notice, this list of conditions and the following disclaimer in
--           the documentation and/or other materials provided with the
--           distribution.
--
--      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
--      "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
--      LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
--      A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
--      OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
--      SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
--      LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
--      DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
--      THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
--      (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
--      OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  CRC_GEN is
    generic (
        CRC_BITS  : integer := 32;
        CRC_POLY  : integer := 16#04C11DB7#;
        CRC_INIT  : integer := 1;
        DATA_BITS : integer := 32
    );
    port (
        CLK       : in  std_logic;
        RST       : in  std_logic;
        LOAD      : in  std_logic;
        LAST      : in  std_logic;
        DATA      : in  std_logic_vector(DATA_BITS-1 downto 0);
        CRC       : out std_logic_vector(CRC_BITS -1 downto 0);
        VAL       : out std_logic
    );
end entity;

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
architecture RTL of CRC_GEN is
    subtype   CRC_TYPE          is std_logic_vector(CRC_BITS-1 downto 0);
    signal    curr_crc          :  CRC_TYPE;

    function  CONV_CRC_TYPE(N:integer) return CRC_TYPE is
    begin
        return std_logic_vector(TO_UNSIGNED(N,CRC_BITS));
    end CONV_CRC_TYPE;

    function  CONV_CRC_INIT(CRC_INIT: integer) return CRC_TYPE is
        variable crc_init_val   :  CRC_TYPE;
    begin
        if (CRC_INIT = 0) then
            crc_init_val := (others => '0');
        else
            crc_init_val := (others => '1');
        end if;
        return crc_init_val;
    end function;

    constant  CALC_CRC_INIT     :  CRC_TYPE := CONV_CRC_INIT(CRC_INIT);
    constant  CALC_CRC_POLY_BIT :  CRC_TYPE := CONV_CRC_TYPE(CRC_POLY);

    function  CALC_CRC(CRC:CRC_TYPE;D:std_logic) return CRC_TYPE is
        variable new_crc        :  CRC_TYPE;
        variable crc_xor_d_bit  :  std_logic;
        variable prev_crc_bit   :  std_logic;
    begin
        crc_xor_d_bit := CRC(CRC'high) xor D;
        prev_crc_bit  := '0';
        for i in 0 to CRC_BITS-1 loop
            if (CALC_CRC_POLY_BIT(i) = '1') then
                new_crc(i) := prev_crc_bit xor crc_xor_d_bit;
            else
                new_crc(i) := prev_crc_bit;
            end if;
            prev_crc_bit := CRC(i);
        end loop;
        return new_crc;
    end CALC_CRC;

    function  CALC_CRC(CRC:CRC_TYPE;D:std_logic_vector) return CRC_TYPE is
        variable new_crc : CRC_TYPE;
    begin
        new_crc := CRC;
        for i in D'low to D'high loop
            new_crc := CALC_CRC(new_crc, D(i));
        end loop;
        return new_crc;
    end CALC_CRC;
begin
    process(CLK, RST) 
        variable next_crc :  CRC_TYPE;
    begin
        if (RST = '1') then
            curr_crc <= CALC_CRC_INIT;
            CRC      <= CALC_CRC_INIT;
            VAL      <= '0';
        elsif (CLK'event and CLK = '1') then
            if (LOAD = '1') then
                next_crc := CALC_CRC(curr_crc, DATA);
                if (LAST = '1') then
                    curr_crc <= CALC_CRC_INIT;
                    CRC      <= next_crc;
                    VAL      <= '1';
                else
                    curr_crc <= next_crc;
                    CRC      <= next_crc;
                    VAL      <= '0';
                end if;
            else
                    VAL      <= '0';
            end if;
        end if;
    end process;
end RTL;

