library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-----------------------------------
entity fir_tb is
end entity fir_tb;
----------------------------------
architecture test of fir_tb is

	--clock and validation i/o
	signal clock     : std_logic := '0';
	signal valid_in  : std_logic;
	signal valid_out : std_logic;

	signal data_input  : std_logic_vector(7 downto 0);
	signal data_output : std_logic_vector(7 downto 0);

begin



	DUT : entity work.fir_filter
				port map(
					clock  => clock,
					valid_in  => valid_in,
					valid_out   => valid_out,
					data_input => data_input,
					data_output => data_output);
					
	clock <= not clock after 5 ns;
	
	WaveGen_Proc : process is
	begin
	
		valid_in <= '0';
		data_input <= "00000000";
		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';
		wait for 8 us;
	
		--25
		data_input <= "00011001";
		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';
		wait for 8 us;
		
		--43
		data_input <= "00101011";
		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';
		wait for 8 us;

		--65
		data_input <= "01000001";
		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';
		wait for 8 us;

		--22
		data_input <= "00010110";
		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';
		wait for 8 us;
		
		--35
		data_input <= "00100011";
		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';
		wait for 8 us;

		--86
		data_input <= "01010110";
		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';
		wait for 8 us;


		--12
		data_input <= "00001100";
		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';
		wait for 8 us;


		--6
		data_input <= "00000110";
		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';
		wait for 8 us;
		
		--5
		data_input <= "00000101";
		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';
		wait for 8 us;

		--4
		data_input <= "00000100";
		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';
		wait for 8 us;

		--7
		data_input <= "00000111";
		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';
		wait for 8 us;

		-- -25
		data_input <= "11100111";
		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';
		wait for 8 us;


		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';

		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';

		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';

		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';

		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';

		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';

		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';

		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';

		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';

		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';

		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';

		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';

		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';

		valid_in <= '1';
		wait for 8 us;
		valid_in <= '0';
		wait;
	end process WaveGen_Proc;
	
end architecture test;
					
					
					
					
					
					
					
					
