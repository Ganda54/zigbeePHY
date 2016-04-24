library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use work.pack.all;


entity symbol_to_chip is
		port(
			symbol:   in  std_logic_vector(Nbits_symb-1 downto 0);
			ich0: 	  out std_logic;
			qch0: 	  out std_logic;
			reset: 	  in  std_logic;
			Fs:       in  std_logic;
			Fc:       in  std_logic;
			clk:	  in  std_logic
		);
end symbol_to_chip;

architecture a_symbol_to_chip of symbol_to_chip is

begin
end a_symbol_to_chip;