
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity step_4_sum_significands is
	generic(
		mant_size : natural := 5
	);
	port(
		significand_a : in std_logic_vector(mant_size downto 0);
		significand_b : in std_logic_vector(mant_size downto 0);
		significand_res : out std_logic_vector(mant_size downto 0);
		sign_a : in std_logic;
		sign_b : in std_logic;
		comp_sig : out std_logic;
		c_out : out std_logic
	);
end entity step_4_sum_significands;

architecture step_4_sum_significands_arq of step_4_sum_significands is

	constant ONE : unsigned(mant_size downto 0) := to_unsigned(1, mant_size + 1);

begin

	adder : process (significand_a, significand_b, sign_a, sign_b) is
	
		variable add_res: std_logic_vector(mant_size + 1 downto 0);
		variable significand_aux : std_logic_vector(mant_size downto 0);
		variable c_out_aux : std_logic;
		variable diff : std_logic;

	begin

		add_res := std_logic_vector(unsigned('0' & significand_a) + unsigned('0' & significand_b));
		significand_aux := add_res(mant_size downto 0);
		c_out_aux := add_res(mant_size + 1);

		diff := sign_a xor sign_b;

		if (diff = '1' and significand_aux(mant_size) = '1' and c_out_aux = '0') then
			significand_res <= std_logic_vector(unsigned(not significand_aux) + ONE);
			comp_sig <= '1';
		else
			significand_res <= significand_aux;
			comp_sig <= '0';
		end if;

		c_out <= c_out_aux;

	end process adder;

end architecture step_4_sum_significands_arq;
