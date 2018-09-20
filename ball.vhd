library ieee;
use ieee.std_logic_1164.all;

entity ball is
	
	port (clk27M		 : in std_logic;
			rstn 			 : in std_logic;
			paddle_size : in integer range 0 to 10;
			paddle_X		 : in integer range 0 to 128;
			paddle_Y		 : in integer range 0 to 95;
			ball_X		 : buffer integer range 0 to 128;
			ball_Y		 : buffer integer range 0 to 95;
			colision 	 : in std_logic;
			trapaca      : in std_logic;
			speed_control : in std_logic);
			
end ball;

architecture behavior of ball is
	
	--marca a direcao pra qual a bolinha esta indo: 1 = direita, 0 = esquerda
	signal direcaoX : std_logic;

	--marca a direcao para qual a bolinha esta indo: 1 = pra cima, 0 = pra baixo XD
	signal direcaoY : std_logic;
	
	begin
	
	process(clk27M)
	  variable contador : integer range 0 to 450000;
	  variable speed_flag : std_logic;
	  
	  begin
		
		 if (clk27M'event and clk27M = '1') then
			--TODO VERIFICAR COMO DEIXAR ESSE RESET ASSINCRONO (ESTA SINCRONO POR ENQUANTO)
			if (rstn = '0') then
				ball_X <= 64;
				ball_Y <= 79;
				direcaoX <= '1';
				direcaoY <= '1';
			end if;
		 
			contador := contador + 1;
			speed_flag := not(speed_flag);
			
			-- Contador para manter os 60 Hz de frequencia
			if contador >= 449999 then
				contador := 0;
				
				if(colision = '1') then 
					direcaoY <= not(direcaoY);
					if(ball_Y < 22 AND direcaoY = '1') then
						direcaoX <= not(direcaoX);
					end if;
					
				end if;
				
				--bolinha indo para a direita
				if (direcaoX = '1') then
					--bater na parede direita					
					if(ball_X = 127) then
						direcaoX <= '0';				
					elsif(speed_control = '1' OR speed_flag=	'1') then
						ball_X <= ball_X+1;
					
					end if;
				end if;	
			 
				--bolinha indo para a esquerda
				if(direcaoX = '0') then
					--bater na parede esquerda
					if(ball_X = 2) then
						direcaoX <= '1';
						
						--momento da bolinha
						elsif (speed_control = '1' OR speed_flag= '1') then 
							ball_X <= ball_X-1;
					end if;
				end if;
					
				--bolinha indo pra cima
				if (direcaoY = '1') then
					if(ball_Y = 0) then
						direcaoY <= '0';
					
					else
						ball_Y <= ball_Y-1;
					end if;
				end if;	
				
				--bolinha indo para baixo
				if(direcaoY = '0') then
					--se o modo trapaca esta ligado, a bola fica presa na regiao das barras
					if(trapaca = '1' and ball_Y = 30) then
						direcaoY <= '1';
					
					elsif( (paddle_Y = ball_Y) and  (ball_X >= paddle_X - paddle_size  and ball_X <= paddle_X + paddle_size)   ) then
						direcaoY <= '1';
						
						if ball_X >= paddle_X then
							direcaoX <='1';
						
						elsif ball_X <paddle_X then
							direcaoX <= '0';
						end if;
							
						else
							ball_Y <= ball_Y +1;
					end if;
				end if;
			end if;
		end if;	
	end process;
end behavior;
