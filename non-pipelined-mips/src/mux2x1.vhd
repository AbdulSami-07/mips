library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;

entity mux2x1  is
    generic(
        DATA_WIDTH: integer := 32
    );
    port(
        i0 : in std_logic_vector(DATA_WIDTH-1 downto 0);
        i1 : in std_logic_vector(DATA_WIDTH-1 downto 0);
        sel : in std_logic;
        o : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
    
end entity;

architecture rtl of mux2x1 is

begin

    with sel select
        o <= i0 when '0',
             i1 when '1',
             (others => '0') when others;

end architecture;