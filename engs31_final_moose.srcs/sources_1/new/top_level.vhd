library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TopShell is
    Port (
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        rx       : in  STD_LOGIC;
        seg      : out STD_LOGIC_VECTOR(0 to 6);
        dp       : out STD_LOGIC;
        an       : out STD_LOGIC_VECTOR(3 downto 0)
    );
end TopShell;

architecture Behavioral of TopShell is

    -- Internal signals
    signal data_out      : STD_LOGIC_VECTOR(7 downto 0);
    signal rx_done       : STD_LOGIC;
    signal y3, y2, y1, y0: STD_LOGIC_VECTOR(3 downto 0);
    signal dp_set        : STD_LOGIC_VECTOR(3 downto 0);

begin

    -- Instantiate the sci_receiver
    sci_receiver_inst : entity work.sci_receiver
        port map (
            clk       => clk,
            rst       => rst,
            rx        => rx,
            data_out  => data_out,
            rx_done   => rx_done
        );

    -- Convert the 8-bit received data into 4-bit values for the 7-segment display
    y0 <= data_out(3 downto 0); -- Lower 4 bits
    y1 <= data_out(7 downto 4); -- Upper 4 bits
    y2 <= "0000"; -- Unused in this example
    y3 <= "0000"; -- Unused in this example
    dp_set <= "1111"; -- No decimal points used

    -- Instantiate the mux7seg for display
    mux7seg_inst : entity work.mux7seg
        port map (
            clk_port    => clk,
            y3_port     => y3,
            y2_port     => y2,
            y1_port     => y1,
            y0_port     => y0,
            dp_set_port => dp_set,
            seg_port    => seg,
            dp_port     => dp,
            an_port     => an
        );

end Behavioral;
