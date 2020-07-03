
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity main is
    generic (
        word_size : natural := 10;
        exp_size  : natural := 4
    );
    port (
        a : in    std_logic_vector(word_size - 1 downto 0);
        b : in    std_logic_vector(word_size - 1 downto 0);
        s : out   std_logic_vector(word_size - 1 downto 0)
    );
end entity main;

architecture main_arq of main is

begin

end architecture main_arq;
