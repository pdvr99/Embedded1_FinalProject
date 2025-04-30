----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2025 10:02:50 AM
-- Design Name: 
-- Module Name: clk_div - Behavioral
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

entity clk_div is
    port ( 
        clk : in std_logic;
        div : out std_logic     
    );
end clk_div;

architecture Behavioral of clk_div is

    signal counter : std_logic_vector(26 downto 0) := (others => '0'); 

begin

    process(clk)
    begin
        if rising_edge(clk) then
        
            if(unsigned(counter) < 1084) then
                div <= '0'; 
            elsif(unsigned(counter) >= 1084)then
                div <= '1'; 
            end if;
        
            if(unsigned(counter) < 1084) then 
                counter <=  std_logic_vector(unsigned(counter) + 1); 
            else 
                counter <= (others => '0'); 
            end if; 
        end if; 
    end process; 
            


end Behavioral;