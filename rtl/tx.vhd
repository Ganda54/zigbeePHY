library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use work.pack.all;

entity tx is
	port(
		from_mac: in  std_logic;
		ich: 	  out std_logic_vector();
		qch:	  out std_logic_vector();
		reset: 	  in  std_logic;
		clk:	  in  std_logic
	);
end tx;


architecture a_tx of tx is

	component bit_to_symbol is
		port(
			from_mac: in  std_logic;
			symbol:   out std_logic_vector();
			reset: 	  in  std_logic;
			clk:	  in  std_logic
		);
	end component bit_to_symbol;

	component symbol_to_chip is
		port(
			symbol:   in  std_logic_vector();
			ich0: 	  out std_logic;
			qch0: 	  out std_logic;
			reset: 	  in  std_logic;
			clk:	  in  std_logic
		);
	end component symbol_to_chip;

	component shaper is
		port(
			ich0: 	  in  std_logic;
			qch0: 	  in  std_logic;
			ich1:     out std_logic_vector();
			qch1:     out std_logic_vector();
			reset: 	  in  std_logic;
			clk:	  in  std_logic
		);
	end component shaper;
begin


end a_tx;


