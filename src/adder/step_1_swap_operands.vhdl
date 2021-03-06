
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity step_1_swap_operands is
	generic(
		exp_size : natural := 4;
		mant_size : natural := 5
	);
	port(
		swap : out std_logic;
		sign_a : in std_logic;
		sign_b : in std_logic;
		exp_a : in std_logic_vector(exp_size - 1 downto 0);
		exp_b : in std_logic_vector(exp_size - 1 downto 0);
		mant_a : in std_logic_vector(mant_size - 1 downto 0);
		mant_b : in std_logic_vector(mant_size - 1 downto 0);
		sign_a_out : out std_logic;
		sign_b_out : out std_logic;
		exp_a_out : out std_logic_vector(exp_size - 1 downto 0);
		exp_b_out : out std_logic_vector(exp_size - 1 downto 0);
		significand_a_out : out std_logic_vector(mant_size downto 0);
		significand_b_out : out std_logic_vector(mant_size downto 0)
	);
end entity step_1_swap_operands;

architecture step_1_swap_operands_arq of step_1_swap_operands is

begin

	swapper : process (exp_a, exp_b) is

		variable exp_a_val : integer;
		variable exp_b_val : integer;

	begin

		exp_a_val := to_integer(unsigned(exp_a));
		exp_b_val := to_integer(unsigned(exp_b));

		if (exp_a_val < exp_b_val) then
			exp_a_out <= exp_b;
			exp_b_out <= exp_a;
			significand_a_out <= '1' & mant_b;
			significand_b_out <= '1' & mant_a;
			swap <= '1';
		else
			exp_a_out <= exp_a;
			exp_b_out <= exp_b;
			significand_a_out <= '1' & mant_a;
			significand_b_out <= '1' & mant_b;
			swap <= '0';
		end if;

		sign_a_out <= sign_a;
		sign_b_out <= sign_b;

	end process swapper;

end architecture step_1_swap_operands_arq;
