library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
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
	subtype chip_sec is std_logic_vector (31 downto 0); 
	type mem      is array (15 downto 0) of chip_sec;
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
	signal reg: std_logic_vector(31 downto 0);
	signal reg_i,reg_q : std_logic_vector(15 downto 0);
	begin
	shifter_reg:process(clk,reset)
		begin
		if clk'event and clk ='1' then
			if reset ='1' then reg <= (others => '0');
			elsif Fs='1' then 
				case symbol IS 
					when "0000" => reg<= code(0);
					when "1000" => reg<= code(1);
					when "0100" => reg<= code(2);
					when "1100" => reg<= code(3);
					when "0010" => reg<= code(4);
					when "1010" => reg<= code(5);
					when "0110" => reg<= code(6);
					when "1110" => reg<= code(7);
					when "0001" => reg<= code(8);
					when "1001" => reg<= code(9);
					when "0101" => reg<= code(10);
					when "1101" => reg<= code(11);
					when "0011" => reg<= code(12);
					when "1011" => reg<= code(13);
					when "0111" => reg<= code(14);
					when others => reg<= code(15);
				end case;
				reg_i <= (reg(1),reg(3),reg(5),reg(7),reg(9),reg(11),reg(13),reg(15),reg(17),
							reg(19),reg(21),reg(23),reg(25),reg(27),reg(29),reg(31));
				
				reg_q <= (reg(0),reg(2),reg(4),reg(6),reg(8),reg(10),reg(12),reg(14),reg(16),
							reg(18),reg(20),reg(22),reg(24),reg(26),reg(28),reg(30));
			end if;
			if Fc='1' then
				ich0 <= reg_i(15);
				qch0 <= reg_q(15);
				reg_i(15 downto 1) <= reg_i(14 downto 0);
				reg_q(15 downto 1) <= reg_q(14 downto 0);
			end if;										
		end if;
	end process;                                    
end a_symbol_to_chip;