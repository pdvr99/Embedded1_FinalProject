----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/08/2025 11:04:19 AM
-- Design Name: 
-- Module Name: top_gps_tb_3 - Behavioral
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

entity top_gps_tb_3 is
--  Port ( );
end top_gps_tb_3;

architecture Behavioral of top_gps_tb_3 is
    component top_gps is
        port ( 
                clk : in std_logic; 
                btn : in std_logic_vector(1 downto 0); 
                rx : in std_logic;             
                done : out std_logic;
                sck : out std_logic; 
                vga_hs, vga_vs: out std_logic;
                MOSI_value : out std_logic; 
                cs_value : out std_logic; 
                dc_value : out std_logic; 
                bit_out : out std_logic; 
                vga_r, vga_b: out std_logic_vector(4 downto 0); 
                vga_g: out std_logic_vector(5 downto 0)            
    
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
    signal btn : std_logic_vector(1 downto 0) := "00";
    signal rx  : std_logic := '1';
    signal done : std_logic;
    signal sck : std_logic;             
    signal vga_hs, vga_vs: std_logic;
    signal MOSI : std_logic; 
    signal cs : std_logic; 
    signal dc : std_logic; 
    signal bit_out : std_logic; 
    signal vga_r, vga_b: std_logic_vector(4 downto 0); 
    signal vga_g: std_logic_vector(5 downto 0);   
        
    
    
begin

    dut: top_gps
        port map(
            clk => clk, 
            btn => btn, 
            rx => rx, 
            done => done,
            sck => sck, 
            vga_hs => vga_hs, 
            vga_vs => vga_vs, 
            MOSI_value => MOSI, 
            cs_value => cs,
            dc_value => dc,
            bit_out => bit_out,
            vga_r => vga_r,
            vga_b => vga_b, 
            vga_g => vga_g
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
        btn(0) <= '1'; 
        wait for 20ns; 
        btn(0) <= '0'; 
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
        
    end process;                  

end Behavioral;
