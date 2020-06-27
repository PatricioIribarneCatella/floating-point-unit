library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity result_builder is
	generic(
		exp_size: natural := 4;
		mant_size : natural := 5
	);
	port(
		sign : in std_logic;
		mant_in : in std_logic_vector(mant_size - 1 downto 0);
		exp_in : in integer;
		sign_out : out std_logic;
		mant_out : out std_logic_vector(mant_size - 1 downto 0);
		exp_out : out integer
	);
end entity result_builder;

architecture result_builder_arq of result_builder is

	constant BIAS : integer := 2**(exp_size - 1) - 1;
	constant MAX_EXP : integer := BIAS;
	constant MIN_EXP : integer := -(BIAS - 1);

	constant SAT_EXP : integer := MAX_EXP;
	constant SAT_MANT : std_logic_vector(mant_size - 1 downto 0)
						:= (others => '1');

	constant ZERO_EXP : integer := 0;
	constant ZERO_MANT : std_logic_vector(mant_size - 1 downto 0)
						:= (others => '0');
begin

	builder: process (sign, mant_in, exp_in)
	begin
		sign_out <= sign;

		if exp_in > MAX_EXP then
			-- saturation reached
			exp_out <= SAT_EXP;
			mant_out <= SAT_MANT;
		elsif exp_in < MIN_EXP then
			-- zero reached
			exp_out <= ZERO_EXP;
			mant_out <= ZERO_MANT;
		else
			-- the result its OK
			exp_out <= exp_in + BIAS;
			mant_out <= mant_in;
		end if;
	end process;

end architecture result_builder_arq;
