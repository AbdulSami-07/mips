library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;
use work.util.all;

entity register_file is
    generic(
        DATA_WIDTH : integer := 32;
        DEPTH : integer := 32
    );
    port(
        clk_i    : in std_logic;
        rst_i    : in std_logic;
        wr_i     : in std_logic;
        addr0_i  : in std_logic_vector(clog2(DEPTH)-1 downto 0); -- A1
        addr1_i  : in std_logic_vector(clog2(DEPTH)-1 downto 0); -- A2
        addr2_i  : in std_logic_vector(clog2(DEPTH)-1 downto 0); -- A3
        data_i   : in std_logic_vector(DATA_WIDTH-1 downto 0);  -- W3
        data0_o  : out std_logic_vector(DATA_WIDTH-1 downto 0); -- RD1
        data1_o  : out std_logic_vector(DATA_WIDTH-1 downto 0)  -- RD2
    );
    
end entity;

architecture rtl of register_file is
    type mem is array(natural range <>) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal ram : mem(DEPTH-1 downto 0);
    signal data0_o_t : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal data1_o_t : std_logic_vector(DATA_WIDTH-1 downto 0);
    
begin
    process(clk_i) is 
    begin
        if rising_edge(clk_i) then
            if (wr_i = '1') then
                ram(to_integer(addr2_i)) <= data_i;
            end if;
        end if;
    end process;
    
    process(all) is
    begin
        data0_o_t <= ram(to_integer(addr0_i));
        data1_o_t <= ram(to_integer(addr1_i));
    end process;
    
   data0_o <= data0_o_t;
   data1_o <= data1_o_t;

end architecture;
