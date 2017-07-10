library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use work.pack.all;


entity symbol_to_chip is
		port(
			symbol:   in  std_logic_vector(Nbits_symb-1 downto 0);
			chip  :   out std_logic_vector (31 downto 0);
			ich0: 	  out std_logic;
			qch0: 	  out std_logic;
			reset: 	  in  std_logic;
			Fs:       in  std_logic;
			Fc2:       in  std_logic;
			clk:	  in  std_logic
		);
end symbol_to_chip;

architecture a_symbol_to_chip of symbol_to_chip is
	type mem      is array (0 to 15) of std_logic_vector (31 downto 0);
	constant code : mem:= ("11011001110000110101001000101110",
										   "11101101100111000011010100100010",
										   "00101110110110011100001101010010",
										   "00100010111011011001110000110101",
										   "01010010001011101101100111000011",
										   "00110101001000101110110110011100",
										   "11000011010100100010111011011001",
										   "10011100001101010010001011101101",
										   "10001100100101100000011101111011",
										   "10111000110010010110000001110111",
										   "01111011100011001001011000000111",
										   "01110111101110001100100101100000",
										   "00000111011110111000110010010110",
										   "01100000011101111011100011001001",
										   "10010110000001110111101110001100",
										   "11001001011000000111011110111000"
										  );
	begin
	shifter_reg: process(clk,reset)
	  variable reg: std_logic_vector (31 downto 0);
	  variable reversed_symbol : std_logic_vector(Nbits_symb-1 downto 0);
		begin
		if clk'event and clk ='1' then
			if reset ='1' then
			  reg   := (others => '0');
			elsif Fs='1' then
			  reversed_symbol := symbol(3)&symbol(2)&symbol(1)&symbol(0);
			  reg := code(conv_integer(reversed_symbol));
			  chip <= reg;
			end if;
			if Fc2='1' then
				ich0 <= reg(31);
				qch0 <= reg(30);
				reg  := reg(29 downto 0) & "00";
			end if;										
		end if;
	end process;                                    
end a_symbol_to_chip;