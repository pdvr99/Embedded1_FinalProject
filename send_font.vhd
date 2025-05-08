library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity send_font is
    port ( 
        sck         : in std_logic;       
        font_type   : in std_logic;        
        en          : in std_logic; 
        done        : in std_logic;        
        pixel1      : in std_logic_vector(7 downto 0);   
        pixel2      : in std_logic_vector(7 downto 0);   
        bit_out     : out std_logic;       
        cs          : out std_logic;       
        dc          : out std_logic;       
        addr1       : out std_logic_vector(7 downto 0); 
        addr2       : out std_logic_vector(7 downto 0)       
    );
end send_font;

architecture Behavioral of send_font is

    type state is (idle, pixel_receive, bits, finish); 
    signal ps : state := idle;  

    signal i : integer range 0 to 7 := 0;  -- Counter for bit shifting
    signal pixel_data : std_logic_vector(7 downto 0); -- Data to be sent (depends on font type)
    signal sck_reg : std_logic := '0';  -- SPI clock register
    signal count : integer range 0 to 11 := 0; 
    signal addr1_inter : std_logic_vector(7 downto 0) := (others => '0'); 
    signal addr2_inter : std_logic_vector(7 downto 0) := (others => '0'); 
    
    signal cs_inter : std_logic := '1'; 
    
begin
    
    process(sck)
    begin
        if rising_edge(sck) then
            if(en = '1') then 
                case ps is 
                    when idle => 
                        ps <= pixel_receive;
                    when pixel_receive => 
                        dc <= '1'; 
                        if(font_type = '0') then
                            pixel_data <= pixel1; 
                            ps <= bits; 
                        else
                            pixel_data <= pixel2;
                            ps <= bits;  
                        end if; 
                    when bits => 
                        cs_inter <= '0';
                                 
                        bit_out <= pixel_data(i);
                                               
                        if(i = 7) then
                            i <= 0; 
                            ps <= finish;  
                        else
                            i <= i + 1; 
                        end if; 
                        
                         
                    when finish => 
                        cs_inter <= '1'; 
                        if(font_type = '0') then
                            addr1_inter <= std_logic_vector(unsigned(addr1_inter) + 1);  
                            ps <= idle; 
                        else
                            addr2_inter <= std_logic_vector(unsigned(addr2_inter) + 1); 
                            ps <= idle;  
                        end if;                       
                    when others => 
                        ps <= idle; 
                      
                end case; 
            end if;  
        end if;  
    end process;
    
  
    
    addr1 <= addr1_inter; 
    addr2 <= addr2_inter;
    
    cs <= cs_inter; 

end Behavioral;
