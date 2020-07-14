
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity main is
    generic (
        word_size : natural := 10;
        exp_size  : natural := 4
    );
    port (
        op_a  : in  std_logic_vector(word_size - 1 downto 0);
        op_b  : in  std_logic_vector(word_size - 1 downto 0);
        res   : out std_logic_vector(word_size - 1 downto 0);
		clk   : in std_logic;
		start : in std_logic;
		done  : out std_logic
    );
end entity main;

architecture main_arq of main is

	constant BIAS       : integer := 2**(exp_size - 1) - 1;
	constant MANT_SIZE  : natural := word_size - exp_size - 1;

	-- register size constants
	constant REG_0_SIZE : natural := 2 * word_size;
	constant REG_1_SIZE : natural := 2 + 2 * exp_size + 2 * (MANT_SIZE + 1) + 1;
	constant REG_2_SIZE : natural := REG_1_SIZE + 1;
	constant REG_3_SIZE : natural := REG_2_SIZE;
	constant REG_4_SIZE : natural := 2 + exp_size + (MANT_SIZE + 1) + 4;
	constant REG_5_SIZE : natural := 2 + exp_size + (MANT_SIZE + 1) + 2;
	constant REG_8_SIZE : natural := 1 + exp_size + (MANT_SIZE + 1);

	-- register limit constants
	-- R0
	-- sign | exp | mant | sign | exp | mant
	constant R0_SIGN_A : natural := REG_0_SIZE - 1;
	constant R0_SIGN_B : natural := exp_size + MANT_SIZE;
	constant R0_EXP_A_BEGIN : natural := 2 * MANT_SIZE + exp_size + 1;
	constant R0_EXP_A_END : natural := REG_0_SIZE - 2;
	constant R0_EXP_B_BEGIN : natural := MANT_SIZE;
	constant R0_EXP_B_END : natural := exp_size + MANT_SIZE - 1;
	constant R0_MANT_A_BEGIN : natural := exp_size + MANT_SIZE + 1;
	constant R0_MANT_A_END : natural := 2 * MANT_SIZE + exp_size;
	constant R0_MANT_B_BEGIN : natural := 0;
	constant R0_MANT_B_END : natural := MANT_SIZE - 1;

	-- R1
	-- sign_a | exp_a | significand_a | sign_b | exp_b | significand_b | swap
	constant R1_SWAP : natural := 0;
	constant R1_FRAC_B_BEGIN : natural := R1_SWAP + 1;
	constant R1_FRAC_B_END : natural  := R1_FRAC_B_BEGIN + MANT_SIZE;
	constant R1_EXP_B_BEGIN : natural := R1_FRAC_B_END + 1;
	constant R1_EXP_B_END : natural   := R1_EXP_B_BEGIN + exp_size - 1;
	constant R1_SIGN_A : natural := REG_1_SIZE - 1;
	constant R1_SIGN_B : natural := R1_EXP_B_END + 1;
	constant R1_FRAC_A_BEGIN : natural := R1_SIGN_B + 1;
	constant R1_FRAC_A_END : natural := R1_FRAC_A_BEGIN + MANT_SIZE;
	constant R1_EXP_A_BEGIN : natural := R1_FRAC_A_END + 1;
	constant R1_EXP_A_END : natural   := R1_EXP_A_BEGIN + exp_size - 1;

	-- R2
	-- sign_a | exp_a | significand_a | sign_b | exp_b | significand_b | swap | comp_b
	constant R2_COMP_B : natural := 0;
	constant R2_SWAP : natural := 1;
	constant R2_FRAC_B_BEGIN : natural := R2_SWAP + 1;
	constant R2_FRAC_B_END : natural  := R2_FRAC_B_BEGIN + MANT_SIZE;
	constant R2_EXP_B_BEGIN : natural := R2_FRAC_B_END + 1;
	constant R2_EXP_B_END : natural   := R2_EXP_B_BEGIN + exp_size - 1;
	constant R2_SIGN_A : natural := REG_2_SIZE - 1;
	constant R2_SIGN_B : natural := R2_EXP_B_END + 1;
	constant R2_FRAC_A_BEGIN : natural := R2_SIGN_B + 1;
	constant R2_FRAC_A_END : natural := R2_FRAC_A_BEGIN + MANT_SIZE;
	constant R2_EXP_A_BEGIN : natural := R2_FRAC_A_END + 1;
	constant R2_EXP_A_END : natural   := R2_EXP_A_BEGIN + exp_size - 1;

	-- R3
	-- sign_a | exp_a | significand_a | sign_b | exp_b | significand_b | swap | guard_bit
	constant R3_GUARD_BIT : natural := 0;
	constant R3_SWAP : natural := 1;
	constant R3_FRAC_B_BEGIN : natural := R3_SWAP + 1;
	constant R3_FRAC_B_END : natural  := R3_FRAC_B_BEGIN + MANT_SIZE;
	constant R3_EXP_B_BEGIN : natural := R3_FRAC_B_END + 1;
	constant R3_EXP_B_END : natural   := R3_EXP_B_BEGIN + exp_size - 1;
	constant R3_SIGN_A : natural := REG_3_SIZE - 1;
	constant R3_SIGN_B : natural := R3_EXP_B_END + 1;
	constant R3_FRAC_A_BEGIN : natural := R3_SIGN_B + 1;
	constant R3_FRAC_A_END : natural := R3_FRAC_A_BEGIN + MANT_SIZE;
	constant R3_EXP_A_BEGIN : natural := R3_FRAC_A_END + 1;
	constant R3_EXP_A_END : natural   := R3_EXP_A_BEGIN + exp_size - 1;

	-- R4
	-- sign_a | sign_b | exp | significand | comp_sig | swap | guard_bit | c_out
	constant R4_COMP : natural := 3;
	constant R4_SWAP : natural := 2;
	constant R4_GUARD_BIT : natural := 1;
	constant R4_COUT : natural := 0;
	constant R4_SIGN_A : natural := REG_4_SIZE - 1;
	constant R4_SIGN_B : natural := REG_4_SIZE - 2;
	constant R4_FRAC_BEGIN : natural := R4_COMP + 1;
	constant R4_FRAC_END : natural   := R4_FRAC_BEGIN + MANT_SIZE;
	constant R4_EXP_BEGIN : natural  := R4_FRAC_END + 1;
	constant R4_EXP_END : natural    := R4_EXP_BEGIN + exp_size - 1;

	-- R5
	-- sign_a | sign_b | exp | significand | comp_sig | swap
	constant R5_COMP : natural := 1;
	constant R5_SWAP : natural := 0;
	constant R5_SIGN_A : natural := REG_5_SIZE - 1;
	constant R5_SIGN_B : natural := REG_5_SIZE - 2;
	constant R5_FRAC_BEGIN : natural := R5_COMP + 1;
	constant R5_FRAC_END : natural   := R5_FRAC_BEGIN + MANT_SIZE;
	constant R5_EXP_BEGIN : natural  := R5_FRAC_END + 1;
	constant R5_EXP_END : natural    := R5_EXP_BEGIN + exp_size - 1;

	-- R8
	-- sign | exp | significand
	constant R8_SIGN : natural := REG_8_SIZE - 1;
	constant R8_FRAC_BEGIN : natural := 0;
	constant R8_FRAC_END : natural := R8_FRAC_BEGIN + MANT_SIZE;
	constant R8_EXP_BEGIN : natural := R8_FRAC_END + 1;
	constant R8_EXP_END : natural := R8_EXP_BEGIN + exp_size - 1;

	-- register signals
	signal reg_0_in, reg_0_out : std_logic_vector(REG_0_SIZE - 1 downto 0);
	signal reg_1_in, reg_1_out : std_logic_vector(REG_1_SIZE - 1 downto 0);
	signal reg_2_in, reg_2_out : std_logic_vector(REG_2_SIZE - 1 downto 0);
	signal reg_3_in, reg_3_out : std_logic_vector(REG_3_SIZE - 1 downto 0);
	signal reg_4_in, reg_4_out : std_logic_vector(REG_4_SIZE - 1 downto 0);
	signal reg_5_in, reg_5_out : std_logic_vector(REG_5_SIZE - 1 downto 0);
	signal reg_8_in, reg_8_out : std_logic_vector(REG_8_SIZE - 1 downto 0);
	signal reg_out_in, reg_out_out : std_logic_vector(word_size - 1 downto 0);

    signal exp_val : integer := 0;

