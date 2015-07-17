----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    23/12/2013 
-- Design Name:    Basisklok
-- Module Name:    SignalPulsModuleTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity SignalPulsModuleTestbench is
end SignalPulsModuleTestbench;
 
architecture struct of SignalPulsModuleTestbench is 
   Component SignalPulsModule
	Port( sysClk : in std_logic;
	      reset : in std_logic;
			pulsFrequentie : in std_logic;
			signalIn : in std_logic;
			pulsOut : out std_logic);
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal reset : std_logic := '0';
signal pulsFrequentie : std_logic := '0';
signal signalIn : std_logic := '0';
signal pulsOut : std_logic := '0';

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_SignalPulsModule: SignalPulsModule port map( sysClk => sysClk,
																  reset => reset,
																  pulsFrequentie => pulsFrequentie,
																  signalIn => signalIn,
																  pulsOut => pulsOut);

   --Klokpuls genereren
   sysClk_process : process
   begin
		sysClk <= '0';
		wait for sysClk_period/2;
		sysClk <= '1';
		wait for sysClk_period/2;
   end process;
	
	--Genereer stimulus (pulsFrequentie)
	pulsFrequentie_process : process
	begin
		pulsFrequentie <= '0';
		wait for sysClk_period*2;
		pulsFrequentie <= '1';
		wait for sysClk_period;
	end process;
 
   --Genereer stimulus (signalIn)
	signalIn_process : process
   begin
		signalIn <= '0';
		wait for sysClk_period*8;
		signalIn <= '1';
		wait for sysClk_period*16;
   end process;
	
	--Genereer stimulus (reset)
	reset_process : process
   begin
		reset <= '0';
		wait for sysClk_period*50;
		reset <= '1';
		wait for sysClk_period;
   end process;
	
end struct;