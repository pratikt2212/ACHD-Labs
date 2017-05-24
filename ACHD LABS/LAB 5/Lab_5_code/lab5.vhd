library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity lab5 is
port
(
 clk : IN std_LOGIC;
 clr : IN STD_LOGIC;
 input : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
 btn : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
 output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);
-- display: out std_logic_vector(7 downto 0);
-- led : out std_logic_vector (6 downto 0);
--ready : OUT STD_LOGIC);
end lab5;

architecture Behavioural of lab5 is

--a
signal a_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal areg_l : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal areg_u : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal areg_lu: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal a_rot : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal ab_xor : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL a	: STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL a_pre: STD_LOGIC_VECTOR(31 DOWNTO 0);

--b
signal b_reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal breg_l : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal breg_u : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL breg_lu: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal b_rot : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal ba_xor : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL b	: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal b_pre: STD_LOGIC_VECTOR(31 DOWNTO 0);

signal round_cnt : STD_LOGIC_VECTOR(3 DOWNTO 0);

TYPE StateType IS(IDLE,
						A_lowerinput,
						A_upperinput,
						B_lowerinput,
						B_upperinput,
						A_loweroutput,
						A_upperoutput,
						B_loweroutput,
						B_upperoutput,
						calculation,
                  pre_round, 
                  round_op,
                  ready);
							  
signal state: StateType;
 
TYPE rom IS ARRAY (0 TO 25) OF STD_LOGIC_VECTOR(31 DOWNTO 0); 
  Constant skey:
  rom := rom'( x"00000000", x"00000000", x"46F8E8C5", x"460C6085",
x"70F83B8A", x"284B8303", x"513E1454", x"F621ED22",
x"3125065D", x"11A83A5D", x"D427686B", x"713AD82D",
x"4B792F99", x"2799A4DD", x"A7901C49", x"DEDE871A",
x"36C03196", x"A7EFC249", x"61A78BB8", x"3B0A1D2B",
x"4DBFCA76", x"AE162167", x"30D76B0A", x"43192304",
x"F6CC1431", x"65046380");

begin

