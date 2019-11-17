LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY fsm IS
PORT	(
			Clock		: BIT;
			Reset		: IN STD_LOGIC;
			Day			: IN STD_LOGIC;
			Emergency	: IN STD_LOGIC;
			M_US		: OUT STD_LOGIC;
			K_US		: OUT STD_LOGIC;
			H_US		: OUT STD_LOGIC;
			M_BT		: OUT STD_LOGIC;
			K_BT		: OUT STD_LOGIC;
			H_BT		: OUT STD_LOGIC);
END fsm;

ARCHITECTURE Behavior OF fsm IS
	TYPE State IS (S0, S1, S2, S3, E0, E1);
	SIGNAL CurrentState : State;
	SIGNAL Counter		: STD_LOGIC_VECTOR (3 downto 0);
	CONSTANT SEC8		: STD_LOGIC_VECTOR (3 downto 0) := "1000";
	CONSTANT SEC2		: STD_LOGIC_VECTOR (3 downto 0) := "0010";
	CONSTANT SEC1		: STD_LOGIC_VECTOR (3 downto 0) := "0001";
	CONSTANT SEC3		: STD_LOGIC_VECTOR (3 downto 0) := "0011";
	CONSTANT SEC4		: STD_LOGIC_VECTOR (3 downto 0) := "0100";
	
	BEGIN
		
	PROCESS (Clock, Reset, Day, Emergency, CurrentState)
		BEGIN
		IF Reset = '1' THEN
			CurrentState <= S0;
			Counter <= "0000";
		ELSIF Clock'EVENT AND Clock = '1' THEN
			CASE CurrentState IS
				WHEN S0 =>
					IF (Emergency = '0') THEN
						IF (Day = '1') THEN
							IF Counter < SEC8 THEN
								CurrentState <= S0;
								Counter <= Counter + 1;
							ELSE
								CurrentState <= S1;
								Counter <= "0000";
							END IF;
						ELSE
							IF Counter < SEC4 THEN
								CurrentState <= S0;
								Counter <= Counter + 1;
							ELSE
								CurrentState <= S1;
								Counter <= "0000";
							END IF;
						END IF;
					ELSE
						CurrentState <= E0;
						Counter <= "0000";
					END IF;
					M_US <= '1';
					K_US <= '0';
					H_US <= '0';
					M_BT <= '0';
					K_BT <= '0';
					H_BT <= '1';
				WHEN S1 =>
					IF (Emergency = '0') THEN
						IF (Day = '1') THEN
							IF Counter < SEC2 THEN
								CurrentState <= S1;
								Counter <= Counter + 1;
							ELSE
								CurrentState <= S2;
								Counter <= "0000";
							END IF;
						ELSE
							IF Counter < SEC1 THEN
								CurrentState <= S1;
								Counter <= Counter + 1;
							ELSE
								CurrentState <= S2;
								Counter <= "0000";
							END IF;
						END IF;
					ELSE
						CurrentState <= E0;
						Counter <= "0000";
					END IF;
					M_US <= '1';
					K_US <= '0';
					H_US <= '0';
					M_BT <= '0';
					K_BT <= '1';
					H_BT <= '0';
				WHEN S2 =>
					IF (Emergency = '0') THEN
						IF (Day = '1') THEN
							IF Counter < SEC8 THEN
								CurrentState <= S2;
								Counter <= Counter + 1;
							ELSE
								CurrentState <= S3;
								Counter <= "0000";
							END IF;
						ELSE
							IF Counter < SEC4 THEN
								CurrentState <= S2;
								Counter <= Counter + 1;
							ELSE
								CurrentState <= S3;
								Counter <= "0000";
							END IF;
						END IF;
					ELSE
						CurrentState <= E0;
						Counter <= "0000";
					END IF;
					M_US <= '0';
					K_US <= '0';
					H_US <= '1';
					M_BT <= '1';
					K_BT <= '0';
					H_BT <= '0';
				WHEN S3 =>
					IF (Emergency = '0') THEN
						IF (Day = '1') THEN
							IF Counter < SEC2 THEN
								CurrentState <= S3;
								Counter <= Counter + 1;
							ELSE
								CurrentState <= S0;
								Counter <= "0000";
							END IF;
						ELSE
							IF Counter < SEC1 THEN
								CurrentState <= S3;
								Counter <= Counter + 1;
							ELSE
								CurrentState <= S0;
								Counter <= "0000";
							END IF;
						END IF;
					ELSE
						CurrentState <= E0;
						Counter <= "0000";
					END IF;
					M_US <= '0';
					K_US <= '1';
					H_US <= '0';
					M_BT <= '1';
					K_BT <= '0';
					H_BT <= '0';
				WHEN E0 =>
					IF Counter = "0001" THEN	
						CurrentState <= E0;
						Counter <= Counter+1;
					ELSE 
						CurrentState <= E1;
						Counter <= Counter+1;
					END IF;
					M_US <= '0';
					K_US <= '1'; 
					H_US <= '0';
					M_BT <= '0'; 
					K_BT <= '1';
					H_BT <= '0';
				WHEN E1 =>
					IF counter = "0000" THEN
						CurrentState <= E1;
						Counter <= Counter+1;
					ELSIF Counter = "0010" THEN
						CurrentState <= E1;
						Counter <= Counter+1;
					ELSIF Counter = "0011" THEN
						CurrentState <= S0;
						Counter <= "0000";
					ELSE
						CurrentState <= E0;
						Counter <= Counter + 1;
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
END Behavior;
					