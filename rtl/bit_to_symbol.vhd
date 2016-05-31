library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
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
	type shift_array is (0 to 3) of std_logic;
	signal reg: shift_array;
begin
	shift_reg: process(clk, reset)
			 begin
				if clk'event and clk = '1' then
					if reset = '1' then
						reg <= (others => '0');
					elsif Fb = '1' then
						reg(3 downto 1) <= reg(2 downto 0);
						reg(0) < = from_mac;
					end if;
					if Fs = '1' then
						symbol <= reg;
					end if;
				end if;
			end process;
end a_bit_to_symbol;