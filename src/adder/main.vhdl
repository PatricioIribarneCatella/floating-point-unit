
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
        res : out  std_logic_vector(word_size - 1 downto 0)
    );
end entity main;

architecture main_arq of main is

    constant BIAS       : integer := 2**(exp_size - 1) - 1;

    -- sign part
    signal sign_aux      : std_logic;

    -- exponent part
    constant EXP_BEGIN  : natural := word_size - 2;
    constant EXP_END    : natural := EXP_BEGIN - exp_size + 1;

    signal exp_aux       : integer;
    signal exp_res_aux   : integer;
    signal decoded_exp_a : integer := 0;
    signal decoded_exp_b : integer := 0;

    -- fraction part
    constant MANT_BEGIN : natural := EXP_END - 1;
    constant MANT_END   : natural := 0;
    constant MANT_SIZE  : natural := word_size - exp_size - 1;

    signal mant_aux      : std_logic_vector(MANT_SIZE - 1 downto 0);
    signal mant_res_aux  : std_logic_vector(2 * MANT_SIZE + 1 downto 0);
    signal significand_a : std_logic_vector(MANT_SIZE downto 0);
    signal significand_b : std_logic_vector(MANT_SIZE downto 0);

begin

    decoded_exp_a <= to_integer(unsigned(op_a(EXP_BEGIN downto EXP_END))) - BIAS;
    decoded_exp_b <= to_integer(unsigned(op_b(EXP_BEGIN downto EXP_END))) - BIAS;

    significand_a <= '1' & op_a(MANT_BEGIN downto MANT_END);
    significand_b <= '1' & op_b(MANT_BEGIN downto MANT_END);

	STEP_1_SWAP_OPERANDS: entity work.step_1_swap_operands
		generic map(
			exp_size => exp_size,
			mant_size => MANT_SIZE
		)
		port map(
			swap => swap_aux,
			exp_a => decoded_exp_a,
			exp_b => decoded_exp_b,
			mant_a => op_a(MANT_BEGIN downto MANT_END),
			mant_b => op_b(MANT_BEGIN downto MANT_END),
			exp_a_out => exp_a_out_aux,
			exp_b_out => exp_b_out_aux,
			mant_a_out => mant_a_out_aux,
			mant_b_out => mant_b_out_aux
		);

	STEP_2_COMPLEMENT_SIG_B: entity work.step_2_complement_sig_b
		generic map(
			mant_size => MANT_SIZE
		)
		port map(
			comp_sig_b => comp_sig_b_aux,
			sign_a => op_a(word_size - 1),
			sign_b => op_b(word_size - 1),
			significand_b => significand_b,
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
			exp_a => decoded_exp_a,
			exp_b => decoded_exp_b,
			guard_bit => guard_bit_aux
		);

	STEP_4_SUM_SIGNIFICANDS: entity work.step_4_sum_significands
		generic map(
			
		)
		port map(
			
		);

	STEP_5_SHIFT_SIG_RES: entity work.step_5_shift_sig_res
		generic map(
			
		)
		port map(
			
		);

	STEP_8_CALC_SIGN: entity work.step_8_calc_sign
		generic map(
			
		)
		port map(
			
		);

end architecture main_arq;
