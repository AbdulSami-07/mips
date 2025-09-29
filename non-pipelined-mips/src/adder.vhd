library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;

entity adder is
    generic(
        DATA_WIDTH : integer := 32
    );
    port(
        a: in std_logic_vector(DATA_WIDTH-1 downto 0);
        b: in std_logic_vector(DATA_WIDTH-1 downto 0);
        c: out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity;

architecture rtl of adder is
    signal c_t : std_logic_vector(DATA_WIDTH-1 downto 0);
begin
    process(all) is
    begin
        c_t <= a + b;
    end process;
    c <= c_t;
end architecture;