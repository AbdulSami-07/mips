library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registers is
    generic(
        DATA_WIDTH : integer := 32
    );
    port(
        clk_i  : in std_logic;
        rst_i  : in std_logic;
        data_i : in std_logic_vector(DATA_WIDTH-1 downto 0);
        data_o : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );

end entity;

architecture rtl of registers is
    signal data_o_t : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
begin
    process(clk_i) is
    begin
        if rising_edge(clk_i) then
            if (rst_i = '0') then
                data_o_t <= (others => '0');
            else
            data_o_t <= data_i;
            end if;
        end if;
    end process;
    data_o <= data_o_t;
end architecture;