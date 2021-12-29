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
  signal data_from_fir            : std_logic_vector(7 downto 0);
  signal validation_from_receiver : std_logic;
  signal validation_from_fir      : std_logic;
  signal busy                     : std_logic;
  --signal uart_tx        : std_logic; --idem commento qui sopra


  component uart_transmitter is
    port (
      clock           : in  std_logic;
      data_valid      : in  std_logic;
      data_to_send    : in  std_logic_vector(7 downto 0);
      uart_tx         : out std_logic;
      busy            : out std_logic);
  end component uart_transmitter;

  component uart_receiver is
    port (
      clock           : in  std_logic;
      uart_rx         : in  std_logic;
      received_data   : out std_logic_vector(7 downto 0);
      valid           : out std_logic);
  end component uart_receiver;

  component fir_filter is
    port
    (
        -- clock and validation i/o
        clock     : in std_logic;
        valid_in  : in std_logic;
        valid_out : out std_logic;

        -- data i/o
        data_input     : in  std_logic_vector(7 downto 0);
        data_output    : out std_logic_vector(7 downto 0)
    );
  end component fir_filter;

begin 

  receiver: uart_receiver
    port map (
      clock           => CLK100MHZ,
      uart_rx         => uart_txd_in,
      valid           => validation_from_receiver,
      received_data   => data_from_receiver);

  filter : fir_filter
    port map (
      clock => CLK100MHZ,
      valid_in        => validation_from_receiver,
      valid_out       => validation_from_fir,
      data_input      => data_from_receiver,
      data_output     => data_from_fir);

  transmitter : uart_transmitter
    port map (
      clock           => CLK100MHZ,
      data_valid      => validation_from_fir,
      data_to_send    => data_from_fir,
      busy            => busy,
      uart_tx         => uart_rxd_out);

end architecture str;