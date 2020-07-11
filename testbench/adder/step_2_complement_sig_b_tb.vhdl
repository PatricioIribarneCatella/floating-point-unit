
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity step_2_complement_sig_b_tb is
end entity step_2_complement_sig_b_tb;

architecture step_2_complement_sig_b_tb_arq of step_2_complement_sig_b_tb is

	constant mant_size_tb : natural := 3;

	signal comp_sig_b_aux : std_logic;

	signal sign_a_aux : std_logic := '1';
	signal sign_b_aux : std_logic := '0';
	
	signal significand_b_aux : std_logic_vector(mant_size_tb downto 0) := "1010";
	signal significand_b_out_aux : std_logic_vector(mant_size_tb downto 0);

begin

	sign_a_aux <= '0' after 50 ns, '1' after 100 ns, '0' after 150 ns;
	sign_b_aux <= '1' after 100 ns;

	DUT: entity work.step_2_complement_sig_b
		generic map(
			mant_size => mant_size_tb
		)
		port map(
			comp_sig_b => comp_sig_b_aux,
			sign_a => sign_a_aux,
			sign_b => sign_b_aux,
			significand_b => significand_b_aux,
			significand_b_out => significand_b_out_aux
		);

end architecture step_2_complement_sig_b_tb_arq;
