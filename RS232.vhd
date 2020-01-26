library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity RS232 is
port(clock, reset, go : in std_logic;
	 word_tx : out std_logic_vector (7 downto 0);
	 Busy : out std_logic;
	 clk_sampling : out std_logic;
	 Serial_Data : out std_logic);
end RS232;

architecture dataflow of RS232 is

component div_horloge_gen is
generic (debit : integer := 20);
port(clk, reset, start : in std_logic;
	 horloge_gen : buffer std_logic);
end component;


component UART_Tx is
port(clk, reset, go : in std_logic;
	 word_tx : in std_logic_vector (7 downto 0);
	 Busy : out std_logic;
	 Serial_Data : out std_logic);
end component;

constant word : std_logic_vector (7 downto 0) := "01110101";
signal sig_clk_txx : std_logic;

begin

clock_SigTap : div_horloge_gen generic map (230400) port map (clock, reset, '1', sig_clk_txx);

--horloge_tx : div_horloge_gen generic map (14400) port map (clock, reset, '1', sig_clk_tx);

--horloge_txx : div_horloge_gen generic map (14400) port map (clock, reset, '1', sig_clk_txx);

UART_Transmission : UART_Tx port map(sig_clk_txx, reset, go, word, Busy, Serial_Data);

word_tx <= word;
clk_sampling <= sig_clk_txx;
--clock <= sig_clk; 

end dataflow;