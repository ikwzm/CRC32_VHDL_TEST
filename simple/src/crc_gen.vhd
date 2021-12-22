-----------------------------------------------------------------------------------
--!     @file    crcgen.vhd
--!     @brief   CRCGEN : シンプルに for-loop を回して CRC を演算するモジュール
--!     @version 0.0.3
--!     @date    2021/12/21
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
        CRC_POLY  : string  := "0xEDB88320";
        CRC_INIT  : string  := "0xFFFFFFFF";
        CRC_RIGHT : boolean := TRUE;
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
use     work.util.all;
architecture RTL of CRC_GEN is
    -------------------------------------------------------------------------------
    -- CRC_BITS の１次元配列のタイプ宣言
    -------------------------------------------------------------------------------
    subtype   CRC_TYPE          is std_logic_vector(CRC_BITS-1 downto 0);
    signal    curr_crc          :  CRC_TYPE;
    function  CONV_CRC_TYPE(CRC_STR : string) return CRC_TYPE is
        variable   crc_bit      :  CRC_TYPE;
        variable   crc_len      :  integer;
    begin
        STRING_TO_STD_LOGIC_VECTOR(CRC_STR, crc_bit, crc_len);
        return crc_bit;
    end function;
    -------------------------------------------------------------------------------
    -- CRC用多項式(CRC_POLY)が整数のままだと使いにくいので、ビット配列に変換しておく
    -------------------------------------------------------------------------------
    constant  CRC_POLY_BIT      :  CRC_TYPE := CONV_CRC_TYPE(CRC_POLY);
    -------------------------------------------------------------------------------
    -- CRCの初期値もビット配列に変換しておく
    -------------------------------------------------------------------------------
    constant  CRC_INIT_BIT      :  CRC_TYPE := CONV_CRC_TYPE(CRC_INIT);
    -------------------------------------------------------------------------------
    -- １ビットの入力データに対してCRC演算する関数の定義
    -------------------------------------------------------------------------------
    function  CALC_CRC(CRC:CRC_TYPE;D:std_logic) return CRC_TYPE is
        variable new_crc        :  CRC_TYPE;
        variable sft_crc        :  CRC_TYPE;
        variable crc_xor_d_bit  :  std_logic;
    begin
        if (CRC_RIGHT) then
            for i in CRC_TYPE'range loop
                if (i = CRC_TYPE'high) then
                    sft_crc(i) := '0';
                else
                    sft_crc(i) := CRC(i+1);
                end if;
            end loop;
            crc_xor_d_bit := CRC(CRC_TYPE'low ) xor D;
        else
            for i in CRC_TYPE'range loop
                if (i = CRC_TYPE'low) then
                    sft_crc(i) := '0';
                else
                    sft_crc(i) := CRC(i-1);
                end if;
            end loop;
            crc_xor_d_bit := CRC(CRC_TYPE'high) xor D;
        end if;
        for i in CRC_TYPE'range loop
            if (CRC_POLY_BIT(i) = '1') then
                new_crc(i) := sft_crc(i) xor crc_xor_d_bit;
            else
                new_crc(i) := sft_crc(i);
            end if;
        end loop;
        return new_crc;
    end function;
    -------------------------------------------------------------------------------
    -- 複数ビットまとめてCRC演算する関数の定義(簡易版)
    --    指定されたビット数の回数だけ上述のCALC_CRC関数を呼び出すだけの簡単な関数。
    --    記述は単純明解だが、論理合成ツールがちゃんと最適化してくれないと、とんでもなく遅延の大きい
    --    回路になってしまう可能性がある。
    -------------------------------------------------------------------------------
    function  CALC_CRC(CRC:CRC_TYPE;D:std_logic_vector) return CRC_TYPE is
        variable new_crc : CRC_TYPE;
    begin
        new_crc := CRC;
        for i in D'low to D'high loop
            new_crc := CALC_CRC(new_crc, D(i));
        end loop;
        return new_crc;
    end function;
begin
    process(CLK, RST) 
        variable next_crc :  CRC_TYPE;
    begin
        if (RST = '1') then
            curr_crc <= CRC_INIT_BIT;
            CRC      <= CRC_INIT_BIT;
            VAL      <= '0';
        elsif (CLK'event and CLK = '1') then
            if (LOAD = '1') then
                next_crc := CALC_CRC(curr_crc, DATA);
                if (LAST = '1') then
                    curr_crc <= CRC_INIT_BIT;
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

