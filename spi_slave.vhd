----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/08/2025 08:09:37 AM
-- Design Name: 
-- Module Name: spi_slave - Behavioral
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

entity spi_slave is
  port ( 
        sck : in std_logic;  
        rst : in std_logic;
        done : in std_logic; 
        MOSI : in std_logic;  
        cs: in std_logic; 
        bit_out : out std_logic 
         
  
  );
end spi_slave;

architecture Behavioral of spi_slave is

    signal rx_reg : std_logic_vector(7 downto 0) := (others => '0'); 
    signal bit_index : integer range 0 to 7; 

begin

    process(sck)
    begin  
        if(rising_edge(sck)) then
            if(cs = '0') then 
               rx_reg(bit_index) <= MOSI; 
               bit_out <= rx_reg(bit_index);
               bit_index <= bit_index + 1; 
              
               
               if(bit_index >= 7) then 
                    bit_index <= 0;
               end if; 
            elsif(rst = '1') then 
                bit_index <= 0;
            end if; 
        end if; 
    end process;
    
    

end Behavioral;
