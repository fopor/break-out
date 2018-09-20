library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controle_pontos is
	
	port (clk27M		    : in std_logic;
		rstn 	    		    : in std_logic;
		colision  		    : in std_logic;
		jogo_start 			 : in std_logic;
		ball_Y				 : in integer range 0 to 95; --sinal para saber que perdemos uma vida
		LEDR               : out std_logic_vector(9 downto 0); 
		reset_ball         : out std_logic; --sinal para reposicionarmos a bola apos perdemos uma vida
		reset_brick        : out std_logic;
		speed_control      : out std_logic;
		game_over_control  : out std_logic;
		win_game_control   : out std_logic;
		brick_condition    : in std_logic_vector (128 downto 0);
		brick_condition2   : in std_logic_vector(128 downto 0);
		brick_condition3   : in std_logic_vector(128 downto 0);
		n_pontos 			 : out integer range 0 to 128;
		trapaca 				 : in std_logic
		);
	
end controle_pontos;

architecture behavior of controle_pontos is
	begin
	
	process(clk27M)
		variable contador 		 : integer range 0 to 450000;
	   variable tempo_passado   : integer range 0 to 999999999;
		variable vidas_restantes : integer range 0 to 4;
		variable fase 				 : integer range 0 to 1;
		variable jogo_espera 	 : std_logic;
		variable game_over_flag  : std_logic;
		variable win_game_flag   : std_logic;
		
	   begin
		
		if (clk27M'event and clk27M = '1') then
			if (rstn = '0') then
				tempo_passado := 0;
				vidas_restantes := 4;
				fase := 0;
				reset_ball <= '0';
				reset_brick <= '0';
				speed_control <= '0';
				game_over_control <= '0';
				win_game_control <= '0';
				LEDR <= "0000000111";
				jogo_espera := '1';
				n_pontos <= 5;
				game_over_flag := '0';
				win_game_flag := '0';
				
			elsif (jogo_espera = '1') then
				reset_ball <= '0';
				if(jogo_start = '0') then
					jogo_espera := '0';
				end if;
			
			else
				contador := contador + 1;
				reset_ball <= '1';
				reset_brick <= '1';
			
			-- Contador para manter os 60 Hz de frequencia
				if contador >= 449999 then
					contador := 0;
					tempo_passado := tempo_passado + 1;
					
					--perde uma vida
					if(ball_Y > 93) then
						vidas_restantes := vidas_restantes - 1;
						
						if(vidas_restantes = 3) then
							LEDR <= "0000000011";
							
						elsif(vidas_restantes = 2) then
							LEDR <= "0000000001";
						
						elsif(vidas_restantes = 1) then
							LEDR <= "0000000000";
							
						elsif(vidas_restantes = 0 AND trapaca = '0') then
							game_over_control <='1';
							game_over_flag :='1';
							
						end if;
						
						reset_ball <= '0';
					end if;
					
					--verifica se avancamos de fase
					if(unsigned (brick_condition(128 downto 0) OR brick_condition2 (128 downto 0) OR brick_condition3 (128 downto 0)) = 0) then
						if(fase = 1) then
							win_game_control <= '1';
							win_game_flag := '1';
						end if;
						
						reset_brick <= '0';
						reset_ball <= '0';
						speed_control <= '1';
						fase := 1;
					end if;
					
					--decide quanto vale cada tijolo de acordo com o tempo passado
					if(colision = '1') then
						--pontos feitos antes de 10 segundos
						if(tempo_passado <= 600 ) then 
							n_pontos <= 5;
							
						elsif (tempo_passado <= 2000) then
							n_pontos <= 3;
							
						elsif (tempo_passado <= 3000) then
							n_pontos <= 2;
							
						else 
							n_pontos <= 1;
						end if;
					end if;
					
					--se estamos em game_over entao 'seguramos' a bola
					if(game_over_flag = '1' OR win_game_flag = '1') then
						reset_ball <='0'; --impede a bola de continuar marcando pontos
												--depois do game over
					end if;
				
				end if;
			end if;
		end if;	
	end process;

	
end behavior;
