LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY fsm IS
PORT	(
			Clock		: BIT;
			Reset		: IN STD_LOGIC;
			-- INPUT 

			Button 		: IN STD_LOGIC;
			Touched		: IN STD_LOGIC;
			-- OUTPUT 
			Z			: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			-- 00 for A , 01 for B  , 11 for C , 10 for D
			isStart 	: OUT STD_LOGIC_VECTOR 
			) ;
END fsm;

ARCHITECTURE Behavior OF fsm IS
	TYPE State IS (A, B, C, D);
	-- A => kondisi mulai 
	-- B => kondisi start ( tidak lompat )
	-- C => Kondisi lompat 
	-- D => Kondisi gameover  

	SIGNAL CurrentState : State;
	SIGNAL Counter		: STD_LOGIC_VECTOR (3 downto 0);
	
	-- 

	CONSTANT GameOverSec		: STD_LOGIC_VECTOR (3 downto 0) := "1000";
	
	BEGIN
		
	PROCESS (Clock, Reset, Day, Emergency, CurrentState)
		BEGIN
		IF Reset = '1' THEN
			CurrentState <= S0;
			Counter <= "0000";
			-- kondisi reset 
		ELSIF Clock'EVENT AND Clock = '1' THEN
			CASE CurrentState IS
				WHEN A =>
					IF (Button = '1') THEN
						CurrentState <= B ;
					ELSE
						CurrentState <= A ;
					END IF;					
				isStart = '0';
				Z		= "00" ; 
				WHEN B =>
					IF (Button= '0' ) and (Touched= '0' ) THEN 
						CurrentState <= B ;
						-- Stay di B 
					ELSIF (Touched = '0') and (Button = '1' ) THEN
						CurrentState <= C ;
					ELSE 
						CurrentState <=  D ; 
					END IF ;
				isStart = '1' ; 
				Z = "01" ; 
				WHEN C =>
					 IF (Button = '0') and (Touched= '1') THEN
						CurrentState <= C ; 
					 ELSIF ( Button = '0') and ( Touched ='0') THEN 
						CurrentState <= B ; 
					 ELSE 
						CurrentState <= D ; 
					 END IF;
				isStart = '1' ; 
				Z = '11' ;  
				WHEN D =>
					IF ( Counter < SEC8 ) THEN
					Counter <= Counter +1 ;
					CurrentState <= D ; 
					ELSE 
					Counter <= "0000";
					CurrentState <= A ;
					END IF; 
				isStart = '0' ; 
				Z = '10' ; 
			END CASE;
		END IF;
	END PROCESS;
END Behavior;
					