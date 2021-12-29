library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
----------------------------
entity baudrate_generator is

	port(
			clk_in   : in std_logic;
			clk_out  : out std_logic);
			
end entity baudrate_generator;
---------------------

architecture str of baudrate_generator is

	signal count          : unsigned(10 downto 0) := (others => '0');
	constant divider      : unsigned(10 downto 0) := to_unsigned(867, 11);
begin
	
		
	baudrate : process(clk_in) is
		
		
	begin
		
		if (rising_edge(clk_in)) then
			count <= count + 1;
			if count = divider then
				clk_out <= '1';
				count   <= (others => '0');
			else
				clk_out <= '0';
			end if;
			
		end if;
		
	end process baudrate;
	
end architecture str;
		
		
		
		
		
		
		
		
		
		
		
		
		
		

