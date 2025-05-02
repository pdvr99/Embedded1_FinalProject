----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2025 02:31:53 PM
-- Design Name: 
-- Module Name: top_gps_tb_1 - Behavioral
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

entity top_gps_tb_1 is
--  Port ( );
end top_gps_tb_1;

architecture Behavioral of top_gps_tb_1 is

    component top_gps
        port ( 
            clk : in std_logic; 
            btn : in std_logic; 
            rx : in std_logic;
            done : out std_logic;
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
    
    signal clk : std_logic := '0';
    signal btn : std_logic := '0';
    signal rx  : std_logic := '1'; -- Unused here
    signal done : std_logic;
    signal latitude_data : std_logic_vector(71 downto 0);
    signal longitude_data : std_logic_vector(79 downto 0);
    
    

begin

    dut: top_gps
        port map (
            clk => clk,
            btn => btn,
            rx  => rx,  -- not used in sim
            done => done,
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
        variable current_byte : std_logic_vector(7 downto 0);
    begin
        wait for 20ns; 
        btn <= '1'; 
        wait for 20ns; 
        btn <= '0'; 
        wait for 20ns; 
        
        
        for i in 0 to 69 loop
            rx <= '0'; 
            wait for 104166ns;
            for j in 0 to 7 loop
                rx <=  gprmc_sentence(i)(j); 
                wait for 104166ns;
                
                report "Sending bit: " & std_logic'image(gprmc_sentence(i)(j));


            end loop; 
            rx <= '1'; 
            wait for 104166ns;
           
        end loop; 
        
        wait for 1 ms; 
        
        report "Latitude (hex): " & to_hstring(to_bitvector(latitude_data));
        report "Longitude (hex): " & to_hstring(to_bitvector(longitude_data));
        
        wait;
    end process; 
    

end Behavioral;
