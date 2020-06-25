library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity multiplier_tb is
end entity multiplier_tb;

architecture multiplier_tb_arq of multiplier_tb is

	constant mant_size_tb : natural := 5;

	signal a_aux : std_logic_vector(mant_size_tb downto 0)
					:= std_logic_vector(to_unsigned(5, mant_size_tb + 1));
	signal b_aux : std_logic_vector(mant_size_tb downto 0)
					:= std_logic_vector(to_unsigned(5, mant_size_tb + 1));
	signal res_aux : std_logic_vector(2 * mant_size_tb + 1 downto 0);

begin

	a_aux <= std_logic_vector(to_unsigned(2, mant_size_tb + 1)) after 200 ns,
			 std_logic_vector(to_unsigned(3, mant_size_tb + 1)) after 300 ns,
			 std_logic_vector(to_unsigned(4, mant_size_tb + 1)) after 400 ns;

	b_aux <= std_logic_vector(to_unsigned(2, mant_size_tb + 1)) after 200 ns,
			 std_logic_vector(to_unsigned(4, mant_size_tb + 1)) after 300 ns,
			 std_logic_vector(to_unsigned(5, mant_size_tb + 1)) after 400 ns;

	DUT: entity work.multiplier
		generic map(
			mant_size => mant_size_tb
		)
		port map(
			a => a_aux,
			b => b_aux,
			res => res_aux
		);

end architecture multiplier_tb_arq;
