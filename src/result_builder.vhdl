library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity result_builder is
	generic(
		exp_size: natural := 4;
		mant_size : natural := 5;
		word_size : natural := 10
	);
	port(
		sign : in std_logic;
		exp_in : in integer;
		mant_in : in std_logic_vector(mant_size - 1 downto 0);
		res : out std_logic_vector(word_size - 1 downto 0)
	);
end entity result_builder;

architecture result_builder_arq of result_builder is

	constant BIAS : integer := 2**(exp_size - 1) - 1;
	constant MAX_EXP : integer := BIAS;
	constant MIN_EXP : integer := -(BIAS - 1);

	constant SAT_EXP : std_logic_vector(exp_size - 1 downto 0)
						:= std_logic_vector(to_unsigned(MAX_EXP, exp_size));
	constant SAT_MANT : std_logic_vector(mant_size - 1 downto 0)
						:= (others => '1');

	constant ZERO_EXP : std_logic_vector(exp_size - 1 downto 0)
						:= (others => '0');
	constant ZERO_MANT : std_logic_vector(mant_size - 1 downto 0)
						:= (others => '0');
begin

	builder: process (sign, mant_in, exp_in)
	begin
		if exp_in > MAX_EXP then
			-- saturation reached
			res <= sign & SAT_EXP & SAT_MANT;
		elsif exp_in < MIN_EXP then
			-- zero reached
			res <= sign & ZERO_EXP & ZERO_MANT;
		else
			-- the result its OK
			res <= sign & std_logic_vector(to_unsigned(exp_in + BIAS, exp_size)) & mant_in;
		end if;
	end process;

end architecture result_builder_arq;
