
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity adder_tb is
end entity adder_tb;

architecture adder_tb_arq of adder_tb is

    signal a_aux   : integer := 1;
    signal b_aux   : integer := 0;
    signal res_aux : integer;

begin

    a_aux <= 2 after 200 ns, 31 after 300 ns, 4 after 400 ns;
    b_aux <= 2 after 200 ns, -1 after 300 ns, 5 after 400 ns;

  DUT: entity work.adder
        port map (
            a   => a_aux,
            b   => b_aux,
            res => res_aux
        );

end architecture adder_tb_arq;
