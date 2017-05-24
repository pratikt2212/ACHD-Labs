
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.All;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity inverse is
 port ( 
  button : IN STD_LOGIC_VECTOR (4 downto 0);
  rst: IN STD_LOGIC;  
  clk: IN STD_LOGIC;  
  din: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
  dout: OUT STD_LOGIC_VECTOR(63 DOWNTO 0) 
  );

end inverse;

architecture function_inverse of inverse is

TYPE  StateType IS (idle, 
                    input_lower1, 
						  input_lower2,
                    input_upper1, 
						  input_upper2, 
                    select_lr
						  );
  SIGNAL state: StateType;
  SIGNAL i_cnt: STD_LOGIC_VECTOR(3 DOWNTO 0) := "1100";  
  SIGNAL ab_xor: STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL a_rot: STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL a: STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL a_reg: STD_LOGIC_VECTOR(31 DOWNTO 0); 
  SIGNAL ba_xor: STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL b_rot: STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL b: STD_LOGIC_VECTOR(31 DOWNTO 0);
  SIGNAL b_reg: STD_LOGIC_VECTOR(31 DOWNTO 0); 
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

  PROCESS(rst,state,clk)  BEGIN
  IF(clk'EVENT AND clk='1' AND rst='0' AND state = input_lower1) THEN
  a_reg (15 DOWNTO 0) <= din(15 DOWNTO 0);
  END IF;
  IF (clk'EVENT AND clk='1' AND rst='0' AND state = input_lower2) THEN
  a_reg (31 DOWNTO 16) <= din(15 DOWNTO 0);
  ELSIF(clk'EVENT AND clk='1' AND state = select_lr) THEN 
  a_reg<=ab_xor;
  END IF;
  END PROCESS;

  PROCESS(rst,state,clk)  BEGIN
  IF(clk'EVENT AND clk='1' AND rst='0' AND state = input_upper1) THEN 
  b_reg(15 DOWNTO 0) <= din(15 DOWNTO 0);
  END IF;
  IF(clk'EVENT AND clk='1' AND rst='0' AND state = input_upper2) THEN 
  b_reg(31 DOWNTO 16) <= din(15 DOWNTO 0);
  ELSIF(clk'EVENT AND clk='1' AND state = select_lr) THEN 
  b_reg<=ba_xor;
  END IF;
  END PROCESS;


    
  PROCESS(rst,state,clk)  
  BEGIN
  IF(rst='1') THEN 
	i_cnt<="1100";
  ELSIF(clk'EVENT AND clk='1' AND state = select_lr) THEN
       IF(i_cnt="0001") THEN
         i_cnt<="1100";
       ELSE
         i_cnt<=i_cnt-'1';
       END IF;
    END IF;
   END PROCESS;
	

  b<= b_reg - skey(CONV_INTEGER(i_cnt & '1')); 
  WITH a_reg(4 DOWNTO 0) SELECT
    b_rot<=	b(0) & b(31 DOWNTO 1) WHEN "00001",
				b(1 DOWNTO 0) & b(31 DOWNTO 2) WHEN "00010",
				b(2 DOWNTO 0) & b(31 DOWNTO 3) WHEN "00011",
				b(3 DOWNTO 0) & b(31 DOWNTO 4) WHEN "00100",
				b(4 DOWNTO 0) & b(31 DOWNTO 5) WHEN "00101",
				b(5 DOWNTO 0) & b(31 DOWNTO 6) WHEN "00110",
				b(6 DOWNTO 0) & b(31 DOWNTO 7) WHEN "00111",
				b(7 DOWNTO 0) & b(31 DOWNTO 8) WHEN "01000",
				b(8 DOWNTO 0) & b(31 DOWNTO 9) WHEN "01001",
				b(9 DOWNTO 0) & b(31 DOWNTO 10) WHEN "01010",
				b(10 DOWNTO 0)& b(31 DOWNTO 11) WHEN "01011",
				b(11 DOWNTO 0)& b(31 DOWNTO 12) WHEN "01100",
				b(12 DOWNTO 0) & b(31 DOWNTO 13) WHEN "01101",
				b(13 DOWNTO 0) & b(31 DOWNTO 14) WHEN "01110",
				b(14 DOWNTO 0) & b(31 DOWNTO 15) WHEN "01111",
				b(15 DOWNTO 0) & b(31 DOWNTO 16) WHEN "10000",
				b(16 DOWNTO 0) & b(31 DOWNTO 17) WHEN "10001",
				b(17 DOWNTO 0) & b(31 DOWNTO 18) WHEN "10010",
				b(18 DOWNTO 0) & b(31 DOWNTO 19) WHEN "10011",
				b(19 DOWNTO 0) & b(31 DOWNTO 20) WHEN "10100",
				b(20 DOWNTO 0) & b(31 DOWNTO 21) WHEN "10101",
				b(21 DOWNTO 0) & b(31 DOWNTO 22) WHEN "10110",
				b(22 DOWNTO 0) & b(31 DOWNTO 23) WHEN "10111",
				b(23 DOWNTO 0) & b(31 DOWNTO 24) WHEN "11000",
				b(24 DOWNTO 0) & b(31 DOWNTO 25) WHEN "11001",
				b(25 DOWNTO 0) & b(31 DOWNTO 26) WHEN "11010",
				b(26 DOWNTO 0) & b(31 DOWNTO 27) WHEN "11011",
				b(27 DOWNTO 0) & b(31 DOWNTO 28) WHEN "11100",
				b(28 DOWNTO 0) & b(31 DOWNTO 29) WHEN "11101",
				b(29 DOWNTO 0) & b(31 DOWNTO 30) WHEN "11110",
				b(30 DOWNTO 0) & b(31) WHEN "11111",
				b WHEN OTHERS;

   ba_xor <= b_rot xor a_reg;
	
	
	a<=a_reg - skey(CONV_INTEGER(i_cnt & '0')); 
	WITH ba_xor(4 DOWNTO 0) SELECT
    a_rot<=	a(0) & a(31 DOWNTO 1) WHEN "00001",
				a(1 DOWNTO 0) & a(31 DOWNTO 2) WHEN "00010",
				a(2 DOWNTO 0) & a(31 DOWNTO 3) WHEN "00011",
				a(3 DOWNTO 0) & a(31 DOWNTO 4) WHEN "00100",
				a(4 DOWNTO 0) & a(31 DOWNTO 5) WHEN "00101",
				a(5 DOWNTO 0) & a(31 DOWNTO 6) WHEN "00110",
				a(6 DOWNTO 0) & a(31 DOWNTO 7) WHEN "00111",
				a(7 DOWNTO 0) & a(31 DOWNTO 8) WHEN "01000",
				a(8 DOWNTO 0) & a(31 DOWNTO 9) WHEN "01001",
				a(9 DOWNTO 0) & a(31 DOWNTO 10) WHEN "01010",
				a(10 DOWNTO 0)& a(31 DOWNTO 11) WHEN "01011",
				a(11 DOWNTO 0)& a(31 DOWNTO 12) WHEN "01100",
				a(12 DOWNTO 0) & a(31 DOWNTO 13) WHEN "01101",
				a(13 DOWNTO 0) & a(31 DOWNTO 14) WHEN "01110",
				a(14 DOWNTO 0) & a(31 DOWNTO 15) WHEN "01111",
				a(15 DOWNTO 0) & a(31 DOWNTO 16) WHEN "10000",
				a(16 DOWNTO 0) & a(31 DOWNTO 17) WHEN "10001",
				a(17 DOWNTO 0) & a(31 DOWNTO 18) WHEN "10010",
				a(18 DOWNTO 0) & a(31 DOWNTO 19) WHEN "10011",
				a(19 DOWNTO 0) & a(31 DOWNTO 20) WHEN "10100",
				a(20 DOWNTO 0) & a(31 DOWNTO 21) WHEN "10101",
				a(21 DOWNTO 0) & a(31 DOWNTO 22) WHEN "10110",
				a(22 DOWNTO 0) & a(31 DOWNTO 23) WHEN "10111",
				a(23 DOWNTO 0) & a(31 DOWNTO 24) WHEN "11000",
				a(24 DOWNTO 0) & a(31 DOWNTO 25) WHEN "11001",
				a(25 DOWNTO 0) & a(31 DOWNTO 26) WHEN "11010",
				a(26 DOWNTO 0) & a(31 DOWNTO 27) WHEN "11011",
				a(27 DOWNTO 0) & a(31 DOWNTO 28) WHEN "11100",
				a(28 DOWNTO 0) & a(31 DOWNTO 29) WHEN "11101",
				a(29 DOWNTO 0) & a(31 DOWNTO 30) WHEN "11110",
				a(30 DOWNTO 0) & a(31) WHEN "11111",
				a WHEN OTHERS;
				
	 ab_xor <= a_rot xor ba_xor;

    dout<=a_reg & b_reg;	 
PROCESS(button)
  begin
  case button(4 downto 0) is
	   WHEN "00001" => state <= input_lower1;  
		WHEN "00010" => state <= input_lower2; 
      WHEN "00100"=>  state <= input_upper1;
		WHEN "01000"=>  state <= input_upper2;
      WHEN "10000"=>  state <= select_lr;  
		WHEN others => state <= idle;
      END CASE;
   end process;
end function_inverse ;