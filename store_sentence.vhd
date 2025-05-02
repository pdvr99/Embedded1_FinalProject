----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2025 10:36:44 AM
-- Design Name: 
-- Module Name: store_sentence - Behavioral
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

entity store_sentence is
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
end store_sentence;

architecture Behavioral of store_sentence is

    type ram_type is array(0 to 69) of std_logic_vector(7 downto 0); 
    signal ram_block : ram_type; 
    
    signal wr_addr : integer range 0 to 69; 
    signal full_block : std_logic := '0';
     
      

begin
    
    --write
    process(newChar) 
    begin 
        if newChar = '1' and full_block = '0' then
        
            ram_block(wr_addr) <= charIn; 
           
            if wr_addr = 69 then 
                full_block <= '1';
                wr_addr <= 0;  
            else 
                wr_addr <= wr_addr + 1; 
            end if;  
            
        end if ; 
    end process; 
    
    wr_done <= full_block;
    
    --read
    process(clk) 
    begin 
        if rising_edge(clk) then
            if read_en = '1' then 
                charOut <= ram_block(read_addr); 
            else
                charOut <= (others => '0');  
            end if; 
            
        end if; 
    end process;
    


end Behavioral;
