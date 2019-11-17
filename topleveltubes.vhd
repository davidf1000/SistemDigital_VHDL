LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY topleveltubes IS
PORT	(
			clocktest 	: IN STD_LOGIC;
			Clock1		: IN STD_LOGIC;
			Reset1		: IN STD_LOGIC;
			Day1		: IN STD_LOGIC;
			Emergency1	: IN STD_LOGIC;
			M_US1		: OUT STD_LOGIC;
			K_US1		: OUT STD_LOGIC;
			H_US1		: OUT STD_LOGIC;
			M_BT1		: OUT STD_LOGIC;
			K_BT1		: OUT STD_LOGIC;
			H_BT1		: OUT STD_LOGIC);
END topleveltubes;

ARCHITECTURE Behavior OF topleveltubes IS
	COMPONENT Traffic IS
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
	END COMPONENT;
	
	COMPONENT Clockdiv IS
		port(
		CLK: IN std_logic;
		DIVOUT: buffer BIT);
	END COMPONENT;
	
	SIGNAL Clock_buffer : BIT;
	SIGNAL Emergency : STD_LOGIC ;
	SIGNAL Reset: STD_LOGIC ;
	SIGNAL Day: STD_LOGIC ;
	
	BEGIN
		
			Waktu : Clockdiv port map(Clock1, Clock_buffer);
			Lampu : Traffic port map (
					Clock => Clock_buffer,
					Reset => Reset1,
					Day => Day1,
					Emergency => Emergency1,
					M_US => M_US1,	
					K_US => K_US1,
					H_US => H_US1,	
					M_BT => M_BT1,	
					K_BT => K_BT1,	
					H_BT => H_BT1);		
					
	
END Behavior;