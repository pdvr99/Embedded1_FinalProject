----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/12/2025 10:40:47 AM
-- Design Name: 
-- Module Name: ascii_to_number - Behavioral
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

entity ascii_to_number is
    port ( 
        clk : in std_logic; 
        distance_km : in std_logic_vector(47 downto 0); 
        distance_out : out std_logic_vector(47 downto 0)
        
        
    );
end ascii_to_number;

architecture Behavioral of ascii_to_number is

    type d_arr is array(0 to 7) of std_logic_vector(7 downto 0);

    signal digits : d_arr; 
    
    signal i : integer range 0 to 7 := 0; 
    
    signal input_digit : std_logic_vector(7 downto 0);
    
    signal dist_accum : std_logic_vector(47 downto 0) := (others => '0');  -- Accumulated result (48 bits) 
    
    signal ascii_out : std_logic_vector(7 downto 0);  -- Holds the ASCII value for the current digit

begin

    process(clk)
    begin 
        if(rising_edge(clk)) then
        
            digits(0) <= distance_km(47 downto 40); -- First 8 bits
            digits(1) <= distance_km(39 downto 32); -- Next 8 bits
            digits(2) <= distance_km(31 downto 24); -- And so on...
            digits(3) <= distance_km(23 downto 16);
            digits(4) <= distance_km(15 downto 8);
            digits(5) <= distance_km(7 downto 0);
        
            input_digit <= digits(i); 
            
            case input_digit is
                when "0000" =>  -- '0'
                    ascii_out <= "00110000";  -- ASCII '0' = 48 = "00110000"
                when "0001" =>  -- '1'
                    ascii_out <= "00110001";  -- ASCII '1' = 49 = "00110001"
                when "0010" =>  -- '2'
                    ascii_out <= "00110010";  -- ASCII '2' = 50 = "00110010"
                when "0011" =>  -- '3'
                    ascii_out <= "00110011";  -- ASCII '3' = 51 = "00110011"
                when "0100" =>  -- '4'
                    ascii_out <= "00110100";  -- ASCII '4' = 52 = "00110100"
                when "0101" =>  -- '5'
                    ascii_out <= "00110101";  -- ASCII '5' = 53 = "00110101"
                when "0110" =>  -- '6'
                    ascii_out <= "00110110";  -- ASCII '6' = 54 = "00110110"
                when "0111" =>  -- '7'
                    ascii_out <= "00110111";  -- ASCII '7' = 55 = "00110111"
                when "1000" =>  -- '8'
                    ascii_out <= "00111000";  -- ASCII '8' = 56 = "00111000"
                when "1001" =>  -- '9'
                    ascii_out <= "00111001";  -- ASCII '9' = 57 = "00111001"
                when others =>
                    ascii_out <= "00000000";  -- Default (error case)
            end case; 
            
             --Accumulate the ASCII values into dist_accum
            dist_accum <= dist_accum(39 downto 0) & ascii_out;  -- Shift left by 8 bits and add the new ASCII value

            -- Store the accumulated result into distance_ou
            
            -- Increment the index to move to the next digit in the array
            if i = 7 then
                i <= 0;  -- Reset to the first digit
            else
                i <= i + 1;  -- Move to the next digit
            end if;
            
        end if; 
    end process;
    
    distance_out <= dist_accum;

end Behavioral;
