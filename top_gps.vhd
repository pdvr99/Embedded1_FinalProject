----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2025 12:14:21 PM
-- Design Name: 
-- Module Name: top_gps - Behavioral
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

entity top_gps is
    port ( 
            clk : in std_logic;
            rst : in std_logic; 
            newChar : in std_logic; 
            charIn : in std_logic_vector(7 downto 0);  
            done : out std_logic;
            latitude_data : out std_logic_vector(71 downto 0); 
            longitude_data : out std_logic_vector(79 downto 0)
    
    );
end top_gps;

architecture Behavioral of top_gps is

    component store_sentence is
        port ( 
                clk : in std_logic;
                rst : in std_logic; 
                newChar : in std_logic; 
                charIn : in std_logic_vector(7 downto 0); 
                read_en : in std_logic; 
                read_addr : in integer range 0 to 127; 
                charOut : out std_logic_vector(7 downto 0); 
                wr_done : out std_logic 
        );
    end component;
    
    component gps_parser is
    port ( 
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
    
    signal ram_data       : std_logic_vector(7 downto 0);
    signal wr_done        : std_logic;
    signal rd_addr : integer range 0 to 127;
    signal rd_en : std_logic := '1'; 
   

begin

    U1: store_sentence
        port map (
            clk      => clk,
            rst      => rst,
            newChar  => newChar,
            charIn   => charIn,
            read_en  => '1',  
            read_addr => rd_addr,
            charOut  => ram_data,
            wr_done  => wr_done
        );
        
    U2: gps_parser
        port map (
            clk            => clk,
            rst            => rst,
            ram_data       => ram_data,
            start_parse    => wr_done,
            done           => done,
            read_addr      => rd_addr,
            latitude_data  => latitude_data,
            longitude_data => longitude_data
        );


end Behavioral;
