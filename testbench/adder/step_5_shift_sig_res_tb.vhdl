
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity step_5_shift_sig_res_tb is
end entity step_5_shift_sig_res_tb;

architecture step_5_shift_sig_res_tb_arq of step_5_shift_sig_res_tb is

	constant mant_size_tb : natural := 11;

	signal c_out_aux : std_logic := '1';
	signal guard_bit_aux : std_logic := '1';
	signal sign_a_aux : std_logic := '0';
	signal sign_b_aux : std_logic := '0';
	signal significand_in_aux : std_logic_vector(mant_size_tb downto 0)
									:= "011000000000";
	signal significand_out_aux : std_logic_vector(mant_size_tb downto 0);
	signal exp_aux : integer := 5;
	signal exp_out_aux : integer;

begin

	sign_a_aux <= '1' after 50 ns, '0' after 100 ns;
	significand_in_aux <= "000010000000" after 50 ns;

	DUT: entity work.step_5_shift_sig_res
		generic map(
			mant_size => mant_size_tb
		)
		port map(
			c_out => c_out_aux,
			guard_bit => guard_bit_aux,
			sign_a => sign_a_aux,
			sign_b => sign_b_aux,
			significand_in => significand_in_aux,
			significand_out => significand_out_aux,
			exp => exp_aux,
			exp_out => exp_out_aux
		);

end architecture step_5_shift_sig_res_tb_arq;
