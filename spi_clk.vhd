----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/08/2025 09:04:06 AM
-- Design Name: 
-- Module Name: spi_clk - Behavioral
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

entity spi_clk is
    port ( 
            clk : in std_logic; 
            sck : out std_logic
    );
end spi_clk;

architecture Behavioral of spi_clk is

    signal sck_reg : std_logic := '0';  -- SPI clock register
    signal count : integer range 0 to 11 := 0;

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if (count = 11) then
                count <= 0; 
                sck_reg <= not sck_reg;
            else
                count <= count + 1; 
            end if; 
        end if;
    end process;

    sck <= sck_reg;
    
end Behavioral;
