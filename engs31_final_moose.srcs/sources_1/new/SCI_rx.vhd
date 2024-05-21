library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sci_receiver is
    Port (
        clk : in  STD_LOGIC;
        rst : in  STD_LOGIC;
        rx : in  STD_LOGIC;
        data_out : out  STD_LOGIC_VECTOR (7 downto 0);
        rx_done : out  STD_LOGIC
    );
end sci_receiver;

architecture Behavioral of sci_receiver is
    signal shift_reg : STD_LOGIC_VECTOR (7 downto 0);
    signal bit_count : integer range 0 to 9 := 0;  -- Adjusted range
    signal rx_done_int : STD_LOGIC := '0';
    signal baud_counter : integer range 0 to 10416 := 0; -- Adjust the range based on your CLK_DIV value
    signal tc_baud : STD_LOGIC := '0';  -- Replaces sample_tick
    signal tc_bit : STD_LOGIC := '0';   -- High when 8 bits are loaded
    
    constant CLK_DIV : integer := 10417; -- Adjust this constant based on your clock and baud rate
begin
    -- Clock divider process to generate tc_baud for baud rate
    process(clk, rst)
    begin
        if rst = '1' then
            baud_counter <= 0;
            tc_baud <= '0';
        elsif rising_edge(clk) then
            if baud_counter = CLK_DIV - 1 then
                baud_counter <= 0;
                tc_baud <= '1';
            else
                baud_counter <= baud_counter + 1;
                tc_baud <= '0';
            end if;
        end if;
    end process;

    -- Shift register and control logic
    process(clk, rst)
    begin
        if rst = '1' then
            shift_reg <= (others => '0');
            bit_count <= 0;
            rx_done_int <= '0';
            tc_bit <= '0';
        elsif rising_edge(clk) then
            if tc_bit = '1' then
                shift_reg <= (others => '0');
                bit_count <= 0;
                rx_done_int <= '0';
                tc_bit <= '0';
            elsif tc_baud = '1' then
                if bit_count = 0 and rx = '0' then
                    bit_count <= bit_count + 1; -- Start bit detected
                elsif bit_count > 0 and bit_count <= 8 then
                    shift_reg <= shift_reg(6 downto 0) & rx;
                    if bit_count = 8 then
                        rx_done_int <= '1'; -- Full byte received
                        tc_bit <= '1';  -- Indicate that 8 bits are loaded
                    end if;
                    bit_count <= bit_count + 1;
                elsif bit_count = 9 then
                    bit_count <= 0; -- Reset bit count after receiving a full byte
                    rx_done_int <= '0';
                    tc_bit <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Output assignments
    data_out <= shift_reg;
    rx_done <= rx_done_int;
end Behavioral;
