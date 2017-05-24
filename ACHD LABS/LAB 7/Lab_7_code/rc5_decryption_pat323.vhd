library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.rc5Package.all;



entity rc5_decryption is
Port ( clear : in  STD_LOGIC;
           clock : in  STD_LOGIC;
           din	: in std_logic_vector(63 downto 0);
			  di_vld : in  STD_LOGIC;
			  dout : out std_logic_vector(63 downto 0);
			  o_rdy: out std_logic;
			  s_key	: in S_array
			  );
end rc5_decryption;

architecture Behavioral of rc5_decryption is

SIGNAL i_cnt	: STD_LOGIC_VECTOR(3 DOWNTO 0); 
	
	signal do_rdy : STD_LOGIC;
    SIGNAL a_sub	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL a_rot	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL a	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL a_reg	: STD_LOGIC_VECTOR(31 DOWNTO 0); 
	
    SIGNAL b_sub: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL b_rot	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL b	: STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL b_reg	: STD_LOGIC_VECTOR(31 DOWNTO 0); 
	 
   TYPE  StateType IS (ST_IDLE, 
                                ST_POST_ROUND, 
                                 ST_ROUND_OP, 
                                 ST_READY -- 
                                  );

   SIGNAL  state:   StateType;

begin

b_sub <= b_reg - s_key(CONV_INTEGER(i_cnt & '1')); 
 WITH a_reg(4 DOWNTO 0) SELECT
		b_rot <= b_sub(0) & b_sub(31 DOWNTO 1) WHEN "00001",
				b_sub(1 DOWNTO 0) & b_sub(31 DOWNTO 2) WHEN "00010",
				b_sub(2 DOWNTO 0) & b_sub(31 DOWNTO 3) WHEN "00011",
				b_sub(3 DOWNTO 0) & b_sub(31 DOWNTO 4) WHEN "00100",
				b_sub(4 DOWNTO 0) & b_sub(31 DOWNTO 5) WHEN "00101",
				b_sub(5 DOWNTO 0) & b_sub(31 DOWNTO 6) WHEN "00110",
				b_sub(6 DOWNTO 0) & b_sub(31 DOWNTO 7) WHEN "00111",
				b_sub(7 DOWNTO 0) & b_sub(31 DOWNTO 8) WHEN "01000",
				b_sub(8 DOWNTO 0) & b_sub(31 DOWNTO 9) WHEN "01001",
				b_sub(9 DOWNTO 0) & b_sub(31 DOWNTO 10) WHEN "01010",
				b_sub(10 DOWNTO 0) & b_sub(31 DOWNTO 11) WHEN "01011",
				b_sub(11 DOWNTO 0) & b_sub(31 DOWNTO 12) WHEN "01100",
				b_sub(12 DOWNTO 0) & b_sub(31 DOWNTO 13) WHEN "01101",
				b_sub(13 DOWNTO 0) & b_sub(31 DOWNTO 14) WHEN "01110",
				b_sub(14 DOWNTO 0) & b_sub(31 DOWNTO 15) WHEN "01111",
				b_sub(15 DOWNTO 0) & b_sub(31 DOWNTO 16) WHEN "10000",
				b_sub(16 DOWNTO 0) & b_sub(31 DOWNTO 17) WHEN "10001",
				b_sub(17 DOWNTO 0) & b_sub(31 DOWNTO 18) WHEN "10010",
				b_sub(18 DOWNTO 0) & b_sub(31 DOWNTO 19) WHEN "10011",
				b_sub(19 DOWNTO 0) & b_sub(31 DOWNTO 20) WHEN "10100",
				b_sub(20 DOWNTO 0) & b_sub(31 DOWNTO 21) WHEN "10101",
				b_sub(21 DOWNTO 0) & b_sub(31 DOWNTO 22) WHEN "10110",
				b_sub(22 DOWNTO 0) & b_sub(31 DOWNTO 23) WHEN "10111",
				b_sub(23 DOWNTO 0) & b_sub(31 DOWNTO 24) WHEN "11000",
				b_sub(24 DOWNTO 0) & b_sub(31 DOWNTO 25) WHEN "11001",
				b_sub(25 DOWNTO 0) & b_sub(31 DOWNTO 26) WHEN "11010",
				b_sub(26 DOWNTO 0) & b_sub(31 DOWNTO 27) WHEN "11011",
				b_sub(27 DOWNTO 0) & b_sub(31 DOWNTO 28) WHEN "11100",
				b_sub(28 DOWNTO 0) & b_sub(31 DOWNTO 29) WHEN "11101",
				b_sub(29 DOWNTO 0) & b_sub(31 DOWNTO 30) WHEN "11110",
				b_sub(30 DOWNTO 0) & b_sub(31) WHEN "11111",
				b_sub WHEN OTHERS;
				
		b <= b_rot xor a_reg;							
		
 a_sub <= a_reg - s_key(CONV_INTEGER(i_cnt & '0')); 
 
		WITH b(4 DOWNTO 0) SELECT
			a_rot<=a_sub(0) & a_sub(31 DOWNTO 1) WHEN "00001",
				a_sub(1 DOWNTO 0) & a_sub(31 DOWNTO 2) WHEN "00010",
				a_sub(2 DOWNTO 0) & a_sub(31 DOWNTO 3) WHEN "00011",
				a_sub(3 DOWNTO 0) & a_sub(31 DOWNTO 4) WHEN "00100",
				a_sub(4 DOWNTO 0) & a_sub(31 DOWNTO 5) WHEN "00101",
				a_sub(5 DOWNTO 0) & a_sub(31 DOWNTO 6) WHEN "00110",
				a_sub(6 DOWNTO 0) & a_sub(31 DOWNTO 7) WHEN "00111",
				a_sub(7 DOWNTO 0) & a_sub(31 DOWNTO 8) WHEN "01000",
				a_sub(8 DOWNTO 0) & a_sub(31 DOWNTO 9) WHEN "01001",
				a_sub(9 DOWNTO 0) & a_sub(31 DOWNTO 10) WHEN "01010",
				a_sub(10 DOWNTO 0) & a_sub(31 DOWNTO 11) WHEN "01011",
				a_sub(11 DOWNTO 0) & a_sub(31 DOWNTO 12) WHEN "01100",
				a_sub(12 DOWNTO 0) & a_sub(31 DOWNTO 13) WHEN "01101",
				a_sub(13 DOWNTO 0) & a_sub(31 DOWNTO 14) WHEN "01110",
				a_sub(14 DOWNTO 0) & a_sub(31 DOWNTO 15) WHEN "01111",
				a_sub(15 DOWNTO 0) & a_sub(31 DOWNTO 16) WHEN "10000",
				a_sub(16 DOWNTO 0) & a_sub(31 DOWNTO 17) WHEN "10001",
				a_sub(17 DOWNTO 0) & a_sub(31 DOWNTO 18) WHEN "10010",
				a_sub(18 DOWNTO 0) & a_sub(31 DOWNTO 19) WHEN "10011",
				a_sub(19 DOWNTO 0) & a_sub(31 DOWNTO 20) WHEN "10100",
				a_sub(20 DOWNTO 0) & a_sub(31 DOWNTO 21) WHEN "10101",
				a_sub(21 DOWNTO 0) & a_sub(31 DOWNTO 22) WHEN "10110",
				a_sub(22 DOWNTO 0) & a_sub(31 DOWNTO 23) WHEN "10111",
				a_sub(23 DOWNTO 0) & a_sub(31 DOWNTO 24) WHEN "11000",
				a_sub(24 DOWNTO 0) & a_sub(31 DOWNTO 25) WHEN "11001",
				a_sub(25 DOWNTO 0) & a_sub(31 DOWNTO 26) WHEN "11010",
				a_sub(26 DOWNTO 0) & a_sub(31 DOWNTO 27) WHEN "11011",
				a_sub(27 DOWNTO 0) & a_sub(31 DOWNTO 28) WHEN "11100",
				a_sub(28 DOWNTO 0) & a_sub(31 DOWNTO 29) WHEN "11101",
				a_sub(29 DOWNTO 0) & a_sub(31 DOWNTO 30) WHEN "11110",
				a_sub(30 DOWNTO 0) & a_sub(31) WHEN "11111",
				a_sub WHEN OTHERS;
			
		a <=a_rot xor b;								
	
	
