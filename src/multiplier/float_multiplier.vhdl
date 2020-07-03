
library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;

entity float_multiplier is
    generic (
        word_size : natural := 10;
        exp_size  : natural := 4
    );
    port (
        op_a : in    std_logic_vector(word_size - 1 downto 0);
        op_b : in    std_logic_vector(word_size - 1 downto 0);
        res  : out   std_logic_vector(word_size - 1 downto 0)
    );
end entity float_multiplier;

architecture float_multiplier_arq of float_multiplier is

    constant BIAS       : integer := 2**(exp_size - 1) - 1;

    -- sign part
    signal sign_aux      : std_logic;

    -- exponent part
    constant EXP_BEGIN  : natural := word_size - 2;
    constant EXP_END    : natural := EXP_BEGIN - exp_size + 1;

    signal exp_aux       : integer;
    signal exp_res_aux   : integer;
    signal decoded_exp_a : integer := 0;
    signal decoded_exp_b : integer := 0;

    -- fraction part
    constant MANT_BEGIN : natural := EXP_END - 1;
    constant MANT_END   : natural := 0;
    constant MANT_SIZE  : natural := word_size - exp_size - 1;

    signal mant_aux      : std_logic_vector(MANT_SIZE - 1 downto 0);
    signal mant_res_aux  : std_logic_vector(2 * MANT_SIZE + 1 downto 0);
    signal significand_a : std_logic_vector(MANT_SIZE downto 0);
    signal significand_b : std_logic_vector(MANT_SIZE downto 0);

begin

    sign_aux <= op_a(word_size - 1) xor op_b(word_size - 1);

    decoded_exp_a <= to_integer(unsigned(op_a(EXP_BEGIN downto EXP_END))) - BIAS;
    decoded_exp_b <= to_integer(unsigned(op_b(EXP_BEGIN downto EXP_END))) - BIAS;

    significand_a <= '1' & op_a(MANT_BEGIN downto MANT_END);
    significand_b <= '1' & op_b(MANT_BEGIN downto MANT_END);

  ADDER: entity work.adder
        port map (
            a   => decoded_exp_a,
            b   => decoded_exp_b,
            res => exp_res_aux
        );

  MULTIPLIER: entity work.multiplier
        generic map (
            mant_size => MANT_SIZE
        )
        port map (
            a   => significand_a,
            b   => significand_b,
            res => mant_res_aux
        );

  RESULT_PICKER: entity work.result_picker
        generic map (
            mant_size => MANT_SIZE
        )
        port map (
            mant     => mant_res_aux,
            exp      => exp_res_aux,
            mant_res => mant_aux,
            exp_res  => exp_aux
        );

  RESULT_BUILDER: entity work.result_builder
        generic map (
            word_size => word_size,
            exp_size  => exp_size,
            mant_size => MANT_SIZE
        )
        port map (
            sign    => sign_aux,
            exp_in  => exp_aux,
            mant_in => mant_aux,
            res     => res
        );

end architecture float_multiplier_arq;
