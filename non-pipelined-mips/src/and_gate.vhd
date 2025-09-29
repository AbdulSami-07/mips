library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;

entity and_gate is
    generic(
        DATA_WIDTH : integer := 32
    );
    port(
        i0: in std_logic_vector(DATA_WIDTH-1 downto 0);
        i1: in std_logic_vector(DATA_WIDTH-1 downto 0);
        o : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );

end entity;

architecture rtl of and_gate is
    signal o_t : std_logic_vector(DATA_WIDTH-1 downto 0);
begin
    process(all) is
    
    begin
        o_t <= i0 and i1;
    end process;
    o <= o_t;
end architecture;