PROCESS(clock,clear)							
	BEGIN
		IF(clear = '0') THEN
		ELSIF(clock'EVENT AND clock ='1') THEN
		IF(state = ST_IDLE) THEN
			a_reg <= din(63 DOWNTO 32); END IF;
			IF(state = ST_ROUND_OP) THEN
			a_reg <= a; END IF;
				IF(state = ST_POST_ROUND) THEN
			a_reg <= a_reg - s_key(0);
		END IF;
		END IF;

	END PROCESS;
	
	
PROCESS(clock,clear)							
BEGIN
	IF(clear = '0') THEN
		ELSIF(clock'EVENT AND clock ='1') THEN
		IF(state = ST_IDLE) THEN
			b_reg <= din(31 DOWNTO 0);END IF;
		IF(state = ST_ROUND_OP) THEN
			b_reg <= b; END IF;
		IF(state = ST_POST_ROUND) THEN
			b_reg <= b_reg - s_key(1);
	END IF;
	END IF;
END PROCESS;
 
	 
PROCESS(clear, clock)
   BEGIN
      IF(clear='0') THEN
         state<=ST_IDLE;
      ELSIF(clock'EVENT AND clock='1') THEN
         CASE state IS
            WHEN ST_IDLE=>  IF(di_vld='1') THEN state<=ST_ROUND_OP;  END IF;
            WHEN ST_ROUND_OP=>  IF(i_cnt="0001") THEN state<=ST_POST_ROUND;  END IF;
            WHEN ST_POST_ROUND=>    state<=ST_READY;
				WHEN ST_READY=>   state<=ST_IDLE;
         END CASE;
      END IF;
   END PROCESS;
	
	
    PROCESS(clear, clock)  BEGIN
        IF(clear='0') THEN
           i_cnt<="1100";
        ELSIF(clock'EVENT AND clock='1') THEN
           IF(state=ST_ROUND_OP) THEN
              IF(i_cnt="0001") THEN   i_cnt<="1100";
              ELSE    i_cnt<=i_cnt - '1';    
				  END IF;
           END IF;
        END IF;
    END PROCESS;   
	 
    WITH state SELECT
        do_rdy<=	'1' WHEN ST_READY,
		'0' WHEN OTHERS;
		
		o_rdy<= do_rdy;

PROCESS(clock)  BEGIN                                                 
			IF(clock'EVENT AND clock='1') THEN 
			IF(do_rdy = '1') then
			dout <= a_reg & b_reg;
			END IF;                                                                
			END IF;
		END PROCESS; 
end behavioral;