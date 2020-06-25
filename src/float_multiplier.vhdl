library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity float_multiplier is
	generic(
		word_size: natural := 10;
		exp_size: natural := 4
	);
	port(
		A: in std_logic_vector(word_size - 1 downto 0);
		B: in std_logic_vector(word_size - 1 downto 0);
		S: out std_logic_vector(word_size - 1 downto 0)
	);
end entity float_multiplier;

architecture float_multiplier_arq of float_multiplier is

	constant BIAS : integer := 2**(exp_size - 1) - 1;

	-- exponent
	constant EXP_BEGIN : natural := word_size - 2;
	constant EXP_END: natural := EXP_BEGIN + exp_size;

	-- mantisa
	constant MANT_BEGIN : natural := EXP_END - 1;
	constant MANT_END : natural := 0;
	constant MANT_SIZE : natural := MANT_BEGIN - MANT_END;

	signal exp_aux : integer;
	signal exp_res_aux : integer;
	signal mant_res_aux : std_logic_vector(2 * MANT_SIZE + 1 downto 0);
	signal mant_aux : std_logic_vector(MANT_SIZE - 1 downto 0);

	signal decoded_exp_a : std_logic_vector(exp_size - 1 downto 0);
	signal decoded_exp_b : std_logic_vector(exp_size - 1 downto 0);

	signal sign_aux : std_logic;

begin

	sign_aux <= A(word_size - 1) xor B(word_size - 1);

	decoded_exp_a <= unsigned(A(EXP_BEGIN downto EXP_END)) - BIAS;
	decoded_exp_b <= unsigned(B(EXP_BEGIN downto EXP_END)) - BIAS;

	ADDER: entity work.adder
		port map(
			a => to_integer(decoded_exp_a),
			b => to_integer(decoded_exp_b),
			res => exp_res_aux
		);

	MULTIPLIER: entity work.multiplier
		generic map(
			mant_size => MANT_SIZE
		)
		port map(
			a => '1' & A(MANT_BEGIN downto MANT_END),
			b => '1' & B(MANT_BEGIN downto MANT_END),
			res => mant_res_aux
		);

	RESULT_PICKER: entity work.result_picker
		generic map(
			mant_size => MANT_SIZE
		)
		port map(
			mant => mant_res_aux,
			exp => exp_res_aux,
			mant_res => mant_aux,
			exp_res => exp_aux
		);

	RESULT_BUILDER: entity work.result_builder
		generic map(
			word_size => word_size,
			exp_size => exp_size,
			mant_size => MANT_SIZE
		)
		port map(
			sign => sign_aux,
			mant => mant_aux,
			exp => exp_aux,
			res => S
		);

end architecture float_multiplier_arq;
