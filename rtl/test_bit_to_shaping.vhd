library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_SIGNED.all;
use IEEE.STD_LOGIC_TEXTIO.all;
use STD.TEXTIO.ALL;
use work.pack.all;

entity test_bit_to_shaping is
end test_bit_to_shaping;

architecture a_test_bit_to_shaping of test_bit_to_shaping is
  signal clk:       std_logic;
  signal from_mac : std_logic:='X';
  signal reset:     std_logic;
  signal symbol:    std_logic_vector(Nbits_symb-1 downto 0);
  signal chip  :    std_logic_vector (31 downto 0);
  signal ich0: 	    std_logic;
  signal qch0: 	    std_logic;
  signal ich1: 	    std_logic_vector(Nbits_dac-1 downto 0);
  signal qch1: 	    std_logic_vector(Nbits_dac-1 downto 0);
  signal Fb:        std_logic;
  signal Fs:        std_logic;
  signal Fc2:       std_logic;
  signal Fe:        std_logic;
  signal cpt:       integer := 0; 
  constant period:  time := 4 ns; 
  
  component bit_to_symbol is
		port(
			from_mac: in  std_logic;
			symbol:   out std_logic_vector(Nbits_symb-1 downto 0);
			reset: 	  in  std_logic;
			Fb:       in  std_logic;
			Fs:       in  std_logic;
			clk:	     in  std_logic
		);
  end component;

  component symbol_to_chip is
		port(
			symbol:    in  std_logic_vector(Nbits_symb-1 downto 0);
			chip  :    out std_logic_vector (31 downto 0);
			ich0: 	   out std_logic;
			qch0: 	   out std_logic;
			reset: 	   in  std_logic;
			Fs:        in  std_logic;
			Fc2:        in  std_logic;
			clk:	   in  std_logic
		);
  end component;
  

  component shaper is
		port(
			ich0: 	  in  std_logic;
			qch0: 	  in  std_logic;
			ich1:     out std_logic_vector(Nbits_dac-1 downto 0);
			qch1:     out std_logic_vector(Nbits_dac-1 downto 0);
			reset: 	  in  std_logic;
			Fc2:      in  std_logic;
			Fe:       in  std_logic;
			clk:	  in  std_logic
		);
  end component;

	
begin
  bit_to_symbol_i : bit_to_symbol
  port map(from_mac, symbol, reset, Fb, Fs, clk);

  symbol_to_chip_i : symbol_to_chip
  port map(symbol,chip,ich0,qch0, reset, Fs, Fc2, clk);

  shaper_i : shaper
  port map(ich0,qch0,ich1,qch1, reset,Fc2,Fe, clk);


----------------------------
--Generates reset signal
----------------------------
  reset_gen: process
             begin
               reset <= '1';
               wait for 10 ns;
               while true loop
               reset <= '0';
               wait for 150 ns;
               end loop;
             end process;
----------------------------
--Generates clock signal
----------------------------
  clk_gen: process
           begin
               clk <= '0';
               wait for 0 ns;
               while true loop
               clk <= '1';
               wait for period/2;
               clk <= '0';
               wait for period/2;
               end loop;
           end process;
-----------------------------
--Increases cpt counter value
-----------------------------
  div_freq: process
            begin
              wait until clk'event and clk = '1' and reset = '0';
               cpt <= cpt+1;
              end process;
-----------------------------
--Generates signal Fb , Fs and Fc2
-----------------------------
Fb <= '1' when ((cpt mod 1000) = 0 and cpt/=0) else '0';
Fs <= '1' when ((cpt mod 4016) = 0 and cpt/=0) else '0';
Fc2 <= '1' when ((cpt mod 251) =  0  and cpt>=8032) else '0';
Fe <= '1' when  ((cpt mod 63 )= 0 and cpt>=251) else '0';


-----------------------------
--Reads input bits data from file
-----------------------------
  bits_reading: process
                  file data : text open read_mode is "input_bits.txt";
                  variable ln: line;
                  variable t:  integer;
                begin
                  wait until Fb'event and Fb = '1';
                  while not endfile(data) loop
                    readline(data, ln);
                    read(ln,t);
                    from_mac <= std_logic(to_unsigned(t, 1)(0));
                   wait until Fb'event and Fb = '1';
                  end loop;
                  Assert false Report "Test completed";
                  wait;
                end process;

----------------------------------
--Write ouput sample ich1  into a file
-----------------------------------
writing_ich1 : process
		 file data_i1 : text open write_mode is "output_chips_ich1.txt";
		 variable ln_i1: line;
	        begin 
		 wait until Fe'event and Fe= '1' and cpt > 252;
		 while true loop 
		   write(ln_i1,ich1);
		   writeline(data_i1,ln_i1);
		   wait until Fe'event and Fe = '1';
		 end loop;
		 Assert false Report "Test completed";
		 wait;
	       end process;

----------------------------------
--Write ouput sample ich1  into a file
-----------------------------------
writing_qch1 : process
		 file data_q1 : text open write_mode is "output_chips_qch1.txt";
		 variable ln_q1: line;
	        begin 
		 wait until Fe'event and Fe= '1' and cpt > 252;
		 while true loop 
		   write(ln_q1,qch1);
		   writeline(data_q1,ln_q1);
		   wait until Fe'event and Fe = '1';
		 end loop;
		 Assert false Report "Test completed";
		 wait;
	       end process;

end a_test_bit_to_shaping;