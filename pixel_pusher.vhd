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

    component fonts IS
      PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
      );
    END component;
    
    signal addr_inter: std_logic_vector(6 downto 0) := (others => '0'); 
    signal char_index : std_logic_vector(7 downto 0) := (others => '0');
    signal char_col : integer range 0 to 9 := 0; 
    signal pixel_data : std_logic_vector(7 downto 0); 
    signal pixel_col : integer range 0 to 7 := 0;
    
    signal current_char : std_logic_vector(7 downto 0);  
    
    signal row_inter : std_logic_vector(2 downto 0);
    
    signal addr_inter_period: std_logic_vector(6 downto 0) := (others => '0');
    signal addr_inter_0: std_logic_vector(6 downto 0) := x"08"; -- Address 0 ('.')
    signal addr_inter_1: std_logic_vector(6 downto 0) := x"10"; -- Address 8 ('0')
    signal addr_inter_2: std_logic_vector(6 downto 0) := x"18"; -- Address 16 ('1')
    signal addr_inter_3: std_logic_vector(6 downto 0) := x"20"; -- Address 24 ('2')
    signal addr_inter_4: std_logic_vector(6 downto 0) := x"28"; -- Address 32 ('3')
    signal addr_inter_5: std_logic_vector(6 downto 0) := x"30"; -- Address 40
    signal addr_inter_6: std_logic_vector(6 downto 0) := x"38"; -- Address 48
    signal addr_inter_7: std_logic_vector(6 downto 0) := x"40"; -- Address 56
    signal addr_inter_8: std_logic_vector(6 downto 0) := x"48"; -- Address 64
    signal addr_inter_9: std_logic_vector(6 downto 0) := x"50"; -- Address 72
    
    signal hcount_inter, vcount_inter: std_logic_vector(9 downto 0); 
   
begin

    rom : fonts 
    port map(
        clka => clk, 
        addra => addr_inter, 
        douta => pixel
    
    );

    process(hcount_inter, vcount_inter)
    begin
        if(unsigned(vcount_inter) < 320) then 
            if(hcount_inter(2 downto 0) = "000") then --multiples of 8
                char_index <= hcount_inter(9 downto 3); 
                
                case to_integer(unsigned(char_index)) is
                    when 0 => current_char <= latitude_data(71 downto 64);  -- First character of latitude
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
            end if; 
        else
            if(hcount_inter(2 downto 0) = "000") then --multiples of 8
                char_index <= hcount_inter(9 downto 3); 
                
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
            end if; 
        end if; 
        
       
    end process; 

    process(clk)
    begin 
        if(rising_edge(clk)) then
            if(en = '1' and vid = '1' and unsigned(hcount) < 480) then
                case current_char is 
                    when x"2E" => 
                        addr_inter <= addr_inter_period; 
                        addr_inter_period <= std_logic_vector(unsigned(addr_inter_period) + 1);
                    when x"30" => 
                        addr_inter <= addr_inter_0; 
                        addr_inter_period <= std_logic_vector(unsigned(addr_inter_0) + 1);
                    when x"31" => 
                        addr_inter <= addr_inter_1; 
                        addr_inter_period <= std_logic_vector(unsigned(addr_inter_1) + 1);
                    when x"32" => 
                        addr_inter <= addr_inter_2; 
                        addr_inter_period <= std_logic_vector(unsigned(addr_inter_2) + 1);
                    when x"33" => 
                        addr_inter <= addr_inter_3; 
                        addr_inter_period <= std_logic_vector(unsigned(addr_inter_3) + 1);
                    when x"34" => 
                        addr_inter <= addr_inter_4; 
                        addr_inter_period <= std_logic_vector(unsigned(addr_inter_4) + 1);
                    when x"35" => 
                        addr_inter <= addr_inter_5; 
                        addr_inter_period <= std_logic_vector(unsigned(addr_inter_5) + 1);
                     when x"36" => 
                        addr_inter <= addr_inter_6; 
                        addr_inter_period <= std_logic_vector(unsigned(addr_inter_6) + 1);
                    when x"37" => 
                        addr_inter <= addr_inter_7; 
                        addr_inter_period <= std_logic_vector(unsigned(addr_inter_7) + 1);
                     when x"38" => 
                        addr_inter <= addr_inter_8; 
                        addr_inter_period <= std_logic_vector(unsigned(addr_inter_8) + 1);
                     when x"39" => 
                        addr_inter <= addr_inter_9; 
                        addr_inter_period <= std_logic_vector(unsigned(addr_inter_9) + 1);                                                                                             
                    when others => 
                       addr_inter <= (others => '0');
                end case; 
                
                if(unsigned(vcount_inter) = 320) then
                    addr_inter_period <= (others => '0');
                    addr_inter_0 <= x"08"; -- Address 0 ('.')
                    addr_inter_1 <= x"10"; -- Address 8 ('0')
                    addr_inter_2 <= x"18"; -- Address 16 ('1')
                    addr_inter_3 <= x"20"; -- Address 24 ('2')
                    addr_inter_4 <= x"28"; -- Address 32 ('3')
                    addr_inter_5 <= x"30"; -- Address 40
                    addr_inter_6 <= x"38"; -- Address 48
                    addr_inter_7 <= x"40"; -- Address 56
                    addr_inter_8 <= x"48"; -- Address 64
                    addr_inter_9 <= x"50"; -- Address addr 
                end if; 
            elsif(vs = '0') then 
                addr_inter <= (others => '0');
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

    addr <= addr_inter; 
    hcount_inter <= hcount; 
    vcount_inter <= vcount; 

end Behavioral;
