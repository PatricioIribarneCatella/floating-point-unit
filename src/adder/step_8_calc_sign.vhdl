
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;
	use work.utils.all;

entity step_8_calc_sign is
	port(
		sign_a : in std_logic;
		sign_b : in std_logic;
		swap : in std_logic;
		comp_sig : in std_logic;
		sign_out : out std_logic
	);
end entity step_8_calc_sign;

architecture step_8_calc_sign_arq of step_8_calc_sign is
begin

	sign_out <= sign_a when (sign_a = sign_b)
					else calc_sign(swap, comp_sig, sign_a, sign_b);

end architecture step_8_calc_sign_arq;
