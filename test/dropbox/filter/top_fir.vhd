library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-----------------------------------
entity top is
	port (
		clock  : in std_logic;
		input  : in std_logic;
		busy   : out std_logic;
		output : out std_logic);
end entity top;
-----------------------------------
architecture str of top is

	signal validation_from_receiver : std_logic;
	signal validation_from_fir : std_logic;
	signal data_from_receiver : std_logic_vector (7 downto 0);
	signal data_from_fir : std_logic_vector (7 downto 0);
	signal data_output : std_logic;
	
	
	component uart_transmitter is
		port(
			clk_in  : in std_logic;
			valid   : in std_logic;
			data    : in std_logic_vector (7 downto 0);
			busy    : out std_logic;
			trans   : out std_logic);
	end component uart_transmitter;
	
	component uart_receiver is
		port(
			clock         : in std_logic;
			uart_rx       : in std_logic;
			valid         : out std_logic;
			data          : out std_logic_vector(7 downto 0));
	end component uart_receiver;
	
	component fir_filter is
	port(
		--clock and validation i/o
		clock     : in std_logic;
		valid_in  : in std_logic;
		valid_out : out std_logic;

		--data i/o
		data_input  : in std_logic_vector(7 downto 0);
		data_output : out std_logic_vector(7 downto 0));
	end component fir_filter;
	
begin

	receiver : uart_receiver
	port map(
		clock => clock,
		uart_rx => input,
		valid => validation_from_receiver,
		data => data_from_receiver);
		
	filter : fir_filter
	port map(
		clock => clock,
		valid_in => validation_from_receiver,
		valid_out => validation_from_fir,
		data_input => data_from_receiver,
		data_output => data_from_fir);
		
	transmitter : uart_transmitter
	port map(
		clk_in => clock,
		valid => validation_from_fir,
		data => data_from_fir,
		busy => busy,
		trans => output);
		
end architecture str;
		
		
	
	
	
	
	
	
	
	
		
	
	
	

