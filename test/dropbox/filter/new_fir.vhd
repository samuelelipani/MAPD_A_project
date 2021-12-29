library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-----------------------------------
entity fir_filter is
	port(
		--clock and validation i/o
		clock     : in std_logic;
		valid_in  : in std_logic;
		valid_out : out std_logic;
		
		--data i/o
		data_input  : in std_logic_vector(7 downto 0);
		data_output : out std_logic_vector(7 downto 0));
end entity fir_filter;
-----------------------------------------------------------------
architecture str of fir_filter is

	--type definition (they are all matrices)
	type buffer_t is array (0 to 7) of signed (7 downto 0);--(n1-1 downto 0)
	type coeff_t  is array (0 to 7) of signed (7 downto 0);--(n2-1 downto 0)
	type mult_t   is array (0 to 7) of signed (15 downto 0);--(n1+n2-1 downto 0)
	type add0_t   is array (0 to 3) of signed (16 downto 0);--(n1+n2 downto 0)
	type add1_t   is array (0 to 1) of signed (17 downto 0);--(n1+n2+1 downto 0)
	
	--signals initialized to '0'
	signal buffer_s : buffer_t := (others => (others => '0'));
	signal coeff_s  : coeff_t  := (others => (others => '0'));
	signal mult_s   : mult_t   := (others => (others => '0'));
	signal add0_s   : add0_t   := (others => (others => '0'));
	signal add1_s   : add1_t   := (others => (others => '0'));
	signal add2_s   : signed(18 downto 0) := (others => '0');

	--signals
  	signal val_comp : std_logic := '0';
  	signal output_s : std_logic_vector (7 downto 0) := (others => '0');

begin


	upload : process(data_input)
	begin
			
				buffer_s   <= signed(data_input)&buffer_s(0 to buffer_s'length-2);
				if buffer_s(7) /= "00000000" then
					val_comp <= '1';
				end if;
	
	end process upload;
	
	filter : process(clock, val_comp)
	begin
	
		if rising_edge(clock) then
	
			if val_comp = '1' then
	
				--assign coefficients
				coeff_s(0) <= to_signed(4,8);--X"B2";
				coeff_s(1) <= to_signed(15,8);--X"01";
				coeff_s(2) <= to_signed(42,8);--X"ff";
				coeff_s(3) <= to_signed(65,8);--X"ff";
				coeff_s(4) <= to_signed(65,8);--X"B2";
				coeff_s(5) <= to_signed(42,8);--X"01";
				coeff_s(6) <= to_signed(15,8);--X"ff";
				coeff_s(7) <= to_signed(4,8);--X"ff";
				
				
				--multiplication
				mult_s(0) <= buffer_s(0)*coeff_s(0);
				mult_s(1) <= buffer_s(1)*coeff_s(1);
				mult_s(2) <= buffer_s(2)*coeff_s(2);
				mult_s(3) <= buffer_s(3)*coeff_s(3);
				mult_s(4) <= buffer_s(4)*coeff_s(4);
				mult_s(5) <= buffer_s(5)*coeff_s(5);
				mult_s(6) <= buffer_s(6)*coeff_s(6);
				mult_s(7) <= buffer_s(7)*coeff_s(7);
				
				
				--first addition(17 bit)
				add0_s(0) <= resize(mult_s(0),17)+resize(mult_s(1),17);
				add0_s(1) <= resize(mult_s(2),17)+resize(mult_s(3),17);
				add0_s(2) <= resize(mult_s(4),17)+resize(mult_s(5),17);
				add0_s(3) <= resize(mult_s(6),17)+resize(mult_s(7),17);
				
				--second addition
				add1_s(0) <= resize(add0_s(0),18)+resize(add0_s(1),18);
				add1_s(1) <= resize(add0_s(2),18)+resize(add0_s(3),18);
				
				
				--final addition
				add2_s <= resize(add1_s(0),19)+resize(add1_s(1),19);
				
				
				--set output value
				output_s <= std_logic_vector(add2_s(18)&add2_s(14 downto 8));
				
				--computation ready
				if output_s /= "00000000" then
					data_output <= output_s;
					valid_out <= '1';
				else 
					valid_out <= '0';
				end if;
		
			end if;
		end if;
	end process filter;
	
	
end architecture str;















