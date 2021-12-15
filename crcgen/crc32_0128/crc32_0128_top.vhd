
library ieee;
use     ieee.std_logic_1164.all;
entity  crc32_0128_gen is
    generic (
        WIDTH: integer := 8
    );
    port (
        CLK  : in  std_logic;
        RST  : in  std_logic;
        LOAD : in  std_logic;
        LAST : in  std_logic;
        DATA : in  std_logic_vector(WIDTH-1 downto 0);
        CRC  : out std_logic_vector(     31 downto 0);
        VAL  : out std_logic
    );
end entity;
architecture RTL of crc32_0128_gen is
    signal   curr_crc :  std_logic_vector(31 downto 0); 
    signal   next_crc :  std_logic_vector(31 downto 0);
begin
    U: entity work.crc32_0128 port map(c => curr_crc, d => DATA, o => next_crc);
    process(CLK, RST) begin
        if (RST = '1') then
            curr_crc <= (others => '1');
            CRC      <= (others => '1');
            VAL      <= '0';
        elsif (CLK'event and CLK = '1') then
            if (LOAD = '1') then
                if (LAST = '1') then
                    curr_crc <= (others => '1');
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

library ieee;
use     ieee.std_logic_1164.all;
entity  crc32_0128_top is
    port (
        CLK  : in  std_logic;
        RST  : in  std_logic;
        LOAD : in  std_logic;
        LAST : in  std_logic;
        DATA : in  std_logic_vector( 7 downto 0);
        CRC  : out std_logic_vector(31 downto 0);
        VAL  : out std_logic
    );
end entity;
architecture RTL of crc32_0128_top is
    constant WIDTH    :  integer := 128;
    constant WORDS    :  integer := WIDTH/DATA'length;
    signal   i_load   :  std_logic;
    signal   i_last   :  std_logic;
    signal   i_data   :  std_logic_vector(DATA'range);
    signal   d_valid  :  std_logic;
    signal   d_last   :  std_logic;
    signal   d_load   :  std_logic_vector(WORDS-1 downto 0);
    signal   d_data   :  std_logic_vector(WIDTH-1 downto 0);
begin
    process (CLK, RST) begin
        if (RST = '1') then
            i_data <= (others => '0');
            i_load <= '0';
            i_last <= '0';
        elsif (CLK'event and CLK = '1') then
            i_data <= DATA;
            i_load <= LOAD;
            i_last <= LAST;
        end if;
    end process;

    process (CLK, RST) begin
        if (RST = '1') then
            d_data  <= (others => '0');
            d_load  <= (0 downto 0 => '1', others => '0');
            d_last  <= '0';
            d_valid <= '0';
        elsif (CLK'event and CLK = '1') then
            if (i_load = '1') then
                for i in d_load'low to d_load'high loop
                    if (d_load(i) = '1') then
                        d_data((i+1)*i_data'length-1 downto i*i_data'length) <= i_data;
                    end if;
                    if (i_last = '1') then
                        if (i > 0) then
                            d_load(i) <= '0';
                        else
                            d_load(i) <= '1';
                        end if;
                    else
                        if (i > 0) then
                            d_load(i) <= d_load(i-1);
                        else
                            d_load(i) <= d_load(d_load'high);
                        end if;
                    end if;
                end loop;
            end if;
            if (i_load = '1' and (i_last = '1' or d_load(d_load'high) = '1')) then
                d_valid <= '1';
            else
                d_valid <= '0';
            end if;
            d_last <= i_last;
        end if;
    end process;
    
    CRCGEN: entity work.crc32_0128_gen 
        generic map (WIDTH => WIDTH) 
        port    map (
             CLK  => CLK, 
             RST  => RST, 
             LOAD => d_valid, 
             LAST => d_last,
             DATA => d_data, 
             CRC  => CRC,
             VAL  => VAL
        );
end RTL;

