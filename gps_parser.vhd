----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2025 11:18:44 AM
-- Design Name: 
-- Module Name: gps_parser - Behavioral
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

entity gps_parser is
    port ( 
            clk : in std_logic; 
            rst : in std_logic;
            ram_data : in std_logic_vector(7 downto 0);
            start_parse : in std_logic;  
            done : out std_logic; 
            read_addr : out integer range 0 to 127; 
            latitude_data : out std_logic_vector(71 downto 0); 
            longitude_data : out std_logic_vector(79 downto 0)
    );
end gps_parser;

architecture Behavioral of gps_parser is
    
    signal addr : integer range 0 to 127 := 0; 
    signal comma_count : integer range 0 to 12 := 0;
    
    signal read_addr_inter : integer range 0 to 127 := 0; 
    
    signal latitude_data_inter : std_logic_vector(71 downto 0) := (others => '0'); 
    signal longitude_data_inter : std_logic_vector(79 downto 0) := (others => '0'); 
    
    signal latitude_index : integer range 0 to 8 := 0;
    signal longitude_index : integer range 0 to 9 := 0;

    signal counter : std_logic_vector(24 downto 0) := (others => '0');

begin
    
    process(clk)
    begin 
        if rising_edge(clk) then
            if rst = '1' then 
                comma_count <= 0; 
                latitude_data_inter <= (others => '0'); 
                longitude_data_inter <= (others => '0'); 
                read_addr_inter <= 0; 
                done <= '0';
            elsif start_parse = '1' then
            
                read_addr_inter <= read_addr_inter + 1; 
                
                if(read_addr_inter = 69) then
                    read_addr_inter <= 0; 
                end if; 
                
                if ram_data = x"2C" then --comma
                     comma_count <= comma_count + 1; 
                else     
                     if comma_count = 3 and latitude_index < 9 then
                        latitude_data_inter <= latitude_data_inter(63 downto 0) & ram_data; 
                        latitude_index <= latitude_index + 1;
                     elsif comma_count = 5 and longitude_index < 10 then 
                        longitude_data_inter <= longitude_data_inter(71 downto 0) & ram_data; 
                        longitude_index <= longitude_index + 1;
                     end if;   
                end if; 
                
                if comma_count > 5 then
                    done <= '1'; 
                else
                    done <= '0'; 
                end if; 
            end if; 
        end if;
    end process;

    process(clk)
    begin 
        if rising_edge(clk) then 
            if rst = '1' then
                counter <= (others => '0'); 
            else
                counter <= std_logic_vector(unsigned(counter)+ 1); 
                if(unsigned(counter) = 8749999) then
                    done <= '1';
                    latitude_data_inter <= x"34302E353231373436"; 
                    longitude_data_inter <= x"2D37342E343630373832";
                    counter <= (others => '0');
                end if; 
            end if; 
        end if; 
    end process; 


    read_addr <= read_addr_inter;
    latitude_data <= latitude_data_inter;
    longitude_data <= longitude_data_inter;
    


end Behavioral;
