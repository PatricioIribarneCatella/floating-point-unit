library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity result_builder_tb is
end entity result_builder_tb;

architecture result_builder_tb_arq of result_builder_tb is

	constant exp_size_tb : natural := 4;
	constant mant_size_tb : natural := 5;
	constant word_size_tb : natural := 10;

	constant BIAS : natural := 2**(exp_size_tb - 1) - 1;

	signal sign_aux : std_logic := '0';
	signal exp_in_aux : integer := 4;
	signal mant_in_aux : std_logic_vector(mant_size_tb - 1 downto 0)
							:= "10000";

	signal res_aux : std_logic_vector(word_size_tb - 1 downto 0);

begin

	sign_aux <= '1' after 100 ns, '0' after 200 ns, '1' after 300 ns;
	exp_in_aux <= BIAS after 50 ns, -- limit for max saturation
				  -(BIAS - 1) after 100 ns, -- limit for min underflow
				  (BIAS + 1) after 150 ns, -- limit for max saturation + 1
				  -(BIAS - 1) - 1 after 200 ns; -- limit for min underflow - 1

	DUT: entity work.result_builder
		generic map(
			exp_size => exp_size_tb,
			mant_size => mant_size_tb,
			word_size => word_size_tb
		)
		port map(
			sign => sign_aux,
			exp_in => exp_in_aux,
			mant_in => mant_in_aux,
			res => res_aux
		);

end architecture result_builder_tb_arq;
