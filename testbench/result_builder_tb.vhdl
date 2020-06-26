library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity result_builder_tb is
end entity result_builder_tb;

architecture result_builder_tb_arq of result_builder_tb is

	constant word_size_tb : natural := 10;
	constant exp_size_tb : natural := 4;
	constant mant_size_tb : natural := 5;

	signal sign_aux : std_logic := '0';
	signal mant_aux : std_logic_vector(mant_size_tb - 1 downto 0)
						:= "10000";
	signal exp_aux : integer := 4;

	signal res_aux : std_logic_vector(word_size_tb - 1 downto 0);

begin

	sign_aux <= '0' after 100 ns, '1' after 200 ns;

	DUT: entity work.result_builder
		generic map(
			word_size => word_size_tb,
			exp_size => exp_size_tb,
			mant_size => mant_size_tb
		)
		port map(
			sign => sign_aux,
			mant => mant_aux,
			exp => exp_aux,
			res => res_aux
		);

end architecture result_builder_tb_arq;
