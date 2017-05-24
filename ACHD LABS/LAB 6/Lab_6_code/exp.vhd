----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:55:22 11/16/2016 
-- Design Name: 
-- Module Name:    lab6_Roundkey - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--USE WORK.rc5_pkg.ALL;
use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


--inputs/ outputs
entity key_exp is
    Port ( swin : in  STD_LOGIC_VECTOR (7 downto 0);
           buttons : in  STD_LOGIC_VECTOR (3 downto 0);
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  ip : in  STD_LOGIC;
			  st : in  STD_LOGIC;
			  --op : in  STD_LOGIC;
			  sw : in  STD_LOGIC_VECTOR(3 downto 0);
			  SSEG_CA 		: out  STD_LOGIC_VECTOR (6 downto 0);
			  SSEG_AN 		: out  STD_LOGIC_VECTOR (7 downto 0));
end key_exp;


--declaring arrays
--PACKAGE rc5_pkg IS
 
--END rc5_pkg;


architecture Behavioral of key_exp is


--declaring signals
signal in_l0 : std_logic_vector(7 downto 0);
signal in_l1 : std_logic_vector(7 downto 0);
signal in_l2 : std_logic_vector(7 downto 0);
signal in_l3 : std_logic_vector(7 downto 0);
signal in_l4 : std_logic_vector(7 downto 0);
signal in_l5 : std_logic_vector(7 downto 0);
signal in_l6 : std_logic_vector(7 downto 0);
signal in_l7 : std_logic_vector(7 downto 0);
signal in_l8 : std_logic_vector(7 downto 0);
signal in_l9 : std_logic_vector(7 downto 0);
signal in_l10 : std_logic_vector(7 downto 0);
signal in_l11 : std_logic_vector(7 downto 0);
signal in_l12 : std_logic_vector(7 downto 0);
signal in_l13 : std_logic_vector(7 downto 0);
signal in_l14 : std_logic_vector(7 downto 0);
signal in_l15 : std_logic_vector(7 downto 0);
signal a_reg : std_logic_vector(31 downto 0);

signal in_cnt : std_logic_vector(3 downto 0);
signal i_cnt : std_logic_vector(4 downto 0);
signal j_cnt : std_logic_vector(1 downto 0);
signal seg_cnt : std_logic_vector(2 downto 0);
signal a_temp1 : std_logic_vector(31 downto 0);
signal a_temp2 : std_logic_vector(31 downto 0);
signal b_reg : std_logic_vector(31 downto 0);

signal ab_temp : std_logic_vector(31 downto 0);
signal b_temp1 : std_logic_vector(31 downto 0);
signal b_temp2 : std_logic_vector(31 downto 0);
signal k_cnt : std_logic_vector(6 downto 0);
signal s_arr0 : std_logic_vector(31 downto 0);
signal s_arr25 : std_logic_vector(31 downto 0);
signal timer : integer;

TYPE   S_ARRAY IS ARRAY (0 TO 25) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
TYPE   L_ARRAY IS ARRAY (0 TO 3) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
signal l_arr : L_ARRAY;
signal s_arr_temp : S_ARRAY;



--defining states
Type statetype is( ST_idle,
						ST_INPUT,
						ST_KEY_IN,
						ST_KEY_EXP,
						ST_READY,
						ST_OUTPUT
						);
signal state : statetype;
						
begin


