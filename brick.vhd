library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
USE IEEE.NUMERIC_STD.ALL;

entity brick is
	
	port (clk27M		 : in std_logic;
		rstn 			    : in std_logic;
		ball_X		    : in integer range 0 to 128;
		ball_Y		 	 : in integer range 0 to 95;
		colision 	 	 : out std_logic;
		condition    	 : buffer std_logic_vector (128 downto 0);
		condition2   	 : buffer std_logic_vector (128 downto 0);
		condition3   	 : buffer std_logic_vector (128 downto 0));
	
end brick;

architecture behavior of brick is
	
	signal temp 					: std_logic;
	signal contadorDelayFlag 	: std_logic;
	
	begin

	process(clk27M)
		variable contador : integer range 0 to 450000;
		variable aux : integer range 0 to 300;
		variable contadorDelay : integer range 0 to 4500000;
	  
	   begin
		
		if (clk27M'event and clk27M = '1') then
			if (rstn = '0') then
				for I in 0 to 127 loop
					condition(I) <= '1';
					condition2(I) <= '1';
					condition3(I) <= '1';
				end loop;		
				contadorDelayFlag <= '1';
			end if;
		 
			contador := contador + 1;
			
			if( contadorDelayFlag = '0' AND  contadorDelay >= 4499999 ) then
				contadorDelay := 0;
				contadorDelayFlag <= '1';
			end if;
			
			if ( contadorDelay < 4499999 AND contadorDelayFlag = '0' ) then
				contadorDelay := contadorDelay + 1;
			end if;
		
			-- Contador para manter os 60 Hz de frequencia
			if contador >= 449999 then 
				contador := 0;
				
				temp <= '0';
			 
				--colisao com a barra
				if ( contadorDelayFlag = '1' AND (ball_Y = 5 OR ball_Y = 6 OR ball_Y = 7 or ball_Y = 8 OR ball_Y = 9 OR ball_Y = 10 OR ball_Y = 11 or ball_Y = 12 or ball_Y = 13 OR ball_Y = 14) )then
					if(condition(ball_X) = '1') then
						contadorDelayFlag <= '0'; --voltar pra zero
						temp <= '1';
						aux := ball_X / 8;
						aux := aux * 8;
						for I in 0 to 7 loop
							condition(aux+I) <= '0';
						end loop;
					end if;
					
				end if;
				
				if ( contadorDelayFlag = '1' AND ( ball_Y = 20 OR ball_Y = 19 OR ball_Y = 18 or ball_Y = 17 OR ball_Y = 16 OR ball_Y = 15 OR ball_Y = 21 or ball_Y = 22) )then
					if(condition2(ball_X) = '1') then
						contadorDelayFlag <= '0';
						temp <= '1';
						aux := ball_X / 8;
						aux := aux * 8;
						for I in 0 to 7 loop
							condition2(aux+I) <= '0';
						end loop;
					end if;	
				end if;
					
					
				if ( contadorDelayFlag = '1' AND (ball_Y = 28 OR ball_Y = 27 OR ball_Y = 26 or ball_Y = 25 OR ball_Y = 24 OR ball_Y = 23 OR ball_Y = 30 or ball_Y = 29) )then
					if(condition3(ball_X) = '1') then
						contadorDelayFlag <= '0';
						temp <= '1';
						aux := ball_X / 8;
						aux := aux * 8;
						for I in 0 to 7 loop
							condition3(aux+I) <= '0';
						end loop;
					end if;
				end if;
				
			end if;
		end if;
	end process;
	
	colision <= temp;
	
end behavior;
