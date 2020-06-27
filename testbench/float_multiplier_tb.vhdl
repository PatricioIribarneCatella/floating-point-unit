library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity float_multiplier_tb is
end entity float_multiplier_tb;

architecture float_multiplier_tb_arq of float_multiplier_tb is

	constant word_size_tb : natural := 23;
	constant exp_size_tb : natural := 6;

	signal A_aux : std_logic_vector(word_size_tb - 1 downto 0)
					:= "11111101111111111111111";
	signal B_aux : std_logic_vector(word_size_tb - 1 downto 0)
					:= "00111101010001110011001";
	signal S_aux : std_logic_vector(word_size_tb - 1 downto 0);

begin

	A_aux <= (others => '0') after 50 ns;
	B_aux <= (others => '0') after 50 ns;

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
