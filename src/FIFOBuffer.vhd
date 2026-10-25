LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FIFOBuffer IS
    PORT (
        DataIn : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        Pop, Push : IN STD_LOGIC;
        Reset : IN STD_LOGIC;
        Clk : IN STD_LOGIC;
        DataOut : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
        Invalid : OUT STD_LOGIC
    );
END ENTITY FIFOBuffer;

ARCHITECTURE Struct OF FIFOBuffer IS

    -- Memory
    TYPE DataArray IS ARRAY (255 DOWNTO 0) OF STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL Memory : DataArray;

    -- Pointers
    SIGNAL FirstPointer : unsigned(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL LastPointer : unsigned(7 DOWNTO 0) := (OTHERS => '0');

    -- Counter 
    SIGNAL Count : unsigned(8 DOWNTO 0) := (OTHERS => '0');

    -- Temp
    SIGNAL TempOut : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- Constants
    CONSTANT Zero : STD_LOGIC_VECTOR(63 DOWNTO 0);

BEGIN

    PROCESS (Clk)
    BEGIN

        IF rising_edge(Clk) THEN
        END IF;

    END PROCESS;

    TempOut <= Memory(to_integer(FirstPointer));
    DataOut <= TempOut;
    Invalid <= '1' WHEN TempOut = Zero ELSE
        '0';

END Struct;