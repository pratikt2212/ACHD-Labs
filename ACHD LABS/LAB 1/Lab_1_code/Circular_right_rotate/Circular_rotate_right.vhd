----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:35:03 09/25/2016 
-- Design Name: 
-- Module Name:    Circular_rotate_right - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Circular_rotate_right is
    Port ( ford : in  STD_LOGIC_VECTOR (31 downto 0);
           gm : in  STD_LOGIC_VECTOR (8 downto 0);
           lambo : out  STD_LOGIC_VECTOR (31 downto 0));
end Circular_rotate_right;

architecture Behavioral of Circular_rotate_right is

begin
with gm(4 downto 0) select
lambo <= ford(0) & ford(31 DOWNTO 1) WHEN "00001",
	  ford(1 DOWNTO 0) & ford(31 DOWNTO 2) WHEN "00010",
	  ford(2 DOWNTO 0) & ford(31 DOWNTO 3) WHEN "00011",
	  ford(3 DOWNTO 0) & ford(31 DOWNTO 4) WHEN "00100",
	  ford(4 DOWNTO 0) & ford(31 DOWNTO 5) WHEN "00101",
	  ford(5 DOWNTO 0) & ford(31 DOWNTO 6) WHEN "00110",
	  ford(6 DOWNTO 0) & ford(31 DOWNTO 7) WHEN "00111",
	  ford(7 DOWNTO 0) & ford(31 DOWNTO 8) WHEN "01000",
	  ford(8 DOWNTO 0) & ford(31 DOWNTO 9) WHEN "01001",
	  ford(9 DOWNTO 0) & ford(31 DOWNTO 10) WHEN "01010",
	  ford(10 DOWNTO 0) & ford(31 DOWNTO 11) WHEN "01011",
	  ford(11 DOWNTO 0) & ford(31 DOWNTO 12) WHEN "01100",
	  ford(12 DOWNTO 0) & ford(31 DOWNTO 13) WHEN "01101",
	  ford(13 DOWNTO 0) & ford(31 DOWNTO 14) WHEN "01110",
	  ford(14 DOWNTO 0) & ford(31 DOWNTO 15) WHEN "01111",
	  ford(15 DOWNTO 0) & ford(31 DOWNTO 16) WHEN "10000",
	  ford(16 DOWNTO 0) & ford(31 DOWNTO 17) WHEN "10001",
	  ford(17 DOWNTO 0) & ford(31 DOWNTO 18) WHEN "10010",
	  ford(18 DOWNTO 0) & ford(31 DOWNTO 19) WHEN "10011",
	  ford(19 DOWNTO 0) & ford(31 DOWNTO 20) WHEN "10100",
	  ford(20 DOWNTO 0) & ford(31 DOWNTO 21) WHEN "10101",
	  ford(21 DOWNTO 0) & ford(31 DOWNTO 22) WHEN "10110",
	  ford(22 DOWNTO 0) & ford(31 DOWNTO 23) WHEN "10111",
	  ford(23 DOWNTO 0) & ford(31 DOWNTO 24) WHEN "11000",
	  ford(24 DOWNTO 0) & ford(31 DOWNTO 25) WHEN "11001",
	  ford(25 DOWNTO 0) & ford(31 DOWNTO 26) WHEN "11010",
	  ford(26 DOWNTO 0) & ford(31 DOWNTO 27) WHEN "11011",
	  ford(27 DOWNTO 0) & ford(31 DOWNTO 28) WHEN "11100",
	  ford(28 DOWNTO 0) & ford(31 DOWNTO 29) WHEN "11101",
	  ford(29 DOWNTO 0) & ford(31 DOWNTO 30) WHEN "11110",
	  ford(30 DOWNTO 0) & ford(31) WHEN "11111",
	  ford WHEN OTHERS;



end Behavioral;

