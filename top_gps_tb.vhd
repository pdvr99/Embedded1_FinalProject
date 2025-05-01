----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2025 09:08:24 AM
-- Design Name: 
-- Module Name: top_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_tb is
--  Port ( );
end top_tb;

architecture Behavioral of top_tb is

    component top
        port (
            clk         : in std_logic;
            RX          : in std_logic;
            fix_status  : in std_logic;
            btn         : in std_logic;
            TX          : out std_logic;
            lat_ready   : out std_logic;
            long_ready  : out std_logic;
            lat_data    : out std_logic_vector(71 downto 0);
            long_data   : out std_logic_vector(79 downto 0)
        );
    end component;
    
type str69 is array(0 to 69) of std_logic_vector(7 downto 0);

signal gprmc_sentence : str69 := (
    x"24", -- $
    x"47", -- G
    x"50", -- P
    x"52", -- R
    x"4D", -- M
    x"43", -- C
    x"2C", -- ,
    x"31", -- 1
    x"32", -- 2
    x"33", -- 3
    x"35", -- 5
    x"31", -- 1
    x"39", -- 9
    x"2C", -- ,
    x"41", -- A
    x"2C", -- ,
    x"34", -- 4
    x"38", -- 8
    x"30", -- 0
    x"37", -- 7
    x"2E", -- .
    x"30", -- 0
    x"33", -- 3
    x"38", -- 8
    x"2C", -- ,
    x"4E", -- N
    x"2C", -- ,
    x"30", -- 0
    x"31", -- 1
    x"31", -- 1
    x"33", -- 3
    x"31", -- 1
    x"2E", -- .
    x"30", -- 0
    x"30", -- 0
    x"30", -- 0
    x"2C", -- ,
    x"45", -- E
    x"2C", -- ,
    x"30", -- 0
    x"32", -- 2
    x"32", -- 2
    x"2E", -- .
    x"34", -- 4
    x"2C", -- ,
    x"30", -- 0
    x"38", -- 8
    x"34", -- 4
    x"2E", -- .
    x"34", -- 4
    x"2C", -- ,
    x"32", -- 2
    x"33", -- 3
    x"30", -- 0
    x"33", -- 3
    x"39", -- 9
    x"34", -- 4
    x"2C", -- ,
    x"30", -- 0
    x"30", -- 0
    x"33", -- 3
    x"2E", -- .
    x"31", -- 1
    x"2C", -- ,
    x"57", -- W
    x"2A", -- *
    x"36", -- 6
    x"41", -- A
    x"0D", -- CR
    x"0A"  -- LF
);
    
    
    -- DUT signals
    signal clk         : std_logic := '0';
    signal RX          : std_logic := '1';  -- Idle high
    signal fix_status  : std_logic := '1';
    signal btn         : std_logic := '0';
    signal TX          : std_logic;
    signal lat_ready   : std_logic;
    signal long_ready  : std_logic;
    signal lat_data    : std_logic_vector(71 downto 0);
    signal long_data   : std_logic_vector(79 downto 0);   


begin


    dut: top
        port map (
            clk => clk,
            RX => RX,
            fix_status => fix_status,
            btn => btn,
            TX => TX,
            lat_ready => lat_ready,
            long_ready => long_ready,
            lat_data => lat_data,
            long_data => long_data
        );
        
        
    process
    begin
        clk <= '0';
        wait for 4 ns;
        clk <= '1';
        wait for 4 ns;
    end process;
    
    process
    begin
        -- Wait for the system to start
        wait for 20 ns;

        -- Send each byte of the GPRMC sentence
        for i in 0 to 69 loop
            for j in 0 to 7 loop
                RX <= gprmc_sentence(i)(j);
                wait for 20 ns; -- wait between sending each byte
            end loop; 
        end loop;

        -- End simulation after sending the whole sentence
        wait;
    end process;

end Behavioral;
