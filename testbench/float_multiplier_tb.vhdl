library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity float_multiplier_tb is
end entity float_multiplier_tb;

architecture float_multiplier_tb_arq of float_multiplier_tb is

	constant word_size_tb : natural := 10;
	constant exp_size_tb : natural := 4;

	signal A_aux : std_logic_vector(word_size_tb - 1 downto 0);
	signal B_aux : std_logic_vector(word_size_tb - 1 downto 0);
	signal S_aux : std_logic_vector(word_size_tb - 1 downto 0);

begin

	DUT: entity work.float_multiplier
		generic map(
			word_size => word_size_tb,
			exp_size => exp_size_tb
		)
		port map(
			A => A_aux,
			B => B_aux,
			S => S_aux
		);

end architecture float_multiplier_tb_arq;
