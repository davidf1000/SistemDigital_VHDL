LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY TRAFFIC IS
PORT ( 
		clock, reset, day, emergency : IN STD_LOGIC;
		M_US, K_US, H_US, M_BT, K_BT, H_BT : OUT STD_LOGIC);
END TRAFFIC;
		
ARCHITECTURE behavioral OF TRAFFIC IS 
	TYPE state is (S0, S1, S2, S3, S4, E0, E1);
	SIGNAL y: state;
	SIGNAL counter : STD_LOGIC_VECTOR(4 downto 0);
	CONSTANT SEC8 : STD_LOGIC_VECTOR(4 downto 0) := "11000";
	CONSTANT SEC2 : STD_LOGIC_VECTOR(4 downto 0) := "00110";
	CONSTANT SEC4 : STD_LOGIC_VECTOR(4 downto 0) := "01100";
	CONSTANT SEC1 : STD_LOGIC_VECTOR(4 downto 0) := "00011";
	CONSTANT SEC3 : STD_LOGIC_VECTOR(4 downto 0) := "01001";
	
COMPONENT CLOCKDIV IS
PORT(
	CLK: IN std_logic;
	DIVOUT: buffer BIT);
END COMPONENT
	
BEGIN 
PROCESS (clock, reset, day, emergency, y)
BEGIN
IF reset = '1' THEN
	y <= S0;
	counter <= "00000";
ELSIF clock'event AND clock = '1' THEN
CASE y IS
		WHEN S0 =>
			IF (emergency = '0') THEN
				IF (day = '1') THEN
					IF counter < SEC8 THEN
						y <= S0;
						counter <= counter + 1;
					ELSE 
						y <= S1;
						counter <= "00000";
					END IF;
				ELSE 
					IF counter < SEC4 THEN
							y <= S0;
							counter <= counter + 1;
					ELSE 
							y <= S1;
							counter <= "00000";
					END IF;
				END IF;
			ELSE	
				y <= E0;
				counter <= "00000";
			END IF;
			M_US <= '1';
			K_US <= '0'; 
			H_US <= '0';
			M_BT <= '0'; 
			K_BT <= '0';
			H_BT <= '1';
		WHEN S1 =>
			IF (emergency = '0') THEN
				IF (day = '1') THEN
					IF counter < SEC2 THEN
						y <= S1;
						counter <= counter + 1;
					ELSE 
						y <= S2;
						counter <= "00000";
					END IF;
				ELSE 
					IF counter < SEC1 THEN
							y <= S1;
							counter <= counter + 1;
					ELSE 
							y <= S2;
							counter <= "00000";
					END IF;
				END IF;
			ELSE	
				y <= E0;
				counter <= "00000";
			END IF;
			M_US <= '1';
			K_US <= '0'; 
			H_US <= '0';
			M_BT <= '0'; 
			K_BT <= '1';
			H_BT <= '0';
		WHEN S2 =>
			IF (emergency = '0') THEN
				IF (day = '1') THEN
					IF counter < SEC2 THEN
						y <= S2;
						counter <= counter + 1;
					ELSE 
						y <= S3;
						counter <= "00000";
					END IF;
				ELSE 
					IF counter < SEC1 THEN
							y <= S2;
							counter <= counter + 1;
					ELSE 
							y <= S3;
							counter <= "00000";
					END IF;
				END IF;
			ELSE	
				y <= E0;
				counter <= "00000";
			END IF;
			M_US <= '0';
			K_US <= '1'; 
			H_US <= '0';
			M_BT <= '1'; 
			K_BT <= '0';
			H_BT <= '0';
		WHEN S3 =>
			IF (emergency = '0') THEN
				IF (day = '1') THEN
					IF counter < SEC8 THEN
						y <= S3;
						counter <= counter + 1;
					ELSE 
						y <= S4;
						counter <= "00000";
					END IF;
				ELSE 
					IF counter < SEC4 THEN
							y <= S3;
							counter <= counter + 1;
					ELSE 
							y <= S4;
							counter <= "00000";
					END IF;
				END IF;
			ELSE	
				y <= E0;
				counter <= "00000";
			END IF;
			M_US <= '0';
			K_US <= '0'; 
			H_US <= '1';
			M_BT <= '1'; 
			K_BT <= '0';
			H_BT <= '0';		
		WHEN S4 =>
			IF (emergency = '0') THEN
				IF (day = '1') THEN
					IF counter < SEC2 THEN
						y <= S4;
						counter <= counter + 1;
					ELSE 
						y <= S0;
						counter <= "00000";
					END IF;
				ELSE 
					IF counter < SEC1 THEN
							y <= S4;
							counter <= counter + 1;
					ELSE 
							y <= S0;
							counter <= "00000";
					END IF;
				END IF;
			ELSE	
				y <= E0;
				counter <= "00000";
			END IF;
			M_US <= '0';
			K_US <= '1'; 
			H_US <= '0';
			M_BT <= '0'; 
			K_BT <= '1';
			H_BT <= '0';
		WHEN E0 =>
			IF counter < SEC1 THEN	
				y <= E0;
				counter <= counter+1;
			ELSIF counter > SEC1 AND counter < SEC3 THEN
				y <= E0;
				counter <= counter+1;
			ELSE 
				y <= E1;
				counter <= counter+1;
			END IF;
			M_US <= '0';
			K_US <= '1'; 
			H_US <= '0';
			M_BT <= '0'; 
			K_BT <= '1';
			H_BT <= '0';
		WHEN E1 =>
			IF counter < SEC2 THEN
				y <= E1;
				counter <= counter+1;
			ELSIF counter = SEC2 THEN
				y <= E0;
				counter <= counter+1;
			ELSIF counter > SEC2 AND counter < SEC4 THEN
				y <= E1;
				counter <= counter+1;
			ELSE
				y <= S0;
				counter <= "00000";
			END IF;
			M_US <= '0';
			K_US <= '0'; 
			H_US <= '0';
			M_BT <= '0'; 
			K_BT <= '0';
			H_BT <= '0';	
END CASE;
END IF;
END PROCESS;

PORT MAP (
   CLK: IN std_logic;
	DIVOUT: buffer BIT);
END PORT;


END behavioral;					