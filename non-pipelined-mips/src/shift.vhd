library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;

entity shift is
    generic(
        DATA_WIDTH : integer := 8;
        RIGHT : std_logic := '0';
        N : integer := 2
        
    );
    port(
        i : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        o : out std_logic_vector(DATA_WIDTH - 1 downto 0) 
    );

end entity;

architecture rtl of shift is
    signal o_t : std_logic_vector(DATA_WIDTH-1 downto 0);
begin
    process(all) begin
        if (not(RIGHT)) then
            for k in 0 to N loop
                o_t(k) <= '0';
            end loop;
            for j in N to DATA_WIDTH-1 loop
                o_t(j) <= i(j-N);
            end loop;
        else
            for k in N-1 downto 0 loop
                o_t(k) <= i(DATA_WIDTH-1-N);
            end loop;
            for j in  DATA_WIDTH-1 downto N loop
                o_t(j) <= '0';
            end loop;
        end if;
    end process;
    o <= o_t;
end architecture;