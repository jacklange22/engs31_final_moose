library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_sci_receiver is
end tb_sci_receiver;

architecture Behavioral of tb_sci_receiver is
    -- Component declaration for the Unit Under Test (UUT)
    component sci_receiver is
        Port (
            clk : in  STD_LOGIC;
            rst : in  STD_LOGIC;
            rx : in  STD_LOGIC;
            data_out : out  STD_LOGIC_VECTOR (7 downto 0);
            rx_done : out  STD_LOGIC
        );
    end component;

    -- Testbench signals
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';
    signal rx : STD_LOGIC := '1';
    signal data_out : STD_LOGIC_VECTOR (7 downto 0);
    signal rx_done : STD_LOGIC;

    constant CLK_PERIOD : time := 10 ns;  -- Adjust based on your clock frequency
begin
    -- Instantiate the Unit Under Test (UUT)
    uut: sci_receiver
        Port map (
            clk => clk,
            rst => rst,
            rx => rx,
            data_out => data_out,
            rx_done => rx_done
        );

    -- Clock generation
    clk_process :process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset the UUT
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 20 ns;

        -- Simulate receiving a byte (e.g., 0xA5)
        rx <= '0';  -- Start bit
        wait for 104170 ns;  -- Wait one baud period (CLK_DIV * CLK_PERIOD)

        -- Send bits LSB first: 0xA5 = 10100101
        rx <= '1';  -- Bit 0
        wait for 104170 ns;
        rx <= '0';  -- Bit 1
        wait for 104170 ns;
        rx <= '1';  -- Bit 2
        wait for 104170 ns;
        rx <= '0';  -- Bit 3
        wait for 104170 ns;
        rx <= '0';  -- Bit 4
        wait for 104170 ns;
        rx <= '1';  -- Bit 5
        wait for 104170 ns;
        rx <= '0';  -- Bit 6
        wait for 104170 ns;
        rx <= '1';  -- Bit 7
        wait for 104170 ns;

        -- Stop bit
        rx <= '1';
        wait for 104170 ns;

        -- Add some wait time to observe the output
        wait for 1000 ns;

        -- Finish the simulation
        wait;
    end process;
end Behavioral;
