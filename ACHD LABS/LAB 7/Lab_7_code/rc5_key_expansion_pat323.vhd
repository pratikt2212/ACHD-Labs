library work;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.rc5Package.all;



entity rc5_key_expansion is
    Port ( 
	     clear : in STD_LOGIC;
		  clock	: in STD_LOGIC;  								
		  ukey: in std_logic_vector(127 downto 0);
        key_in	: in STD_LOGIC;
		  s_key: out S_ARRAY
		  );
end rc5_key_expansion;

architecture Behavioral of rc5_key_expansion is


	signal key_rdy : STD_LOGIC;

SIGNAL  a_reg	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL  b_reg	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL  a_tmp1	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL  a_tmp2	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL  ab_tmp	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL  b_tmp1	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL  b_tmp2	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL  l_arr	: L_ARRAY;
SIGNAL  s_arr_tmp: S_ARRAY;

SIGNAL  i_cnt	: INTEGER RANGE 0 TO 25; 
SIGNAL  j_cnt	: INTEGER RANGE 0 TO 3;  
SIGNAL  k_cnt	: INTEGER RANGE 0 TO 77;

TYPE     StateType IS (ST_IDLE, ST_KEY_INIT, ST_KEY_EXP, ST_READY);
SIGNAL	state : StateType;


begin

a_tmp1<=s_arr_tmp(i_cnt)+a_reg+b_reg;

a_tmp2<=a_tmp1(28 DOWNTO 0) & a_tmp1(31 DOWNTO 29); 

ab_tmp<=a_tmp2+b_reg;
b_tmp1<=l_arr(j_cnt)+ab_tmp;
WITH ab_tmp(4 DOWNTO 0) SELECT
b_tmp2<= 
   b_tmp1(30 DOWNTO 0) & b_tmp1(31) WHEN "00001",
   b_tmp1(29 DOWNTO 0) & b_tmp1(31 DOWNTO 30) WHEN "00010",
   b_tmp1(28 DOWNTO 0) & b_tmp1(31 DOWNTO 29) WHEN "00011",
   b_tmp1(27 DOWNTO 0) & b_tmp1(31 DOWNTO 28) WHEN"00100",
	b_tmp1(26 DOWNTO 0) & b_tmp1(31 DOWNTO 27) WHEN"00101",
	b_tmp1(25 DOWNTO 0) & b_tmp1(31 DOWNTO 26) WHEN"00110",
	b_tmp1(24 DOWNTO 0) & b_tmp1(31 DOWNTO 25) WHEN"00111",
	b_tmp1(23 DOWNTO 0) & b_tmp1(31 DOWNTO 24) WHEN"01000",
	b_tmp1(22 DOWNTO 0) & b_tmp1(31 DOWNTO 23) WHEN"01001",
	b_tmp1(21 DOWNTO 0) & b_tmp1(31 DOWNTO 22) WHEN"01010",
	b_tmp1(20 DOWNTO 0) & b_tmp1(31 DOWNTO 21) WHEN"01011",
	b_tmp1(19 DOWNTO 0) & b_tmp1(31 DOWNTO 20) WHEN"01100",
	b_tmp1(18 DOWNTO 0) & b_tmp1(31 DOWNTO 19) WHEN"01101",
	b_tmp1(17 DOWNTO 0) & b_tmp1(31 DOWNTO 18) WHEN"01110",
	b_tmp1(16 DOWNTO 0) & b_tmp1(31 DOWNTO 17) WHEN"01111",
	b_tmp1(15 DOWNTO 0) & b_tmp1(31 DOWNTO 16) WHEN"10000",
	b_tmp1(14 DOWNTO 0) & b_tmp1(31 DOWNTO 15) WHEN"10001",
	b_tmp1(13 DOWNTO 0) & b_tmp1(31 DOWNTO 14) WHEN"10010",
	b_tmp1(12 DOWNTO 0) & b_tmp1(31 DOWNTO 13) WHEN"10011",
	b_tmp1(11 DOWNTO 0) & b_tmp1(31 DOWNTO 12) WHEN"10100",
	b_tmp1(10 DOWNTO 0) & b_tmp1(31 DOWNTO 11) WHEN"10101",
	b_tmp1(9 DOWNTO 0) & b_tmp1(31 DOWNTO 10) WHEN"10110",
	b_tmp1(8 DOWNTO 0) & b_tmp1(31 DOWNTO 9) WHEN"10111", 
	b_tmp1(7 DOWNTO 0) & b_tmp1(31 DOWNTO 8) WHEN"11000",
	b_tmp1(6 DOWNTO 0) & b_tmp1(31 DOWNTO 7) WHEN"11001",
	b_tmp1(5 DOWNTO 0) & b_tmp1(31 DOWNTO 6) WHEN"11010",
	b_tmp1(4 DOWNTO 0) & b_tmp1(31 DOWNTO 5) WHEN"11011",
	b_tmp1(3 DOWNTO 0) & b_tmp1(31 DOWNTO 4) WHEN"11100",
	b_tmp1(2 DOWNTO 0) & b_tmp1(31 DOWNTO 3) WHEN"11101",
	b_tmp1(1 DOWNTO 0) & b_tmp1(31 DOWNTO 2) WHEN"11110",
   b_tmp1(0) & b_tmp1(31 DOWNTO 1)   WHEN "11111",
   b_tmp1   WHEN OTHERS;


