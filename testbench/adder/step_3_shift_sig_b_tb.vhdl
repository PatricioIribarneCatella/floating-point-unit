
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity step_3_shift_sig_b_tb is
end entity step_3_shift_sig_b_tb;

architecture step_3_shift_sig_b_tb_arq of step_3_shift_sig_b_tb is

	constant mant_size_tb : natural := 7;

	signal comp_sig_b_aux : std_logic := '0';
	signal significand_b_aux : std_logic_vector(mant_size_tb downto 0) := "11000001";
	signal significand_b_out_aux : std_logic_vector(mant_size_tb downto 0);
	signal exp_a_aux : integer := 4;
	signal exp_b_aux : integer := 1;
	signal guard_bit_aux : std_logic;

begin

	comp_sig_b_aux <= '1' after 50 ns, '0' after 100 ns;

	DUT: entity work.step_3_shift_sig_b
		generic map(
			mant_size => mant_size_tb
		)
		port map(
			comp_sig_b => comp_sig_b_aux,
			significand_b => significand_b_aux,
			significand_b_out => significand_b_out_aux,
			exp_a => exp_a_aux,
			exp_b => exp_b_aux,
			guard_bit => guard_bit_aux
		);

end architecture step_3_shift_sig_b_tb_arq;
