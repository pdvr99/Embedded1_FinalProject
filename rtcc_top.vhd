----------------------------------------------------------------------------------
-- Company:
-- Engineer: 
-- 
-- Create Date: 05/01/2025 07:35:57 PM
-- Design Name: 
-- Module Name: rtcc_top - Behavioral
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

entity rtcc_top is
port(
    rst : in std_logic;
    clk           : IN    STD_LOGIC;                     --system clock
    reset_n       : IN    STD_LOGIC;                     --asynchronous active-low reset
    scl           : INOUT STD_LOGIC;                     --I2C serial clock
    sda           : INOUT STD_LOGIC;                     --I2C serial data
    set_clk_ena : IN STD_LOGIC;
--    secondsOutter : out std_logic_vector(3 downto 0);
--    seconds       : OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);  --clock output time: seconds
--    minutes       : OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);  --clock output time: minutes
--    hours         : OUT   STD_LOGIC_VECTOR(4 DOWNTO 0);  --clock output time: hours
    btn : in std_logic;
    CS  	: out STD_LOGIC;
    SDIN	: out STD_LOGIC;
	SCLK	: out STD_LOGIC;
	DC		: out STD_LOGIC;
	RES	: out STD_LOGIC;
	VBAT	: out STD_LOGIC;
	VDD	: out STD_LOGIC;
    MISO : in std_logic;
    MOSI : out std_logic;
    sclk2           : BUFFER  STD_LOGIC;                      --SPI bus: serial clock
    ss_n           : BUFFER  STD_LOGIC_VECTOR(0 DOWNTO 0)   --SPI bus: slave select
--    am_pm         : OUT   STD_LOGIC;                     --clock output time: am/pm (am = '0', pm = '1')
--    weekday       : OUT   STD_LOGIC_VECTOR(2 DOWNTO 0);  --clock output time: weekday
--    day           : OUT   STD_LOGIC_VECTOR(5 DOWNTO 0);  --clock output time: day of month
--    month         : OUT   STD_LOGIC_VECTOR(4 DOWNTO 0);  --clock output time: month
--    year          : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0)
);
end rtcc_top;

architecture Behavioral of rtcc_top is
component pmod_accelerometer_adxl345
  Generic(
    clk_freq   : INTEGER := 125;              --system clock frequency in MHz
    data_rate  : STD_LOGIC_VECTOR := "0110"; --data rate code to configure the accelerometer
    data_range : STD_LOGIC_VECTOR := "00");
  PORT(
    clk            : IN      STD_LOGIC;                      --system clock
    reset_n        : IN      STD_LOGIC;                      --active low asynchronous reset
    miso           : IN      STD_LOGIC;                      --SPI bus: master in, slave out
    sclk           : BUFFER  STD_LOGIC;                      --SPI bus: serial clock
    ss_n           : BUFFER  STD_LOGIC_VECTOR(0 DOWNTO 0);   --SPI bus: slave select
    mosi           : OUT     STD_LOGIC;                      --SPI bus: master out, slave in
    acceleration_x : OUT     STD_LOGIC_VECTOR(15 DOWNTO 0);  --x-axis acceleration data
    acceleration_y : OUT     STD_LOGIC_VECTOR(15 DOWNTO 0);  --y-axis acceleration data
    acceleration_z : OUT     STD_LOGIC_VECTOR(15 DOWNTO 0)); --z-axis acceleration data
end component;

component PmodOLEDCtrl
 Port ( 
	    secondso       : IN   STD_LOGIC_VECTOR(6 DOWNTO 0);  --clock output time: seconds
        minuteso       : IN   STD_LOGIC_VECTOR(6 DOWNTO 0);  --clock output time: minutes
        hourso         : IN   STD_LOGIC_VECTOR(4 DOWNTO 0);
        monthso       : IN   STD_LOGIC_VECTOR(4 DOWNTO 0);  --clock output time: minutes
        dayso         : IN   STD_LOGIC_VECTOR(5 DOWNTO 0);
        xAxiso : IN STD_LOGIC_VECTOR(15 downto 0);
        yAxiso : IN STD_LOGIC_VECTOR(15 downto 0);
        zAxiso : IN STD_LOGIC_VECTOR(15 downto 0);
        btn : in STD_LOGIC;
		CLK 	: in  STD_LOGIC;
		RST 	: in	STD_LOGIC;
		CS  	: out STD_LOGIC;
		SDIN	: out STD_LOGIC;
		SCLK	: out STD_LOGIC;
		DC		: out STD_LOGIC;
		RES	: out STD_LOGIC;
		VBAT	: out STD_LOGIC;
		VDD	: out STD_LOGIC);
end component;

component PmodACL_DEMO port(
        CLK : in  STD_LOGIC;
        RST : in  STD_LOGIC;
        SDI : in  STD_LOGIC;
        SDO : out  STD_LOGIC;
        SCLK : out  STD_LOGIC;
        SS : out  STD_LOGIC;
--           AN : out  STD_LOGIC_VECTOR (3 downto 0);
--           SEG : out  STD_LOGIC_VECTOR (6 downto 0);
--           DOT : out  STD_LOGIC;
        DOUTX : out  STD_LOGIC_VECTOR (9 downto 0);
        DOUTY : out  STD_LOGIC_VECTOR (9 downto 0);
        DOUTZ : out  STD_LOGIC_VECTOR (9 downto 0);
        LED : out  STD_LOGIC_VECTOR (2 downto 0)
);
end component;

