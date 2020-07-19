#
# string representation
# of the VHDL testbench file
#

PROLOGUE = "\
library IEEE;\n\
    use IEEE.std_logic_1164.all;\n\
    use IEEE.numeric_std.all;\n\
    use std.textio.all;\n\
\n\
entity main_tb is\n\
end entity main_tb;\n\
\n\
architecture main_tb_arq of main_tb is\n\
\n"

# multiplier epilogue

EPILOGUE_MUL = "\
constant TCK: time := 20 ns;\n\
constant DELAY: natural := 0;\n\
\n\
constant WORD_SIZE_T: natural := {};\n\
constant EXP_SIZE_T: natural := {};\n\
\n\
signal clk: std_logic := '0';\n\
signal a_file: unsigned(WORD_SIZE_T-1 downto 0) := (others => '0');\n\
signal b_file: unsigned(WORD_SIZE_T-1 downto 0) := (others => '0');\n\
signal z_file: unsigned(WORD_SIZE_T-1 downto 0) := (others => '0');\n\
signal z_del: unsigned(WORD_SIZE_T-1 downto 0)  := (others => '0');\n\
signal z_dut: unsigned(WORD_SIZE_T-1 downto 0)  := (others => '0');\n\
\n\
signal ciclos: integer := 0;\n\
signal errores: integer := 0;\n\
\n\
signal z_del_aux: std_logic_vector(WORD_SIZE_T-1 downto 0) := (others => '0');\n\
\n\
file datos: text open read_mode is \"{}\";\n\
begin\n\
\n\
clk <= not(clk) after TCK / 2;\n\
\n\
test_sequence: process\n\
        variable l: line;\n\
        variable ch: character:= ' ';\n\
        variable aux: integer;\n\
begin\n\
\n\
        while not(endfile(datos)) loop\n\
                wait until rising_edge(clk);\n\
                ciclos <= ciclos + 1;\n\
                readline(datos, l);\n\
                read(l, aux);\n\
                a_file <= to_unsigned(aux, WORD_SIZE_T);\n\
                read(l, ch);\n\
                read(l, aux);\n\
                b_file <= to_unsigned(aux, WORD_SIZE_T);\n\
                read(l, ch);\n\
                read(l, aux);\n\
                z_file <= to_unsigned(aux, WORD_SIZE_T);\n\
        end loop;\n\
\n\
        file_close(datos);\n\
        wait for TCK * (DELAY + 1);\n\
        assert false report\n\
                \"Fin de la simulacion\" severity failure;\n\
\n\
end process test_sequence;\n\
\n\
DUT: entity work.main\n\
        generic map(\n\
                word_size => WORD_SIZE_T,\n\
                exp_size => EXP_SIZE_T\n\
        )\n\
        port map(\n\
                op_a => std_logic_vector(a_file),\n\
                op_b => std_logic_vector(b_file),\n\
                unsigned(res) => z_dut\n\
        );\n\
\n\
DELAY_GEN: entity work.delay_gen\n\
        generic map(\n\
                N => WORD_SIZE_T,\n\
                DELAY => DELAY\n\
        )\n\
        port map(\n\
                clk => clk,\n\
                A => std_logic_vector(z_file),\n\
                B => z_del_aux\n\
        );\n\
\n\
z_del <= unsigned(z_del_aux);\n\
\n\
verificacion: process(clk)\n\
begin\n\
        if rising_edge(clk) then\n\
                assert to_integer(z_del) = to_integer(z_dut) report\n\
                        \"Error: Salida del DUT: \" & integer'image(to_integer(z_dut)) &\n\
                        \", salida del archivo = \" & integer'image(to_integer(z_del))\n\
                        severity warning;\n\
                if to_integer(z_del) /= to_integer(z_dut) then\n\
                        errores <= errores + 1;\n\
                end if;\n\
        end if;\n\
end process verificacion;\n\
\n\
end architecture main_tb_arq;\n\
\n"

# adder epilogue

