
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity step_4_sum_significands_tb is
end entity step_4_sum_significands_tb;

architecture step_4_sum_significands_tb_arq of step_4_sum_significands_tb is

	constant mant_size_tb : natural := 7;

	signal significand_a_aux : std_logic_vector(mant_size_tb downto 0) := "11001000";
	signal significand_b_aux : std_logic_vector(mant_size_tb downto 0) := "00011000";
	signal significand_res_aux : std_logic_vector(mant_size_tb downto 0);
	signal sign_a_aux : std_logic := '0';
	signal sign_b_aux : std_logic := '0';
	signal comp_sig_aux : std_logic;
	signal c_out_aux : std_logic;

begin

	sign_a_aux <= '1' after 50 ns, '0' after 100 ns;

	DUT: entity work.step_4_sum_significands
		generic map(
			mant_size => mant_size_tb
		)
		port map(
			significand_a => significand_a_aux,
			significand_b => significand_b_aux,
			significand_res => significand_res_aux,
			sign_a => sign_a_aux,
			sign_b => sign_b_aux,
			comp_sig => comp_sig_aux,
			c_out => c_out_aux
		);

end architecture step_4_sum_significands_tb_arq;
