library IEEE; 
	use IEEE.std_logic_1164.all; 

package utils is 

	function count_zeros(V: std_logic_vector) return natural;
	function calc_sign(swap, comp, sign_a, sign_b: std_logic) return std_logic;

end package utils;

package body utils is

	function count_zeros(V: std_logic_vector) return natural is
		variable count : natural;
	begin
		count := 0;

		for i in V'range loop
			if (V(i) = '1') then
				return count;
			else
				count := count + 1;
			end if;
		end loop;

		return count;

	end function count_zeros;

	function calc_sign(swap, comp, sign_a, sign_b: std_logic) return std_logic is

		variable t1, t2, t3 : std_logic;	
	begin

		t1 := swap and (not sign_a) and sign_b;
		t2 := (not swap) and (not comp) and sign_a and (not sign_b);
		t3 := (not swap) and comp and (not sign_a) and sign_b;

		return t1 or t2 or t3;

	end function calc_sign;

end package body utils;
