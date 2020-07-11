
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity step_2_complement_sig_b is
	generic(
		mant_size : natural := 5
	);
	port(
		comp_sig_b : out std_logic;
		sign_a : in std_logic;
		sign_b : in std_logic;
		significand_b : in std_logic_vector(mant_size downto 0);
		significand_b_out : out std_logic_vector(mant_size downto 0)
	);
end entity step_2_complement_sig_b;

architecture step_2_complement_sig_b_arq of step_2_complement_sig_b is

	constant ONE : unsigned(mant_size downto 0) := to_unsigned(1, mant_size + 1);

	signal diff : std_logic;

begin

	diff <= sign_a xor sign_b;

	significand_b_out <= significand_b when diff = '0'
						 else std_logic_vector(unsigned(not significand_b) + ONE);

	comp_sig_b <= '1' when diff = '1' else '0';

end architecture step_2_complement_sig_b_arq;