PROCESS(clear, clock)	
     BEGIN
       IF(clear='0') THEN
           state<=ST_IDLE;
       ELSIF(clock'EVENT AND clock='1') THEN
           CASE state IS
              WHEN ST_IDLE=>
                  IF(key_in='1') THEN  state<=ST_KEY_INIT;   END IF;
              WHEN ST_KEY_INIT=>
                  state<=ST_KEY_EXP;
              WHEN ST_KEY_EXP=>
                  IF(k_cnt=77) THEN   state<=ST_READY;  END IF;
			  WHEN ST_READY => if(key_in ='0') then state <= ST_IDLE; end if;
          END CASE;
        END IF;
END PROCESS;


PROCESS(clear, clock)  BEGIN
  IF(clear='0') THEN
	  a_reg<=(OTHERS=>'0');
  ELSIF(clock'EVENT AND clock='1') THEN
	  IF(state=ST_KEY_EXP) THEN   a_reg<=a_tmp2;
	  END IF;
  END IF;
END PROCESS;


PROCESS(clear, clock)  BEGIN
  IF(clear='0') THEN
	  b_reg<=(OTHERS=>'0');
  ELSIF(clock'EVENT AND clock='1') THEN
	  IF(state=ST_KEY_EXP) THEN   b_reg<=b_tmp2;
	  END IF;
  END IF;
END PROCESS;  

PROCESS(clear, clock)
 BEGIN
    IF(clear='0') THEN  i_cnt<=0;
    ELSIF(clock'EVENT AND clock='1') THEN
       IF(state=ST_KEY_EXP) THEN
         IF(i_cnt=25) THEN   i_cnt<=0;
         ELSE   i_cnt<=i_cnt+1;
         END IF;
       END IF;
    END IF;
 END PROCESS;
 
 
 PROCESS(clear, clock)
 BEGIN
    IF(clear='0') THEN  j_cnt<=0;
    ELSIF(clock'EVENT AND clock='1') THEN
       IF(state=ST_KEY_EXP) THEN
         IF(j_cnt=3) THEN   j_cnt<=0;
         ELSE   j_cnt<=j_cnt+1;
         END IF;
       END IF;
    END IF;
 END PROCESS;
 
PROCESS(clock,clear)							
BEGIN
	IF(clear = '0') THEN k_cnt <= 0;
	ELSIF(clock'EVENT AND clock ='1')THEN
		IF(STATE = ST_KEY_EXP) THEN
			IF(k_cnt = 77) THEN k_cnt <= 0;
			ELSE k_cnt <= k_cnt + 1;
			END IF;
		END IF;
	END IF;
END PROCESS;


PROCESS(clear, clock)
 BEGIN
   IF(clear='0') THEN	 
      s_arr_tmp(0) <= X"b7e15163";
		s_arr_tmp(1) <= X"5618cb1c";
		s_arr_tmp(2) <= X"f45044d5";
		s_arr_tmp(3) <= X"9287be8e";
		s_arr_tmp(4) <= X"30bf3847";
		s_arr_tmp(5) <= X"cef6b200";
		s_arr_tmp(6) <= X"6d2e2bb9";
		s_arr_tmp(7) <= X"0b65a572";
		s_arr_tmp(8) <= X"a99d1f2b";
		s_arr_tmp(9) <= X"47d498e4";
		s_arr_tmp(10) <= X"e60c129d";
		s_arr_tmp(11) <= X"84438c56";
		s_arr_tmp(12) <= X"227b060f";
		s_arr_tmp(13) <= X"c0b27fc8";
		s_arr_tmp(14) <= X"5ee9f981";
		s_arr_tmp(15) <= X"fd21733a";
		s_arr_tmp(16) <= X"9b58ecf3";
		s_arr_tmp(17) <= X"399066ac";
		s_arr_tmp(18) <= X"d7c7e065";
		s_arr_tmp(19) <= X"75ff5a1e";
		s_arr_tmp(20) <= X"1436d3d7";
		s_arr_tmp(21) <= X"b26e4d90";
		s_arr_tmp(22) <= X"50a5c749";
		s_arr_tmp(23) <= X"eedd4102";
		s_arr_tmp(24) <= X"8d14babb";
		s_arr_tmp(25) <= X"2b4c3474";
   ELSIF(clock'EVENT AND clock='1') THEN
     IF(state=ST_KEY_EXP) THEN   s_arr_tmp(i_cnt)<=a_tmp2;
     END IF;
   END IF;
 END PROCESS;
  
 PROCESS(clear, clock)
   BEGIN
     IF(clear='0') THEN
        FOR i IN 0 TO 3 LOOP
           l_arr(i)<=(OTHERS=>'0');
        END LOOP;
     ELSIF(clock'EVENT AND clock='1') THEN
        IF(state=ST_KEY_INIT) THEN
           l_arr(0)<=ukey(31 DOWNTO 0);
          l_arr(1)<=ukey(63 DOWNTO 32);
          l_arr(2)<=ukey(95 DOWNTO 64);
          l_arr(3)<=ukey(127 DOWNTO 96);
        ELSIF(state=ST_KEY_EXP) THEN
           l_arr(j_cnt)<=b_tmp2;
        END IF;
     END IF;
  END PROCESS;
  
 process(clock,key_rdy,state) begin
 if(clock'event and clock='1') then
 if(key_rdy = '1' and state = ST_READY) then 
 s_key <= s_arr_tmp;
 end if;
 end if;
 end process;

with state select
	key_rdy <= '1' when ST_READY,
					'0' when others;
					
end behavioral;