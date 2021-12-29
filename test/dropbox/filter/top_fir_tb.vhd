library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-----------------------------------
entity top_tb is
end entity top_tb;
----------------------------------
architecture test of top_tb is

	signal clock  : std_logic := '0';
	signal input  : std_logic;
	signal busy   : std_logic;
	signal output : std_logic;
		
begin

	DUT : entity work.top
				port map(
					clock  => clock,
					input  => input,
					busy   => busy,
					output => output);
					
	clock <= not clock after 5 ns;
	
	WaveGen_Proc : process is
	begin
	
	input <= '0';
	wait for 8.7 us;
	
	--25
	input <= '1';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '1';
	wait for 8.7 us;
	input <= '1';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 26 us;

	--43
	input <= '1';
	wait for 8.7 us;
	input <= '1';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '1';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '1';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 26 us;

	--65
	input <= '1';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '1';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 26 us;


	--22
	input <= '0';
	wait for 8.7 us;
	input <= '1';
	wait for 8.7 us;
	input <= '1';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '1';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 26 us;

	--35
	input <= '1';
	wait for 8.7 us;
	input <= '1';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '1';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 26 us;

	--86
	input <= '0';
	wait for 8.7 us;
	input <= '1';
	wait for 8.7 us;
	input <= '1';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '1';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '1';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 26 us;


	--12
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '1';
	wait for 8.7 us;
	input <= '1';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 26 us;


	--6
	input <= '0';
	wait for 8.7 us;
	input <= '1';
	wait for 8.7 us;
	input <= '1';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 8.7 us;
	input <= '0';
	wait for 8 us;
	
		
	wait;
	
	
	end process WaveGen_Proc;
	
end architecture test;
					
					
