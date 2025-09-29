library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;

entity sign_extend is 
    generic(
        DATA_IN_WIDTH : integer := 5;
        DATA_OUT_WIDTH : integer := 32
    );
    port(
        data_i : in std_logic_vector(DATA_IN_WIDTH-1 downto 0);
        data_o : out std_logic_vector(DATA_OUT_WIDTH-1 downto 0)  
    );
    
end entity;

architecture rtl of sign_extend is

begin
    process(all) is
    begin
        for i in data_i'range loop
            data_o(i) <= data_i(i);
        end loop;
        for j in data_o'left downto (data_i'left+1) loop
            data_o(j) <= data_i(data_i'left);
        end loop;
    end process;
end architecture;