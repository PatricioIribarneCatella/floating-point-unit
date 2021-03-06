
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity step_3_shift_sig_b is
	generic(
		exp_size : natural := 3;
		mant_size : natural := 5
	);
	port(
		comp_sig_b : in std_logic;
		significand_b : in std_logic_vector(mant_size downto 0);
		significand_b_out : out std_logic_vector(mant_size downto 0);
		exp_a : in std_logic_vector(exp_size - 1 downto 0);
		exp_b : in std_logic_vector(exp_size - 1 downto 0);
		guard_bit : out std_logic
	);
end entity step_3_shift_sig_b;

architecture step_3_shift_sig_b_arq of step_3_shift_sig_b is
begin

	shifter : process (exp_a, exp_b, comp_sig_b) is
	
		variable shift_count : integer;

	begin

		shift_count := to_integer(unsigned(exp_a) - unsigned(exp_b));

		if (shift_count = 0) then

			guard_bit <= '0';
			significand_b_out <= significand_b;

		elsif (shift_count > (mant_size + 1)) then

			if (comp_sig_b = '0') then
				significand_b_out <= (others => '0');
				guard_bit <= '0';
			else
				significand_b_out <= (others => '1');
				guard_bit <= '1';
			end if;
		else

			significand_b_out <= std_logic_vector(shift_right(unsigned(significand_b), shift_count));

			if (comp_sig_b = '1') then
				significand_b_out(mant_size downto (mant_size + 1 - shift_count)) <= (others => '1');
			end if;

			guard_bit <= significand_b(shift_count - 1);
		end if;

	end process shifter;

end architecture step_3_shift_sig_b_arq;
