----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2025 09:57:08 AM
-- Design Name: 
-- Module Name: pixel_pusher - Behavioral
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

entity pixel_pusher is
    port ( 
            clk, en: in std_logic;
            vs: in std_logic; 
            pixel: in std_logic_vector(7 downto 0); 
            hcount, vcount: in std_logic_vector(9 downto 0); 
            vid: in std_logic; 
            latitude_data  : in std_logic_vector(71 downto 0); 
            longitude_data : in std_logic_vector(79 downto 0); 
            R, B: out std_logic_vector(4 downto 0); 
            G: out std_logic_vector(5 downto 0); 
            addr: out std_logic_vector(6 downto 0)
               
    );
end pixel_pusher;

architecture Behavioral of pixel_pusher is


    
    signal addr_inter: std_logic_vector(6 downto 0) := (others => '0'); 
    signal char_index : std_logic_vector(2 downto 0) := (others => '0');
    signal char_col : integer range 0 to 9 := 0; 
    signal pixel_data : std_logic_vector(7 downto 0); 
    signal pixel_col : integer range 0 to 7 := 0;
    
    signal current_char : std_logic_vector(7 downto 0);  
    
    signal row_inter : std_logic_vector(2 downto 0);


    signal addr_inter_period : integer range 0 to 7 := 0; 
    signal addr_inter_0:  integer range 8 to 15 := 8;
    signal addr_inter_1:  integer range 16 to 23 := 16;
    signal addr_inter_2:  integer range 24 to 31 := 24;
    signal addr_inter_3:  integer range 32 to 39 := 32;
    signal addr_inter_4: integer range 40 to 47 := 40;
    signal addr_inter_5: integer range 48 to 55 := 48;
    signal addr_inter_6: integer range 56 to 63 := 56;
    signal addr_inter_7: integer range 64 to 71 := 64;
    signal addr_inter_8: integer range 72 to 79 := 72;
    signal addr_inter_9: integer range 80 to 87 := 80;
    
    signal hcount_inter, vcount_inter: std_logic_vector(9 downto 0); 
   
