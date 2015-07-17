----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    23/12/2013 
-- Design Name:    Basisklok
-- Module Name:    ModeSelector5ToestandenZelftestendeTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
library HuybrechtsThomas_Library;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use HuybrechtsThomas_Library.TestbenchPackage.ALL;
 
entity ModeSelector5ToestandenZelftestendeTestbench is
end ModeSelector5ToestandenZelftestendeTestbench;
 
architecture struct of ModeSelector5ToestandenZelftestendeTestbench is 
   Component ModeSelector5Toestanden
	Port( sysClk : in std_logic;
			nextMode : in std_logic;
	      reset : in std_logic;
			currentMode : out std_logic_vector(4 downto 0));
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal nextMode : std_logic := '0';
signal reset : std_logic := '0';
signal currentMode : std_logic_vector(4 downto 0) := "00001";
signal simulatieActief : std_logic := '0';

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_ModeSelector5Toestanden: ModeSelector5Toestanden port map( sysClk => sysClk,
																					 nextMode => nextMode,
																					 reset => reset,
																					 currentMode => currentMode);
	
	--sysClk stimulatie
	sysClk_process : clockStimulus(sysClk_period, sysClk_period/2, simulatieActief, sysClk);
	
	--Zelftestende testbench
	ModeSelector5Toestanden_Test_process : process
	begin
		report "Simulatie: ModeSelector5Toestanden";
		nextMode <= '0';
		reset <= '0';
		simulatieActief <= '1'; 
		wait for 20 ns;
		
		report "Start: currentMode = 00001";
		if currentMode = "00001" then
			report "Geslaagd!";
		else
			assert(false) report "De startwaarde is niet '00001'!" severity warning;
		end if;
		
		report "Switch naar volgende mode: currentMode = 00010";
		buttonSimulatie(1, sysClk_period, 20ns, nextMode);
		if currentMode = "00010" then
			report "Geslaagd!";
		else
			assert(false) report "De currentMode is niet '00010'!" severity error;
		end if;
		
		report "Switch naar volgende mode: currentMode = 00100";
		buttonSimulatie(1, sysClk_period, 20ns, nextMode);
		if currentMode = "00100" then
			report "Geslaagd!";
		else
			assert(false) report "De currentMode is niet '00100'!" severity error;
		end if;
		
		report "Switch naar volgende mode: currentMode = 01000";
		buttonSimulatie(1, sysClk_period, 20ns, nextMode);
		if currentMode = "01000" then
			report "Geslaagd!";
		else
			assert(false) report "De currentMode is niet '01000'!" severity error;
		end if;
		
		report "Switch naar volgende mode: currentMode = 10000";
		buttonSimulatie(1, sysClk_period, 20ns, nextMode);
		if currentMode = "10000" then
			report "Geslaagd!";
		else
			assert(false) report "De currentMode is niet '10000'!" severity error;
		end if;
		
		report "Voer een reset uit";
		buttonSimulatie(1, sysClk_period, 20ns, reset);
		if currentMode = "00001" then
			report "Geslaagd!";
		else
			assert(false) report "De currentMode is niet '00001'!" severity error;
		end if;
		
		simulatieActief <= '0';
		report "Simulatie geëindigd";
		wait;
	end process;
	
end struct;