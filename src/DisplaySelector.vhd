----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    01/11/2013 
-- Design Name:    Basisklok
-- Module Name:    DisplaySelector
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DisplaySelector is
	Port ( huidigWerkingsmode : in STD_LOGIC_VECTOR(4 downto 0);
	       huidigInstelmode : in STD_LOGIC_VECTOR(4 downto 0);
	       M0SS : in STD_LOGIC_VECTOR(7 downto 0);													--Uitgangen module: uurwerk
	       M0MM : in STD_LOGIC_VECTOR(7 downto 0);
	       M0UU : in STD_LOGIC_VECTOR(7 downto 0);
	       M1DD : in STD_LOGIC_VECTOR(7 downto 0);													--Uitgangen module: datum
	       M1MM : in STD_LOGIC_VECTOR(7 downto 0);
	       M1JJ : in STD_LOGIC_VECTOR(7 downto 0);
	       M2MM : in STD_LOGIC_VECTOR(7 downto 0);													--Uitgangen module: alarm
	       M2UU : in STD_LOGIC_VECTOR(7 downto 0);
	       M3SS : in STD_LOGIC_VECTOR(7 downto 0);													--Uitgangen module: timer
	       M3MM : in STD_LOGIC_VECTOR(7 downto 0);
	       M4HH : in STD_LOGIC_VECTOR(7 downto 0);													--Uitgangen module: chronometer
	       M4SS : in STD_LOGIC_VECTOR(7 downto 0);
	       M4MM : in STD_LOGIC_VECTOR(7 downto 0);
	       M4UU : in STD_LOGIC_VECTOR(7 downto 0);
	       BCDTellerToDis0_1 : out STD_LOGIC_VECTOR(3 downto 0) := "0000";
	       BCDTellerToDis2_3 : out STD_LOGIC_VECTOR(3 downto 0) := "0000";
	       BCDTeller0 : out STD_LOGIC_VECTOR(7 downto 0) := "00000000";	
	       BCDTeller1 : out STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	       BCDTeller2 : out STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	       BCDTeller3 : out STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	       disPunt : out STD_LOGIC_VECTOR(3 downto 0) := "1111";											--Laag actief
	       disBlink : out STD_LOGIC_VECTOR(3 downto 0) := "0000");	
end DisplaySelector;

architecture struct of DisplaySelector is

