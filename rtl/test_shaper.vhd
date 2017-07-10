library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_arith.all;
use IEEE.STD_LOGIC_SIGNED.all;
use IEEE.STD_LOGIC_TEXTIO.all;
use STD.TEXTIO.ALL;
use work.pack.all;

entity test_shaper is
end test_shaper;

architecture a_test_shaper of test_shaper is
  signal clk:       std_logic;
  signal reset:     std_logic;
  signal ich0:      std_logic;
  signal qch0:      std_logic;
  signal ich1:      std_logic_vector(Nbits_dac-1 downto 0);
  signal qch1:      std_logic_vector(Nbits_dac-1 downto 0);
  signal Fc2:       std_logic;
  signal Fe:        std_logic;
  signal cpt:       integer := 0; 
  constant period:  time := 4 ns; 
  

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
  shaper_i : shaper
  port map(ich0,qch0,ich1,qch1,reset,Fc2,Fe,clk);

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
Fc2 <= '1' when ((cpt mod 251) =  0  and cpt/=0) else '0';
Fe <= '1' when  ((cpt mod 63 )= 0 and cpt>=251) else '0';


-----------------------------
--Reads input  ich0 from file
-----------------------------
  ich0_reading: process
                  file data : text open read_mode is "output_chips_ich.txt";
                  variable ln: line;
                  variable t:  integer;
                begin
                  wait until Fc2'event and Fc2 = '1';
                  while not endfile(data) loop
                    readline(data, ln);
                    read(ln,t);
                    ich0 <= std_logic(to_unsigned(t, 1)(0));
                   wait until Fc2'event and Fc2 = '1';
                  end loop;
                  Assert false Report "Test completed";
                  wait;
                end process;

-----------------------------
--Reads input  qch0 from file
-----------------------------
 qch0_reading: process
                  file data : text open read_mode is "output_chips_qch.txt";
                  variable ln: line;
                  variable t:  integer;
                begin
                  wait until Fc2'event and Fc2 = '1';
                  while not endfile(data) loop
                    readline(data, ln);
                    read(ln,t);
                    qch0 <= std_logic(to_unsigned(t, 1)(0));
                   wait until Fc2'event and Fc2 = '1';
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
		 wait until Fe'event and Fe= '1';
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
		 wait until Fe'event and Fe= '1';
		 while true loop 
		   write(ln_q1,qch1);
		   writeline(data_q1,ln_q1);
		   wait until Fe'event and Fe = '1';
		 end loop;
		 Assert false Report "Test completed";
		 wait;
	       end process;
end a_test_shaper;