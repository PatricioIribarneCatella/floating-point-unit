
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;
	use std.textio.all;

entity float_multiplier_tb is
end entity float_multiplier_tb;

architecture float_multiplier_tb_arq of float_multiplier_tb is

	constant TCK: time := 20 ns;			-- periodo de reloj
	constant DELAY: natural := 0;			-- retardo de procesamiento del DUT
	constant WORD_SIZE_T: natural := 28;	-- tamaño de datos
	constant EXP_SIZE_T: natural := 8;      -- tamaño exponente
	
	signal clk: std_logic := '0';
	signal a_file: unsigned(WORD_SIZE_T-1 downto 0) := (others => '0');
	signal b_file: unsigned(WORD_SIZE_T-1 downto 0) := (others => '0');
	signal z_file: unsigned(WORD_SIZE_T-1 downto 0) := (others => '0');
	signal z_del: unsigned(WORD_SIZE_T-1 downto 0)  := (others => '0');
	signal z_dut: unsigned(WORD_SIZE_T-1 downto 0)  := (others => '0');
	
	signal ciclos: integer := 0;
	signal errores: integer := 0;
	
	-- La senal z_del_aux se define por un problema de conversión
	signal z_del_aux: std_logic_vector(WORD_SIZE_T-1 downto 0):= (others => '0');
	
	file datos: text open read_mode is "testbench/files/fmul_19_8.txt";

begin

	clk <= not(clk) after TCK/ 2;

	test_sequence: process
		variable l: line;
		variable ch: character:= ' ';
		variable aux: integer;
	begin

		while not(endfile(datos)) loop
			wait until rising_edge(clk);
			-- solo para debugging
			ciclos <= ciclos + 1;
			-- se lee una linea del archivo de valores de prueba
			readline(datos, l);
			-- se extrae un entero de la linea
			read(l, aux);
			-- se carga el valor del operando A
			a_file <= to_unsigned(aux, WORD_SIZE_T);
			-- se lee un caracter (es el espacio)
			read(l, ch);
			-- se lee otro entero de la linea
			read(l, aux);
			-- se carga el valor del operando B
			b_file <= to_unsigned(aux, WORD_SIZE_T);
			-- se lee otro caracter (es el espacio)
			read(l, ch);
			-- se lee otro entero
			read(l, aux);
			-- se carga el valor de salida (resultado)
			z_file <= to_unsigned(aux, WORD_SIZE_T);
		end loop;

		-- se cierra el archivo
		file_close(datos);
		wait for TCK * (DELAY + 1);
		-- se aborta la simulacion (fin del archivo)
		assert false report
			"Fin de la simulacion" severity failure;

	end process test_sequence;
	
	-- Instanciacion del DUT
	DUT: entity work.float_multiplier
		generic map(
			word_size => WORD_SIZE_T,
			exp_size => EXP_SIZE_T
		)
		port map(
			op_a => std_logic_vector(a_file),
			op_b => std_logic_vector(b_file),
			unsigned(res) => z_dut
		);
	
	-- Instanciacion de la linea de retardo
	DELAY_GEN: entity work.delay_gen
		generic map(
			N => WORD_SIZE_T,
			DELAY => DELAY
		)
		port map(
			clk => clk,
			A => std_logic_vector(z_file),
			B => z_del_aux
		);
				
	z_del <= unsigned(z_del_aux);
	
	-- Verificacion de la condicion
	verificacion: process(clk)
	begin
		if rising_edge(clk) then
			assert to_integer(z_del) = to_integer(z_dut) report
				"Error: Salida del DUT no coincide con referencia (salida del dut = " & 
				integer'image(to_integer(z_dut)) &
				", salida del archivo = " &
				integer'image(to_integer(z_del)) & ")"
				severity warning;
			if to_integer(z_del) /= to_integer(z_dut) then
				errores <= errores + 1;
			end if;
		end if;
	end process verificacion;

end architecture float_multiplier_tb_arq;
