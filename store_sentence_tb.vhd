----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2025 11:07:33 AM
-- Design Name: 
-- Module Name: store_sentence_tb - Behavioral
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

entity store_sentence_tb is
--  Port ( );
end store_sentence_tb;

architecture Behavioral of store_sentence_tb is

    component store_sentence
        port (
            clk        : in std_logic;
            rst        : in std_logic;
            newChar    : in std_logic;
            charIn     : in std_logic_vector(7 downto 0);
            read_en    : in std_logic;
            read_addr  : in integer range 0 to 127;
            charOut    : out std_logic_vector(7 downto 0);
            wr_done    : out std_logic
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
    
    signal clk        : std_logic := '0';
    signal rst        : std_logic := '0';
    signal newChar    : std_logic := '0';
    signal charIn     : std_logic_vector(7 downto 0) := (others => '0');
    signal read_en    : std_logic := '0';
    signal read_addr  : integer range 0 to 127 := 0;
    signal charOut    : std_logic_vector(7 downto 0);
    signal wr_done    : std_logic;
    
    


begin

    dut: store_sentence
    port map (
        clk      => clk,
        rst      => rst,
        newChar  => newChar,
        charIn   => charIn,
        read_en  => read_en,
        read_addr => read_addr,
        charOut  => charOut,
        wr_done  => wr_done
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
        rst <= '1'; 
        wait for 20ns; 
        rst <= '0'; 
        wait for 20ns; 
        
        for i in 0 to 69 loop
            charIn <= gprmc_sentence(i);
            newChar <= '1'; 
            wait for 8ns; 
            newChar <= '0'; 
            wait for 8ns; 
        end loop; 
    end process; 
    
    process
    begin
        wait for 2000 ns;  -- wait long enough for writing to finish
    
        read_en <= '1';
        for i in 0 to 69 loop
            read_addr <= i;
            wait for 8ns;
        end loop;
        read_en <= '0';
    
        wait;
    end process;
    
    process
    begin
        wait until wr_done = '1';
        report "Write complete!";
        wait;
    end process;
    


end Behavioral;
