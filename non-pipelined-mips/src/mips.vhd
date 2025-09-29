library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_std_unsigned.all;
use work.util.all;

entity mips is
    generic(
        MEM_WORD_SIZE : integer := 8
    );
    port(
    clk_i : in std_logic;
    rst_i : in std_logic
--    reg_o: out std_logic_vector(31 downto 0)
    );
    attribute keep_hierarchy : string;
    attribute keep_hierarchy of mips : entity is "yes";
end entity;

architecture rtl of mips is
--    attribute dont_touch : string;
--    attribute dont_touch of rtl : architecture is "yes";
    -- register_file --
    signal register_file_0_clk_i_t    : std_logic;
    signal register_file_0_rst_i_t    : std_logic;
    signal register_file_0_wr_i_t     : std_logic;
    signal register_file_0_addr0_i_t  : std_logic_vector(clog2(32)-1 downto 0); -- A1
    signal register_file_0_addr1_i_t  : std_logic_vector(clog2(32)-1 downto 0); -- A2
    signal register_file_0_addr2_i_t  : std_logic_vector(clog2(32)-1 downto 0); -- A3
    signal register_file_0_data_i_t   : std_logic_vector(31 downto 0);  -- W3
    signal register_file_0_data0_o_t  : std_logic_vector(31 downto 0); -- RD1
    signal register_file_0_data1_o_t  : std_logic_vector(31 downto 0); -- RD2
    
    component register_file
        generic(
            DATA_WIDTH : integer := 32;
            DEPTH : integer := 32
        );
        port(
            clk_i    : in std_logic;
            rst_i    : in std_logic;
            wr_i     : in std_logic;
            addr0_i  : in std_logic_vector(clog2(DEPTH)-1 downto 0); -- A1
            addr1_i  : in std_logic_vector(clog2(DEPTH)-1 downto 0); -- A2
            addr2_i  : in std_logic_vector(clog2(DEPTH)-1 downto 0); -- A3
            data_i   : in std_logic_vector(DATA_WIDTH-1 downto 0);   -- W3
            data0_o  : out std_logic_vector(DATA_WIDTH-1 downto 0);  -- RD1
            data1_o  : out std_logic_vector(DATA_WIDTH-1 downto 0)   -- RD2
        );
    end component;
    -------------
    
    -- register --
    signal registers_0_clk_i_t       : std_logic;
    signal registers_0_rst_i_t       : std_logic;
    signal registers_0_data_i_t   : std_logic_vector(31 downto 0); --registers_0_data_o_t
    signal registers_0_data_o_t  : std_logic_vector(31 downto 0);

    -- Instantiate the register component
    component registers
        generic(
            DATA_WIDTH : integer := 32
        );
        port(
            clk_i  : in std_logic;
            rst_i  : in std_logic;
            data_i : in std_logic_vector(DATA_WIDTH-1 downto 0);
            data_o : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;
    -------------
    
    -- sign_extend --
    signal sign_extend_0_data_i_t    : std_logic_vector(15 downto 0); -- sign_extend_0_data_i_t
    signal sign_extend_0_data_o_t   : std_logic_vector(31 downto 0);

    -- Instantiate the sign_extend component
    component sign_extend
        generic(
            DATA_IN_WIDTH : integer := 5;
            DATA_OUT_WIDTH : integer := 32
        );
        port(
            data_i : in std_logic_vector(DATA_IN_WIDTH-1 downto 0);
            data_o : out std_logic_vector(DATA_OUT_WIDTH-1 downto 0)
        );
    end component;
    -----------------
    
    -- adder --
    signal adder_0_a_t : std_logic_vector(31 downto 0);
    signal adder_0_b_t : std_logic_vector(31 downto 0);
    signal adder_0_c_t : std_logic_vector(31 downto 0);

    signal adder_1_a_t : std_logic_vector(31 downto 0);
    signal adder_1_b_t : std_logic_vector(31 downto 0);
    signal adder_1_c_t : std_logic_vector(31 downto 0);
    
    component adder
        generic(
            DATA_WIDTH : integer := 32
        );
        port(
            a: in std_logic_vector(DATA_WIDTH-1 downto 0);
            b: in std_logic_vector(DATA_WIDTH-1 downto 0);
            c: out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;
    -----------
    
    -- alu --
    signal alu_0_a_t    : std_logic_vector(31 downto 0);
    signal alu_0_b_t    : std_logic_vector(31 downto 0);
    signal alu_0_r_t    : std_logic_vector(31 downto 0);
    signal alu_0_zero_t : std_logic;
    signal alu_0_ctrl_t : std_logic_vector(2 downto 0);

    -- alu --
    component alu
        generic(
            DATA_WIDTH : integer := 32
        );
        port(
            a    : in std_logic_vector(DATA_WIDTH-1 downto 0);
            b    : in std_logic_vector(DATA_WIDTH-1 downto 0);
            r    : out std_logic_vector(DATA_WIDTH-1 downto 0);
            zero : out std_logic;
            ctrl : in std_logic_vector(2 downto 0)
        );
    end component;
    ---------
    
    -- data_memory --
    signal data_memory_0_clk_i_t   : std_logic;
    signal data_memory_0_rst_i_t   : std_logic;
    signal data_memory_0_we_i_t    : std_logic;
    signal data_memory_0_addr_i_t  : std_logic_vector(31 downto 0);  -- Assuming DEPTH=1024, clog2(1024) = 10
    signal data_memory_0_data_i_t : std_logic_vector(31 downto 0);
    signal data_memory_0_data_o_t : std_logic_vector(31 downto 0);

    -- Instantiate the data_memory component
    component data_memory
        generic(
            DATA_WIDTH : integer := 32;
            DEPTH : integer := 1024
        );
        port(
            clk_i   : in std_logic;
            rst_i   : in std_logic;
            we_i    : in std_logic;
            addr_i  : in std_logic_vector(DATA_WIDTH-1 downto 0);
            data_i  : in std_logic_vector(DATA_WIDTH-1 downto 0);
            data_o  : out std_logic_vector(DATA_WIDTH-1 downto 0)
        );
    end component;
    -----------------
    
    -- instruction_memory --
    signal instruction_memory_0_addr_i_t : std_logic_vector(31 downto 0);  -- Assuming DEPTH=1024, clog2(1024) = 10
    signal instruction_memory_0_data_o_t : std_logic_vector(31 downto 0);

    -- instruction memory --
    component instruction_memory
        generic(
            DATA_WIDTH : integer := 32;
            DEPTH : integer := 1024
        );
        port(
            addr_i  : in std_logic_vector(DATA_WIDTH-1 downto 0);
            data_o  : out std_logic_vector(DATA_WIDTH-1 downto 0)   
        );
    end component;
    ------------------------
    
    -- shift --
    signal shift_0_i_t : std_logic_vector(31 downto 0);
    signal shift_0_o_t : std_logic_vector(31 downto 0);


    -- Instantiate the shift components
    component shift
        generic(
            DATA_WIDTH : integer := 8;
            RIGHT : std_logic := '0';
            N : integer := 2
        );
        port(
            i : in std_logic_vector(DATA_WIDTH - 1 downto 0);
            o : out std_logic_vector(DATA_WIDTH - 1 downto 0)
        );
    end component;
    -----------
    
    -- mux2x1 --
    signal mux2x1_0_i0_t   : std_logic_vector(31 downto 0);
    signal mux2x1_0_i1_t   : std_logic_vector(31 downto 0);
    signal mux2x1_0_sel_t  : std_logic;
    signal mux2x1_0_o_t    : std_logic_vector(31 downto 0);

    signal mux2x1_1_i0_t   : std_logic_vector(31 downto 0);
    signal mux2x1_1_i1_t   : std_logic_vector(31 downto 0);
    signal mux2x1_1_sel_t  : std_logic;
    signal mux2x1_1_o_t    : std_logic_vector(31 downto 0);

    signal mux2x1_2_i0_t   : std_logic_vector(4 downto 0);
    signal mux2x1_2_i1_t   : std_logic_vector(4 downto 0);
    signal mux2x1_2_sel_t  : std_logic;
    signal mux2x1_2_o_t    : std_logic_vector(4 downto 0);

    signal mux2x1_3_i0_t   : std_logic_vector(31 downto 0);
    signal mux2x1_3_i1_t   : std_logic_vector(31 downto 0);
    signal mux2x1_3_sel_t  : std_logic;
    signal mux2x1_3_o_t    : std_logic_vector(31 downto 0);


    -- Instantiate the mux2x1 components
    component mux2x1
        generic(
            DATA_WIDTH : integer := 32
        );
        port(
            i0  : in std_logic_vector(DATA_WIDTH - 1 downto 0);
            i1  : in std_logic_vector(DATA_WIDTH - 1 downto 0);
            sel : in std_logic;
            o   : out std_logic_vector(DATA_WIDTH - 1 downto 0)
        );
    end component;
    ------------
    
    -- and_gate --
    signal and_gate_0_i0_t : std_logic_vector(0 downto 0);
    signal and_gate_0_i1_t : std_logic_vector(0 downto 0);
    signal and_gate_0_o_t : std_logic_vector(0 downto 0);
    
    -- Instantiate the and_gate components
    component and_gate is
    generic(
        DATA_WIDTH : integer := 32
    );
    port(
        i0: in std_logic_vector(DATA_WIDTH-1 downto 0);
        i1: in std_logic_vector(DATA_WIDTH-1 downto 0);
        o : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );

    end component;
    --------------
    
    -- control unit --
    signal control_unit_0_op_i_t : std_logic_vector(5 downto 0);
    signal control_unit_0_funct_i_t : std_logic_vector(5 downto 0);
    signal control_unit_0_mem_to_reg_o_t : std_logic;
    signal control_unit_0_mem_write_o_t : std_logic;
    signal control_unit_0_branch_o_t : std_logic;
    signal control_unit_0_alu_src_o_t : std_logic;
    signal control_unit_0_reg_dst_o_t : std_logic;
    signal control_unit_0_reg_write_o_t : std_logic;
    signal control_unit_0_alu_ctrl_o_t : std_logic_vector(2 downto 0);
    
    component control_unit is
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
    end component;
    ------------------
    
begin
    
--    reg_o <= mux2x1_1_o_t;
    
    adder_0_a_t            <= registers_0_data_o_t; -- pc regisiter data out --
    adder_0_b_t            <= std_logic_vector(to_unsigned(MEM_WORD_SIZE/8,32));
    
    registers_0_data_i_t   <= mux2x1_3_o_t;
    registers_0_clk_i_t    <= clk_i;
    registers_0_rst_i_t     <= rst_i;

    instruction_memory_0_addr_i_t <= registers_0_data_o_t; -- pc register data out --
    
    sign_extend_0_data_i_t <= instruction_memory_0_data_o_t(15 downto 0);
    
    register_file_0_clk_i_t     <= clk_i;
    register_file_0_rst_i_t     <= rst_i;
    register_file_0_wr_i_t      <= control_unit_0_reg_write_o_t;
    register_file_0_addr0_i_t  <= instruction_memory_0_data_o_t(25 downto 21);
    register_file_0_addr1_i_t  <= instruction_memory_0_data_o_t(20 downto 16);
    register_file_0_addr2_i_t  <= mux2x1_2_o_t; -- instruction_memory_0_data_o_t(20 downto 16)
    register_file_0_data_i_t    <= mux2x1_1_o_t;
    
    
    alu_0_a_t  <= register_file_0_data0_o_t;
    alu_0_b_t  <= mux2x1_0_o_t;
    alu_0_ctrl_t <= control_unit_0_alu_ctrl_o_t;
    
    data_memory_0_clk_i_t <= clk_i;
    data_memory_0_rst_i_t <= rst_i;
    data_memory_0_we_i_t <= control_unit_0_mem_write_o_t;
    data_memory_0_addr_i_t <= alu_0_r_t;
    data_memory_0_data_i_t <= register_file_0_data1_o_t;
    
    mux2x1_0_i0_t <= register_file_0_data1_o_t;
    mux2x1_0_i1_t <= sign_extend_0_data_o_t;
    mux2x1_0_sel_t <= control_unit_0_alu_src_o_t; -- alu_src;
    
    mux2x1_1_i0_t <= alu_0_r_t;
    mux2x1_1_i1_t <= data_memory_0_data_o_t;
    mux2x1_1_sel_t <= control_unit_0_mem_to_reg_o_t; -- mem_to_reg
    
    mux2x1_2_i0_t <= instruction_memory_0_data_o_t(20 downto 16);
    mux2x1_2_i1_t <= instruction_memory_0_data_o_t(15 downto 11);
    mux2x1_2_sel_t <= control_unit_0_reg_dst_o_t; -- reg_dest
       
    shift_0_i_t <= sign_extend_0_data_o_t;
    
    adder_1_a_t <= shift_0_o_t;
    adder_1_b_t <= adder_0_c_t;
    
    and_gate_0_i0_t(0) <= alu_0_zero_t; 
    and_gate_0_i1_t(0) <= control_unit_0_branch_o_t; -- branch
    
    mux2x1_3_i0_t <= adder_0_c_t;
    mux2x1_3_i1_t <= adder_1_c_t;
    mux2x1_3_sel_t <=  and_gate_0_o_t(0); -- pc_src
    
    control_unit_0_op_i_t <= instruction_memory_0_data_o_t(31 downto 26);
    control_unit_0_funct_i_t <= instruction_memory_0_data_o_t(5 downto 0);
     
     
     
     
    register_file_0 : register_file
    generic map(
        DATA_WIDTH => 32,
        DEPTH      => 32
    )
    port map(
        -- Connect the ports of the top-level module to the signals with "_t" suffix
        clk_i    => register_file_0_clk_i_t,
        rst_i    => register_file_0_rst_i_t,
        wr_i     => register_file_0_wr_i_t,
        addr0_i  => register_file_0_addr0_i_t,
        addr1_i  => register_file_0_addr1_i_t,
        addr2_i  => register_file_0_addr2_i_t,
        data_i   => register_file_0_data_i_t,
        data0_o  => register_file_0_data0_o_t,
        data1_o  => register_file_0_data1_o_t
    );
    
    registers_0 : registers
    generic map(
        DATA_WIDTH => 32
    )
    port map(
        -- Connect the ports of the top-level module to the signals
        clk_i  => registers_0_clk_i_t,
        rst_i  => registers_0_rst_i_t,
        data_i => registers_0_data_i_t,
        data_o => registers_0_data_o_t
    );
    
    sign_extend_0 : sign_extend
    generic map(
        DATA_IN_WIDTH  => 16,
        DATA_OUT_WIDTH => 32
    )
    port map(
        -- Connect the ports of the top-level module to the signals
        data_i => sign_extend_0_data_i_t,
        data_o => sign_extend_0_data_o_t
    );

    adder_0 : adder
    generic map(
        DATA_WIDTH => 32
    )
    port map(
        a => adder_0_a_t,
        b => adder_0_b_t,
        c => adder_0_c_t
    );
    
    adder_1 : adder
    generic map(
        DATA_WIDTH => 32
    )
    port map(
        a => adder_1_a_t,
        b => adder_1_b_t,
        c => adder_1_c_t
    );
    
    alu_0 : alu
    generic map(
        DATA_WIDTH => 32
    )
    port map(
        a    => alu_0_a_t,
        b    => alu_0_b_t,
        r    => alu_0_r_t,
        zero => alu_0_zero_t,
        ctrl => alu_0_ctrl_t
    );
    
    data_memory_0 : data_memory
    generic map(
        DATA_WIDTH => 32,
        DEPTH      => 1024
    )
    port map(
        clk_i   => data_memory_0_clk_i_t,
        rst_i   => data_memory_0_rst_i_t,
        we_i    => data_memory_0_we_i_t,
        addr_i  => data_memory_0_addr_i_t,
        data_i  => data_memory_0_data_i_t,
        data_o  => data_memory_0_data_o_t
    );
    
    instruction_memory_0 : instruction_memory
    generic map(
        DATA_WIDTH => 32,
        DEPTH      => 1024
    )
    port map(
        addr_i  => instruction_memory_0_addr_i_t,
        data_o  => instruction_memory_0_data_o_t
    );
    
    shift_0 : shift
        generic map(
            DATA_WIDTH => 32,
            RIGHT      => '0',
            N          => 2
        )
        port map(
            i => shift_0_i_t,
            o => shift_0_o_t
        );
        
    mux2x1_0 : mux2x1
        generic map(
            DATA_WIDTH => 32
        )
        port map(
            i0  => mux2x1_0_i0_t,
            i1  => mux2x1_0_i1_t,
            sel => mux2x1_0_sel_t,
            o   => mux2x1_0_o_t
        );

    mux2x1_1 : mux2x1
        generic map(
            DATA_WIDTH => 32
        )
        port map(
            i0  => mux2x1_1_i0_t,
            i1  => mux2x1_1_i1_t,
            sel => mux2x1_1_sel_t,
            o   => mux2x1_1_o_t
        );

    mux2x1_2 : mux2x1
        generic map(
            DATA_WIDTH => 5
        )
        port map(
            i0  => mux2x1_2_i0_t,
            i1  => mux2x1_2_i1_t,
            sel => mux2x1_2_sel_t,
            o   => mux2x1_2_o_t
        );

    mux2x1_3 : mux2x1
        generic map(
            DATA_WIDTH => 32
        )
        port map(
            i0  => mux2x1_3_i0_t,
            i1  => mux2x1_3_i1_t,
            sel => mux2x1_3_sel_t,
            o   => mux2x1_3_o_t
        );

    and_gate_0: and_gate
        generic map(
            DATA_WIDTH => 1
        )
        port map(
            i0 => and_gate_0_i0_t,
            i1 => and_gate_0_i1_t,
            o => and_gate_0_o_t
        );
        
    control_unit_0: control_unit
    port map (
        op_i => control_unit_0_op_i_t,
        funct_i => control_unit_0_funct_i_t,
        mem_to_reg_o => control_unit_0_mem_to_reg_o_t,
        mem_write_o => control_unit_0_mem_write_o_t,
        branch_o => control_unit_0_branch_o_t,
        alu_src_o => control_unit_0_alu_src_o_t,
        reg_dst_o => control_unit_0_reg_dst_o_t,
        reg_write_o => control_unit_0_reg_write_o_t,
        alu_ctrl_o => control_unit_0_alu_ctrl_o_t
    );
end architecture;