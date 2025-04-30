----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/30/2025 01:27:19 PM
-- Design Name: 
-- Module Name: top - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
  port ( 
        clk : in std_logic; 
        RX : in std_logic;
        fix_status : in std_logic;
        btn : in std_logic; 
        TX : out std_logic;
        lat_ready: out std_logic; 
        long_ready: out std_logic; 
        lat_data: out std_logic_vector(71 downto 0); 
        long_data: out std_logic_vector(79 downto 0)
       
  );
end top;

architecture Behavioral of top is


    component uart is
        port (
            clk, en, send, rx, rst      : in std_logic;
            charSend                    : in std_logic_vector (7 downto 0);
            ready, tx, newChar          : out std_logic;
            charRec                     : out std_logic_vector (7 downto 0) 
        );
    end component;
    
    component gps_parser is
    port ( 
            clk : in std_logic; 
            rst : in std_logic;
            newChar : in std_logic;
            charIn : in std_logic_vector(7 downto 0); 
            latitude_ready : out std_logic;
            longitude_ready : out std_logic; 
            latitude_data : out std_logic_vector(71 downto 0); 
            longitude_data : out std_logic_vector(79 downto 0)
    );
    end component;
    
    component clk_div is
        port ( 
            clk : in std_logic;
            div : out std_logic     
        );
    end component;
    
    component debounce is
        port ( 
                clk: in std_logic;
                btn: in std_logic;
                dbnc: out std_logic
        );
    end component;

    signal char_inter : std_logic_vector(7 downto 0); 
    signal en_inter : std_logic; 
    signal ready_inter : std_logic;
    signal rst_inter : std_logic;   
    
    signal lat_ready_inter : std_logic;
    signal long_ready_inter : std_logic;
    signal tx_inter : std_logic;  
    signal lat_data_inter : std_logic_vector(71 downto 0); 
    signal long_data_inter :std_logic_vector(79 downto 0);

begin

    U1: uart 
    port map(
        clk => clk,
        en => en_inter,
        send => fix_status, 
        rx => RX,
        rst => rst_inter, 
        charSend => char_inter, 
        ready => ready_inter,
        tx => TX      
    );
    
    U2: clk_div 
    port map(
        clk => clk, 
        div => en_inter       
    );
    
    U3: debounce
    port map(
        clk => clk, 
        btn => btn, 
        dbnc => rst_inter
    );
    
    U4: gps_parser
    port map (
        clk => clk,
        rst => rst_inter,
        newChar => tx_inter,
        charIn => char_inter,
        latitude_ready => lat_ready_inter,
        longitude_ready => long_ready_inter,
        latitude_data => lat_data_inter,
        longitude_data => long_data_inter
    );

    lat_ready <= lat_ready_inter; 
    long_ready <= long_ready_inter;
    lat_data <= lat_data_inter; 
    long_data <= long_data_inter;
    TX <= tx_inter;  

end Behavioral;
