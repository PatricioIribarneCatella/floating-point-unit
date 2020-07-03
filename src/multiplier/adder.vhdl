
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity adder is
    port (
        a   : in    integer;
        b   : in    integer;
        res : out   integer
    );
end entity adder;

architecture adder_arq of adder is

begin

    res <= a + b;

end architecture adder_arq;
