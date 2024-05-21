library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TopShell_tb is
end TopShell_tb;

architecture Behavioral of TopShell_tb is

    -- Testbench signals
    signal clk      : STD_LOGIC := '0';
    signal rst      : STD_LOGIC := '1';
    signal rx       : STD_LOGIC := '1';
    signal seg      : STD_LOGIC_VECTOR(0 to 6);
    signal dp       : STD_LOGIC;
    signal an       : STD_LOGIC_VECTOR(3 downto 0);

    -- Clock period definition for 100 MHz
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the TopShell
    uut: entity work.TopShell
        port map (
            clk => clk,
            rst => rst,
            rx  => rx,
            seg => seg,
            dp  => dp,
            an  => an
        );

    -- Clock generation
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus process
    stimulus: process
    begin
        -- Apply reset
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 20 ns;

        -- Simulate UART reception of a byte (e.g., 0x55 which is 01010101)
        -- Start bit
        rx <= '0';
        wait for 10417 * clk_period; -- wait for one baud period

        -- Data bits (least significant bit first)
        rx <= '1';
        wait for 10417 * clk_period;
        rx <= '0';
        wait for 10417 * clk_period;
        rx <= '1';
        wait for 10417 * clk_period;
        rx <= '0';
        wait for 10417 * clk_period;
        rx <= '1';
        wait for 10417 * clk_period;
        rx <= '0';
        wait for 10417 * clk_period;
        rx <= '1';
        wait for 10417 * clk_period;
        rx <= '0';
        wait for 10417 * clk_period;

        -- Stop bit
        rx <= '1';
        wait for 10417 * clk_period;

        -- Wait and observe the results
        wait for 100 ns;

        -- End simulation
        wait;
    end process;

end Behavioral;
