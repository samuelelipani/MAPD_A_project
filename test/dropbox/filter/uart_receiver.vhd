library ieee;
use ieee.std_logic_1164.all;
---------------------------------
entity uart_receiver is
	port(
		clock         : in std_logic;
		uart_rx       : in std_logic;
		valid         : out std_logic;
		data : out std_logic_vector(7 downto 0));
end entity uart_receiver;
-----------------------------

architecture str of uart_receiver is

	--user defined type
	type state_t is (idle_s, bit0_s, bit1_s, bit2_s, bit3_s, bit4_s, bit5_s, bit6_s, bit7_s, stop_s);
	--instantiation of signal state
	signal state : state_t := idle_s;
	
	signal baudrate_out : std_logic;
	signal data_s : std_logic_vector(7 downto 0);
	
	--1 component of uart receiver
	component sampler_generator is
		port(
			clock : in std_logic;
			uart_rx : in std_logic;
			baudrate_out : out std_logic);
	end component sampler_generator;
	
begin


	--first process of the architecture: mapping signals of component
	sampler_generator_proc : sampler_generator
		port map(
			clock        => clock,
			uart_rx      => uart_rx,
			baudrate_out => baudrate_out);
			
	
	--main process of uart receiver (STATE MACHINE)
	state_machine : process(clock) is
	begin
		if rising_edge(clock) then
			case state is
			
				when idle_s =>
					data_s  <= (others => '0');
					valid <= '0';
					if baudrate_out = '1' then
            					state <= bit0_s;
						data_s(0) <= uart_rx;
						
					end if;
				when bit0_s =>
					if baudrate_out = '1' then
						data_s(1) <= uart_rx;
						state     <= bit1_s;
					end if;
				when bit1_s =>
					if baudrate_out = '1' then
						data_s(2) <= uart_rx;
						state     <= bit2_s;
					end if;
				when bit2_s =>
					if baudrate_out = '1' then
						data_s(3) <= uart_rx;
						state     <= bit3_s;
					end if;
				when bit3_s =>
					if baudrate_out = '1' then
						data_s(4) <= uart_rx;
						state     <= bit4_s;
					end if;
				when bit4_s =>
					if baudrate_out = '1' then
						data_s(5) <= uart_rx;
						state     <= bit5_s;
					end if;
				when bit5_s =>
					if baudrate_out = '1' then
						data_s(6) <= uart_rx;
						state     <= bit6_s;
					end if;
				when bit6_s=>
					if baudrate_out = '1' then
						data_s(7) <= uart_rx;
						state     <= bit7_s;
					end if;
				when bit7_s =>
					if baudrate_out = '1' then
				
						state <= stop_s;
					end if;
				when stop_s =>
					if baudrate_out = '1' then
					valid <= '1';
					data  <= data_s;
					state <= idle_s;
					end if;	
				when others => null;
			end case;
		end if;
	end process state_machine;
end architecture str;
	
	
	
	
	
	
	
	
	
	
	
	
	
