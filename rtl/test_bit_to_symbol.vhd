library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_SIGNED.all;
use IEEE.STD_LOGIC_TEXTIO.all;
use STD.TEXTIO.ALL;
use work.pack.all;

entity test_bit_to_symbol is
end test_bit_to_symbol;


architecture a_test_bit_to_symbol of test_bit_to_symbol is
  signal clk:       std_logic;
  signal reset:     std_logic;
  signal from_mac : std_logic;
  signal symbol:    std_logic_vector(Nbits_symb-1 downto 0):="0000";
  signal Fb:        std_logic;
  signal Fs:        std_logic;
  signal cpt:       integer := 0; 
  constant period:  time := 62.5 ns; 
  

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
begin
  bit_to_symbol_i : bit_to_symbol
  port map(from_mac, symbol, reset, Fb, Fs, clk);

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
              wait until clk'event and clk = '1' and reset = '0'; -- should not be done in VHDL 
               cpt <= cpt+1;
              end process;
-----------------------------
--Generates signal Fb and Fs
-----------------------------
Fb <= '1' when ((cpt mod 64) = 0) else '0';
Fs <= '1' when ((cpt mod 256) = 0) else '0';


-----------------------------
--Reads input data from file
-----------------------------
  data_reading: process
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
--Write ouput symbols into a file
-----------------------------------

data_writing : process
		 file data : text open write_mode is "output_symbols.txt";
		 variable ln: line;
	        begin 
		 wait until Fs'event and Fs= '1';
		 while true loop 
		   write(ln,symbol);
		   writeline(data,ln);
		   wait until Fs'event and Fs = '1';
		 end loop;
		 Assert false Report "Test completed";
		 wait;
	       end process;
end a_test_bit_to_symbol;