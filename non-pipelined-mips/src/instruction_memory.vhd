library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;
use ieee.math_real.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.util.all;

entity instruction_memory is
    generic(
        DATA_WIDTH: integer := 32;
        DEPTH : integer := 1024
    );
    port(
        addr_i  : in std_logic_vector(DATA_WIDTH-1 downto 0);
        data_o  : out std_logic_vector(DATA_WIDTH-1 downto 0)   
    );
    
end entity;

architecture rtl of instruction_memory is
    type mem is  array(integer range <>) of std_logic_vector(DATA_WIDTH-1 downto 0);
    impure function ram_init(ram_file_name : in string) return mem is
        file ramfile : text is in ram_file_name;
        variable curr_line: line;
        variable ramtype: mem(DEPTH-1 downto 0);
    begin
        for i in ramtype'range loop
            readline(ramfile, curr_line);
            read(curr_line, ramtype(i));
        end loop;
        return ramtype;
    end function;
    
    signal ram : mem(DEPTH-1 downto 0) := ram_init("data.mem");
    signal addr_i_t : std_logic_vector(clog2(DEPTH)-1 downto 0);
begin
    addr_i_t <= addr_i(clog2(DEPTH-1)-1 downto 0);
    process(all) is
    begin
        data_o <= ram(to_integer(addr_i_t));
    end process;
end architecture;