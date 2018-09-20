LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY display7seg IS

	port (Inp : in std_logic_vector(3 downto 0);
			Xis : out std_logic_vector(6 downto 0)
	);		  

END display7seg;

ARCHITECTURE Behavior OF display7seg IS
	
BEGIN 
	WITH Inp SELECT
		Xis <= "1000000" WHEN "0000",  -- 0
			"1111001" WHEN "0001",  -- 1
			"0100100" WHEN "0010",  -- 2
			"0110000" WHEN "0011",  -- 3
		   "0011001" WHEN "0100",	-- 4
		   "0010010" WHEN "0101",	-- 5
		   "0000010" WHEN "0110",  -- 6
  			"1111000" WHEN "0111",  -- 7
			"0000000" WHEN "1000",	-- 8
			"0011000" WHEN "1001",	-- 9
		 
			"1000000" WHEN OTHERS ;

END Behavior;