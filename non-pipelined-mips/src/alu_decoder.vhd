library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;
use work.util.all;

entity alu_decoder is
    port(
        alu_op_i : in std_logic_vector(1 downto 0);
        funct_i : in std_logic_vector(5 downto 0);
        alu_ctrl_o : out std_logic_vector(2 downto 0)
    );
end entity;

architecture rtl of alu_decoder is
    signal alu_ctrl_o_t : std_logic_vector(2 downto 0);
begin
    process(all) is
    begin
        case(alu_op_i & funct_i) is
            when (b"00" & b"------") => -- add --
                alu_ctrl_o_t <= b"010";
            when (b"-1" & b"------") => -- sub --
                alu_ctrl_o_t <= b"110"; 
            when (b"1-" & b"100000") => -- add --
                alu_ctrl_o_t <= b"010";
            when (b"1-" & b"100010") => -- sub --
                alu_ctrl_o_t <= b"110";
            when (b"1-" & b"100100") => -- and --
                alu_ctrl_o_t <= b"000";
            when (b"1-" & b"100101") => -- or --
                alu_ctrl_o_t <= b"010";
            when (b"1-" & b"101010") => -- slt --
                alu_ctrl_o_t <= b"111";
            when others =>
                alu_ctrl_o_t <= b"---"; 
        end case;
    end process;
    alu_ctrl_o <= alu_ctrl_o_t;
end architecture;