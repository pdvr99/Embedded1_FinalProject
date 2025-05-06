----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/01/2025 12:14:21 PM
-- Design Name: 
-- Module Name: top_gps - Behavioral
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

entity top_gps is
    port ( 
            clk : in std_logic; 
            btn : in std_logic; 
            rx : in std_logic;             
            done : out std_logic;
            vga_hs, vga_vs: out std_logic;
            vga_r, vga_b: out std_logic_vector(4 downto 0); 
            vga_g: out std_logic_vector(5 downto 0)            

    );
end top_gps;

architecture Behavioral of top_gps is

    component store_sentence is
        port ( 
                clk : in std_logic;
                rst : in std_logic; 
                newChar : in std_logic; 
                charIn : in std_logic_vector(7 downto 0); 
                read_en : in std_logic; 
                read_addr : in integer range 0 to 127; 
                charOut : out std_logic_vector(7 downto 0); 
                wr_done : out std_logic 
        );
    end component;
    
    component gps_parser is
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
    end component;
    
    component uart_rx is
        port (
        clk, en, rx, rst    : in std_logic;
        newChar             : out std_logic;
        char                : out std_logic_vector (7 downto 0)
    );
    end component;
    
    component fonts IS
      PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
      );
    END component;
    
    component pixel_pusher is
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
    end component;

    component clk_div is
        port ( 
            clk : in std_logic;
            div : out std_logic     
        );
    end component;
    
    component vga_ctrl is
    port ( 
            clk, en: in std_logic; 
            hcount, vcount: out std_logic_vector(9 downto 0); 
            vid: out std_logic; 
            hs, vs: out std_logic  
    );
    end component;
    
    component clk_div_vga is
        port (    
                  clk : in std_logic;
                  div : out std_logic      
                );
    end component;    
    
    component debounce is
        port ( 
                clk: in std_logic;
                btn: in std_logic;
                dbnc: out std_logic
        );
    end component;
    
    signal ram_data       : std_logic_vector(7 downto 0);
    signal wr_done        : std_logic;
    signal rd_addr : integer range 0 to 127;
    signal rd_en : std_logic := '1'; 
    signal rst_inter : std_logic;
    signal en_inter : std_logic;
    signal en_inter_vga : std_logic;
    signal newChar_inter : std_logic;
    signal charIn_inter : std_logic_vector(7 downto 0);
    signal pixel: std_logic_vector(7 downto 0);  
    signal hcount, vcount: std_logic_vector(9 downto 0); 
    signal vid: std_logic; 
    signal hs: std_logic; 
    signal vs: std_logic;
    signal latitude_data : std_logic_vector(71 downto 0); 
    signal longitude_data :std_logic_vector(79 downto 0);
    signal R, B: std_logic_vector(4 downto 0); 
    signal G: std_logic_vector(5 downto 0);
    signal addr: std_logic_vector(6 downto 0);   
   

begin

    U1: store_sentence
        port map (
            clk      => clk,
            rst      => rst_inter,
            newChar  => newChar_inter,
            charIn   => charIn_inter,
            read_en  => '1',  
            read_addr => rd_addr,
            charOut  => ram_data,
            wr_done  => wr_done
        );
        
    U2: gps_parser
        port map (
            clk            => clk,
            rst            => rst_inter,
            ram_data       => ram_data,
            start_parse    => wr_done,
            done           => done,
            read_addr      => rd_addr,
            latitude_data  => latitude_data,
            longitude_data => longitude_data
        );
        
     
    U3: clk_div 
        port map(
            clk => clk, 
            div => en_inter       
        );
        
    U4: debounce
        port map(
            clk => clk, 
            btn => btn, 
            dbnc => rst_inter
        );
        
    U5: uart_rx 
        port map(
            clk => clk,
            en => en_inter,
            rx => rx, 
            rst => rst_inter, 
            newChar => newChar_inter, 
            char => charIn_inter     
        );
        
    U6: pixel_pusher 
        port map(
            clk => clk, 
            vs => vs,
            en => en_inter_vga,
            pixel => pixel,
            hcount => hcount, 
            vcount => vcount,
            vid => vid,
            latitude_data => latitude_data ,
            longitude_data => longitude_data,  
            R => R, 
            B => B, 
            G => G, 
            addr => addr
            
        ); 
        
    U7: clk_div_vga
        port map(
            clk => clk, 
            div => en_inter_vga
        );
        
    U8: vga_ctrl 
        port map(
            clk => clk, 
            en => en_inter_vga, 
            hcount => hcount,
            vcount => vcount, 
            vid => vid, 
            hs => hs,
            vs => vs 
        ); 
        
    U9 : fonts 
    port map(
        clka => clk, 
        addra => addr, 
        douta => pixel
    
    );


    vga_hs <= hs; 
    vga_vs <= vs;
    vga_r <= R;
    vga_b <= B;
    vga_g <= G;

end Behavioral;
