library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use work.pack.all;


entity shaper is
		port(
			ich0: 	  in  std_logic;
			qch0: 	  in  std_logic;
			ich1:     out std_logic_vector(Nbits_dac-1 downto 0);
			qch1:     out std_logic_vector(Nbits_dac-1 downto 0);
			reset: 	  in  std_logic;
			Fc:       in  std_logic;
			Fe:       in  std_logic;
			clk:	  in  std_logic
		);
end shaper;

architecture a_shaper of shaper is

begin
end a_shaper;