begin

	reg_0_in <= op_a & op_b;

	-- IN -> STEP-1
	REG_0: entity work.register_pipe
		generic map(
			N => REG_0_SIZE
		)
		port map(
			clk => clk,
			rst => '0',
			data_in => reg_0_in,
			data_out => reg_0_out
		);

	STEP_1_SWAP_OPERANDS: entity work.step_1_swap_operands
		generic map(
			exp_size => exp_size,
			mant_size => MANT_SIZE
		)
		port map(
			sign_a => reg_0_out(R0_SIGN_A),
			sign_b => reg_0_out(R0_SIGN_B),
			exp_a =>  reg_0_out(R0_EXP_A_END downto R0_EXP_A_BEGIN),
			exp_b =>  reg_0_out(R0_EXP_B_END downto R0_EXP_B_BEGIN),
			mant_a => reg_0_out(R0_MANT_A_END downto R0_MANT_A_BEGIN),
			mant_b => reg_0_out(R0_MANT_B_END downto R0_MANT_B_BEGIN),
			sign_a_out => reg_1_in(R1_SIGN_A),
			sign_b_out => reg_1_in(R1_SIGN_B),
			exp_a_out => reg_1_in(R1_EXP_A_END downto R1_EXP_A_BEGIN),
			exp_b_out => reg_1_in(R1_EXP_B_END downto R1_EXP_B_BEGIN),
			significand_a_out => reg_1_in(R1_FRAC_A_END downto R1_FRAC_A_BEGIN),
			significand_b_out => reg_1_in(R1_FRAC_B_END downto R1_FRAC_B_BEGIN),
			swap => reg_1_in(0)
		);

	-- STEP-1 -> STEP-2
	REG_1: entity work.register_pipe
		generic map(
			N => REG_1_SIZE
		)
		port map(
			clk => clk,
			rst => '0',
			data_in => reg_1_in,
			data_out => reg_1_out
		);

	STEP_2_COMPLEMENT_SIG_B: entity work.step_2_complement_sig_b
		generic map(
			mant_size => MANT_SIZE
		)
		port map(
			sign_a => reg_1_out(R1_SIGN_A),
			sign_b => reg_1_out(R1_SIGN_B),
			significand_b => reg_1_out(R1_FRAC_B_END downto R1_FRAC_B_BEGIN),
			significand_b_out => reg_2_in(R2_FRAC_B_END downto R2_FRAC_B_BEGIN),
			comp_sig_b => reg_2_in(R2_COMP_B)
		);

	-- bypass all the other fields not used
	-- swap
	reg_2_in(R2_SWAP) <= reg_1_out(R1_SWAP);
	 -- sign_a
	reg_2_in(R2_SIGN_A) <= reg_1_out(R1_SIGN_A);
	 -- exp_a
	reg_2_in(R2_EXP_A_END downto R2_EXP_A_BEGIN) <= reg_1_out(R1_EXP_A_END downto R1_EXP_A_BEGIN);
	 -- significand_a
	reg_2_in(R2_FRAC_A_END downto R2_FRAC_A_BEGIN) <= reg_1_out(R1_FRAC_A_END downto R1_FRAC_A_BEGIN);
	 -- sign_b
	reg_2_in(R2_SIGN_B) <= reg_1_out(R1_SIGN_B);
	 -- exp_b
	reg_2_in(R2_EXP_B_END downto R2_EXP_B_BEGIN) <= reg_1_out(R1_EXP_B_END downto R1_EXP_B_BEGIN);

	-- STEP-2 -> STEP-3
	REG_2: entity work.register_pipe
		generic map(
			N => REG_2_SIZE
		)
		port map(
			clk => clk,
			rst => '0',
			data_in => reg_2_in,
			data_out => reg_2_out
		);

	STEP_3_SHIFT_SIG_B: entity work.step_3_shift_sig_b
		generic map(
			exp_size => exp_size,
			mant_size => MANT_SIZE
		)
		port map(
			exp_a             => reg_2_out(R2_EXP_A_END downto R2_EXP_A_BEGIN),
			exp_b             => reg_2_out(R2_EXP_B_END downto R2_EXP_B_BEGIN),
			comp_sig_b        => reg_2_out(R2_COMP_B),
			significand_b     => reg_2_out(R2_FRAC_B_END downto R2_FRAC_B_BEGIN),
			significand_b_out => reg_3_in(R3_FRAC_B_END downto R3_FRAC_B_BEGIN),
			guard_bit         => reg_3_in(R3_GUARD_BIT)
		);

	-- bypass all the other fields not used
	-- swap
	reg_3_in(R3_SWAP) <= reg_2_out(R2_SWAP);
	 -- sign_a
	reg_3_in(R3_SIGN_A) <= reg_2_out(R2_SIGN_A);
	 -- exp_a
	reg_3_in(R3_EXP_A_END downto R3_EXP_A_BEGIN) <= reg_2_out(R2_EXP_A_END downto R2_EXP_A_BEGIN);
	 -- significand_a
	reg_3_in(R3_FRAC_A_END downto R3_FRAC_A_BEGIN) <= reg_2_out(R2_FRAC_A_END downto R2_FRAC_A_BEGIN);
	 -- sign_b
	reg_3_in(R3_SIGN_B) <= reg_2_out(R2_SIGN_B);
	 -- exp_b
	reg_3_in(R3_EXP_B_END downto R3_EXP_B_BEGIN) <= reg_2_out(R2_EXP_B_END downto R2_EXP_B_BEGIN);

	-- STEP-3 -> STEP-4
	REG_3: entity work.register_pipe
		generic map(
			N => REG_3_SIZE
		)
		port map(
			clk => clk,
			rst => '0',
			data_in => reg_3_in,
			data_out => reg_3_out
		);

	STEP_4_SUM_SIGNIFICANDS: entity work.step_4_sum_significands
		generic map(
			mant_size => MANT_SIZE
		)
		port map(
			sign_a          => reg_3_out(R3_SIGN_A),
			sign_b          => reg_3_out(R3_SIGN_B),
			significand_a   => reg_3_out(R3_FRAC_A_END downto R3_FRAC_A_BEGIN),
			significand_b   => reg_3_out(R3_FRAC_B_END downto R3_FRAC_B_BEGIN),
			significand_res => reg_4_in(R4_FRAC_END downto R4_FRAC_BEGIN),
			comp_sig        => reg_4_in(R4_COMP),
			c_out           => reg_4_in(R4_COUT)
		);

	-- bypass all the other fields not used
	-- swap
	reg_4_in(R4_SWAP) <= reg_3_out(R3_SWAP);
	-- guard bit
	reg_4_in(R4_GUARD_BIT) <= reg_3_out(R3_GUARD_BIT);
	 -- sign_a
	reg_4_in(R4_SIGN_A) <= reg_3_out(R3_SIGN_A);
	 -- sign_b
	reg_4_in(R4_SIGN_B) <= reg_3_out(R3_SIGN_B);
	 -- exp_a
	reg_4_in(R4_EXP_END downto R4_EXP_BEGIN) <= reg_3_out(R3_EXP_A_END downto R3_EXP_A_BEGIN);

	-- STEP-4 -> STEP-5
	REG_4: entity work.register_pipe
		generic map(
			N => REG_4_SIZE
		)
		port map(
			clk => clk,
			rst => '0',
			data_in => reg_4_in,
			data_out => reg_4_out
		);

	STEP_5_SHIFT_SIG_RES: entity work.step_5_shift_sig_res
		generic map(
			exp_size => exp_size,
			mant_size => MANT_SIZE
		)
		port map(
			c_out           => reg_4_out(R4_COUT),
			guard_bit       => reg_4_out(R4_GUARD_BIT),
			sign_a          => reg_4_out(R4_SIGN_A),
			sign_b          => reg_4_out(R4_SIGN_B),
			exp             => reg_4_out(R4_EXP_END downto R4_EXP_BEGIN),
			significand_in  => reg_4_out(R4_FRAC_END downto R4_FRAC_BEGIN),
			significand_out => reg_5_in(R5_FRAC_END downto R5_FRAC_BEGIN),
			exp_out         => reg_5_in(R5_EXP_END downto R5_EXP_BEGIN)
		);

	-- bypass all the other fields not used
	-- swap
	reg_5_in(R5_SWAP) <= reg_4_out(R4_SWAP);
	 -- sign_a
	reg_5_in(R5_SIGN_A) <= reg_4_out(R4_SIGN_A);
	 -- sign_b
	reg_5_in(R5_SIGN_B) <= reg_4_out(R4_SIGN_B);
	-- comp_sig
	reg_5_in(R5_COMP) <= reg_4_out(R4_COMP);

	-- STEP-5 -> STEP-8
	REG_5: entity work.register_pipe
		generic map(
			N => REG_5_SIZE
		)
		port map(
			clk => clk,
			rst => '0',
			data_in => reg_5_in,
			data_out => reg_5_out
		);

	STEP_8_CALC_SIGN: entity work.step_8_calc_sign
		port map(
			sign_a   => reg_5_out(R5_SIGN_A),
			sign_b   => reg_5_out(R5_SIGN_B),
			swap     => reg_5_out(R5_SWAP),
			comp_sig => reg_5_out(R5_COMP),
			sign_out => reg_8_in(R8_SIGN)
		);
	
	-- bypass all the other fields not used
	-- significand
	reg_8_in(R8_FRAC_END downto R8_FRAC_BEGIN) <= reg_5_out(R5_FRAC_END downto R5_FRAC_BEGIN);
    -- exponent
	reg_8_in(R8_EXP_END downto R8_EXP_BEGIN) <= reg_5_out(R5_EXP_END downto R5_EXP_BEGIN);

	-- STEP-8 -> builder
	REG_8: entity work.register_pipe
		generic map(
			N => REG_8_SIZE
		)
		port map(
			clk => clk,
			rst => '0',
			data_in => reg_8_in,
			data_out => reg_8_out
		);

	exp_val <= to_integer(unsigned(reg_8_out(R8_EXP_END downto R8_EXP_BEGIN))) - BIAS;

	RESULT_BUILDER: entity work.result_builder
        generic map(
            word_size => word_size,
            exp_size  => exp_size,
            mant_size => MANT_SIZE
        )
        port map(
            sign    => reg_8_out(R8_SIGN),
            exp_in  => exp_val,
            mant_in => reg_8_out(R8_FRAC_END - 1 downto R8_FRAC_BEGIN),
            res     => reg_out_in
        );

	-- builder -> OUT
	REG_OUT: entity work.register_pipe
		generic map(
			N => word_size
		)
		port map(
			clk => clk,
			rst => '0',
			data_in => reg_out_in,
			data_out => reg_out_out
		);

		res <= reg_out_out;

end architecture main_arq;
