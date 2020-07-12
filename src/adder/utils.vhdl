library IEEE; 
	use IEEE.std_logic_1164.all; 

package utils is 

	function count_zeros(V: std_logic_vector) return natural;

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

end package body utils;
