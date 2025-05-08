----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2025 08:29:16 AM
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
    port ( 
            clk, en: in std_logic; 
            hcount, vcount: out std_logic_vector(9 downto 0); 
            done : in std_logic; 
            vid: out std_logic; 
            hs, vs: out std_logic  
    );
end vga_ctrl;

architecture Behavioral of vga_ctrl is

    signal hcount_inter, vcount_inter: std_logic_vector(9 downto 0) := (others => '0'); 
    signal hs_inter, vs_inter: std_logic := '0';
    signal vid_inter: std_logic := '0';


begin


    process(clk)
    begin
        if(rising_edge(clk) and en = '1' and done = '1') then 
                if(unsigned(hcount_inter) = 799) then 
                    hcount_inter <= (others => '0');
                    
                    if(unsigned(vcount_inter) = 524) then 
                        vcount_inter <= (others => '0'); 
                    else 
                        vcount_inter <= std_logic_vector(unsigned(vcount_inter) + 1);
                    end if; 
                else 
                     hcount_inter <= std_logic_vector(unsigned(hcount_inter) + 1);
                end if;           
        end if;  
         
    end process; 
    
    
    process(hcount_inter, vcount_inter)
    begin 
        if(unsigned(hcount_inter) >= 0 and unsigned(hcount_inter) <= 639 and unsigned(vcount_inter) >= 0 and unsigned(vcount_inter) <= 479) then
            vid_inter <= '1'; 
        else
            vid_inter <= '0';     
        end if; 
    end process; 
    
    
    process(hcount_inter)
    begin 
        if(unsigned(hcount_inter) >= 656 and unsigned(hcount_inter) <= 751) then
            hs_inter <= '0';  
        else
            hs_inter <= '1'; 
        end if; 
    end process; 
    
    
    process(vcount_inter) 
    begin 
        if(unsigned(vcount_inter) >= 490 and unsigned(vcount_inter) <= 491) then
            vs_inter <= '0';  
        else
            vs_inter <= '1'; 
        end if;
    
    end process;
    
    hcount <= hcount_inter; 
    vcount <= vcount_inter;
    hs <= hs_inter; 
    vs <= vs_inter; 
    vid <= vid_inter;


end Behavioral;
