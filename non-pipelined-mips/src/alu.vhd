library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;

entity alu is
    generic(
        DATA_WIDTH : integer := 32
    );
    port(
        a : in std_logic_vector(DATA_WIDTH-1 downto 0);
        b : in std_logic_vector(DATA_WIDTH-1 downto 0);
        r : out std_logic_vector(DATA_WIDTH-1 downto 0);
        zero : out std_logic;
        ctrl :  in std_logic_vector(2 downto 0)
    );
end entity;


architecture rtl of alu is
    signal r_t : std_logic_vector(DATA_WIDTH-1 downto 0);
    
    function slt(arg0: in std_logic_vector(DATA_WIDTH-1 downto 0);
                 arg1: in std_logic_vector(DATA_WIDTH-1 downto 0)) 
                 return integer is
        variable result : integer range 0 to 2 := 0;
    begin
        if (arg0(arg0'left) = '1' and arg1(arg1'left) = '1') then
            if (unsigned(arg0(DATA_WIDTH-2 downto 0)) > unsigned(arg0(DATA_WIDTH-2 downto 0))) then
                result := 1;
            elsif (unsigned(arg0(DATA_WIDTH-2 downto 0)) > unsigned(arg0(DATA_WIDTH-2 downto 0))) then
                result := 2;
            else 
                result := 0;
            end if;
        elsif (arg0(arg0'left) = '1') then
            result := 2;
        elsif (arg1(arg1'left) = '1') then
            result := 1;
        else
            if (unsigned(arg0(DATA_WIDTH-2 downto 0)) > unsigned(arg0(DATA_WIDTH-2 downto 0))) then
                result := 1;
            elsif (unsigned(arg0(DATA_WIDTH-2 downto 0)) > unsigned(arg0(DATA_WIDTH-2 downto 0))) then
                result := 2;
            else 
                result := 0;
            end if;
        end if;
    end function;        
                 
begin
    process(all) is
    begin
        case(ctrl) is
            when "000" =>
                  r_t <= a and b;
            when "001" =>        
                  r_t <= a or b;
            when "010" =>        
                  r_t <= a + b;
--            when "011" =>  -- not used      
--                  r_t <= null;
            when "100" =>        
                  r_t <= a and not(b);
            when "101" =>        
                  r_t <= a or not(b);
            when "110" =>        
                  r_t <= a - b;
            when "111" =>        
                  r_t <= std_logic_vector(to_unsigned(slt(a,b),DATA_WIDTH));
            when others =>
                  r_t <= (others => '0');
        end case;
    end process;
    zero <= '1' when (unsigned(r_t) = 0) else '0';
    r <= r_t;
end architecture;