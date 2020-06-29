library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity fm_tb is
end entity fm_tb;

architecture fm_tb_arq of fm_tb is

    constant WORD_SIZE_TB : natural := 23;
    constant EXP_SIZE_TB  : natural := 6;

    signal a_aux   : std_logic_vector(WORD_SIZE_TB - 1 downto 0) := "11111101111111111111111";
    signal b_aux   : std_logic_vector(WORD_SIZE_TB - 1 downto 0) := "00111101010001110011001";
    signal s_aux   : std_logic_vector(WORD_SIZE_TB - 1 downto 0);

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
