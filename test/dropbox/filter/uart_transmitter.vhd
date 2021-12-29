library ieee;
use ieee.std_logic_1164.all;
----------------------------
entity uart_transmitter is

	port(
		clk_in  : in std_logic;
		valid   : in std_logic;
		data    : in std_logic_vector (7 downto 0);
		busy    : out std_logic;
		trans   : out std_logic);
		
end entity uart_transmitter;
--------------------------
architecture str of uart_transmitter is


	component baudrate_generator is
		port(
			clk_in        : in std_logic;
			clk_out       : out std_logic);
	end component baudrate_generator;

	

	type state_t is (START, LSB, BIT1, BIT2, BIT3,
		BIT4, BIT5, BIT6, BIT7, STOP, IDLE, VALIDATION); --user defined type
	signal state : state_t := IDLE;
	
	signal clk_out : std_logic;
	
begin
	
	--first concurrent process
	baudrate_generator_1 : baudrate_generator
		port map(
			clk_in        => clk_in,
			clk_out       => clk_out);


	--second concurrent process
	transmission : process (clk_out) is
	begin

		if rising_edge(clk_out) then
			case state is
		
				when IDLE =>
					busy <= '0';
					if valid = '1' then 
						state <= VALIDATION;
					end if;
				
				when VALIDATION =>
					state <= START;
					busy  <= '1';
				
				when START =>
					if clk_out = '1' then
						state <= LSB;
						trans <= data(0);
					end if;
				
				when LSB =>
					if clk_out = '1' then
						trans <= data(1);
						state <= BIT1;
					end if;
				
				when BIT1 =>
					if clk_out = '1' then
						trans <= data(2);
						state <= BIT2;
					end if;
				
				when BIT2 =>
					if clk_out = '1' then
						trans <= data(3);
						state <= BIT3;
					end if;
				
				when BIT3 =>
					if clk_out = '1' then
						trans <= data(4);
						state <= BIT4;
					end if;
				
				when BIT4 =>
					if clk_out = '1' then
						trans <= data(5);
						state <= BIT5;
					end if;
				
				when BIT5 =>
					if clk_out = '1' then
						trans <= data(6);
						state <= BIT6;
					end if;

				when BIT6 =>
					if clk_out = '1' then
						trans <= data(7);
						state <= BIT7;
					end if;
	
				when BIT7 =>
					if clk_out = '1' then
						state <= STOP;
					end if;
				
				when STOP =>
					if clk_out = '1' then
						state <= IDLE;
						busy <= '0';
					end if;
				
				when others => null;
			end case;
		end if;
	end process transmission;
end architecture str;
		
		
