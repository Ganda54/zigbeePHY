library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use work.pack.all;

entity shaper is
		port(
			ich0: 	  in  std_logic;
			qch0: 	  in  std_logic;
			ich1:     out std_logic_vector(Nbits_dac-1 downto 0);
			qch1:     out std_logic_vector(Nbits_dac-1 downto 0);
			reset: 	  in  std_logic;
			Fc2:       in  std_logic;
			Fe:       in  std_logic;
			clk:	  in  std_logic
		);
end shaper;

architecture a_shaper of shaper is
	type reg is array (3 downto 0) of std_logic_vector (4 downto 0);
	signal ich0_1,qch0_1: reg;

-- how could we create a 2 array subtype of reg in oder to save memory ? i tried but Vhdl seems to hate mixing various type even if it makes sense
	signal delay :reg:= (std_logic_vector(to_signed(0, 5)),
					std_logic_vector(to_signed(0, 5)),
					std_logic_vector(to_signed(0, 5)),
					std_logic_vector(to_signed(0, 5))
				  );


	constant pos_sine : reg := (std_logic_vector(to_signed(0, 5)),
					std_logic_vector(to_signed(8, 5)),
					std_logic_vector(to_signed(15, 5)),
					std_logic_vector(to_signed(8, 5))

	);
	
	constant neg_sine : reg := (std_logic_vector(to_signed(0, 5)),
					std_logic_vector(to_signed(-8, 5)),
					std_logic_vector(to_signed(-15, 5)),
					std_logic_vector(to_signed(-8, 5))

	);

	begin
		ech_symbol:process(clk)
			begin
				if clk'event and clk='1' then
					if reset='1' then 
						ich0_1(3 downto 0) <= (others => std_logic_vector(to_signed(0, 5)));
						qch0_1(3 downto 0) <= (others => std_logic_vector(to_signed(0, 5)));
					elsif Fc2='1' then
						case ich0 is 
							when '1' =>
								ich0_1 <= pos_sine;
							when '0' =>
								ich0_1 <= neg_sine;
							when others => null;
						end case;
						
						case qch0 is 
							when '1' =>
								qch0_1(3 downto 2) <= delay(1 downto 0);
								qch0_1(1 downto 0) <= pos_sine(3 downto 2);
								delay(1 downto 0)  <= pos_sine(1 downto 0);
							when '0' =>
								qch0_1(3 downto 2) <= delay(1 downto 0);
								qch0_1(1 downto 0) <= neg_sine(3 downto 2);
								delay(1 downto 0)  <= neg_sine(1 downto 0);
							when others => null;
						end case;
					end if;
					if Fe='1' then
						ich1 <= ich0_1(3);
						qch1 <= qch0_1(3);
						ich0_1(3 downto 1) <= ich0_1(2 downto 0);
						qch0_1(3 downto 1) <= qch0_1(2 downto 0);
					end if;
				end if;	
		end process;						
end a_shaper;