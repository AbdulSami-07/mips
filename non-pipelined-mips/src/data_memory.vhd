library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;
use work.util.all;

entity data_memory is
    generic(
        DATA_WIDTH : integer := 32;
        DEPTH : integer := 1024
    );
    port(
        clk_i   : in std_logic;
        rst_i   : in std_logic;
        we_i    : in std_logic;
        addr_i  : in std_logic_vector(DATA_WIDTH-1 downto 0);
        data_i  : in std_logic_vector(DATA_WIDTH-1 downto 0);
        data_o  : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
    
end entity;

architecture rtl of data_memory is
    type mem is array (natural range <>) of std_logic_vector(DATA_WIDTH-1 downto 0);
    signal ram : mem(1023 downto 0);
    signal addr_i_t : std_logic_vector(clog2(DEPTH)-1 downto 0);
begin
    addr_i_t <= addr_i(clog2(DEPTH-1)-1 downto 0);
    process(clk_i) is 
    begin
        if rising_edge(clk_i) then 
            if (we_i = '1') then
                ram(to_integer(addr_i)) <= data_i;
            end if;
        end if;
    end process;
    
    data_o <= ram(to_integer(addr_i)) when (rst_i /= '1') else (others => '1');

end architecture;