begin
Selector : process(huidigWerkingsmode, huidigInstelmode, M0SS, M0MM, M0UU, M1DD, M1MM, M1JJ, M2MM, M2UU, M3SS, M3MM, M4HH, M4SS, M4MM, M4UU)
	begin
		case huidigWerkingsmode is
			when "00001" =>															--Uurwerk
				BCDTeller0 <= M0SS;
				BCDTeller1 <= M0MM;
				BCDTeller2 <= M0UU;
				BCDTeller3 <= "00000000";
				case huidigInstelmode is
					when "00001" =>													--Normale werking
						BCDTellerToDis0_1 <= "0010";
						BCDTellerToDis2_3 <= "0100";
						disPunt <= "1011";
						disBlink <= "0000";
					when "00010" =>													--Instellen uren
						BCDTellerToDis0_1 <= "0010";
						BCDTellerToDis2_3 <= "0100";
						disPunt <= "1011";
						disBlink <= "1100";
					when "00100" =>													--Instellen minuten
						BCDTellerToDis0_1 <= "0010";
						BCDTellerToDis2_3 <= "0100";
						disPunt <= "1011";
						disBlink <= "0011";
					when "01000" =>													--Instellen seconden
						BCDTellerToDis0_1 <= "0001";
						BCDTellerToDis2_3 <= "0000";
						disPunt <= "1111";
						disBlink <= "0011";
					when others =>													--Ongeldige toestand
						BCDTellerToDis0_1 <= "0010";
						BCDTellerToDis2_3 <= "0100";
						disPunt <= "1011";
						disBlink <= "0000";
				end case;
			when "00010" =>															--Datum
				BCDTeller0 <= M1DD;
				BCDTeller1 <= M1MM;
				BCDTeller2 <= M1JJ;
				BCDTeller3 <= "00100000";
				case huidigInstelmode is
					when "00001" =>													--Normale werking
						BCDTellerToDis0_1 <= "0010";
						BCDTellerToDis2_3 <= "0001";
						disPunt <= "1011";
						disBlink <= "0000";
					when "00010" =>													--Instellen dagen
						BCDTellerToDis0_1 <= "0010";
						BCDTellerToDis2_3 <= "0001";
						disPunt <= "1011";
						disBlink <= "1100";
					when "00100" =>													--Instellen maanden
						BCDTellerToDis0_1 <= "0010";
						BCDTellerToDis2_3 <= "0001";
						disPunt <= "1011";
						disBlink <= "0011";
					when "01000" =>													--Instellen jaren
						BCDTellerToDis0_1 <= "0100";
						BCDTellerToDis2_3 <= "1000";
						disPunt <= "1111";
						disBlink <= "1111";
					when others =>													--Ongeldige toestand
						BCDTellerToDis0_1 <= "0010";
						BCDTellerToDis2_3 <= "0001";
						disPunt <= "1011";
						disBlink <= "0000";
				end case;
			when "00100" =>															--Alarm
				BCDTeller0 <= M2MM;
				BCDTeller1 <= M2UU;
				BCDTeller2 <= "00000000";
				BCDTeller3 <= "00000000";
				case huidigInstelmode is
					when "00001" =>													--Normale werking
						BCDTellerToDis0_1 <= "0001";
						BCDTellerToDis2_3 <= "0010";
						disPunt <= "1011";
						disBlink <= "0000";
					when "00010" =>													--Instellen uren
						BCDTellerToDis0_1 <= "0001";
						BCDTellerToDis2_3 <= "0010";
						disPunt <= "1011";
						disBlink <= "1100";
					when "00100" =>													--Instellen minuten
						BCDTellerToDis0_1 <= "0001";
						BCDTellerToDis2_3 <= "0010";
						disPunt <= "1011";
						disBlink <= "0011";
					when others =>													--Ongeldige toestand
						BCDTellerToDis0_1 <= "0001";
						BCDTellerToDis2_3 <= "0010";
						disPunt <= "1011";
						disBlink <= "0000";
				end case;
			when "01000" =>															--Timer
				BCDTeller0 <= M3SS;
				BCDTeller1 <= M3MM;
				BCDTeller2 <= "00000000";
				BCDTeller3 <= "00000000";
				case huidigInstelmode is
					when "00001" =>													--Normale werking
						BCDTellerToDis0_1 <= "0001";
						BCDTellerToDis2_3 <= "0010";
						disPunt <= "1011";
						disBlink <= "0000";
					when "00010" =>													--Instellen minuten
						BCDTellerToDis0_1 <= "0001";
						BCDTellerToDis2_3 <= "0010";
						disPunt <= "1011";
						disBlink <= "1100";
					when "00100" =>													--Instellen seconden
						BCDTellerToDis0_1 <= "0001";
						BCDTellerToDis2_3 <= "0010";
						disPunt <= "1011";
						disBlink <= "0011";
					when others =>													--Ongeldige toestand
						BCDTellerToDis0_1 <= "0001";
						BCDTellerToDis2_3 <= "0010";
						disPunt <= "1011";
						disBlink <= "0000";
				end case;
			when "10000" =>															--Chronometer
				BCDTeller0 <= M4HH;
				BCDTeller1 <= M4SS;
				BCDTeller2 <= M4MM;
				BCDTeller3 <= M4UU;
				case huidigInstelmode is
					when "00001" =>													--Toon SS:HH
						BCDTellerToDis0_1 <= "0001";
						BCDTellerToDis2_3 <= "0010";
						disPunt <= "1011";
						disBlink <= "0000";
					when "00010" =>													--Toon UU:MM
						BCDTellerToDis0_1 <= "0100";
						BCDTellerToDis2_3 <= "1000";
						disPunt <= "1011";
						disBlink <= "0000";
					when others =>													--Ongeldige toestand
						BCDTellerToDis0_1 <= "0001";
						BCDTellerToDis2_3 <= "0010";
						disPunt <= "1011";
						disBlink <= "0000";
				end case;	
			when others =>															--Ongeldige toestand: Uurwerk tonen: Default
				BCDTeller0 <= M0SS;
				BCDTeller1 <= M0MM;
				BCDTeller2 <= M0UU;
				BCDTeller3 <= "00000000";
				BCDTellerToDis0_1 <= "0010";
				BCDTellerToDis2_3 <= "0100";
				disPunt <= "1011";
				disBlink <= "0000";
			end case;
		end process;
		
end struct;
