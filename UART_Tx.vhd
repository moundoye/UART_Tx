library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity UART_Tx is
port(clk, reset, go : in std_logic;
	 word_tx : in std_logic_vector (7 downto 0);
	 Busy : out std_logic;
	 Serial_Data : out std_logic);
end UART_Tx;

architecture dataflow of UART_Tx is

type state_type is (pending, init_com, sending);
signal state : state_type; 

begin
	
process(clk, reset) is
variable cpt : integer range 0 to 9;
begin
	if(reset = '0') then 
		state <= pending;
		Busy <= '0';
		serial_Data <= '0';
		cpt := 0;
	elsif (clk'event and clk = '1') then 
		case state is
			when  pending =>
						Busy <= '0';
						serial_Data <= '1';
						cpt := 0;
						if (go = '0')	then
							state <= init_com;
						end if;	
			when  init_com =>
						Busy <= '1';
						serial_Data <= '0';
						cpt := 0;
						state <= sending;
			
			when  sending =>
						Busy <= '1';	
						serial_Data <= word_tx(cpt);
						cpt := cpt + 1;
						if(cpt > 7)		then	
							state <= pending;	
						end if;
		
		end case;
	end if;
end process;

end dataflow;

