library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity compute_bearing is
    port ( 
        clk : in std_logic; 
        rst : in std_logic; 
        latitude_data : in std_logic_vector(71 downto 0); 
        longitude_data : in std_logic_vector(79 downto 0); 
        distance_km : out std_logic_vector(47 downto 0)
    );
end compute_bearing;

architecture Behavioral of compute_bearing is

    attribute use_dsp48 : string;
    attribute use_dsp48 of Behavioral : architecture is "yes";

    -- Input and internal signals
    signal lat1, long1   : signed(15 downto 0);
    signal lat2          : signed(15 downto 0) := to_signed(-161, 16);
    signal long2         : signed(15 downto 0) := to_signed(2063, 16);
    signal dlat, dlon    : signed(15 downto 0);
    signal dlat_sq, dlon_sq : signed(31 downto 0);
    signal sum_sq        : signed(32 downto 0);
    signal dist_scaled   : signed(47 downto 0);
    constant R_km        : signed(15 downto 0) := to_signed(6383, 16);

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                lat1         <= (others => '0');
                long1        <= (others => '0');
                dlat         <= (others => '0');
                dlon         <= (others => '0');
                dlat_sq      <= (others => '0');
                dlon_sq      <= (others => '0');
                sum_sq       <= (others => '0');
                dist_scaled  <= (others => '0');
                distance_km  <= (others => '0');

            else
                -- Step 1: Extract lat/long
                lat1 <= signed(latitude_data(71 downto 56));
                long1 <= signed(longitude_data(79 downto 64));

                -- Step 2: Compute differences
                dlat <= lat2 - lat1;
                dlon <= long2 - long1;

                -- Step 3: Square differences
                dlat_sq <= dlat * dlat;
                dlon_sq <= dlon * dlon;

                -- Step 4: Sum of squares
                sum_sq <= resize(dlat_sq, 33) + resize(dlon_sq, 33);

                -- Step 5: Multiply by radius (scaled distance)
                dist_scaled <= resize(sum_sq, 24) * resize(R_km, 24);

                -- Step 6: Output
                distance_km <= std_logic_vector(resize(dist_scaled, 48));
            end if;
        end if;
    end process;

end Behavioral;
