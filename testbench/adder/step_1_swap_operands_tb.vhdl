
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity step_1_swap_operands_tb is
end entity step_1_swap_operands_tb;

architecture step_1_swap_operands_tb_arq of step_1_swap_operands_tb is

	constant exp_size_tb : natural := 3;
	constant mant_size_tb : natural := 4;

	signal swap_aux : std_logic;

	signal sign_a_aux : std_logic := '1';
	signal sign_b_aux : std_logic := '0';
	signal sign_a_out_aux : std_logic;
	signal sign_b_out_aux : std_logic;

	signal exp_a_aux : integer := 3;
	signal exp_b_aux : integer := 5;
	signal exp_a_out_aux : integer;
	signal exp_b_out_aux : integer;

	signal mant_a_aux : std_logic_vector(mant_size_tb - 1 downto 0) := "0110";
	signal mant_b_aux : std_logic_vector(mant_size_tb - 1 downto 0) := "1001";
	signal mant_a_out_aux : std_logic_vector(mant_size_tb - 1 downto 0);
	signal mant_b_out_aux : std_logic_vector(mant_size_tb - 1 downto 0);

begin

	exp_a_aux <= 5 after 50 ns, 3 after 100 ns;
	exp_b_aux <= 3 after 50 ns, 5 after 100 ns;

	mant_a_aux <= "0110" after 50 ns;
	mant_b_aux <= "1001" after 50 ns;

	DUT: entity work.step_1_swap_operands
		generic map(
			exp_size => exp_size_tb,
			mant_size => mant_size_tb
		)
		port map(
			swap => swap_aux,
			sign_a => sign_a_aux,
			sign_b => sign_b_aux,
			exp_a => exp_a_aux,
			exp_b => exp_b_aux,
			mant_a => mant_a_aux,
			mant_b => mant_b_aux,
			sign_a_out => sign_a_out_aux,
			sign_b_out => sign_b_out_aux,
			exp_a_out => exp_a_out_aux,
			exp_b_out => exp_b_out_aux,
			mant_a_out => mant_a_out_aux,
			mant_b_out => mant_b_out_aux
		);

end architecture step_1_swap_operands_tb_arq;
