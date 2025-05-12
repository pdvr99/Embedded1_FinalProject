----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/13/2025 02:41:01 PM
-- Design Name: 
-- Module Name: debounce - Behavioral
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
use IEEE.NUMERIC_STD.ALL; 

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debounce is
    port ( 
            clk: in std_logic;
            btn: in std_logic;
            dbnc: out std_logic
    );
end debounce;

architecture Behavioral of debounce is

    signal counter : std_logic_vector(22 downto 0) := (others => '0'); 
    signal shift_reg: std_logic_vector(1 downto 0) := (others => '0'); 

begin



    process(clk) 
    begin
        if rising_edge(clk) then
            shift_reg(1) <= shift_reg(0); 
            shift_reg(0) <= btn; 
            
            if(shift_reg(1) = '1') then 
                counter <= std_logic_vector(unsigned(counter) + 1); 
            else
                counter <= (others => '0'); 
            end if; 
           
            if(unsigned(counter) > 2499999) then
                dbnc <= '1'; 
            else
                dbnc <= '0'; 
            end if;         
        end if; 
    end process;

end Behavioral;