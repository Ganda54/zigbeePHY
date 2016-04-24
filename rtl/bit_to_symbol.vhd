library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use work.pack.all;


entity bit_to_symbol is
		port(
			from_mac: in  std_logic;
			symbol:   out std_logic_vector(Nbits_symb-1 downto 0);
			reset: 	  in  std_logic;
			Fb:       in  std_logic;
			Fs:       in  std_logic;
			clk:	  in  std_logic
		);
end bit_to_symbol;

architecture a_bit_to_symbol of bit_to_symbol is

begin
end a_bit_to_symbol;