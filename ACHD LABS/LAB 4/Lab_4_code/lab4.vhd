----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    06:12:47 10/30/2016 
-- Design Name: 
-- Module Name:    lab4 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Lab4 is

	Port ( button : IN STD_LOGIC_VECTOR (4 downto 0);
			 input : IN STD_LOGIC_vector (15 downto 0);
			 clear : IN bit;
			 clock: IN STD_LOGIC;
          output : out  STD_LOGIC_VECTOR (15 downto 0));

end Lab4;

architecture Behavioral of Lab4 is

TYPE  StateType IS (idle, 
                    input_lower,  
                    input_upper, 
                    select_lr,
						  output_lower,
						  output_upper);
SIGNAL state: StateType;
SIGNAL b  : STD_LOGIC_VECTOR(5 DOWNTO 0);
signal o1 : STD_LOGIC_VECTOR(31 downto 0);
signal o_l: STD_LOGIC_VECTOR(31 downto 0);
signal o_r: STD_LOGIC_VECTOR(31 downto 0);
signal o2 : STD_LOGIC_VECTOR(31 downto 0);
signal a_l: STD_LOGIC_VECToR(15 DOWNTO 0);
signal a_u: STD_LOGIC_VECToR(15 DOWNTO 0);

begin

  PROCESS(clock, state, input)  BEGIN
  IF(clock'EVENT AND clock = '1' AND state = input_lower) THEN 
  a_l(15 DOWNTO 0) <= input(15 DOWNTO 0);
  END IF;
  END PROCESS;

  PROCESS(clock, state, input)  BEGIN
  IF(clock'EVENT AND clock='1' AND state = input_upper) THEN 
  a_u(15 DOWNTO 0) <= input(15 DOWNTO 0);
  END IF;
  END PROCESS;

  PROCESS(clock, state, input)  BEGIN
  IF(clock'EVENT AND clock = '1' AND state = select_lr) THEN 
  b(5 DOWNTO 0) <= input(5 DOWNTO 0);
  END IF;
  END PROCESS;

  PROCESS(clock, o1)  BEGIN
  IF(clock'EVENT AND clock = '1') THEN o_l <= o1;
  END IF;
  END PROCESS;

  PROCESS(clock, o2)  BEGIN
  IF(clock'EVENT AND clock = '1') THEN o_r <= o2;
  END IF;
  END PROCESS;

WITH b(4 DOWNTO 0) SELECT
	o1 <= a_u(14 DOWNTO 0) & a_l(15 downto 0) & a_u(15) WHEN "00001",
         a_u(13 DOWNTO 0) & a_l(15 downto 0) & a_u(15 downto 14) WHEN "00010",
			a_u(12 DOWNTO 0) & a_l(15 downto 0) & a_u(15 DOWNTO 13) WHEN "00011",
			a_u(11 DOWNTO 0) & a_l(15 downto 0) & a_u(15 DOWNTO 12) WHEN "00100",
			a_u(10 DOWNTO 0) & a_l(15 downto 0) & a_u(15 DOWNTO 11) WHEN "00101",
			a_u(9 DOWNTO 0) & a_l(15 downto 0) & a_u(15 DOWNTO 10) WHEN "00110",
			a_u(8 DOWNTO 0) & a_l(15 downto 0) & a_u(15 DOWNTO 9) WHEN "00111",
			a_u(7 DOWNTO 0) & a_l(15 downto 0) & a_u(15 DOWNTO 8) WHEN "01000",
			a_u(6 DOWNTO 0) & a_l(15 downto 0) & a_u(15 DOWNTO 7) WHEN "01001",
			a_u(5 DOWNTO 0) & a_l(15 downto 0) & a_u(15 DOWNTO 6) WHEN "01010",
			a_u(4 DOWNTO 0) & a_l(15 downto 0) & a_u(15 DOWNTO 5) WHEN "01011",
			a_u(3 DOWNTO 0) & a_l(15 downto 0) & a_u(15 DOWNTO 4) WHEN "01100",
			a_u(2 DOWNTO 0) & a_l(15 downto 0) & a_u(15 DOWNTO 3) WHEN "01101",
			a_u(1 DOWNTO 0) & a_l(15 downto 0) & a_u(15 DOWNTO 2) WHEN "01110",
			a_u(0) & a_l(15 downto 0) & a_u(15 DOWNTO 1) WHEN "01111",
			a_l(15 DOWNTO 0) & a_u(15 DOWNTO 0) WHEN "10000",
			a_l(14 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15) WHEN "10001",
			a_l(13 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 downto 14) WHEN "10010",
			a_l(12 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 downto 13) WHEN "10011",
			a_l(11 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 downto 12) WHEN "10100",
			a_l(10 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 downto 11) WHEN "10101",
			a_l(9 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 downto 10) WHEN "10110",
			a_l(8 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 downto 9) WHEN "10111",
			a_l(7 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 downto 8) WHEN "11000",
			a_l(6 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 downto 7) WHEN "11001",
			a_l(5 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 downto 6) WHEN "11010",
			a_l(4 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 downto 5) WHEN "11011",
			a_l(3 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 downto 4)WHEN "11100",
			a_l(2 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 downto 3) WHEN "11101",
			a_l(1 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 downto 2) WHEN "11110",
			a_l(0) & a_u(15 DOWNTO 0) & a_l(15 downto 1) WHEN "11111",
			a_u(15 downto 0) & a_l(15 downto 0) WHEN "00000";

WITH b(4 DOWNTO 0) SELECT
	o2 <=	a_l(0) & a_u(15 DOWNTO 0) & a_l(15 DOWNTO 1) WHEN "00001",
			a_l(1 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 DOWNTO 2) WHEN "00010",
			a_l(2 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 DOWNTO 3) WHEN "00011",
			a_l(3 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 DOWNTO 4) WHEN "00100",
			a_l(4 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 DOWNTO 5) WHEN "00101",
			a_l(5 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 DOWNTO 6) WHEN "00110",
			a_l(6 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 DOWNTO 7) WHEN "00111",
			a_l(7 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 DOWNTO 8) WHEN "01000",
			a_l(8 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 DOWNTO 9) WHEN "01001",
			a_l(9 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 DOWNTO 10) WHEN "01010",
			a_l(10 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 DOWNTO 11) WHEN "01011",
			a_l(11 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 DOWNTO 12) WHEN "01100",
			a_l(12 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 DOWNTO 13) WHEN "01101",
			a_l(13 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15 DOWNTO 14) WHEN "01110",
			a_l(14 DOWNTO 0) & a_u(15 DOWNTO 0) & a_l(15) WHEN "01111",
			a_l(15 DOWNTO 0) & a_u(15 DOWNTO 0) WHEN "10000",
			a_u(0) & a_l(15 DOWNTO 0) & a_u(15 DOWNTO 1) WHEN "10001",
			a_u(1 DOWNTO 0) & a_l(15 DOWNTO 0) & a_u(15 DOWNTO 2) WHEN "10010",
			a_u(2 DOWNTO 0) & a_l(15 DOWNTO 0) & a_u(15 DOWNTO 3) WHEN "10011",
			a_u(3 DOWNTO 0) & a_l(15 DOWNTO 0) & a_u(15 DOWNTO 4) WHEN "10100",
			a_u(4 DOWNTO 0) & a_l(15 DOWNTO 0) & a_u(15 DOWNTO 5) WHEN "10101",
			a_u(5 DOWNTO 0) & a_l(15 DOWNTO 0) & a_u(15 DOWNTO 6) WHEN "10110",
			a_u(6 DOWNTO 0) & a_l(15 DOWNTO 0) & a_u(15 DOWNTO 7) WHEN "10111",
			a_u(7 DOWNTO 0) & a_l(15 DOWNTO 0) & a_u(15 DOWNTO 8) WHEN "11000",
			a_u(8 DOWNTO 0) & a_l(15 DOWNTO 0) & a_u(15 DOWNTO 9) WHEN "11001",
			a_u(9 DOWNTO 0) & a_l(15 DOWNTO 0) & a_u(15 DOWNTO 10) WHEN "11010",
			a_u(10 DOWNTO 0) & a_l(15 DOWNTO 0) & a_u(15 DOWNTO 11) WHEN "11011",
			a_u(11 DOWNTO 0) & a_l(15 DOWNTO 0) & a_u(15 DOWNTO 12) WHEN "11100",
			a_u(12 DOWNTO 0) & a_l(15 DOWNTO 0) & a_u(15 DOWNTO 13) WHEN "11101",
			a_u(13 DOWNTO 0) & a_l(15 DOWNTO 0) & a_u(15 DOWNTO 14) WHEN "11110",
			a_u(14 DOWNTO 0) & a_l(15 DOWNTO 0) & a_u(15) WHEN "11111",
			a_u(15 downto 0) & a_l(15 downto 0) WHEN "00000";

  PROCESS(button)
  begin
  case button(4 downto 0) is
	   WHEN "00001" => state <= input_lower;  
      WHEN "00010"=>  state <= input_upper;
      WHEN "00100"=>  state <= select_lr;  
      WHEN "01000"=>  state <= output_lower;
		WHEN "10000"=>  state <= output_upper;
		WHEN others => state <= idle;
      END CASE;
   end process;	
	

process (state, b, o_l, o_r)
	begin
	
	if(state = output_lower and b(5) = '0') then
    output <= o_l(15 DOWNTO 0);
	elsif(state = output_lower and b(5) = '1') then
    output <= o_r(15 DOWNTO 0);
	elsif(state = output_upper and b(5) = '0') then
    output <= o_l(31 DOWNTO 16);
	elsif (state = output_upper and b(5) = '1') then
    output <= o_r(31 DOWNTO 16);
	else output <= "1111111111111111";
	end if;
end process;


end Behavioral;