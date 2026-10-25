LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FIFOBuffer IS
    GENERIC (
        DataWidth : POSITIVE := 64
    );
    PORT (
        DataIn : IN STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0);
        Pop, Push : IN STD_LOGIC;
        Reset : IN STD_LOGIC;
        Clk : IN STD_LOGIC;
        DataOut : OUT STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0);
        Empty, Full : OUT STD_LOGIC
    );
END ENTITY FIFOBuffer;

ARCHITECTURE Struct OF FIFOBuffer IS

    -- Memory
    TYPE DataArray IS ARRAY (255 DOWNTO 0) OF STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0);
    SIGNAL Memory : DataArray;

    -- Pointers
    SIGNAL FirstPointer : unsigned(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL LastPointer : unsigned(7 DOWNTO 0) := (OTHERS => '0');

    -- Counter 
    SIGNAL Count : unsigned(8 DOWNTO 0) := (OTHERS => '0');

    -- Constants
    CONSTANT Zero : unsigned(8 DOWNTO 0) := (OTHERS => '0');
    CONSTANT MaxCount : unsigned(8 DOWNTO 0) := (8 => '1', OTHERS => '0');

BEGIN

    PROCESS (Clk)
    BEGIN

        IF rising_edge(Clk) THEN

            IF Reset = '1' THEN

                FirstPointer <= (OTHERS => '0');
                LastPointer <= (OTHERS => '0');
                Count <= (OTHERS => '0');
                Memory <= (OTHERS => (OTHERS => '0'));

            ELSE

                IF Pop = '1' AND Count > Zero THEN
                    FirstPointer <= FirstPointer + to_unsigned(1, 8);
                    Count <= Count - to_unsigned(1, 9);
                END IF;

                IF Push = '1' AND Count < MaxCount THEN
                    Memory(to_integer(LastPointer)) <= DataIn;
                    LastPointer <= LastPointer + to_unsigned(1, 8);
                    Count <= Count + to_unsigned(1, 9);
                END IF;

                IF Push = '1' AND Pop = '1' THEN
                    Count <= Count;
                END IF;

            END IF;

        END IF;

    END PROCESS;

    DataOut <= Memory(to_integer(FirstPointer));

    Empty <= '1' WHEN Count = Zero ELSE
        '0';

    Full <= '1' WHEN Count = MaxCount ELSE
        '0';

END Struct;