
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity step_8_calc_sign_tb is
end entity step_8_calc_sign_tb;

architecture step_8_calc_sign_tb_arq of step_8_calc_sign_tb is

	signal sign_a_aux : std_logic := '0';
	signal sign_b_aux : std_logic := '0';
	signal swap_aux : std_logic := '1';
	signal comp_sig_aux : std_logic := '0';
	signal sign_out_aux : std_logic;

begin

	sign_a_aux <= '0' after 20 ns, '1' after 40 ns, '1' after 60 ns, -- swap = 1
				  '0' after 80 ns, '1' after 100 ns, -- swap = 0, comp = 0
				  '0' after 120 ns, '1' after 140 ns, -- swap = 0, comp = 1
				  '0' after 160 ns;
	sign_b_aux <= '1' after 20 ns, '0' after 40 ns, '1' after 60 ns, -- swap = 1
				  '1' after 80 ns, '0' after 100 ns, -- swap = 0, comp = 0
				  '1' after 120 ns, '0' after 140 ns, -- swap = 0, comp = 1
				  '0' after 160 ns;

	swap_aux <= '0' after 80 ns;
	comp_sig_aux <= '1' after 120 ns;

	DUT: entity work.step_8_calc_sign
		port map(
			sign_a => sign_a_aux,
			sign_b => sign_b_aux,
			swap => swap_aux,
			comp_sig => comp_sig_aux,
			sign_out => sign_out_aux
		);

end architecture step_8_calc_sign_tb_arq;
