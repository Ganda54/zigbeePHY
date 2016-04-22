library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use work.pack.all;
use work.Zcomponents.all;

------------------------------------------------------------
-- zigbee transmitter
-- Authors: A & S Ouedraogo
------------------------------------------------------------
entity tx is
	port(
		from_mac: in  std_logic;
		ich: 	  out std_logic_vector(Nbits_dac-1 downto 0);
		qch:	  out std_logic_vector(Nbits_dac-1 downto 0);
		Fb:       in  std_logic;
		Fe:       in  std_logic;
		reset: 	  in  std_logic;
		clk:	  in  std_logic
	);
end tx;


architecture a_tx of tx is

	
begin
U1 : bit_to_symbol  PORT MAP();
U2 : symbol_to_chip PORT MAP();
U3 : shaper PORT MAP();

end a_tx;


