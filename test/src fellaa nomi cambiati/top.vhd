library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top is

  port (
    CLK100MHZ    : in  std_logic;
    uart_txd_in  : in  std_logic;
    uart_rxd_out : out std_logic);

end entity top;

architecture str of top is
  --signal clock          : std_logic; --spero vada bene anche senza, sembrano collegati direttamente al CLK100MHZ
  signal data_from_receiver       : std_logic_vector(7 downto 0);
  signal data_from_fir  : std_logic_vector(7 downto 0);
  signal validation_from_receiver : std_logic;
  signal validation_from_fir : std_logic;
  signal busy           : std_logic;
  --signal uart_tx        : std_logic; --idem commento qui sopra


  -- constant signals: value of the coefficients computed as python_coef*2^8 and then kept the integer part
  signal i_rstb    : std_logic;
  signal i_co_0 : std_logic_vector(7 downto 0) := std_logic_vector(to_signed(4,8));--X"B2";
  signal i_co_1 : std_logic_vector(7 downto 0) := std_logic_vector(to_signed(15,8));--X"01";
  signal i_co_2 : std_logic_vector(7 downto 0) := std_logic_vector(to_signed(42,8));--X"ff";
  signal i_co_3 : std_logic_vector(7 downto 0) := std_logic_vector(to_signed(65,8));--X"ff";
  signal i_co_4 : std_logic_vector(7 downto 0) := std_logic_vector(to_signed(65,8));--X"B2";
  signal i_co_5 : std_logic_vector(7 downto 0) := std_logic_vector(to_signed(42,8));--X"01";
  signal i_co_6 : std_logic_vector(7 downto 0) := std_logic_vector(to_signed(15,8));--X"ff";
  signal i_co_7 : std_logic_vector(7 downto 0) := std_logic_vector(to_signed(4,8));--X"ff";


  component uart_transmitter is
    port (
      clock           : in  std_logic;
      data_valid      : in  std_logic;
      data_to_send    : in  std_logic_vector(7 downto 0);
      uart_tx       : out std_logic;
      busy          : out std_logic);
  end component uart_transmitter;

  component uart_receiver is
    port (
      clock           : in  std_logic;
      uart_rx       : in  std_logic;
      received_data : out std_logic_vector(7 downto 0);
      valid         : out std_logic);
  end component uart_receiver;

  component fir_filter is
    port
    (
        -- clock and validation i/o
        clock     : in std_logic;
        valid_in    : in std_logic;
        valid_out : out std_logic;

        i_co_0 : in std_logic_vector(7 downto 0);
        i_co_1 : in std_logic_vector(7 downto 0);
        i_co_2 : in std_logic_vector(7 downto 0);
        i_co_3 : in std_logic_vector(7 downto 0);
        i_co_4 : in std_logic_vector(7 downto 0);
        i_co_5 : in std_logic_vector(7 downto 0);
        i_co_6 : in std_logic_vector(7 downto 0);
        i_co_7 : in std_logic_vector(7 downto 0);

        -- data i/o
        data_input    : in std_logic_vector(7 downto 0);
        data_output    : out std_logic_vector(7 downto 0)
    );
  end component fir_filter;

begin 

  receiver: uart_receiver
    port map (
      clock        => CLK100MHZ,
      uart_rx    => uart_txd_in,
      valid      => validation_from_receiver,
      received_data   => data_from_receiver);

  filter : fir_filter
    port map (
      clock => CLK100MHZ,
      valid_in  => validation_from_receiver,
      valid_out => validation_from_fir,
      i_co_0 => i_co_0,
      i_co_1 => i_co_1,
      i_co_2 => i_co_2,
      i_co_3 => i_co_3,
      i_co_4 => i_co_4,
      i_co_5 => i_co_5,
      i_co_6 => i_co_6,
      i_co_7 => i_co_7,
      data_input => data_from_receiver,
      data_output => data_from_fir);

  transmitter : uart_transmitter
    port map (
      clock           => CLK100MHZ,
      data_valid      => validation_from_fir,
      data_to_send    => data_from_fir,
      busy            => busy,
      uart_tx         => uart_rxd_out);


end architecture str;