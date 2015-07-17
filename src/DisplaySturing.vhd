----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    28/10/2013 
-- Design Name:    Basisklok
-- Module Name:    DisplaySturing
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DisplaySturing is
	Port ( huidigWerkingsmode : in STD_LOGIC_VECTOR(4 downto 0);
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
			 disBlink : out STD_LOGIC_VECTOR(3 downto 0) := "0000";
			 dis0 : out STD_LOGIC_VECTOR(4 downto 0) := "10000";
			 dis1 : out STD_LOGIC_VECTOR(4 downto 0) := "10000";
			 dis2 : out STD_LOGIC_VECTOR(4 downto 0) := "10000";
			 dis3 : out STD_LOGIC_VECTOR(4 downto 0) := "10000");
end DisplaySturing;

architecture struct of DisplaySturing is
	component DisplaySelector
	Port ( huidigWerkingsmode : in STD_LOGIC_VECTOR(4 downto 0);
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
			 BCDTellerToDis0_1 : out STD_LOGIC_VECTOR(3 downto 0);
			 BCDTellerToDis2_3 : out STD_LOGIC_VECTOR(3 downto 0);
			 BCDTeller0 : out STD_LOGIC_VECTOR(7 downto 0);	
			 BCDTeller1 : out STD_LOGIC_VECTOR(7 downto 0);
			 BCDTeller2 : out STD_LOGIC_VECTOR(7 downto 0);
			 BCDTeller3 : out STD_LOGIC_VECTOR(7 downto 0);
			 disPunt : out STD_LOGIC_VECTOR(3 downto 0);													--Laag actief
			 disBlink : out STD_LOGIC_VECTOR(3 downto 0));
	end component;
	
	component BCDToDis
	Port ( BCDTellerToDis0_1 : in STD_LOGIC_VECTOR(3 downto 0);
			 BCDTellerToDis2_3 : in STD_LOGIC_VECTOR(3 downto 0);
			 BCDTeller0 : in STD_LOGIC_VECTOR(7 downto 0);	
			 BCDTeller1 : in STD_LOGIC_VECTOR(7 downto 0);
			 BCDTeller2 : in STD_LOGIC_VECTOR(7 downto 0);
			 BCDTeller3 : in STD_LOGIC_VECTOR(7 downto 0);
			 disPunt : in STD_LOGIC_VECTOR(3 downto 0);													--Laag actief															
			 dis0 : out STD_LOGIC_VECTOR(4 downto 0);
			 dis1 : out STD_LOGIC_VECTOR(4 downto 0);
			 dis2 : out STD_LOGIC_VECTOR(4 downto 0);
			 dis3 : out STD_LOGIC_VECTOR(4 downto 0));
	end component;
	
--Interne signalen
Signal BCDTellerToDis0_1_intern : STD_LOGIC_VECTOR(3 downto 0) := "0000";
Signal BCDTellerToDis2_3_intern : STD_LOGIC_VECTOR(3 downto 0) := "0000";
Signal BCDTeller0_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
Signal BCDTeller1_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
Signal BCDTeller2_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
Signal BCDTeller3_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
Signal disPunt_intern : STD_LOGIC_VECTOR(3 downto 0) := "1111";

begin
	Inst_DisplaySelector : DisplaySelector Port map ( huidigWerkingsmode => huidigWerkingsmode,
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
																	  BCDTellerToDis0_1 => BCDTellerToDis0_1_intern,
																	  BCDTellerToDis2_3 => BCDTellerToDis2_3_intern,
																	  BCDTeller0 => BCDTeller0_intern,
																	  BCDTeller1 => BCDTeller1_intern,
																	  BCDTeller2 => BCDTeller2_intern,
																	  BCDTeller3 => BCDTeller3_intern,
																	  disPunt => disPunt_intern,
																	  disBlink => disBlink);
																	  
	Inst_BCDToDis : BCDToDis Port map (	BCDTellerToDis0_1 => BCDTellerToDis0_1_intern,
													BCDTellerToDis2_3 => BCDTellerToDis2_3_intern,
													BCDTeller0 => BCDTeller0_intern,
													BCDTeller1 => BCDTeller1_intern,
													BCDTeller2 => BCDTeller2_intern,
													BCDTeller3 => BCDTeller3_intern,
													disPunt => disPunt_intern,
													dis0 => dis0,
													dis1 => dis1,
													dis2 => dis2,
													dis3 => dis3);
end struct;