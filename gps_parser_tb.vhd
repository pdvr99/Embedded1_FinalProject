----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2025 09:28:25 AM
-- Design Name: 
-- Module Name: gps_parser_tb - Behavioral
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

entity gps_parser_tb is
--  Port ( );
end gps_parser_tb;

architecture Behavioral of gps_parser_tb is

   component gps_parser
        port( 
            clk : in std_logic;
            rst : in std_logic;
            ram_data : in std_logic_vector(7 downto 0);
            start_parse : in std_logic;  
            done : out std_logic; 
            read_addr : out integer range 0 to 127; 
            latitude_data : out std_logic_vector(71 downto 0); 
            longitude_data : out std_logic_vector(79 downto 0)
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
        
    signal clk : std_logic;
    signal rst : std_logic := '0';
    signal ram_data : std_logic_vector(7 downto 0) := (others => '0');
    signal start_parse : std_logic := '0';
    signal done : std_logic;
    signal read_addr : integer range 0 to 127;
    signal latitude_data : std_logic_vector(71 downto 0);
    signal longitude_data : std_logic_vector(79 downto 0);
    



begin


    dut: gps_parser
        port map (
            clk => clk,
            rst => rst,
            ram_data => ram_data,
            start_parse => start_parse,
            done => done,
            read_addr => read_addr,
            latitude_data => latitude_data,
            longitude_data => longitude_data
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
        -- Apply reset
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 20 ns;
    
        -- Start feeding the sentence byte by byte
        for i in 0 to 69 loop
            
            start_parse <= '1'; 
            
            -- Send each byte of the sentence
            ram_data <= gprmc_sentence(i);
            
            wait until rising_edge(clk); -- Wait for 20 ns between sending characters
         
        end loop;
    
        -- End simulation after the sentence has been sent
        wait for 1000 ns; -- Allow time for the parser to process the sentence and assert the ready signals
    
    -- End simulation
end process;


end Behavioral;
