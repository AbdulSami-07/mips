library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;
use ieee.math_real.all;

package util is
    function clog2(input: integer) return integer; 
    function clog2(input: real) return integer;
end package;

package body util is
    function clog2(input: integer) return integer is
        variable num : real := real(input);
        variable result : integer := 0;
    begin
        while (num > real(1)) loop
            num := num / 2;
            result := result + 1;
        end loop;
        return result;
    end function;
    
    function clog2(input: real) return integer is
        variable num : real := input;
        variable result : integer := 0;
    begin
        while (num > real(1)) loop
            num := num / 2;
            result := result + 1;
        end loop;
        return result;
    end function;
end package body;