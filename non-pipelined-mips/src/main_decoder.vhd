library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;
use work.util.all;

entity main_decoder is
    port(
        op_i :      in std_logic_vector(5 downto 0);
        mem_to_reg_o : out std_logic;
        mem_write_o : out std_logic;
        branch_o : out std_logic;
        alu_src_o: out std_logic;
        reg_dst_o: out std_logic;
        reg_write_o: out std_logic;
        alu_op_o: out std_logic_vector(1 downto 0)
    );

end entity;

architecture rtl of main_decoder is
    signal mem_to_reg_o_t : std_logic;
    signal mem_write_o_t  : std_logic;
    signal branch_o_t     : std_logic;
    signal alu_src_o_t    : std_logic;
    signal reg_dst_o_t    : std_logic;
    signal reg_write_o_t  : std_logic;
    signal alu_op_o_t     : std_logic_vector(1 downto 0);
begin
    process(all) is
    
    begin
        case(op_i) is
            when b"000000" => -- r type --
                mem_to_reg_o_t <= '0';
                mem_write_o_t  <= '0';
                branch_o_t     <= '0';
                alu_src_o_t    <= '0';
                reg_dst_o_t    <= '1';
                reg_write_o_t  <= '1';
                alu_op_o_t     <= b"10";
            when b"100011" => -- lw --
                mem_to_reg_o_t <= '1';
                mem_write_o_t  <= '0';
                branch_o_t     <= '0';
                alu_src_o_t    <= '1';
                reg_dst_o_t    <= '0';
                reg_write_o_t  <= '1';
                alu_op_o_t     <= b"00";
            when b"101011" => -- sw --
                mem_to_reg_o_t <= '-';
                mem_write_o_t  <= '1';
                branch_o_t     <= '0';
                alu_src_o_t    <= '1';
                reg_dst_o_t    <= '-';
                reg_write_o_t  <= '0';
                alu_op_o_t     <= b"00";
            when b"000100" => -- beq --
                mem_to_reg_o_t <= '-';
                mem_write_o_t  <= '0';
                branch_o_t     <= '1';
                alu_src_o_t    <= '0';
                reg_dst_o_t    <= '-';
                reg_write_o_t  <= '0';
                alu_op_o_t     <= b"01";
            when others => -- don't care --
                mem_to_reg_o_t <= '-';
                mem_write_o_t  <= '-';
                branch_o_t     <= '-';
                alu_src_o_t    <= '-';
                reg_dst_o_t    <= '-';
                reg_write_o_t  <= '-';
                alu_op_o_t     <= b"--";
        end case;
    end process;
    mem_to_reg_o <= mem_to_reg_o_t;
    mem_write_o  <= mem_write_o_t ;
    branch_o     <= branch_o_t    ;
    alu_src_o    <= alu_src_o_t   ;
    reg_dst_o    <= reg_dst_o_t   ;
    reg_write_o  <= reg_write_o_t ;
    alu_op_o     <= alu_op_o_t    ;
end architecture;