--using states
process(buttons, state, rst, clk, st)
 begin
   if(rst = '1') then
	  state <= ST_IDLE;
	elsif(clk'event and clk = '1') then
	  case state is 
	    When ST_IDLE => if(st = '1') then state <= ST_INPUT; end if;
		 When ST_INPUT => if(buttons = "1000") then state <= ST_KEY_IN; end if;
		 when ST_KEY_IN => state <= ST_KEY_EXP;
		 When ST_KEY_EXP => if(k_cnt = "1001110") then state <= ST_Ready; end if;
		 when ST_Ready => if(buttons = "0100") then state <= ST_OUTPUT; end if;
		 When ST_OUTPUT => if(buttons = "1100") then state <= ST_IDLE; end if;
		 WHEN others => state <= ST_idle;
     END CASE;
	end if;
 end process;
 



--count to take input
--process(rst, clk)
--begin
 --if(rst = '1') then
   --in_cnt <= "0000";
 --elsif(clk'event and clk = '1') then
   --if(in_cnt = "1000") then
	  --in_cnt <= "0000";
	--elsif(buttons(3) = '1') then
	  --in_cnt <= in_cnt + '1';
	--end if;
 --end if;
--end process;

process(rst, clk, state, s_arr_temp)
 begin
   if(rst = '1') then
	  s_arr0 <= "00000000000000000000000000000000";
	  s_arr25 <= "00000000000000000000000000000000";
	elsif(clk'event and clk = '1' and state = ST_READY) then
	  s_arr0 <= s_arr_temp(0);
	  s_arr25 <= s_arr_temp(25);
	end if;
 end process;

process(rst, state, buttons, clk, s_arr0, s_arr25, seg_cnt)
 begin
  if(rst = '1') then 
    SSEG_CA <= "0000000";
	 SSEG_AN <= "00000000";
	 seg_cnt <= "000";
	 timer <= 0;
  elsif(clk'event and clk = '1' and state = ST_output) then
    if(timer <= 8000) then timer <= timer + 1;
	 if(state = ST_OUTPUT and buttons = "0010" and seg_cnt = "000") then
	   SSEG_AN <= "01111111";
	   case s_arr0(31 downto 28) is --light up LED bar patterns according to HEX format
				 when "0000" => SSEG_CA<="1000000";
				 when "0001" => SSEG_CA<="1111001";
				 when "0010" => SSEG_CA<="0100100";
				 when "0011" => SSEG_CA<="0110000";
				 when "0100" => SSEG_CA<="0011011";
				 when "0101" => SSEG_CA<="0010010";
				 when "0110" => SSEG_CA<="0000010";
				 when "0111" => SSEG_CA<="1111000";
				 when "1000" => SSEG_CA<="0000000";
				 when "1001" => SSEG_CA<="0011000";
				 when "1010" => SSEG_CA<="0001000";
				 when "1011" => SSEG_CA<="0000011";
				 when "1100" => SSEG_CA<="1000110";
				 when "1101" => SSEG_CA<="0100001";
				 when "1110" => SSEG_CA<="0000100";
				 when others => SSEG_CA<="0001110";
	  end case;
	 elsif(state = ST_OUTPUT and buttons = "0001" and seg_cnt = "000") then
	   SSEG_AN <= "01111111";
	   case s_arr25(31 downto 28) is --light up LED bar patterns according to HEX format
				 when "0000" => SSEG_CA<="1000000";
				 when "0001" => SSEG_CA<="1111001";
				 when "0010" => SSEG_CA<="0100100";
				 when "0011" => SSEG_CA<="0110000";
				 when "0100" => SSEG_CA<="0011011";
				 when "0101" => SSEG_CA<="0010010";
				 when "0110" => SSEG_CA<="0000010";
				 when "0111" => SSEG_CA<="1111000";
				 when "1000" => SSEG_CA<="0000000";
				 when "1001" => SSEG_CA<="0011000";
				 when "1010" => SSEG_CA<="0001000";
				 when "1011" => SSEG_CA<="0000011";
				 when "1100" => SSEG_CA<="1000110";
				 when "1101" => SSEG_CA<="0100001";
				 when "1110" => SSEG_CA<="0000100";
				 when others => SSEG_CA<="0001110";
	  end case;
	  
	 elsif(state = ST_OUTPUT and buttons = "0010" and seg_cnt = "001") then
	   SSEG_AN <= "10111111";
	   case s_arr0(27 downto 24) is --light up LED bar patterns according to HEX format
				 when "0000" => SSEG_CA<="1000000";
				 when "0001" => SSEG_CA<="1111001";
				 when "0010" => SSEG_CA<="0100100";
				 when "0011" => SSEG_CA<="0110000";
				 when "0100" => SSEG_CA<="0011011";
				 when "0101" => SSEG_CA<="0010010";
				 when "0110" => SSEG_CA<="0000010";
				 when "0111" => SSEG_CA<="1111000";
				 when "1000" => SSEG_CA<="0000000";
				 when "1001" => SSEG_CA<="0011000";
				 when "1010" => SSEG_CA<="0001000";
				 when "1011" => SSEG_CA<="0000011";
				 when "1100" => SSEG_CA<="1000110";
				 when "1101" => SSEG_CA<="0100001";
				 when "1110" => SSEG_CA<="0000100";
				 when others => SSEG_CA<="0001110";
	  end case;
	  
	 elsif(state = ST_OUTPUT and buttons = "0001" and seg_cnt = "001") then
	   SSEG_AN <= "10111111";
	   case s_arr25(27 downto 24) is --light up LED bar patterns according to HEX format
		
				 when "0000" => SSEG_CA<="1000000";
				 when "0001" => SSEG_CA<="1111001";
				 when "0010" => SSEG_CA<="0100100";
				 when "0011" => SSEG_CA<="0110000";
				 when "0100" => SSEG_CA<="0011011";
				 when "0101" => SSEG_CA<="0010010";
				 when "0110" => SSEG_CA<="0000010";
				 when "0111" => SSEG_CA<="1111000";
				 when "1000" => SSEG_CA<="0000000";
				 when "1001" => SSEG_CA<="0011000";
				 when "1010" => SSEG_CA<="0001000";
				 when "1011" => SSEG_CA<="0000011";
				 when "1100" => SSEG_CA<="1000110";
				 when "1101" => SSEG_CA<="0100001";
				 when "1110" => SSEG_CA<="0000100";
				 when others => SSEG_CA<="0001110";
	  end case;
	  
	 elsif(state = ST_OUTPUT and buttons = "0010" and seg_cnt = "010") then
	   SSEG_AN <= "11011111";
	   case s_arr0(23 downto 20) is --light up LED bar patterns according to HEX format
				 when "0000" => SSEG_CA<="1000000";
				 when "0001" => SSEG_CA<="1111001";
				 when "0010" => SSEG_CA<="0100100";
				 when "0011" => SSEG_CA<="0110000";
				 when "0100" => SSEG_CA<="0011011";
				 when "0101" => SSEG_CA<="0010010";
				 when "0110" => SSEG_CA<="0000010";
				 when "0111" => SSEG_CA<="1111000";
				 when "1000" => SSEG_CA<="0000000";
				 when "1001" => SSEG_CA<="0011000";
				 when "1010" => SSEG_CA<="0001000";
				 when "1011" => SSEG_CA<="0000011";
				 when "1100" => SSEG_CA<="1000110";
				 when "1101" => SSEG_CA<="0100001";
				 when "1110" => SSEG_CA<="0000100";
				 when others => SSEG_CA<="0001110";
	  end case;
	 
	 elsif(state = ST_OUTPUT and buttons = "0001" and seg_cnt = "010") then
	   SSEG_AN <= "11011111";
	   case s_arr25(23 downto 20) is --light up LED bar patterns according to HEX format
				 when "0000" => SSEG_CA<="1000000";
				 when "0001" => SSEG_CA<="1111001";
				 when "0010" => SSEG_CA<="0100100";
				 when "0011" => SSEG_CA<="0110000";
				 when "0100" => SSEG_CA<="0011011";
				 when "0101" => SSEG_CA<="0010010";
				 when "0110" => SSEG_CA<="0000010";
				 when "0111" => SSEG_CA<="1111000";
				 when "1000" => SSEG_CA<="0000000";
				 when "1001" => SSEG_CA<="0011000";
				 when "1010" => SSEG_CA<="0001000";
				 when "1011" => SSEG_CA<="0000011";
				 when "1100" => SSEG_CA<="1000110";
				 when "1101" => SSEG_CA<="0100001";
				 when "1110" => SSEG_CA<="0000100";
				 when others => SSEG_CA<="0001110";
	  end case;
	  
	 elsif(state = ST_OUTPUT and buttons = "0010" and seg_cnt = "011") then
	   SSEG_AN <= "11101111";
	   case s_arr0(19 downto 16) is --light up LED bar patterns according to HEX format
				 when "0000" => SSEG_CA<="1000000";
				 when "0001" => SSEG_CA<="1111001";
				 when "0010" => SSEG_CA<="0100100";
				 when "0011" => SSEG_CA<="0110000";
				 when "0100" => SSEG_CA<="0011011";
				 when "0101" => SSEG_CA<="0010010";
				 when "0110" => SSEG_CA<="0000010";
				 when "0111" => SSEG_CA<="1111000";
				 when "1000" => SSEG_CA<="0000000";
				 when "1001" => SSEG_CA<="0011000";
				 when "1010" => SSEG_CA<="0001000";
				 when "1011" => SSEG_CA<="0000011";
				 when "1100" => SSEG_CA<="1000110";
				 when "1101" => SSEG_CA<="0100001";
				 when "1110" => SSEG_CA<="0000100";
				 when others => SSEG_CA<="0001110";
	  end case;
	  
	 elsif(state = ST_OUTPUT and buttons = "0001" and seg_cnt = "011") then
	   SSEG_AN <= "11101111";
	   case s_arr25(19 downto 16) is --light up LED bar patterns according to HEX format
				 when "0000" => SSEG_CA<="1000000";
				 when "0001" => SSEG_CA<="1111001";
				 when "0010" => SSEG_CA<="0100100";
				 when "0011" => SSEG_CA<="0110000";
				 when "0100" => SSEG_CA<="0011011";
				 when "0101" => SSEG_CA<="0010010";
				 when "0110" => SSEG_CA<="0000010";
				 when "0111" => SSEG_CA<="1111000";
				 when "1000" => SSEG_CA<="0000000";
				 when "1001" => SSEG_CA<="0011000";
				 when "1010" => SSEG_CA<="0001000";
				 when "1011" => SSEG_CA<="0000011";
				 when "1100" => SSEG_CA<="1000110";
				 when "1101" => SSEG_CA<="0100001";
				 when "1110" => SSEG_CA<="0000100";
				 when others => SSEG_CA<="0001110";
	  end case;
      
	elsif(state = ST_OUTPUT and buttons = "0010" and seg_cnt = "100") then
	   SSEG_AN <= "11110111";
	   case s_arr0(15 downto 12) is --light up LED bar patterns according to HEX format
				 when "0000" => SSEG_CA<="1000000";
				 when "0001" => SSEG_CA<="1111001";
				 when "0010" => SSEG_CA<="0100100";
				 when "0011" => SSEG_CA<="0110000";
				 when "0100" => SSEG_CA<="0011011";
				 when "0101" => SSEG_CA<="0010010";
				 when "0110" => SSEG_CA<="0000010";
				 when "0111" => SSEG_CA<="1111000";
				 when "1000" => SSEG_CA<="0000000";
				 when "1001" => SSEG_CA<="0011000";
				 when "1010" => SSEG_CA<="0001000";
				 when "1011" => SSEG_CA<="0000011";
				 when "1100" => SSEG_CA<="1000110";
				 when "1101" => SSEG_CA<="0100001";
				 when "1110" => SSEG_CA<="0000100";
				 when others => SSEG_CA<="0001110";
	  end case;
	  
	 elsif(state = ST_OUTPUT and buttons = "0001" and seg_cnt = "100") then
	   SSEG_AN <= "11110111";
	   case s_arr25(15 downto 12) is --light up LED bar patterns according to HEX format
				 when "0000" => SSEG_CA<="1000000";
				 when "0001" => SSEG_CA<="1111001";
				 when "0010" => SSEG_CA<="0100100";
				 when "0011" => SSEG_CA<="0110000";
				 when "0100" => SSEG_CA<="0011011";
				 when "0101" => SSEG_CA<="0010010";
				 when "0110" => SSEG_CA<="0000010";
				 when "0111" => SSEG_CA<="1111000";
				 when "1000" => SSEG_CA<="0000000";
				 when "1001" => SSEG_CA<="0011000";
				 when "1010" => SSEG_CA<="0001000";
				 when "1011" => SSEG_CA<="0000011";
				 when "1100" => SSEG_CA<="1000110";
				 when "1101" => SSEG_CA<="0100001";
				 when "1110" => SSEG_CA<="0000100";
				 when others => SSEG_CA<="0001110";
	  end case;
	  
	 elsif(state = ST_OUTPUT and buttons = "0010" and seg_cnt = "101") then
	   SSEG_AN <= "11111011";
	   case s_arr0(11 downto 8) is --light up LED bar patterns according to HEX format
				 when "0000" => SSEG_CA<="1000000";
				 when "0001" => SSEG_CA<="1111001";
				 when "0010" => SSEG_CA<="0100100";
				 when "0011" => SSEG_CA<="0110000";
				 when "0100" => SSEG_CA<="0011011";
				 when "0101" => SSEG_CA<="0010010";
				 when "0110" => SSEG_CA<="0000010";
				 when "0111" => SSEG_CA<="1111000";
				 when "1000" => SSEG_CA<="0000000";
				 when "1001" => SSEG_CA<="0011000";
				 when "1010" => SSEG_CA<="0001000";
				 when "1011" => SSEG_CA<="0000011";
				 when "1100" => SSEG_CA<="1000110";
				 when "1101" => SSEG_CA<="0100001";
				 when "1110" => SSEG_CA<="0000100";
				 when others => SSEG_CA<="0001110";
	  end case;
	  
	 elsif(state = ST_OUTPUT and buttons = "0001" and seg_cnt = "101") then
	   SSEG_AN <= "11111011";
	   case s_arr25(11 downto 8) is --light up LED bar patterns according to HEX format
				 when "0000" => SSEG_CA<="1000000";
				 when "0001" => SSEG_CA<="1111001";
				 when "0010" => SSEG_CA<="0100100";
				 when "0011" => SSEG_CA<="0110000";
				 when "0100" => SSEG_CA<="0011011";
				 when "0101" => SSEG_CA<="0010010";
				 when "0110" => SSEG_CA<="0000010";
				 when "0111" => SSEG_CA<="1111000";
				 when "1000" => SSEG_CA<="0000000";
				 when "1001" => SSEG_CA<="0011000";
				 when "1010" => SSEG_CA<="0001000";
				 when "1011" => SSEG_CA<="0000011";
				 when "1100" => SSEG_CA<="1000110";
				 when "1101" => SSEG_CA<="0100001";
				 when "1110" => SSEG_CA<="0000100";
				 when others => SSEG_CA<="0001110";
	  end case;
	  
	 elsif(state = ST_OUTPUT and buttons = "0010" and seg_cnt = "110") then
	   SSEG_AN <= "11111101";
	   case s_arr0(7 downto 4) is --light up LED bar patterns according to HEX format
				 when "0000" => SSEG_CA<="1000000";
				 when "0001" => SSEG_CA<="1111001";
				 when "0010" => SSEG_CA<="0100100";
				 when "0011" => SSEG_CA<="0110000";
				 when "0100" => SSEG_CA<="0011011";
				 when "0101" => SSEG_CA<="0010010";
				 when "0110" => SSEG_CA<="0000010";
				 when "0111" => SSEG_CA<="1111000";
				 when "1000" => SSEG_CA<="0000000";
				 when "1001" => SSEG_CA<="0011000";
				 when "1010" => SSEG_CA<="0001000";
				 when "1011" => SSEG_CA<="0000011";
				 when "1100" => SSEG_CA<="1000110";
				 when "1101" => SSEG_CA<="0100001";
				 when "1110" => SSEG_CA<="0000100";
				 when others => SSEG_CA<="0001110";
	  end case;
	  
	 elsif(state = ST_OUTPUT and buttons = "0001" and seg_cnt = "110") then
	   SSEG_AN <= "11111101";
	   case s_arr25(7 downto 4) is --light up LED bar patterns according to HEX format
				 when "0000" => SSEG_CA<="1000000";
				 when "0001" => SSEG_CA<="1111001";
				 when "0010" => SSEG_CA<="0100100";
				 when "0011" => SSEG_CA<="0110000";
				 when "0100" => SSEG_CA<="0011011";
				 when "0101" => SSEG_CA<="0010010";
				 when "0110" => SSEG_CA<="0000010";
				 when "0111" => SSEG_CA<="1111000";
				 when "1000" => SSEG_CA<="0000000";
				 when "1001" => SSEG_CA<="0011000";
				 when "1010" => SSEG_CA<="0001000";
				 when "1011" => SSEG_CA<="0000011";
				 when "1100" => SSEG_CA<="1000110";
				 when "1101" => SSEG_CA<="0100001";
				 when "1110" => SSEG_CA<="0000100";
				 when others => SSEG_CA<="0001110";
	  end case;
	  
	 elsif(state = ST_OUTPUT and buttons = "0010" and seg_cnt = "111") then
	   SSEG_AN <= "11111110";
	   case s_arr0(3 downto 0) is --light up LED bar patterns according to HEX format
				 when "0000" => SSEG_CA<="1000000";
				 when "0001" => SSEG_CA<="1111001";
				 when "0010" => SSEG_CA<="0100100";
				 when "0011" => SSEG_CA<="0110000";
				 when "0100" => SSEG_CA<="0011011";
				 when "0101" => SSEG_CA<="0010010";
				 when "0110" => SSEG_CA<="0000010";
				 when "0111" => SSEG_CA<="1111000";
				 when "1000" => SSEG_CA<="0000000";
				 when "1001" => SSEG_CA<="0011000";
				 when "1010" => SSEG_CA<="0001000";
				 when "1011" => SSEG_CA<="0000011";
				 when "1100" => SSEG_CA<="1000110";
				 when "1101" => SSEG_CA<="0100001";
				 when "1110" => SSEG_CA<="0000100";
				 when others => SSEG_CA<="0001110";
	  end case;
	  
	 elsif(state = ST_OUTPUT and buttons = "0001" and seg_cnt = "111") then
	   SSEG_AN <= "11111110";
	   case s_arr25(3 downto 0) is --light up LED bar patterns according to HEX format
				 when "0000" => SSEG_CA<="1000000";
				 when "0001" => SSEG_CA<="1111001";
				 when "0010" => SSEG_CA<="0100100";
				 when "0011" => SSEG_CA<="0110000";
				 when "0100" => SSEG_CA<="0011011";
				 when "0101" => SSEG_CA<="0010010";
				 when "0110" => SSEG_CA<="0000010";
				 when "0111" => SSEG_CA<="1111000";
				 when "1000" => SSEG_CA<="0000000";
				 when "1001" => SSEG_CA<="0011000";
				 when "1010" => SSEG_CA<="0001000";
				 when "1011" => SSEG_CA<="0000011";
				 when "1100" => SSEG_CA<="1000110";
				 when "1101" => SSEG_CA<="0100001";
				 when "1110" => SSEG_CA<="0000100";
				 when others => SSEG_CA<="0001110";
	  end case;
	  end if;
	  elsif (timer > 8000) then 
	if (seg_cnt = "111") then seg_cnt <= "000"; timer <= 0;
	else seg_cnt <= seg_cnt+'1'; timer <= 0;
	end if;
	 end if;
   end if;
 end process;



--takin input and also refining L
process(rst, clk, in_l0, in_l1, in_l2, in_l3, in_l4, in_l5, in_l6, in_l7, in_l8, in_l9, in_l10, in_l11, in_l12, in_l13, in_l14, in_l15, ip, sw, swin)
begin
 if(rst = '1') then
   in_l0 <= "00000000";
	in_l1 <= "00000000";
	in_l2 <= "00000000";
	in_l3 <= "00000000";
	in_l4 <= "00000000";
	in_l5 <= "00000000";
	in_l6 <= "00000000";
	in_l7 <= "00000000";
	in_l8 <= "00000000";
	in_l9 <= "00000000";
	in_l10 <= "00000000";
	in_l11 <= "00000000";
	in_l12 <= "00000000";
	in_l13 <= "00000000";
	in_l14 <= "00000000";
	in_l15 <= "00000000";
	
 elsif(clk'event and clk = '1') then
   if(sw(3 downto 0) = "0000" and state = ST_INPUT) then
	  in_l0 <= swin(7 downto 0);
   elsif(sw(3 downto 0) = "0001" and state = ST_INPUT) then
	  in_l1 <= swin(7 downto 0);
	elsif(sw(3 downto 0) = "0010" and state = ST_INPUT) then
	  in_l2 <= swin(7 downto 0);
	elsif(sw(3 downto 0) = "0011" and state = ST_INPUT) then
	  in_l3 <= swin(7 downto 0);
	elsif(sw(3 downto 0) = "0100" and state = ST_INPUT) then
	  in_l4 <= swin(7 downto 0);
   elsif(sw(3 downto 0) = "0101" and state = ST_INPUT) then
	  in_l5 <= swin(7 downto 0);
	elsif(sw(3 downto 0) = "0110" and state = ST_INPUT) then
	  in_l6 <= swin(7 downto 0);
	elsif(sw(3 downto 0) = "0111" and state = ST_INPUT) then
	  in_l7 <= swin(7 downto 0);
	elsif(sw(3 downto 0) = "1000" and state = ST_INPUT) then
	  in_l8 <= swin(7 downto 0);
	  elsif(sw(3 downto 0) = "1001" and state = ST_INPUT) then
	  in_l9 <= swin(7 downto 0);
	  elsif(sw(3 downto 0) = "1010" and state = ST_INPUT) then
	  in_l10 <= swin(7 downto 0);
	  elsif(sw(3 downto 0) = "1011" and state = ST_INPUT) then
	  in_l11 <= swin(7 downto 0);
	  elsif(sw(3 downto 0) = "1100" and state = ST_INPUT) then
	  in_l12 <= swin(7 downto 0);
	  elsif(sw(3 downto 0) = "1101" and state = ST_INPUT) then
	  in_l13 <= swin(7 downto 0);
	  elsif(sw(3 downto 0) = "1110" and state = ST_INPUT) then
	  in_l14 <= swin(7 downto 0);
	  elsif(sw(3 downto 0) = "1111" and state = ST_INPUT) then
	  in_l15 <= swin(7 downto 0);
	  end if;
 end if;
	  end process;
	  
process (clk, state, ip, rst)
 begin
   if(rst = '1') then
	  l_arr(0) <= "00000000000000000000000000000000";
	  l_arr(1) <= "00000000000000000000000000000000";
	  l_arr(2) <= "00000000000000000000000000000000";
	  l_arr(3) <= "00000000000000000000000000000000";
	elsif (clk'event and clk = '1') then 
	if(state = ST_INPUT and ip = '1') then
	  l_arr(0) <= in_l0 & in_l1 & in_l2 & in_l3;
	  l_arr(1) <= in_l4 & in_l5 & in_l6 & in_l7;
	  l_arr(2) <= in_l8 & in_l9 & in_l10 & in_l11;
	  l_arr(3) <= in_l12 & in_l13 & in_l14 & in_l15;
	elsif(state = ST_KEY_EXP) then
	  l_arr(conv_integer(j_cnt)) <= b_temp2;
	end if;
 end if;
end process;



--counter fir i
process(rst, clk)
 begin
   if(rst = '1') then
	  i_cnt <= "00000";
	elsif(clk'event and clk = '1') then
	  if(state = ST_KEY_EXP) then
	    if(i_cnt = "11001") then
	      i_cnt <= "00000";
	    else 
	      i_cnt <= i_cnt + '1';
	    end if;
	  end if;
	end if;
end process;


--count for j
process(rst, clk)
 begin
   if(rst = '1') then
	  j_cnt <= "00";
	elsif(clk'event and clk = '1') then
	  if(state = ST_KEY_EXP) then
	    if(j_cnt = "11") then
	      j_cnt <= "00";
	    else 
	      j_cnt <= j_cnt + '1';
	    end if;
	  end if;
	end if;
end process;


--count to 78 times
process(rst, clk)
 begin
   if(rst = '1') then
	  k_cnt <= "0000000";
	elsif(clk'event and clk = '1') then
	  if(state = ST_KEY_EXP) then
	    if(k_cnt = "1001110") then
		   k_cnt <= "0000000";
		 else
		   k_cnt <= k_cnt + 1;
		 end if;
	  end if;
	end if;
 end process;


--creating ROM
process(rst, clk)
 begin
   if(rst = '1') then
	  s_arr_temp(0) <= "10110111111000010101000101100011"; 
	  s_arr_temp(1) <= "01010110000110001100101100011100";
	  s_arr_temp(2) <= "11110100010100000100010011010101";
	  s_arr_temp(3) <= "10010010100001111011111010001110";
	  s_arr_temp(4) <= "00110000101111110011100001000111";
	  s_arr_temp(5) <= "11001110111101101011001000000000";
	  s_arr_temp(6) <= "01101101001011100010101110111001";
	  s_arr_temp(7) <= "00001011011001011010010101110010";
	  s_arr_temp(8) <= "10101001100111010001111100101011";
	  s_arr_temp(9) <= "01000111110101001001100011100100";
	  s_arr_temp(10) <= "11100110000011000001001010011101";
	  s_arr_temp(11) <= "10000100010000111000110001010110";
	  s_arr_temp(12) <= "00100010011110110000011000001111";
	  s_arr_temp(13) <= "11000000101100100111111111001000";
	  s_arr_temp(14) <= "01011110111010011111100110000001";
	  s_arr_temp(15) <= "11111101001000010111001100111010";
	  s_arr_temp(16) <= "10011011010110001110110011110011";
	  s_arr_temp(17) <= "00111001100100000110011010101100";
	  s_arr_temp(18) <= "11010111110001111110000001100101";
	  s_arr_temp(19) <= "01110101111111110101101000011110";
	  s_arr_temp(20) <= "00010100001101101101001111010111";
	  s_arr_temp(21) <= "10110010011011100100110110010000";
	  s_arr_temp(22) <= "01010000101001011100011101001001";
	  s_arr_temp(23) 	<= "11101110110111010100000100000010";
	  s_arr_temp(24) <= "10001101000101001011101010111011";
	  s_arr_temp(25) <= "00101011010011000011010001110100";
	elsif(clk'event and clk = '1') then
	  if(state = ST_KEY_EXP) then
	    s_arr_temp(conv_integer(i_cnt)) <= a_temp2;
	  end if;
	end if;
 end process;
 	  


--a_reg
process(rst, clk)
 begin
   if(rst = '1') then 
	  a_reg <= "00000000000000000000000000000000";
	elsif(clk'event and clk = '1') then
	  if(state = ST_KEY_EXP) then
  	    a_reg <= a_temp2;
	  end if;
	end if;
end process;


--b_reg
process(rst, clk)
 begin
   if(rst = '1') then 
	  b_reg <= "00000000000000000000000000000000";
	elsif(clk'event and clk = '1') then
	  if(state = ST_KEY_EXP) then
  	    b_reg <= b_temp2;
	  end if;
	end if;
end process;
	
--operations
a_temp1 <= s_arr_temp(conv_integer(i_cnt)) + a_reg + b_reg;
a_temp2 <= a_temp1(28 downto 0) & a_temp1(31 downto 29);
ab_temp <= a_temp2 + b_reg;
b_temp1 <= l_arr(conv_integer(j_cnt)) + ab_temp;
with ab_temp(4 downto 0) select
  b_temp2 <= b_temp1(30 DOWNTO 0) & b_temp1(31) WHEN "00001",
            b_temp1(29 DOWNTO 0) & b_temp1(31 DOWNTO 30) WHEN "00010", 
	         b_temp1(28 DOWNTO 0) & b_temp1(31 DOWNTO 29) WHEN "00011",
            b_temp1(27 DOWNTO 0) & b_temp1(31 DOWNTO 28) WHEN "00100",
            b_temp1(26 DOWNTO 0) & b_temp1(31 DOWNTO 27) WHEN "00101",
            b_temp1(25 DOWNTO 0) & b_temp1(31 DOWNTO 26) WHEN "00110",
            b_temp1(24 DOWNTO 0) & b_temp1(31 DOWNTO 25) WHEN "00111",
            b_temp1(23 DOWNTO 0) & b_temp1(31 DOWNTO 24) WHEN "01000",
            b_temp1(22 DOWNTO 0) & b_temp1(31 DOWNTO 23) WHEN "01001",
            b_temp1(21 DOWNTO 0) & b_temp1(31 DOWNTO 22) WHEN "01010",
            b_temp1(20 DOWNTO 0) & b_temp1(31 DOWNTO 21) WHEN "01011",
            b_temp1(19 DOWNTO 0) & b_temp1(31 DOWNTO 20) WHEN "01100",
            b_temp1(18 DOWNTO 0) & b_temp1(31 DOWNTO 19) WHEN "01101",
            b_temp1(17 DOWNTO 0) & b_temp1(31 DOWNTO 18) WHEN "01110",
            b_temp1(16 DOWNTO 0) & b_temp1(31 DOWNTO 17) WHEN "01111",
            b_temp1(15 DOWNTO 0) & b_temp1(31 DOWNTO 16) WHEN "10000",
            b_temp1(14 DOWNTO 0) & b_temp1(31 DOWNTO 15) WHEN "10001",
            b_temp1(13 DOWNTO 0) & b_temp1(31 DOWNTO 14) WHEN "10010",
            b_temp1(12 DOWNTO 0) & b_temp1(31 DOWNTO 13) WHEN "10011",
				b_temp1(11 DOWNTO 0) & b_temp1(31 DOWNTO 12) WHEN "10100",
				b_temp1(10 DOWNTO 0) & b_temp1(31 DOWNTO 11) WHEN "10101",
				b_temp1(9 DOWNTO 0) & b_temp1(31 DOWNTO 10) WHEN "10110",
				b_temp1(8 DOWNTO 0) & b_temp1(31 DOWNTO 9) WHEN "10111",
				b_temp1(7 DOWNTO 0) & b_temp1(31 DOWNTO 8) WHEN "11000",
				b_temp1(6 DOWNTO 0) & b_temp1(31 DOWNTO 7) WHEN "11001",
				b_temp1(5 DOWNTO 0) & b_temp1(31 DOWNTO 6) WHEN "11010",
				b_temp1(4 DOWNTO 0) & b_temp1(31 DOWNTO 5) WHEN "11011",
				b_temp1(3 DOWNTO 0) & b_temp1(31 DOWNTO 4) WHEN "11100",
				b_temp1(2 DOWNTO 0) & b_temp1(31 DOWNTO 3) WHEN "11101",
				b_temp1(1 DOWNTO 0) & b_temp1(31 DOWNTO 2) WHEN "11110",
				b_temp1(0) & b_temp1(31 DOWNTO 1) WHEN "11111",
				b_temp1 WHEN OTHERS;



end Behavioral;