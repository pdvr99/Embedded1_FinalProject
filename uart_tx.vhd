----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/14/2025 05:21:41 AM
-- Design Name: 
-- Module Name: uart_tx - Behavioral
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

entity uart_tx is
    port ( 
        clk, en, send, rst : in std_logic; 
        char : in std_logic_vector(7 downto 0); 
        ready, tx : out std_logic
    
    

    );
end uart_tx;

architecture Behavioral of uart_tx is

    type state is (idle, start, transmit, stop); 
    signal ps : state := idle; 
   
     
    signal count_tx : std_logic_vector(3 downto 0) := (others => '0'); 
    
    signal char_reg : std_logic_vector(7 downto 0); 
    
    signal tx_inter : std_logic := '1';
    
    signal ready_inter : std_logic := '1';
    

begin

 
    
    process(clk) 
    begin
        if rising_edge(clk) then 
            if(rst = '1') then
                ps <= idle; 
                ready_inter <= '1'; 
                tx_inter <= '1'; 
            elsif(en = '1') then
                case ps is 
                
                    when idle =>
                            
                        if(send = '1') then 
                            char_reg <= char;
                            count_tx <= (others => '0');
                            ps <= start; 
                        end if;
                           
                    when start => 
                        ps <= transmit;
                        ready_inter <= '0';
                        tx_inter <= '0';
                         

                        
                    when transmit => 
                        if (unsigned(count_tx) <= 7) then
                           tx_inter <= char_reg(to_integer(unsigned(count_tx)));
                           count_tx <= std_logic_vector(unsigned(count_tx) + 1); 
                        else
                            ps <= stop; 
                            tx_inter <= '1';
                        end if;
                        
                    when stop => 
                        ready_inter <= '1';  
                        ps <= idle; 
                        
                    when others =>
                        ps <= idle; 
                end case; 
            end if; 
            
        end if; 
    end process;  
    
    
    tx <= tx_inter;
    ready <= ready_inter;

end Behavioral;