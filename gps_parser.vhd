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
            newChar : in std_logic;
            charIn : in std_logic_vector(7 downto 0); 
            latitude_ready : out std_logic;
            longitude_ready : out std_logic; 
            latitude_data : out std_logic_vector(71 downto 0); 
            longitude_data : out std_logic_vector(79 downto 0)
    );
end gps_parser;

architecture Behavioral of gps_parser is

type state_type is (idle, determine_sentence, start_store, end_sentence, parse, done); 
signal curr : state_type :=  idle;


--each sentence is about 600 bits long. So let's alocate 2^10 bits. 
--there are 75 chaarcters present in each sentence (So let's allocate an array of 128 elements)
type sent_arr_type is array(0 to 127) of std_logic_vector(7 downto 0); 

signal sent_arr : sent_arr_type; 

signal determine_sentence_arr : sent_arr_type(0 to 2); 

signal index : integer range 0 to 127 := 0; 
signal index_sentence: integer range 0 to 2 := 0; 
signal store : std_logic := '0'; 

signal field_index : integer range 0 to 15 := 0; 
signal char_count : integer range 0 to 127 := 0; 

signal gps_valid : std_logic := '0'; 

signal latitude_inter : std_logic_vector(31 downto 0) := (others => '0');

signal longitude_inter : std_logic_vector(31 downto 0) := (others => '0');

begin


process(clk)
begin 
    if rising_edge(clk) then 
        if rst = '1' then 
            index <= 0; 
            store <= '0'; 
            gps_valid <= '0'; 
            latitude_ready <= '0'; 
            longitude_ready <= '0';
        elsif newChar = '1' then 
            case curr is 
                when idle => 
                    if(newChar = '1') then 
                        if(charIn = x"24") then 
                            index_sentence  <= 0; 
                            determine_sentence_arr(0) <= charIn; 
                            curr <= determine_sentence; 
                        else 
                            curr <= idle; 
                        end if; 
                     else 
                        curr <= idle; 
                    end if;
                when determine_sentence  => 
                    if newChar = '1' then 
                        index_sentence <= index_sentence + 1; 
                        determine_sentence_arr(index_sentence) <= charIn; 
                        
                        --checking if we get $GPRMC format
                        if index_sentence = 2 then
                            if determine_sentence_arr(1) = x"47" and determine_sentence_arr(2) = x"50" and charIn = x"52" then
                                sent_arr(0) <= determine_sentence_arr(0); 
                                sent_arr(1) <= determine_sentence_arr(1);
                                sent_arr(2) <= determine_sentence_arr(2);
                                sent_arr(3) <= charIn;
                                
                                index <= 4; 
                                store <= '1'; 
                                curr <= start_store; 
                            else
                                curr <= idle; 
                            end if; 
                        end if; 
                        
                    end if; 
                 
                when start_store => 
                    if store = '1' then 
                        sent_arr(index) <= charIn; 
                        
                        if(charIn = x"0A" or charIn = x"0D") then 
                            curr <= end_sentence;  
                        end if; 
                        
                        index <= index + 1; 
                    end if; 
                when end_sentence => 
                    store <= '0'; 
                    curr <= parse; 
                when parse => 
                    --$GPRMC
                    if sent_arr(0) = x"24" and sent_arr(1) = x"47" and sent_arr(2) = x"50" and sent_arr(3) = x"52" and sent_arr(4) = x"4D" and sent_arr(5) = x"43" then
                       latitude_inter <= sent_arr(20) & sent_arr(21) & sent_arr(22) & sent_arr(23) & sent_arr(24) & sent_arr(25) & sent_arr(26) & sent_arr(27) & sent_arr(28);
                       longitude_inter <= sent_arr(29) & sent_arr(30) & sent_arr(31) & sent_arr(32) & sent_arr(33) & sent_arr(34) & sent_arr(35) & sent_arr(36) & sent_arr(37) & sent_arr(38);
                       
                       latitude_ready <= '1'; 
                       longitude_ready <= '1'; 
                    else
                       latitude_ready <= '0'; 
                       longitude_ready  <= '0'; 
                       
                       curr <= idle; 
                    end if; 
                when done => 
                    curr <= idle; 
            
            end case; 
        else 
            curr <= idle; 
        end if; 
        
    end if; 
end process;

--receive sentence
 
 latitude_data <= latitude_inter; 
 longitude_data <= longitude_inter; 


end Behavioral;
