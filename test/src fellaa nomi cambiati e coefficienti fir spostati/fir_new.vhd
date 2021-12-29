library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--------------------------------------------------------------------
entity fir_filter is
port (
        clock  : in  std_logic;
        valid_in : in  std_logic; -- data valid in
        valid_out : out std_logic; -- data valid out

        -- data i/o
        data_input : in  std_logic_vector(7 downto 0);
        data_output : out std_logic_vector(7 downto 0));
end fir_filter;
--------------------------------------------------------------------
architecture str of fir_filter is

        -- type declaration (they are all matrices)
        type buffer_t   is array (0 to 7) of signed(7    downto 0);
        type coeff_t    is array (0 to 7) of signed(7    downto 0);
        type mult_t     is array (0 to 7) of signed(15   downto 0);
        type add0_t    is array (0 to 3) of signed(15+1 downto 0);
        type add1_t    is array (0 to 1) of signed(15+2 downto 0);

        -- signals initialized to '0'
        signal buffer_s : buffer_t := (others => (others => '0'));
        signal coeff_s  : coeff_t  := (others => (others => '0'));
        signal mult_s   : mult_t   := (others => (others => '0'));
        signal add0_s  : add0_t  := (others => (others => '0'));
        signal add1_s  : add1_t  := (others => (others => '0'));
        signal add2_s  : signed(15+3 downto 0) := (others => '0');
        signal valid_out_s : std_logic := '0';
--------------------------------------------------------------------
begin
        input_p : process (valid_in, clock)
        begin

                if(rising_edge(clock)) then  -- inizialization

                        if(valid_in='1') then
                                -- assign coefficients
                                buffer_s   <= to_signed(data_input)&buffer_s(0 to buffer_s'length-2);
                                coeff_s(0) <= to_signed(4,8);
                                coeff_s(1) <= to_signed(15,8);
                                coeff_s(2) <= to_signed(42,8);
                                coeff_s(3) <= to_signed(65,8);
                                coeff_s(4) <= to_signed(65,8);
                                coeff_s(5) <= to_signed(42,8);
                                coeff_s(6) <= to_signed(15,8);
                                coeff_s(7) <= to_signed(4,8);

                        --else
                        --      valid_out_s <= '0';

                        end if;

                end if;

        end process input_p;

        mult_p : process (valid_in, clock)
        begin
                if rising_edge(clock) then

                        --if(valid_in='0') then -- reset
                        --      mult_s <= (others =>(others => '0'));

                        if(valid_in='1') then 
                        -- multiplication (8+8=16 bits)
                                for i in 0 to 7 loop
                                        mult_s(i) <= buffer_s(i)*coeff_s(i);
                                end loop;
                        end if;

                end if;

        end process mult_p;

        add0_p : process (valid_in, clock)
        begin
                if rising_edge(clock) then

                        --if(valid_in='0') then -- reset
                        --      add0_s <= (others =>(others => '0'));
                        --      valid_out <= '0';

                        if(valid_in='1') then 
                        -- first addition (16+1=17 bits)
                                for i in 0 to 3 loop
                                        add0_s(i) <= resize(mult_s(i*2),17) + resize(mult_s(i*2+1),17); -- i.e. 01, 23, 45, 67
                                end loop;
                        end if;

                end if;
        end process add0_p;

        add1_p : process (valid_in, clock)
        begin
                if rising_edge(clock) then

                        --if(valid_in='0') then -- reset
                        --      add1_s <= (others =>(others => '0'));
                        --      valid_out <= '0';

                        if(valid_in='1') then 
                        -- second addition (17+1=18 bits)
                                for i in 0 to 1 loop
                                        add1_s(i) <= resize(add0_s(i*2),18) + resize(add0_s(i*2+1),18); -- i.e. 01, 23
                                end loop;
                        end if;

                end if;
        end process add1_p;

        add2_p : process (valid_in, clock)
        begin
                if rising_edge(clock) then
                        --if(valid_in='0') then -- reset
                        --      add2_s <= (others => '0');
                        --      valid_out <= '0';
                        if(valid_in='1') then 
                        -- third (final) (18+1=19 bits)
                                add2_s <= resize(add1_s(0),19) + resize(add1_s(1),19);
                        end if;
                end if;
        end process add2_p;

        output_p : process (valid_in, clock)
        begin
                if rising_edge(clock) then
                        if(valid_in='0') then
                                valid_out_s <= '0';
                        --      data_output <= (others => '0');


                        elsif(valid_in='1') then

                                --data_output <= std_logic_vector(add2_s(18 downto 11));

                                data_output <= std_logic_vector(add2_s(18)&add2_s(14 downto 8)); --here we keep only the leftmost 144              
                                -- i.e. most sig. bit and 7 others from the middle as a compromise to keep some of the smallest
                                valid_out_s <= '1';

                        end if;
                valid_out <= valid_out_s;
                end if;
        end process output_p;

end str;