process(clr, clk, state, areg_l, areg_u)
begin
	if (clr = '1') then
   areg_l <= "0000000000000000";
	areg_u <= "0000000000000000";
	elsif(clk'event and clk = '1') then
		if(state = A_lowerinput) then
		areg_l(15 DOWNTO 0) <= input(15 DOWNTO 0);
		elsif(state = A_upperinput) then
		areg_u(15 DOWNTO 0) <= input(15 DOWNTO 0);
		end if;
   end if;
   areg_lu <= areg_u & areg_l;
end process;


process(clr, clk, state, breg_l, breg_u)
begin
	if (clr = '1') then
   breg_l <= "0000000000000000";
	breg_u <= "0000000000000000";
	elsif(clk'event and clk = '1') then
		if (state = B_lowerinput) then
		breg_l(15 DOWNTO 0) <= input(15 DOWNTO 0);
		elsif(state = B_upperinput) then
		breg_u(15 DOWNTO 0) <= input(15 DOWNTO 0);
		end if;
	end if;
	breg_lu <= breg_u & breg_l;
end process;
 
 
process(clr, clk, state)
begin
	if(clr = '1') then
	a_reg <= "00000000000000000000000000000000";
	elsif(clk'event and clk='1') then
		if(state=pre_round) then   a_reg<=a_pre;
		elsif(state=round_op) then   a_reg<=a;   
		end if;
	end if;
end process;


process(clr, clk, state)
begin
	if(clr = '1') then
	b_reg <= "00000000000000000000000000000000";
	elsif(clk'event and clk='1') then
		if(state=pre_round) then   b_reg<=b_pre;
		elsif(state=round_op) then   b_reg<=b;   
		end if;
	end if;
end process;

 
PROCESS(clr, clk, state)
BEGIN
	IF(clr='1') THEN
   round_cnt<="0001";
   ELSIF(clk'EVENT AND clk='1') THEN
		IF(state=round_op) THEN
			IF(round_cnt="1100") THEN round_cnt <= "0001";  
         ELSE round_cnt<=round_cnt+'1';
			END IF;
		END IF;
	END IF;
END PROCESS;   

  -- A=((A XOR B)<<<B) + S[2*i];

 ab_xor <= a_reg XOR b_reg;
  WITH b_reg(4 DOWNTO 0) SELECT
     a_rot<=ab_xor(30 DOWNTO 0) & ab_xor(31) WHEN "00001",
            ab_xor(29 DOWNTO 0) & ab_xor(31 DOWNTO 30) WHEN "00010", 
	         ab_xor(28 DOWNTO 0) & ab_xor(31 DOWNTO 29) WHEN "00011",
            ab_xor(27 DOWNTO 0) & ab_xor(31 DOWNTO 28) WHEN "00100",
            ab_xor(26 DOWNTO 0) & ab_xor(31 DOWNTO 27) WHEN "00101",
            ab_xor(25 DOWNTO 0) & ab_xor(31 DOWNTO 26) WHEN "00110",
            ab_xor(24 DOWNTO 0) & ab_xor(31 DOWNTO 25) WHEN "00111",
            ab_xor(23 DOWNTO 0) & ab_xor(31 DOWNTO 24) WHEN "01000",
            ab_xor(22 DOWNTO 0) & ab_xor(31 DOWNTO 23) WHEN "01001",
            ab_xor(21 DOWNTO 0) & ab_xor(31 DOWNTO 22) WHEN "01010",
            ab_xor(20 DOWNTO 0) & ab_xor(31 DOWNTO 21) WHEN "01011",
            ab_xor(19 DOWNTO 0) & ab_xor(31 DOWNTO 20) WHEN "01100",
            ab_xor(18 DOWNTO 0) & ab_xor(31 DOWNTO 19) WHEN "01101",
            ab_xor(17 DOWNTO 0) & ab_xor(31 DOWNTO 18) WHEN "01110",
            ab_xor(16 DOWNTO 0) & ab_xor(31 DOWNTO 17) WHEN "01111",
            ab_xor(15 DOWNTO 0) & ab_xor(31 DOWNTO 16) WHEN "10000",
            ab_xor(14 DOWNTO 0) & ab_xor(31 DOWNTO 15) WHEN "10001",
            ab_xor(13 DOWNTO 0) & ab_xor(31 DOWNTO 14) WHEN "10010",
            ab_xor(12 DOWNTO 0) & ab_xor(31 DOWNTO 13) WHEN "10011",
				ab_xor(11 DOWNTO 0) & ab_xor(31 DOWNTO 12) WHEN "10100",
				ab_xor(10 DOWNTO 0) & ab_xor(31 DOWNTO 11) WHEN "10101",
				ab_xor(9 DOWNTO 0) & ab_xor(31 DOWNTO 10) WHEN "10110",
				ab_xor(8 DOWNTO 0) & ab_xor(31 DOWNTO 9) WHEN "10111",
				ab_xor(7 DOWNTO 0) & ab_xor(31 DOWNTO 8) WHEN "11000",
				ab_xor(6 DOWNTO 0) & ab_xor(31 DOWNTO 7) WHEN "11001",
				ab_xor(5 DOWNTO 0) & ab_xor(31 DOWNTO 6) WHEN "11010",
				ab_xor(4 DOWNTO 0) & ab_xor(31 DOWNTO 5) WHEN "11011",
				ab_xor(3 DOWNTO 0) & ab_xor(31 DOWNTO 4) WHEN "11100",
				ab_xor(2 DOWNTO 0) & ab_xor(31 DOWNTO 3) WHEN "11101",
				ab_xor(1 DOWNTO 0) & ab_xor(31 DOWNTO 2) WHEN "11110",
				ab_xor(0) & ab_xor(31 DOWNTO 1) WHEN "11111",
				ab_xor WHEN OTHERS;
     a_pre<=areg_lu(31 DOWNTO 0) + skey(0); -- A = A + S[0]
   a<=a_rot + skey(CONV_INTEGER(round_cnt & '0'));  -- S[2*i]
	
	
   --B=((B XOR A)<<<A) + S[2×i+1])
   ba_xor <= b_reg XOR a;
	with a(4 downto 0) select
	b_rot <=	ba_xor(30 DOWNTO 0) & ba_xor(31) WHEN "00001",
            ba_xor(29 DOWNTO 0) & ba_xor(31 DOWNTO 30) WHEN "00010", 
	         ba_xor(28 DOWNTO 0) & ba_xor(31 DOWNTO 29) WHEN "00011",
            ba_xor(27 DOWNTO 0) & ba_xor(31 DOWNTO 28) WHEN "00100",
            ba_xor(26 DOWNTO 0) & ba_xor(31 DOWNTO 27) WHEN "00101",
            ba_xor(25 DOWNTO 0) & ba_xor(31 DOWNTO 26) WHEN "00110",
            ba_xor(24 DOWNTO 0) & ba_xor(31 DOWNTO 25) WHEN "00111",
            ba_xor(23 DOWNTO 0) & ba_xor(31 DOWNTO 24) WHEN "01000",
            ba_xor(22 DOWNTO 0) & ba_xor(31 DOWNTO 23) WHEN "01001",
            ba_xor(21 DOWNTO 0) & ba_xor(31 DOWNTO 22) WHEN "01010",
            ba_xor(20 DOWNTO 0) & ba_xor(31 DOWNTO 21) WHEN "01011",
            ba_xor(19 DOWNTO 0) & ba_xor(31 DOWNTO 20) WHEN "01100",
            ba_xor(18 DOWNTO 0) & ba_xor(31 DOWNTO 19) WHEN "01101",
            ba_xor(17 DOWNTO 0) & ba_xor(31 DOWNTO 18) WHEN "01110",
            ba_xor(16 DOWNTO 0) & ba_xor(31 DOWNTO 17) WHEN "01111",
            ba_xor(15 DOWNTO 0) & ba_xor(31 DOWNTO 16) WHEN "10000",
            ba_xor(14 DOWNTO 0) & ba_xor(31 DOWNTO 15) WHEN "10001",
            ba_xor(13 DOWNTO 0) & ba_xor(31 DOWNTO 14) WHEN "10010",
            ba_xor(12 DOWNTO 0) & ba_xor(31 DOWNTO 13) WHEN "10011",
				ba_xor(11 DOWNTO 0) & ba_xor(31 DOWNTO 12) WHEN "10100",
				ba_xor(10 DOWNTO 0) & ba_xor(31 DOWNTO 11) WHEN "10101",
				ba_xor(9 DOWNTO 0)  & ba_xor(31 DOWNTO 10) WHEN "10110",
				ba_xor(8 DOWNTO 0)  & ba_xor(31 DOWNTO 9) WHEN "10111",
				ba_xor(7 DOWNTO 0)  & ba_xor(31 DOWNTO 8) WHEN "11000",
				ba_xor(6 DOWNTO 0)  & ba_xor(31 DOWNTO 7) WHEN "11001",
				ba_xor(5 DOWNTO 0)  & ba_xor(31 DOWNTO 6) WHEN "11010",
				ba_xor(4 DOWNTO 0)  & ba_xor(31 DOWNTO 5) WHEN "11011",
				ba_xor(3 DOWNTO 0)  & ba_xor(31 DOWNTO 4) WHEN "11100",
				ba_xor(2 DOWNTO 0)  & ba_xor(31 DOWNTO 3) WHEN "11101",
				ba_xor(1 DOWNTO 0) & ba_xor(31 DOWNTO 2) WHEN "11110",
				ba_xor(0) & ba_xor(31 DOWNTO 1) WHEN "11111",
				ba_xor WHEN OTHERS;
				b_pre<=breg_lu(31 DOWNTO 0) + skey(1);
				b<=b_rot + skey(CONV_INTEGER(round_cnt & '1')); 


process(btn, state, clk, clr)
begin
	IF(clr='1') THEN
   state<=IDLE;
   ELSIF(clk'EVENT AND clk='1') THEN
		CASE state IS
      When Idle => if(btn = "0001") then state <= A_lowerinput;
						 elsif(btn = "0011") then state <= A_upperinput;
						 elsif(btn = "0010") then state <= B_lowerinput;
						 elsif(btn = "0110") then state <= B_upperinput;
						 elsif(btn = "0100") then state <= A_loweroutput;
						 elsif(btn = "1100") then state <= A_upperoutput;
						 elsif(btn = "1000") then state <= B_loweroutput;
						 elsif(btn = "1001") then state <= B_upperoutput;
						 end if;
		WHEN B_upperinput => state <= pre_round;
		When pre_round => 	state<=round_op;
		WHEN round_op=>  IF(round_cnt="1100") THEN state<=ready; END IF;
      WHEN ready=>   state<=IDLE;
		WHEN others => state <= IDLE;
      END CASE;
	END IF;
END PROCESS;

process(state)
begin
	if (state = A_loweroutput) then								
	output <= a_reg(15 downto 0);
	elsif (state = A_upperoutput) then
	output <= a_reg(31 downto 16);
	elsif (state = B_loweroutput) then								
	output <= b_reg(15 downto 0);
	elsif (state = B_upperoutput) then
	output <= b_reg(31 downto 16);
	end if;
end process;

end Behavioural;
