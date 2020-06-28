
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity result_picker_tb is
end entity result_picker_tb;

architecture result_picker_tb_arq of result_picker_tb is

    constant MANT_SIZE_TB : natural := 3;

    signal mant_aux       : std_logic_vector(2 * MANT_SIZE_TB + 1 downto 0)            := "11001000";
    signal exp_aux        : integer := 3;

    signal mant_res_aux   : std_logic_vector(MANT_SIZE_TB - 1 downto 0);
    signal exp_res_aux    : integer;

begin

    mant_aux <= "01001000" after 100 ns, "11001000" after 200 ns;
    exp_aux  <= 3 after 100 ns;

  DUT: entity work.result_picker
        generic map (
            mant_size => mant_size_tb
        )
        port map (
            mant     => mant_aux,
            exp      => exp_aux,
            mant_res => mant_res_aux,
            exp_res  => exp_res_aux
        );

end architecture result_picker_tb_arq;
