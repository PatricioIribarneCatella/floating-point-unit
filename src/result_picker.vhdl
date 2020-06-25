library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity result_picker is
	generic(
		mant_size: natural := 5
	);
	port(
		mant: std_logic_vector(2 * mant_size + 1 downto 0);
		exp: integer;
		mant_res: std_logic_vector(mant_size - 1 downto 0);
		exp_res: integer
	);
end entity result_picker;

architecture result_picker_arq of result_picker is

	constant MSB: natural := 2 * mant_size + 1;

	constant RES_CASE_1_BEGIN: natural := MSB - 1;
	constant RES_CASE_1_END: natural := RES_CASE_1_BEGIN - mant_size;

	constant RES_CASE_2_BEGIN: natural := MSB - 2;
	constant RES_CASE_2_END: natural := RES_CASE_2_BEGIN - mant_size;

	signal sel: std_logic;

begin

	sel <= mant(MSB);

	mant_res <= mant(RES_CASE_1_BEGIN downto RES_CASE_1_END) when sel = '1'
				else mant(RES_CASE_2_BEGIN downto RES_CASE_2_END);

	exp_res <= exp + 1 when sel = '1' else exp;

end architecture result_picker_arq;
