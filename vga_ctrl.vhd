----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/03/2025 01:08:44 PM
-- Design Name: 
-- Module Name: vga_ctrl - Behavioral
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

entity vga_ctrl is
port(
     clk, clk_en : in std_logic;
     red : out std_logic;
     hcount, vcount : out std_logic_vector(9 downto 0);
     vid, hs, vs : out std_logic
     );
end vga_ctrl;

architecture Behavioral of vga_ctrl is

signal hcounter : std_logic_vector(9 downto 0) := (others => '0');
signal vcounter : std_logic_vector(9 downto 0) := (others => '0');
signal reset_hcounter : std_logic := '0';
constant maxLong : real := -74.470084;
constant minLong : real := -74.458488;
constant maxLat : real := 40.529002;
constant minLat : real := 40.520552;
constant long : real := -74.460653;
constant lat : real := 40.521515;
begin
hcount <= hcounter;
vcount <= vcounter;
process(clk)

begin

if(rising_edge(clk)) then

    if(clk_en = '1') then
        
        if(unsigned(hcounter) < 799) then
            hcounter <= std_logic_vector(unsigned(hcounter) + 1);
        else
            hcounter <= (others => '0');
            if(unsigned(vcounter) < 524) then
                vcounter <= std_logic_vector(unsigned(vcounter) + 1);
            else
                vcounter <= (others => '0');
            end if;  
        end if;    
    end if;
end if;
end process;
--    if(unsigned(hcounter) < 640 and unsigned(vcounter) < 480) then
--        vid <= '1';
--        if(real(to_integer(unsigned(hcounter))) >= (((real(to_integer(unsigned(long))) - minLong)/0.000193)) * 640.0 - 20.0
--        and
--        real(to_integer(unsigned(hcounter))) <= (((real(to_integer(unsigned(long))) - minLong)/0.000193)) * 640.0 + 20.0
--         ) then
--            red <= '1';
--        else
--            red <= '0';
--        end if;
--    else
--        vid <= '0';    
--    end if;
process(hcounter,vcounter)
begin

    if(unsigned(hcounter) < 640 and unsigned(vcounter) < 480) then
        vid <= '1';
        if(unsigned(hcounter) >= 397
        and
        unsigned(hcounter) <= 417
        and
        unsigned(vcounter) <= 400
        and
        unsigned(vcounter) >= 380
         ) then
            red <= '1';
        else
            red <= '0';
        end if;
    else
        vid <= '0';    
    end if;

--    if(unsigned(hcounter) < 640 and unsigned(vcounter) < 480) then
--        vid <= '1';
--        if((unsigned(hcounter) >= 310) and unsigned(hcounter) <= 330 and (unsigned(vcounter) >= 230) and unsigned(vcounter) <= 250) then
--            red <= '1';
--        else
--            red <= '0';
--        end if;
--    else
--        vid <= '0';    
--    end if;
end process;

process(hcounter)
begin
    if(unsigned(hcounter) > 655 and unsigned(hcounter) < 752) then
        hs <= '0';
    else
        hs <= '1';    
    end if;
end process;

process(vcounter)
begin
    if(unsigned(vcounter) > 489 and unsigned(vcounter) < 492) then
        vs <= '0';
    else
        vs <= '1';    
    end if;
end process;


end Behavioral;