begin



    process(clk, hcount_inter, vcount_inter)
    begin
        if(rising_edge(clk)) then
            if(unsigned(vcount_inter) >= 0 and unsigned(vcount_inter) <= 8) then 
                if(hcount_inter(2 downto 0) = "000") then --multiples of 8
                    
                    case to_integer(unsigned(char_index)) is
                        when 0 => current_char <= latitude_data(71 downto 64);
                        when 1 => current_char <= latitude_data(63 downto 56);
                        when 2 => current_char <= latitude_data(55 downto 48);
                        when 3 => current_char <= latitude_data(47 downto 40);
                        when 4 => current_char <= latitude_data(39 downto 32);
                        when 5 => current_char <= latitude_data(31 downto 24);
                        when 6 => current_char <= latitude_data(23 downto 16);
                        when 7 => current_char <= latitude_data(15 downto 8);
                        when 8 => current_char <= latitude_data(7 downto 0);
                        when others => current_char <= (others => '0');
                    end case;
    
                    if (unsigned(char_index) = 8) then
                        char_index <= (others => '0'); 
                    else
                      char_index <= std_logic_vector(unsigned(char_index) + 1);
                    end if;   
    
                    
                end if; 
            elsif(unsigned(vcount_inter) >= 12 and unsigned(vcount_inter) <= 19) then
                if(hcount_inter(2 downto 0) = "000") then --multiples of 8 
                    
                    case to_integer(unsigned(char_index)) is
                        when 0 => current_char <= longitude_data(79 downto 72);  -- First character of longitude
                        when 1 => current_char <= longitude_data(71 downto 64);
                        when 2 => current_char <= longitude_data(63 downto 56);
                        when 3 => current_char <= longitude_data(55 downto 48);
                        when 4 => current_char <= longitude_data(47 downto 40);
                        when 5 => current_char <= longitude_data(39 downto 32);
                        when 6 => current_char <= longitude_data(31 downto 24);
                        when 7 => current_char <= longitude_data(23 downto 16);
                        when 8 => current_char <= longitude_data(15 downto 8);
                        when 9 => current_char <= longitude_data(7 downto 0);
                        when others => current_char <= (others => '0');
                    end case;
                    
                    if (unsigned(char_index) = 9) then
                        char_index <= (others => '0'); 
                    else
                      char_index <= std_logic_vector(unsigned(char_index) + 1);
                    end if;               
                    
                end if; 
            end if; 
        end if; 
       
    end process;
    
    process(clk, vcount_inter)
    begin 
        if(rising_edge(clk)) then 
            if((unsigned(vcount_inter) >= 1 and unsigned(vcount_inter) <= 7) or (unsigned(vcount_inter) >= 13 and unsigned(vcount_inter) <= 19)) then 
                  addr_inter_period <= addr_inter_period + 1;
                  addr_inter_0 <= addr_inter_0 + 1; 
                  addr_inter_1 <= addr_inter_1 + 1; 
                  addr_inter_2 <= addr_inter_2 + 1; 
                  addr_inter_3 <= addr_inter_3 + 1; 
                  addr_inter_4 <= addr_inter_4 + 1; 
                  addr_inter_5 <= addr_inter_5 + 1;
                  addr_inter_6 <= addr_inter_6 + 1; 
                  addr_inter_7 <= addr_inter_7 + 1;
                  addr_inter_8 <= addr_inter_8 + 1;
                  addr_inter_9 <= addr_inter_9 + 1; 
              else  
                  addr_inter_period <= 0;
                  addr_inter_0 <= 8;
                  addr_inter_1 <= 16; 
                  addr_inter_2 <= 24; 
                  addr_inter_3 <= 32; 
                  addr_inter_4 <= 40; 
                  addr_inter_5 <= 48;
                  addr_inter_6 <= 56; 
                  addr_inter_7 <= 64; 
                  addr_inter_8 <= 72;
                  addr_inter_9 <= 80;     
              end if;
          end if; 
    end process; 

    process(clk, hcount_inter, vcount_inter)
    begin
        if(rising_edge(clk)) then 
          if((unsigned(hcount_inter) >= 0 and unsigned(hcount_inter) <= 79) and ((unsigned(vcount_inter) >= 0 and unsigned(vcount_inter) <= 7) or (unsigned(vcount_inter) >= 12 and unsigned(vcount_inter) <= 19))) then
            case current_char is 
                when x"2E" => 
                  addr_inter <= std_logic_vector(to_unsigned(addr_inter_period, 7));
                when x"30" => 
                  addr_inter <= std_logic_vector(to_unsigned(addr_inter_0, 7));
                when x"31" => 
                  addr_inter <= std_logic_vector(to_unsigned(addr_inter_1, 7));
                when x"32" => 
                  addr_inter <= std_logic_vector(to_unsigned(addr_inter_2, 7)); 
                when x"33" => 
                  addr_inter <= std_logic_vector(to_unsigned(addr_inter_3, 7)); 
                when x"34" => 
                  addr_inter <= std_logic_vector(to_unsigned(addr_inter_4, 7));
                when x"35" => 
                  addr_inter <= std_logic_vector(to_unsigned(addr_inter_5, 7));
                when x"36" => 
                  addr_inter <= std_logic_vector(to_unsigned(addr_inter_6, 7)); 
                when x"37" => 
                  addr_inter <= std_logic_vector(to_unsigned(addr_inter_7, 7));
                when x"38" => 
                  addr_inter <= std_logic_vector(to_unsigned(addr_inter_8, 7));
                when x"39" => 
                  addr_inter <= std_logic_vector(to_unsigned(addr_inter_9, 7));                                                                                         
                when others => 
                  addr_inter <= (others => '0');        
            end case; 
          end if;  
        end if;  
    end process;



    

    process(clk)
    begin 
        if(rising_edge(clk)) then
   
            if(en = '1' and vid = '1' and ((unsigned(vcount) >= 8 and unsigned(vcount) <= 12) or unsigned(vcount) > 19) and unsigned(hcount) < 480) then 
               addr <= (others => '0'); 
            elsif(en = '1' and vid = '1' and unsigned(hcount) < 480) then
               addr <= addr_inter;
            end if;  
            
            if(en = '1' and vid = '1' and unsigned(hcount) < 480) then
                R <= pixel(7 downto 5) & "00"; 
                G <= pixel(4 downto 2) & "000"; 
                B <= pixel(1 downto 0) & "000"; 
            else 
                R <= (others => '0'); 
                G <= (others => '0');
                B <= (others => '0'); 
            end if;
        end if; 
       
    end process; 
    

    hcount_inter <= hcount; 
    vcount_inter <= vcount; 

end Behavioral;
