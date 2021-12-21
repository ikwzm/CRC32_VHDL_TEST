-----------------------------------------------------------------------------------
--!     @file    crcgen_test.vhd
--!     @brief   CRCGEN TEST BENCH:
--!     @version 0.0.1
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
entity  crc32_0064_top_test is
    generic (
        FINISH_ABORT : boolean := FALSE
    );
end entity;

library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use     std.textio.all;
architecture MODEL of crc32_0064_top_test is
    constant  PERIOD        :  time := 10 ns;
    constant  DELAY         :  time :=  1 ns;
    subtype   CRC_TYPE      is std_logic_vector(31 downto 0);
    subtype   DATA_TYPE     is std_logic_vector( 7 downto 0);
    signal    clk_ena       :  boolean;
    signal    CLK           :  std_logic;
    signal    RST           :  std_logic;
    signal    LOAD          :  std_logic;
    signal    LAST          :  std_logic;
    signal    DATA          :  DATA_TYPE;
    signal    CRC           :  CRC_TYPE;
    signal    VAL           :  std_logic;
    subtype   I_DATA_TYPE   is integer range 0 to 255;
    type      I_DATA_VECTOR is array (integer range <>) of I_DATA_TYPE;
    constant  O_CRC_1       :  CRC_TYPE := std_logic_vector(to_unsigned(16#52214B25#, 32));
    constant  I_DATA_1      :  I_DATA_VECTOR(0 to 511)
                            := (16#97#, 16#45#, 16#B6#, 16#65#, 16#37#, 16#83#, 16#2D#, 16#A7#,
                                16#A5#, 16#F8#, 16#A2#, 16#99#, 16#DD#, 16#58#, 16#C6#, 16#A0#,
                                16#71#, 16#23#, 16#A8#, 16#74#, 16#61#, 16#F0#, 16#54#, 16#70#,
                                16#0C#, 16#5C#, 16#20#, 16#BF#, 16#81#, 16#C1#, 16#21#, 16#7B#,
                                16#E2#, 16#2C#, 16#8C#, 16#E9#, 16#53#, 16#BA#, 16#AC#, 16#3F#,
                                16#C0#, 16#D1#, 16#E9#, 16#EE#, 16#30#, 16#59#, 16#A8#, 16#DE#,
                                16#BB#, 16#62#, 16#19#, 16#F7#, 16#2D#, 16#3B#, 16#09#, 16#73#,
                                16#27#, 16#B3#, 16#22#, 16#43#, 16#47#, 16#2A#, 16#38#, 16#A6#,
                                16#CA#, 16#CB#, 16#8B#, 16#06#, 16#AD#, 16#04#, 16#E2#, 16#5F#,
                                16#F2#, 16#2E#, 16#8A#, 16#59#, 16#4E#, 16#FB#, 16#A0#, 16#C0#,
                                16#69#, 16#A9#, 16#E8#, 16#BE#, 16#66#, 16#EC#, 16#79#, 16#2E#,
                                16#9B#, 16#BE#, 16#0B#, 16#F1#, 16#AC#, 16#16#, 16#9A#, 16#1C#,
                                16#19#, 16#08#, 16#D6#, 16#32#, 16#69#, 16#AA#, 16#04#, 16#EC#,
                                16#30#, 16#4D#, 16#97#, 16#EA#, 16#36#, 16#6A#, 16#0E#, 16#4C#,
                                16#6F#, 16#98#, 16#EF#, 16#90#, 16#4A#, 16#04#, 16#A7#, 16#8F#,
                                16#B7#, 16#DF#, 16#C7#, 16#B6#, 16#F4#, 16#DB#, 16#81#, 16#19#,
                                16#4F#, 16#57#, 16#45#, 16#3F#, 16#FB#, 16#83#, 16#97#, 16#D3#,
                                16#C6#, 16#06#, 16#52#, 16#4A#, 16#15#, 16#1C#, 16#B9#, 16#BC#,
                                16#3F#, 16#01#, 16#E6#, 16#2E#, 16#F8#, 16#93#, 16#8C#, 16#A5#,
                                16#BF#, 16#24#, 16#66#, 16#F5#, 16#BC#, 16#65#, 16#D8#, 16#15#,
                                16#BC#, 16#31#, 16#E0#, 16#35#, 16#DC#, 16#97#, 16#EE#, 16#D3#,
                                16#66#, 16#41#, 16#E4#, 16#53#, 16#1D#, 16#DF#, 16#BD#, 16#77#,
                                16#13#, 16#57#, 16#D5#, 16#48#, 16#D7#, 16#3C#, 16#F9#, 16#A2#,
                                16#96#, 16#C4#, 16#46#, 16#D2#, 16#13#, 16#61#, 16#93#, 16#55#,
                                16#B4#, 16#AF#, 16#92#, 16#FC#, 16#54#, 16#62#, 16#C9#, 16#48#,
                                16#CD#, 16#C3#, 16#18#, 16#FB#, 16#EE#, 16#21#, 16#C3#, 16#29#,
                                16#99#, 16#63#, 16#38#, 16#9E#, 16#9B#, 16#8C#, 16#0B#, 16#3B#,
                                16#7A#, 16#D3#, 16#74#, 16#E0#, 16#15#, 16#BA#, 16#B3#, 16#B9#,
                                16#EE#, 16#8B#, 16#36#, 16#65#, 16#C2#, 16#80#, 16#1B#, 16#62#,
                                16#E4#, 16#25#, 16#75#, 16#DA#, 16#77#, 16#E7#, 16#9E#, 16#9B#,
                                16#8B#, 16#27#, 16#B8#, 16#21#, 16#AE#, 16#5B#, 16#25#, 16#9E#,
                                16#6F#, 16#C4#, 16#8A#, 16#2C#, 16#40#, 16#3F#, 16#7F#, 16#25#,
                                16#75#, 16#D8#, 16#E7#, 16#B7#, 16#AF#, 16#F4#, 16#17#, 16#33#,
                                16#57#, 16#58#, 16#40#, 16#B6#, 16#A9#, 16#88#, 16#82#, 16#54#,
                                16#D3#, 16#A9#, 16#A3#, 16#FD#, 16#8E#, 16#A6#, 16#C8#, 16#1A#,
                                16#8E#, 16#2F#, 16#3B#, 16#71#, 16#E4#, 16#0F#, 16#1E#, 16#5E#,
                                16#32#, 16#4F#, 16#55#, 16#3F#, 16#1C#, 16#0A#, 16#EA#, 16#2D#,
                                16#7A#, 16#B6#, 16#C6#, 16#83#, 16#53#, 16#58#, 16#B6#, 16#C7#,
                                16#D0#, 16#D4#, 16#AC#, 16#89#, 16#2D#, 16#03#, 16#35#, 16#11#,
                                16#B3#, 16#BF#, 16#A0#, 16#F6#, 16#1D#, 16#E9#, 16#09#, 16#96#,
                                16#9A#, 16#7A#, 16#9D#, 16#D8#, 16#9D#, 16#01#, 16#93#, 16#57#,
                                16#27#, 16#AA#, 16#08#, 16#D7#, 16#0E#, 16#54#, 16#49#, 16#17#,
                                16#EE#, 16#33#, 16#0B#, 16#59#, 16#CF#, 16#4A#, 16#2F#, 16#2D#,
                                16#6A#, 16#FE#, 16#DD#, 16#A6#, 16#28#, 16#43#, 16#D4#, 16#DD#,
                                16#A3#, 16#7D#, 16#F6#, 16#2F#, 16#85#, 16#95#, 16#94#, 16#A0#,
                                16#6D#, 16#6E#, 16#D9#, 16#0B#, 16#A3#, 16#1E#, 16#D2#, 16#9B#,
                                16#3C#, 16#8A#, 16#C4#, 16#D1#, 16#97#, 16#D7#, 16#CC#, 16#88#,
                                16#44#, 16#66#, 16#22#, 16#10#, 16#01#, 16#98#, 16#6D#, 16#AA#,
                                16#76#, 16#FD#, 16#52#, 16#C0#, 16#BD#, 16#6A#, 16#73#, 16#E0#,
                                16#F0#, 16#8E#, 16#F5#, 16#34#, 16#20#, 16#D4#, 16#A5#, 16#28#,
                                16#73#, 16#3A#, 16#A0#, 16#1D#, 16#78#, 16#96#, 16#8C#, 16#63#,
                                16#D0#, 16#1B#, 16#35#, 16#EB#, 16#E4#, 16#EC#, 16#76#, 16#F0#,
                                16#04#, 16#33#, 16#DD#, 16#27#, 16#30#, 16#5F#, 16#FC#, 16#EB#,
                                16#81#, 16#A9#, 16#F1#, 16#A8#, 16#71#, 16#08#, 16#B4#, 16#4F#,
                                16#99#, 16#F7#, 16#A6#, 16#E9#, 16#01#, 16#DB#, 16#D1#, 16#03#,
                                16#6B#, 16#84#, 16#31#, 16#16#, 16#43#, 16#8C#, 16#2F#, 16#07#,
                                16#2C#, 16#2D#, 16#F4#, 16#AD#, 16#5F#, 16#9E#, 16#75#, 16#C7#,
                                16#69#, 16#85#, 16#FB#, 16#0D#, 16#97#, 16#88#, 16#26#, 16#1F#,
                                16#C7#, 16#5C#, 16#F5#, 16#FC#, 16#C5#, 16#D5#, 16#BB#, 16#EC#,
                                16#FA#, 16#0B#, 16#16#, 16#FB#, 16#3B#, 16#FC#, 16#58#, 16#43#,
                                16#19#, 16#CC#, 16#CA#, 16#D3#, 16#3F#, 16#E6#, 16#D4#, 16#30#,
                                16#27#, 16#46#, 16#06#, 16#7D#, 16#56#, 16#93#, 16#05#, 16#B9#,
                                16#6C#, 16#67#, 16#59#, 16#10#, 16#EE#, 16#40#, 16#E6#, 16#9D#,
                                16#74#, 16#D2#, 16#8A#, 16#7C#, 16#C4#, 16#7B#, 16#9E#, 16#C3#);
    procedure REPORT_MESSAGE(MES:in STRING) is
        variable str : LINE;
    begin
        WRITE(str, Now, RIGHT, 9);
        WRITE(str, " : " & MES);
        WRITELINE(OUTPUT, str);
    end REPORT_MESSAGE;
begin
    DUT: entity WORK.crc32_0064_top
        port map (
            CLK       => CLK      ,
            RST       => RST      ,
            LOAD      => LOAD     ,
            LAST      => LAST     ,
            DATA      => DATA     ,
            CRC       => CRC      ,
            VAL       => VAL
            );

    process begin
        loop
            CLK <= '1'; wait for PERIOD / 2;
            CLK <= '0'; wait for PERIOD / 2;
            exit when (clk_ena = FALSE);
        end loop;
        CLK <= '0';
        wait;
    end process;

    process
        variable  error_count : integer;
        procedure WAIT_CLK(CNT:in integer) is
        begin
            for i in 1 to CNT loop 
                wait until (CLK'event and CLK = '1'); 
            end loop;
        end WAIT_CLK;
        procedure CHECK(I_DATA: I_DATA_VECTOR; EXC_CRC: CRC_TYPE) is
            variable i_pos       :  integer;
            variable val_timeout :  boolean;
        begin
            i_pos := 0;
            LOAD_LOOP: loop
                wait until (CLK'event and CLK = '1'); 
                wait for DELAY;
                if (i_pos > I_DATA'high) then
                    exit LOAD_LOOP;
                end if;
                if (i_pos = I_DATA'high) then
                    LAST <= '1';
                else
                    LAST <= '0';
                end if;
                for i in 0 to DATA'length/8-1 loop
                    if i_pos >= I_DATA'high then
                        LAST <= '1';
                    else
                        LAST <= '0';
                    end if;
                    if i_pos <= I_DATA'high then
                        DATA((i+1)*8-1 downto i*8) <= std_logic_vector(to_unsigned(I_DATA(i_pos),8));
                        i_pos := i_pos + 1;
                    else
                        DATA((i+1)*8-1 downto i*8) <= std_logic_vector(to_unsigned(0,8));
                    end if;
                end loop;
                LOAD <= '1';
            end loop;
            LOAD <= '0';
            LAST <= '0';
            DATA <= (others => '0');
            val_timeout := true;
            VAL_1_LOOP: for cnt in 0 to 63 loop
                wait until (CLK'event and CLK = '1');
                if (VAL = '1') then
                    if (CRC = EXC_CRC) then
                        REPORT_MESSAGE("CRC Success");
                    else
                        REPORT_MESSAGE("CRC Mismatch");
                        error_count := error_count + 1;
                    end if;
                    val_timeout := false;
                    exit VAL_1_LOOP;
                end if;
            end loop;
            if (val_timeout) then
                REPORT_MESSAGE("VAL assert Timeout");
                error_count := error_count + 1;
                return;
            end if;
            wait until (CLK'event and CLK = '1');
            if (VAL /= '0') then
                REPORT_MESSAGE("VAL negate Timeout");
                error_count := error_count + 1;
            end if;
        end procedure;
    begin
        error_count := 0;
        clk_ena <= TRUE;
        RST     <= '1';
        LOAD    <= '0';
        LAST    <= '0';
        DATA    <= (others => '0');
        WAIT_CLK(4);
        RST     <= '0';
        CHECK(I_DATA_1, O_CRC_1);
        WAIT_CLK(4);
        clk_ena <= FALSE;
        if (error_count > 0) then
            assert FALSE report "Simulation complete(error)."    severity FAILURE;
        end if;
        if (FINISH_ABORT) then
            assert FALSE report "Simulation complete(success)."  severity FAILURE;
        else
            assert FALSE report "Simulation complete(success)."  severity NOTE;
        end if;
        wait;
    end process;
end MODEL;
