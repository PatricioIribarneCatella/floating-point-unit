
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;
	use work.utils.all;

entity step_5_shift_sig_res is
	generic(
		exp_size : natural := 3;
		mant_size : natural := 5
	);
	port(
		c_out : in std_logic;
		guard_bit : in std_logic;
		sign_a : in std_logic;
		sign_b : in std_logic;
		significand_in : in std_logic_vector(mant_size downto 0);
		significand_out : out std_logic_vector(mant_size downto 0);
		exp : in std_logic_vector(exp_size - 1 downto 0);
		exp_out : out std_logic_vector(exp_size - 1 downto 0)
	);
end entity step_5_shift_sig_res;

architecture step_5_shift_sig_res_arq of step_5_shift_sig_res is

begin

	shifter : process (sign_a, sign_b, c_out) is

		variable shift_count : integer;

	begin

		if ((sign_a = sign_b) and (c_out = '1')) then
			significand_out <= c_out & significand_in(mant_size downto 1);
			exp_out <= std_logic_vector(unsigned(exp) + to_unsigned(1, exp_size));
		else
			shift_count := count_zeros(significand_in);

			-- for delta time at zero where variables
			-- do not have appropiate values
			if (shift_count = 0 or shift_count = (mant_size + 1)) then
				significand_out <= significand_in;
				exp_out <= exp;
			else
				significand_out(mant_size downto shift_count)
						<= significand_in((mant_size - shift_count) downto 0);

				significand_out(shift_count - 1) <= guard_bit;
				significand_out((shift_count - 2) downto 0) <= (others => '0');

				exp_out <= std_logic_vector(unsigned(exp) - to_unsigned(shift_count, exp_size));
			end if;
		end if;

	end process shifter;

end architecture step_5_shift_sig_res_arq;
