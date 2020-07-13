
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity main is
    generic (
        word_size : natural := 10;
        exp_size  : natural := 4
    );
    port (
        op_a : in  std_logic_vector(word_size - 1 downto 0);
        op_b : in  std_logic_vector(word_size - 1 downto 0);
        res  : out std_logic_vector(word_size - 1 downto 0)
    );
end entity main;

architecture main_arq of main is

    constant BIAS       : integer := 2**(exp_size - 1) - 1;

    -- exponent part
    constant EXP_BEGIN  : natural := word_size - 2;
    constant EXP_END    : natural := EXP_BEGIN - exp_size + 1;

    -- fraction part
    constant MANT_BEGIN : natural := EXP_END - 1;
    constant MANT_END   : natural := 0;
    constant MANT_SIZE  : natural := word_size - exp_size - 1;

    signal decoded_exp_a : integer := 0;
    signal decoded_exp_b : integer := 0;

	signal swap_aux : std_logic := '0';
	signal sign_a_out_aux : std_logic := '0';
	signal sign_b_out_aux : std_logic := '0';
	signal exp_a_out_aux : integer := 0;
	signal exp_b_out_aux : integer := 0;
	signal swap_significand_a_aux : std_logic_vector(MANT_SIZE downto 0) := (others => '0');
	signal swap_significand_b_aux : std_logic_vector(MANT_SIZE downto 0) := (others => '0');

	signal comp_sig_b_aux : std_logic := '0';
	signal significand_b_aux : std_logic_vector(MANT_SIZE downto 0) := (others => '0');
	signal significand_b_out_aux : std_logic_vector(MANT_SIZE downto 0) := (others => '0');
	signal guard_bit_aux : std_logic := '0';

	signal significand_res_aux : std_logic_vector(MANT_SIZE downto 0) := (others => '0');
	signal comp_sig_aux : std_logic := '0';
	signal c_out_aux : std_logic := '0';

	signal significand_out_aux : std_logic_vector(MANT_SIZE downto 0) := (others => '0');
	signal exp_out_aux : integer := 0;

	signal sign_out_aux : std_logic := '0';
    signal significand_a : std_logic_vector(MANT_SIZE downto 0) := (others => '0');
    signal significand_b : std_logic_vector(MANT_SIZE downto 0) := (others => '0');

begin

    decoded_exp_a <= to_integer(unsigned(op_a(EXP_BEGIN downto EXP_END))) - BIAS;
    decoded_exp_b <= to_integer(unsigned(op_b(EXP_BEGIN downto EXP_END))) - BIAS;

	STEP_1_SWAP_OPERANDS: entity work.step_1_swap_operands
		generic map(
			exp_size => exp_size,
			mant_size => MANT_SIZE
		)
		port map(
			swap => swap_aux,
			sign_a => op_a(word_size - 1),
			sign_b => op_b(word_size - 1),
			exp_a => decoded_exp_a,
			exp_b => decoded_exp_b,
			mant_a => op_a(MANT_BEGIN downto MANT_END),
			mant_b => op_b(MANT_BEGIN downto MANT_END),
			sign_a_out => sign_a_out_aux,
			sign_b_out => sign_b_out_aux,
			exp_a_out => exp_a_out_aux,
			exp_b_out => exp_b_out_aux,
			significand_a_out => swap_significand_a_aux,
			significand_b_out => swap_significand_b_aux
		);

	STEP_2_COMPLEMENT_SIG_B: entity work.step_2_complement_sig_b
		generic map(
			mant_size => MANT_SIZE
		)
		port map(
			comp_sig_b => comp_sig_b_aux,
			sign_a => sign_a_out_aux,
			sign_b => sign_b_out_aux,
			significand_b => swap_significand_b_aux,
			significand_b_out => significand_b_aux
		);

	STEP_3_SHIFT_SIG_B: entity work.step_3_shift_sig_b
		generic map(
			mant_size => MANT_SIZE
		)
		port map(
			comp_sig_b => comp_sig_b_aux,
			significand_b => significand_b_aux,
			significand_b_out => significand_b_out_aux,
			exp_a => exp_a_out_aux,
			exp_b => exp_b_out_aux,
			guard_bit => guard_bit_aux
		);

	STEP_4_SUM_SIGNIFICANDS: entity work.step_4_sum_significands
		generic map(
			mant_size => MANT_SIZE
		)
		port map(
			significand_a => swap_significand_a_aux,
			significand_b => significand_b_out_aux,
			significand_res => significand_res_aux,
			sign_a => sign_a_out_aux,
			sign_b => sign_b_out_aux,
			comp_sig => comp_sig_aux,
			c_out => c_out_aux
		);

	STEP_5_SHIFT_SIG_RES: entity work.step_5_shift_sig_res
		generic map(
			mant_size => MANT_SIZE
		)
		port map(
			c_out => c_out_aux,
			guard_bit => guard_bit_aux,
			sign_a => sign_a_out_aux,
			sign_b => sign_b_out_aux,
			significand_in => significand_res_aux,
			significand_out => significand_out_aux,
			exp => exp_a_out_aux,
			exp_out => exp_out_aux
		);

	STEP_8_CALC_SIGN: entity work.step_8_calc_sign
		port map(
			sign_a => sign_a_out_aux,
			sign_b => sign_b_out_aux,
			swap => swap_aux,
			comp_sig => comp_sig_aux,
			sign_out => sign_out_aux
		);

	RESULT_BUILDER: entity work.result_builder
        generic map(
            word_size => word_size,
            exp_size  => exp_size,
            mant_size => MANT_SIZE
        )
        port map(
            sign    => sign_out_aux,
            exp_in  => exp_out_aux,
            mant_in => significand_out_aux(MANT_SIZE - 1 downto 0),
            res     => res
        );

end architecture main_arq;
