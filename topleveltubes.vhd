LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY topleveltubes IS
PORT	(
			Clock1		: BIT;
			Reset1		: IN STD_LOGIC;
			Button_Global : IN STD_LOGIC;
			Touched_Global : IN STD_LOGIC;
			Z_Global : OUT STD_LOGIC_VECTOR(1 DOWNTO 0 );
			isStart_Global : OUT STD_LOGIC);
END topleveltubes;

ARCHITECTURE Behavior OF topleveltubes IS
	COMPONENT fsm IS
		PORT	(
			Clock		: BIT;
			Reset		: IN STD_LOGIC;
			-- INPUT 

			Button 		: IN STD_LOGIC;
			Touched		: IN STD_LOGIC;
			-- OUTPUT 
			Z			: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			-- 00 for A , 01 for B  , 11 for C , 10 for D
			isStart 	: OUT STD_LOGIC
			);
	END COMPONENT;
	
	
	
	SIGNAL Emergency : STD_LOGIC ;
	SIGNAL Reset: STD_LOGIC ;
	SIGNAL Day: STD_LOGIC ;
	
	BEGIN
		
					
			fsmgame : fsm port map (
					Clock => Clock1,
					Reset => Reset1,
					Button =>Button_Global , 
					Touched => Touched_Global,
					Z=> Z_Global, 
					isStart =>isStart_Global
					);		
					
	
END Behavior;