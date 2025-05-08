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
            btn : in std_logic_vector(1 downto 0); 
            rx : in std_logic;             
            done : out std_logic;
            sck : out std_logic; 
            vga_hs, vga_vs: out std_logic;
            MOSI_value : out std_logic; 
            cs_value : out std_logic; 
            dc_value : out std_logic; 
            bit_out : out std_logic; 
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
    
    component fonts_1 IS
      PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
      );
    END component;   
    
    component spi_clk is
    port ( 
            clk : in std_logic; 
            sck : out std_logic
    );
    end component;
    
    component send_font is
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
    end component;    
    
    component spi_slave is
      port ( 
            sck : in std_logic;  
            rst : in std_logic;
            done : in std_logic;  
            MOSI : in std_logic;  
            cs : in std_logic;
            bit_out : out std_logic
            
            
      );
    end component;  

    component arial_name IS
      PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
      );
    END component; 
    
    component times_name IS
      PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
      );
    END component;     
    
    component pixel_pusher is
        port ( 
                clk, en: in std_logic;
                vs: in std_logic; 
                pixel1: in std_logic_vector(7 downto 0); 
                pixel2: in std_logic_vector(7 downto 0);
                hcount, vcount: in std_logic_vector(9 downto 0);
                font_toggle : in std_logic;  
                vid: in std_logic; 
                latitude_data  : in std_logic_vector(71 downto 0); 
                longitude_data : in std_logic_vector(79 downto 0); 
                R, B: out std_logic_vector(4 downto 0); 
                G: out std_logic_vector(5 downto 0); 
                font_type : out std_logic; 
                addr1: out std_logic_vector(6 downto 0);
                addr2 : out std_logic_vector(6 downto 0) 
                   
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
            done: in std_logic;  
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
    signal pixel1: std_logic_vector(7 downto 0); 
    signal pixel2: std_logic_vector(7 downto 0);
    signal pixel1_name: std_logic_vector(7 downto 0); 
    signal pixel2_name: std_logic_vector(7 downto 0);  
    signal hcount, vcount: std_logic_vector(9 downto 0); 
    signal vid: std_logic; 
    signal hs: std_logic; 
    signal vs: std_logic;
    signal sck_inter : std_logic; 
    signal font_toggle_inter : std_logic;
    signal font_type : std_logic; 
    signal done_inter : std_logic; 
    signal latitude_data : std_logic_vector(71 downto 0); 
    signal longitude_data :std_logic_vector(79 downto 0);
    signal R, B: std_logic_vector(4 downto 0); 
    signal G: std_logic_vector(5 downto 0);
    signal addr1: std_logic_vector(6 downto 0); 
    signal addr2: std_logic_vector(6 downto 0); 
    signal addr1_send: std_logic_vector(7 downto 0); 
    signal addr2_send: std_logic_vector(7 downto 0);
    signal bit_out_inter : std_logic;  
    signal MOSI : std_logic;  
    signal cs : std_logic; 
    signal dc : std_logic; 
    
   

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
            done           => done_inter,
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
            btn => btn(0), 
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
            pixel1 => pixel1,
            pixel2 => pixel2,
            hcount => hcount, 
            vcount => vcount,
            font_toggle => font_toggle_inter,
            vid => vid,
            latitude_data => latitude_data ,
            longitude_data => longitude_data,  
            R => R, 
            B => B, 
            G => G, 
            font_type => font_type,
            addr1 => addr1,
            addr2 => addr2
            
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
            done => done_inter,
            hcount => hcount,
            vcount => vcount, 
            vid => vid, 
            hs => hs,
            vs => vs 
        ); 
        
    U9 : fonts 
    port map(
        clka => clk, 
        addra => addr1, 
        douta => pixel1
    
    );
    
    U10 : fonts_1 
    port map(
        clka => clk, 
        addra => addr2, 
        douta => pixel2
    
    );
    
    U11 : arial_name 
    port map(
        clka => clk, 
        addra => addr1_send, 
        douta => pixel1_name
    
    );
    
    U12 : times_name 
    port map(
        clka => clk, 
        addra => addr2_send, 
        douta => pixel2_name
    
    );  
    
    U13 : spi_clk
    port map(
        clk => clk, 
        sck => sck_inter
    ); 
    
    U14 : send_font 
    port map (
        sck => sck_inter,
        font_type => font_type,
        en => en_inter,
        done => done_inter,
        pixel1 => pixel1_name,
        pixel2 => pixel2_name, 
        bit_out => MOSI,
        cs => cs,
        dc => dc, 
        addr1 => addr1_send,
        addr2 => addr2_send 
    ); 
    
    U15 : spi_slave
    port map(
        sck => sck_inter,
        rst => rst_inter,
        done => done_inter,
        cs => cs, 
        MOSI => MOSI,
        bit_out => bit_out_inter
    ); 
    
    U16: debounce
        port map(
            clk => clk, 
            btn => btn(1), 
            dbnc => font_toggle_inter
        );
    
    
    
    sck <= sck_inter; 
    done <= done_inter;
    MOSI_value <= MOSI;
    bit_out <= bit_out_inter;
    cs_value <= cs; 
    dc_value <= dc; 
    vga_hs <= hs; 
    vga_vs <= vs;
    vga_r <= R;
    vga_b <= B;
    vga_g <= G;

end Behavioral;
