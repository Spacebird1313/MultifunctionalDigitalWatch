----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    01/11/2013 
-- Design Name:    Basisklok
-- Module Name:    Display
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Display is
	Port ( clk : in STD_LOGIC;
			 clkBlink : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 huidigWerkingsmode : in STD_LOGIC_VECTOR(4 downto 0);
			 huidigInstelmode : in STD_LOGIC_VECTOR(4 downto 0);
			 M0SS : in STD_LOGIC_VECTOR(7 downto 0);														--Uitgangen module: uurwerk
			 M0MM : in STD_LOGIC_VECTOR(7 downto 0);
			 M0UU : in STD_LOGIC_VECTOR(7 downto 0);
			 M1DD : in STD_LOGIC_VECTOR(7 downto 0);														--Uitgangen module: datum
			 M1MM : in STD_LOGIC_VECTOR(7 downto 0);
			 M1JJ : in STD_LOGIC_VECTOR(7 downto 0);
			 M2MM : in STD_LOGIC_VECTOR(7 downto 0);														--Uitgangen module: alarm
			 M2UU : in STD_LOGIC_VECTOR(7 downto 0);
			 M3SS : in STD_LOGIC_VECTOR(7 downto 0);														--Uitgangen module: timer
			 M3MM : in STD_LOGIC_VECTOR(7 downto 0);
			 M4HH : in STD_LOGIC_VECTOR(7 downto 0);														--Uitgangen module: chronometer
			 M4SS : in STD_LOGIC_VECTOR(7 downto 0);
			 M4MM : in STD_LOGIC_VECTOR(7 downto 0);
			 M4UU : in STD_LOGIC_VECTOR(7 downto 0);
			 disOut : out STD_LOGIC_VECTOR(7 downto 0) := "11111111";
			 disSelect : out STD_LOGIC_VECTOR(3 downto 0) := "1111");
end Display;

architecture struct of Display is	
	component DisplaySturing
	Port ( huidigWerkingsmode : in STD_LOGIC_VECTOR(4 downto 0);
			 huidigInstelmode : in STD_LOGIC_VECTOR(4 downto 0);
			 M0SS : in STD_LOGIC_VECTOR(7 downto 0);								
			 M0MM : in STD_LOGIC_VECTOR(7 downto 0);
			 M0UU : in STD_LOGIC_VECTOR(7 downto 0);
			 M1DD : in STD_LOGIC_VECTOR(7 downto 0);													
			 M1MM : in STD_LOGIC_VECTOR(7 downto 0);
			 M1JJ : in STD_LOGIC_VECTOR(7 downto 0);
			 M2MM : in STD_LOGIC_VECTOR(7 downto 0);													
			 M2UU : in STD_LOGIC_VECTOR(7 downto 0);
			 M3SS : in STD_LOGIC_VECTOR(7 downto 0);													
			 M3MM : in STD_LOGIC_VECTOR(7 downto 0);
			 M4HH : in STD_LOGIC_VECTOR(7 downto 0);												
			 M4SS : in STD_LOGIC_VECTOR(7 downto 0);
			 M4MM : in STD_LOGIC_VECTOR(7 downto 0);
			 M4UU : in STD_LOGIC_VECTOR(7 downto 0);
			 disBlink : out STD_LOGIC_VECTOR(3 downto 0);
			 dis0 : out STD_LOGIC_VECTOR(4 downto 0);
			 dis1 : out STD_LOGIC_VECTOR(4 downto 0);
			 dis2 : out STD_LOGIC_VECTOR(4 downto 0);
			 dis3 : out STD_LOGIC_VECTOR(4 downto 0));
	end component;

	component DisplayModule
	Port ( clk : in STD_LOGIC;
			 clkBlink : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 disBlink : in STD_LOGIC_VECTOR(3 downto 0);
			 dis0 : in STD_LOGIC_VECTOR(4 downto 0);
			 dis1 : in STD_LOGIC_VECTOR(4 downto 0);
			 dis2 : in STD_LOGIC_VECTOR(4 downto 0);
			 dis3 : in STD_LOGIC_VECTOR(4 downto 0);
			 disOut : out STD_LOGIC_VECTOR(7 downto 0);
			 disSelect : out STD_LOGIC_VECTOR(3 downto 0));
	end component;
	
--Interne signalen
Signal disBlink_intern : STD_LOGIC_VECTOR(3 downto 0) := "0000";
Signal dis0_intern : STD_LOGIC_VECTOR(4 downto 0) := "10000";
Signal dis1_intern : STD_LOGIC_VECTOR(4 downto 0) := "10000";
Signal dis2_intern : STD_LOGIC_VECTOR(4 downto 0) := "10000";
Signal dis3_intern : STD_LOGIC_VECTOR(4 downto 0) := "10000";

begin
	Inst_DisplaySturing : DisplaySturing Port map ( huidigWerkingsmode => huidigWerkingsmode,
																	huidigInstelmode => huidigInstelmode,
																	M0SS => M0SS,
																	M0MM => M0MM,
																	M0UU => M0UU,
																	M1DD => M1DD,
																	M1MM => M1MM,
																	M1JJ => M1JJ,
																	M2MM => M2MM,
																	M2UU => M2UU,
																	M3SS => M3SS,
																	M3MM => M3MM,
																	M4HH => M4HH,
																	M4SS => M4SS,
																	M4MM => M4MM,
																	M4UU => M4UU,
																	disBlink => disBlink_intern,
																	dis0 => dis0_intern,
																	dis1 => dis1_intern,
																	dis2 => dis2_intern,
																	dis3 => dis3_intern);

	Inst_DisplayModule : DisplayModule Port map ( clk => clk,
																 clkBlink => clkBlink,
																 reset => reset,
																 disBlink => disBlink_intern,
																 dis0 => dis0_intern,
																 dis1 => dis1_intern,
																 dis2 => dis2_intern,
																 dis3 => dis3_intern,
																 disOut => disOut,
																 disSelect => disSelect);
																			  
end struct;