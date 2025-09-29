library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;
use work.util.all;

entity control_unit is
    port(
        op_i : in std_logic_vector(5 downto 0);
        funct_i : in std_logic_vector(5 downto 0);
        mem_to_reg_o : out std_logic;
        mem_write_o : out std_logic;
        branch_o : out std_logic;
        alu_src_o: out std_logic;
        reg_dst_o: out std_logic;
        reg_write_o: out std_logic;
        alu_ctrl_o : out std_logic_vector(2 downto 0)
    );

end entity;

architecture rtl of control_unit is
    -- main decoder --
    signal main_decoder_0_mem_to_reg_o_t : std_logic;
    signal main_decoder_0_mem_write_o_t : std_logic;
    signal main_decoder_0_branch_o_t : std_logic;
    signal main_decoder_0_alu_src_o_t : std_logic;
    signal main_decoder_0_reg_dst_o_t : std_logic;
    signal main_decoder_0_reg_write_o_t : std_logic;
    signal main_decoder_0_alu_op_o_t : std_logic_vector(1 downto 0);
    
    component main_decoder is
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
    end component;
    ------------------
    
    -- alu decoder --
    signal alu_decoder_0_alu_op_i_t : std_logic_vector(1 downto 0);
    signal alu_decoder_0_funct_i_t : std_logic_vector(5 downto 0);
    signal alu_decoder_0_alu_ctrl_o_t : std_logic_vector(2 downto 0);
    
    component alu_decoder is
    port(
        alu_op_i : in std_logic_vector(1 downto 0);
        funct_i : in std_logic_vector(5 downto 0);
        alu_ctrl_o : out std_logic_vector(2 downto 0)
    );
    end component;
    -----------------
begin
    mem_to_reg_o <= main_decoder_0_mem_to_reg_o_t;
    mem_write_o <= main_decoder_0_mem_write_o_t;
    branch_o <= main_decoder_0_branch_o_t;
    alu_src_o <= main_decoder_0_alu_src_o_t;
    reg_dst_o <= main_decoder_0_reg_dst_o_t;
    reg_write_o <= main_decoder_0_reg_write_o_t;
    alu_ctrl_o <= alu_decoder_0_alu_ctrl_o_t;

    alu_decoder_0_alu_op_i_t <= main_decoder_0_alu_op_o_t;
    alu_decoder_0_funct_i_t <= funct_i;
    
    main_decoder_0: main_decoder
    port map (
        op_i => op_i,
        mem_to_reg_o => main_decoder_0_mem_to_reg_o_t,
        mem_write_o => main_decoder_0_mem_write_o_t,
        branch_o => main_decoder_0_branch_o_t,
        alu_src_o => main_decoder_0_alu_src_o_t,
        reg_dst_o => main_decoder_0_reg_dst_o_t,
        reg_write_o => main_decoder_0_reg_write_o_t,
        alu_op_o => main_decoder_0_alu_op_o_t
    );
    
    alu_decoder_0: alu_decoder
    port map (
        alu_op_i => alu_decoder_0_alu_op_i_t,
        funct_i => alu_decoder_0_funct_i_t,
        alu_ctrl_o => alu_decoder_0_alu_ctrl_o_t
    );
end architecture;