library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity fm_tb is
end entity fm_tb;

architecture fm_tb_arq of fm_tb is

	-- Errors:
	--	File: fmul_15_6.txt
	--		2534066 2064383 3609004
	--		2064383 2618694 3674602
	--		722076 2416840 2126960
	--		2064383 873228 1942471

    constant WORD_SIZE_TB : natural := 22;
    constant EXP_SIZE_TB  : natural := 6;

    signal a_aux : std_logic_vector(WORD_SIZE_TB - 1 downto 0)
					:= std_logic_vector(to_unsigned(2534066, WORD_SIZE_TB));
    signal b_aux : std_logic_vector(WORD_SIZE_TB - 1 downto 0)
					:= std_logic_vector(to_unsigned(2064383, WORD_SIZE_TB));
    signal s_aux : std_logic_vector(WORD_SIZE_TB - 1 downto 0);

	signal expected : std_logic_vector(WORD_SIZE_TB - 1 downto 0)
					:= std_logic_vector(to_unsigned(3609004, WORD_SIZE_TB));
begin

    a_aux <= (others => '0') after 50 ns;
    b_aux <= (others => '0') after 50 ns;

  DUT: entity work.float_multiplier
        generic map (
            word_size => word_size_tb,
            exp_size  => exp_size_tb
        )
        port map (
            op_a => a_aux,
            op_b => b_aux,
            res  => s_aux
        );

end architecture fm_tb_arq;
