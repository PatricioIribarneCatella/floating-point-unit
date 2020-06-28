
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity multiplier is
    generic (
        mant_size : natural := 5
    );
    port (
        a   : in    std_logic_vector(mant_size downto 0);
        b   : in    std_logic_vector(mant_size downto 0);
        res : out   std_logic_vector(2 * mant_size + 1 downto 0)
    );
end entity multiplier;

architecture multiplier_arq of multiplier is

begin

    res <= std_logic_vector(unsigned(a) * unsigned(b));

end architecture multiplier_arq;
