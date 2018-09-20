LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY contador_pontos IS
	PORT ( 	Clock								   : in STD_LOGIC;
				Enable								: in STD_LOGIC;
				n_pontos 						   : in integer range 0 to 128;
				Clear    							: IN STD_LOGIC;
				BCD3, BCD2, BCD1, BCD0	 		: BUFFER  STD_LOGIC_VECTOR(3 DOWNTO 0)
				);
	END contador_pontos ;
	
ARCHITECTURE Behavior OF contador_pontos IS
	
		BEGIN
		PROCESS ( Clock )
			variable contador : integer range 0 to 450000;
			BEGIN
				IF Clock'EVENT AND Clock = '1' THEN
					contador := contador + 1;
					
					IF Clear = '0' OR  (BCD3 = "1001" AND BCD2 = "1001" AND
											  BCD1 = "1001" AND BCD0 = "1001") THEN
					--zera a contagem atual
					BCD0 <= "0000" ; BCD1 <= "0000";
					BCD2 <= "0000" ; BCD3 <= "0000";
					
					ELSIF Enable = '1' AND (contador >= (449999)/n_pontos) THEN
						contador := 0;
							IF(BCD1 = "1001") THEN
								BCD1 <= "0000";
								BCD2 <= BCD2+1;
							ELSE
								IF (BCD0 = "1001") THEN
									BCD0 <= "0000";
									BCD1 <= BCD1+1;
								ELSE
									BCD0 <= BCD0 +1;
								END IF;
							END IF;
					END IF;
				END IF ;
			END PROCESS;
END Behavior ;