EPILOGUE_ADD = "\
constant TCK: time := 20 ns;\n\
constant DELAY: natural := 8;\n\
\n\
constant WORD_SIZE_T: natural := {};\n\
constant EXP_SIZE_T: natural := {};\n\
\n\
signal clk: std_logic := '0';\n\
signal a_file: unsigned(WORD_SIZE_T-1 downto 0) := (others => '0');\n\
signal b_file: unsigned(WORD_SIZE_T-1 downto 0) := (others => '0');\n\
signal z_file: unsigned(WORD_SIZE_T-1 downto 0) := (others => '0');\n\
signal z_del: unsigned(WORD_SIZE_T-1 downto 0)  := (others => '0');\n\
signal z_dut: unsigned(WORD_SIZE_T-1 downto 0)  := (others => '0');\n\
\n\
signal ciclos: integer := 0;\n\
signal errores: integer := 0;\n\
\n\
signal z_del_aux: std_logic_vector(WORD_SIZE_T-1 downto 0) := (others => '0');\n\
\n\
file datos: text open read_mode is \"{}\";\n\
begin\n\
\n\
clk <= not(clk) after TCK / 2;\n\
\n\
test_sequence: process\n\
        variable l: line;\n\
        variable ch: character:= ' ';\n\
        variable aux: integer;\n\
begin\n\
\n\
        while not(endfile(datos)) loop\n\
                wait until rising_edge(clk);\n\
                ciclos <= ciclos + 1;\n\
                readline(datos, l);\n\
                read(l, aux);\n\
                a_file <= to_unsigned(aux, WORD_SIZE_T);\n\
                read(l, ch);\n\
                read(l, aux);\n\
                b_file <= to_unsigned(aux, WORD_SIZE_T);\n\
                read(l, ch);\n\
                read(l, aux);\n\
                z_file <= to_unsigned(aux, WORD_SIZE_T);\n\
        end loop;\n\
\n\
        file_close(datos);\n\
        wait for TCK * (DELAY + 1);\n\
        assert false report\n\
                \"Fin de la simulacion\" severity failure;\n\
\n\
end process test_sequence;\n\
\n\
DUT: entity work.main\n\
        generic map(\n\
                word_size => WORD_SIZE_T,\n\
                exp_size => EXP_SIZE_T\n\
        )\n\
        port map(\n\
                op_a => std_logic_vector(a_file),\n\
                op_b => std_logic_vector(b_file),\n\
                unsigned(res) => z_dut,\n\
                clk => clk\n\
        );\n\
\n\
DELAY_GEN: entity work.delay_gen\n\
        generic map(\n\
                N => WORD_SIZE_T,\n\
                DELAY => DELAY\n\
        )\n\
        port map(\n\
                clk => clk,\n\
                A => std_logic_vector(z_file),\n\
                B => z_del_aux\n\
        );\n\
\n\
z_del <= unsigned(z_del_aux);\n\
\n\
verificacion: process\n\
begin\n\
        wait for TCK * (DELAY + 1);\n\
        assert to_integer(z_del) = to_integer(z_dut) report\n\
                \"Error: Salida del DUT: \" & integer'image(to_integer(z_dut)) &\n\
                \", salida del archivo = \" & integer'image(to_integer(z_del))\n\
                severity warning;\n\
        if to_integer(z_del) /= to_integer(z_dut) then\n\
                errores <= errores + 1;\n\
        end if;\n\
end process verificacion;\n\
\n\
end architecture main_tb_arq;\n\
\n"

# adder template for testing
# only one group of arguments

TEMPLATE_ADD = "\
library IEEE;\n\
    use IEEE.std_logic_1164.all;\n\
    use IEEE.numeric_std.all;\n\
\n\
entity fa_tb is\n\
end entity fa_tb;\n\
\n\
architecture fa_tb_arq of fa_tb is\n\
\n\
    constant WORD_SIZE_TB : natural := {};\n\
    constant EXP_SIZE_TB  : natural := {};\n\
\n\
    constant TCK: time := 100 ns;\n\
    constant DELAY : natural := 8;\n\
\n\
    signal a_aux : std_logic_vector(WORD_SIZE_TB - 1 downto 0)\n\
					:= std_logic_vector(to_unsigned({}, WORD_SIZE_TB));\n\
    signal b_aux : std_logic_vector(WORD_SIZE_TB - 1 downto 0)\n\
					:= std_logic_vector(to_unsigned({}, WORD_SIZE_TB));\n\
    signal s_aux : std_logic_vector(WORD_SIZE_TB - 1 downto 0);\n\
\n\
    signal expected : std_logic_vector(WORD_SIZE_TB - 1 downto 0)\n\
					:= std_logic_vector(to_unsigned({}, WORD_SIZE_TB));\n\
    signal expected_aux : std_logic_vector(WORD_SIZE_TB - 1 downto 0);\n\
\n\
    signal clk : std_logic := '1';\n\
    signal verified : std_logic := '0';\n\
\n\
begin\n\
\n\
    clk <= not(clk) after TCK / 2;\n\
\n\
    DUT: entity work.main\n\
    generic map (\n\
        word_size => word_size_tb,\n\
        exp_size  => exp_size_tb\n\
    )\n\
    port map (\n\
        op_a => a_aux,\n\
        op_b => b_aux,\n\
        res  => s_aux,\n\
        clk  => clk\n\
    );\n\
\n\
    DELAY_GEN: entity work.delay_gen\n\
    generic map(\n\
        N => word_size_tb,\n\
        DELAY => DELAY\n\
    )\n\
    port map(\n\
        clk => clk,\n\
        A => expected,\n\
        B => expected_aux\n\
    );\n\
\n\
    verificacion : process\n\
    begin\n\
        wait for TCK * (DELAY + 1);\n\
\n\
        assert to_integer(unsigned(expected_aux)) = to_integer(unsigned(s_aux)) report\n\
            \"Error: Salida del DUT: \" & integer'image(to_integer(unsigned(s_aux))) &\n\
            \", salida del archivo = \" & integer'image(to_integer(unsigned(expected_aux)))\n\
            severity failure;\n\
\n\
    end process verificacion;\n\
\n\
end architecture fa_tb_arq;"
