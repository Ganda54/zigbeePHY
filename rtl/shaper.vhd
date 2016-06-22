library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
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
	type ech is std_logic_vector (4 downto 0);
	type reg is array (3 downto 0) of ech;
	signal ich0_1,qch0_1: reg;

	begin
		ech_symbol:process(clk)
			begin
				if clk'event and clk='1'
					if reset='1' then 
						ich0_1(3 downto 0) <= (others => 0);
						qch0_1(3 downto 0) <= (others => 0);
					elsif Fc='1' then
						case ich0 is 
							when '1' =>
								ich0_1(0) <= std_logic_vector(to_signed(0, 5)),
								ich0_1(1) <= std_logic_vector(to_signed(8, 5)),
								ich0_1(2) <= std_logic_vector(to_signed(15, 5)),
								ich0_1(3) <= std_logic_vector(to_signed(8, 5));
							when '0' =>
								ich0_1(0) <= std_logic_vector(to_signed(0, 5)),
								ich0_1(1) <= std_logic_vector(to_signed(-8, 5)),
								ich0_1(2) <= std_logic_vector(to_signed(-15, 5)),
								ich0_1(3) <= std_logic_vector(to_signed(-8, 5));
							when others null
						end case;
						
						case qch0 is 
							when '1' =>
								qch0_1(0) <= std_logic_vector(to_signed(0, 5)),
								qch0_1(1) <= std_logic_vector(to_signed(8, 5)),
								qch0_1(2) <= std_logic_vector(to_signed(15, 5)),
								qch0_1(3) <= std_logic_vector(to_signed(8, 5));
							when '0' =>
								qch0_1(0) <= std_logic_vector(to_signed(0, 5)),
								qch0_1(1) <= std_logic_vector(to_signed(-8, 5)),
								qch0_1(2) <= std_logic_vector(to_signed(-15, 5)),
								qch0_1(3) <= std_logic_vector(to_signed(-8, 5));
							when others null
						end case;
					end if;
					if Fe='1' then
						ich1 <= ich0_1(0);
						qch1 <= qch0_1(0);
						ich0_1(2 downto 0) <= ich0_1(3 downto 1);
						qch0_1(2 downto 0) <= qch0_1(3 downto 1);
					end if;
						
								
end a_shaper;