library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_SIGNED.all;
use IEEE.STD_LOGIC_TEXTIO.all;
use STD.TEXTIO.ALL;
use work.pack.all;

entity test_symbol_to_chip is
end test_symbol_to_chip;

architecture a_test_symbol_to_chip of test_symbol_to_chip is
  signal clk:       std_logic;
  signal reset:     std_logic;
  signal symbol:    std_logic_vector(Nbits_symb-1 downto 0);
  signal chip  :    std_logic_vector (31 downto 0);
  signal ich0: 	    std_logic;
  signal qch0: 	    std_logic;
  signal Fs:        std_logic;
  signal Fc:        std_logic;
  signal cpt:       integer := 0; 
  constant period:  time := 4 ns; 
  

  component symbol_to_chip is
		port(
			symbol:    in  std_logic_vector(Nbits_symb-1 downto 0);
			chip  :    out std_logic_vector (31 downto 0);
			ich0: 	   out std_logic;
			qch0: 	   out std_logic;
			reset: 	   in  std_logic;
			Fs:        in  std_logic;
			Fc:        in  std_logic;
			clk:	   in  std_logic
		);
  end component;
begin
  symbol_to_chip_i : symbol_to_chip
  port map(symbol,chip,ich0,qch0, reset, Fs, Fc, clk);

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
--Generates signal Fb and Fs
-----------------------------
Fs <= '1' when ((cpt mod 4016) = 0 and cpt/=0) else '0';
Fc <= '1' when ((cpt mod 251) =  0  and cpt>=4016) else '0';


----------------------------------------
--Reads input data from out_symbols.txt
----------------------------------------
 data_reading: process
                  file data : text open read_mode is "output_symbols.txt";
                  variable ln: line;
                  variable v:  std_logic_vector(3 downto 0);
                begin
                  wait until Fs'event and Fs = '1';
                  while not endfile(data) loop
                    readline(data, ln);
                    read(ln,v);
                    symbol <= v;
                   wait until Fs'event and Fs = '1';
                  end loop;
                  Assert false Report "Test completed";
                  wait;
                end process;

-- How about writing ich and qch in the same file ?
----------------------------------
--Write ouput chips  into a file
-----------------------------------
data_writing_ich : process
		 file data_i : text open write_mode is "output_chips_ich.txt";
		 variable ln_i: line;
	        begin 
		 wait until Fc'event and Fc= '1';
		 while true loop 
		   write(ln_i,ich0);
		   writeline(data_i,ln_i);
		   wait until Fc'event and Fc = '1';
		 end loop;
		 Assert false Report "Test completed";
		 wait;
	       end process;
----------------------------------
--Write ouput chips  into a file
-----------------------------------
data_writing_qch : process
		 file data_q : text open write_mode is "output_chips_qch.txt";
		 variable ln_q: line;
	        begin 
		 wait until Fc'event and Fc= '1';
		 while true loop 
		   write(ln_q,qch0);
		   writeline(data_q,ln_q);
		   wait until Fc'event and Fc = '1';
		 end loop;
		 Assert false Report "Test completed";
		 wait;
	       end process;


end a_test_symbol_to_chip;