component pmod_real_time_clock port (
    clk           : IN    STD_LOGIC;                     --system clock
    reset_n       : IN    STD_LOGIC;                     --asynchronous active-low reset
    scl           : INOUT STD_LOGIC;                     --I2C serial clock
    sda           : INOUT STD_LOGIC;                     --I2C serial data
    i2c_ack_err   : OUT   STD_LOGIC;                     --I2C slave acknowledge error flag
    set_clk_ena   : IN    STD_LOGIC;                     --set clock enable
    set_seconds   : IN    STD_LOGIC_VECTOR(6 DOWNTO 0);  --seconds to set clock to
    set_minutes   : IN    STD_LOGIC_VECTOR(6 DOWNTO 0);  --minutes to set clock to
    set_hours     : IN    STD_LOGIC_VECTOR(4 DOWNTO 0);  --hours to set clock to
    set_am_pm     : IN    STD_LOGIC;                     --am/pm to set clock to, am = '0', pm = '1'
    set_weekday   : IN    STD_LOGIC_VECTOR(2 DOWNTO 0);  --weekday to set clock to
    set_day       : IN    STD_LOGIC_VECTOR(5 DOWNTO 0);  --day of month to set clock to
    set_month     : IN    STD_LOGIC_VECTOR(4 DOWNTO 0);  --month to set clock to
    set_year      : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);  --year to set clock to
    set_leapyear  : IN    STD_LOGIC;                     --specify if setting is a leapyear ('1') or not ('0')
    seconds       : OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);  --clock output time: seconds
    minutes       : OUT   STD_LOGIC_VECTOR(6 DOWNTO 0);  --clock output time: minutes
    hours         : OUT   STD_LOGIC_VECTOR(4 DOWNTO 0);  --clock output time: hours
    am_pm         : OUT   STD_LOGIC;                     --clock output time: am/pm (am = '0', pm = '1')
    weekday       : OUT   STD_LOGIC_VECTOR(2 DOWNTO 0);  --clock output time: weekday
    day           : OUT   STD_LOGIC_VECTOR(5 DOWNTO 0);  --clock output time: day of month
    month         : OUT   STD_LOGIC_VECTOR(4 DOWNTO 0);  --clock output time: month
    year          : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0)
);
end component;
signal secondsOUT : std_logic_vector(6 downto 0);
signal minutesOUT : std_logic_vector(6 downto 0);
signal hoursOUT : std_logic_vector(4 downto 0);

signal secondsOUT2 : std_logic_vector(6 downto 0);
signal minutesOUT2 : std_logic_vector(6 downto 0);
signal hoursOUT2 : std_logic_vector(4 downto 0);

signal monthsOUT : std_logic_vector(4 downto 0);
signal daysOUT : std_logic_vector(5 downto 0);

signal monthsOUT2 : std_logic_vector(4 downto 0);
signal daysOUT2 : std_logic_vector(5 downto 0);

signal xAxisOut : std_logic_vector(15 downto 0);
signal yAxisOut : std_logic_vector(15 downto 0);
signal zAxisOut : std_logic_vector(15 downto 0);

signal xAxisOut2 : std_logic_vector(15 downto 0);
signal yAxisOut2 : std_logic_vector(15 downto 0);
signal zAxisOut2 : std_logic_vector(15 downto 0);

begin
secondsOUT <= secondsOUT2;
minutesOUT <= minutesOUT2;
hoursOUT <= hoursOUT2;

xAxisOut <= xAxisOut2;
yAxisOut <= yAxisOut2;
zAxisOut <= zAxisOut2;

yo2 : pmod_accelerometer_adxl345 Port map(

clk => clk,
reset_n => '1',
miso => MISO,
sclk => sclk2,
ss_n => ss_n,
mosi => MOSI,
acceleration_x => xAxisOut,
acceleration_y => yAxisOut,
acceleration_z => zAxisOut
);

yo1 : PmodOLEDCtrl Port map( 
	    secondso => secondsOUT,
        minuteso => minutesOUT,  --clock output time: minutes
        hourso => hoursOUT,
        monthso => monthsOUT,
        dayso => daysOUT,
        xAxiso =>xAxisOut2,
        yAxiso =>yAxisOut2,
        zAxiso =>zAxisOut2,
		CLK => clk,
		btn => btn,
		RST => rst,
		CS => CS,
		SDIN => SDIN,
		SCLK => SCLK,
		DC => DC,
		RES => RES,
		VBAT => VBAT,
		VDD => VDD);

yo: pmod_real_time_clock port map(
clk => clk,
reset_n => '1',
set_clk_ena => set_clk_ena,
set_am_pm => '0',
set_leapyear => '0',
scl => scl,
sda => sda,
set_seconds => "0000000",
set_minutes => "0000000",
seconds => secondsOUT2,
minutes => minutesOUT2,
set_hours => "00000",
set_month => "00000",
hours => hoursOUT2,
month => monthsOUT2,
set_weekday => "000",
--weekday => weekday,
set_day => "000000",
day => daysOUT2,
set_year => "00000000"
--year => year
);


end Behavioral;
