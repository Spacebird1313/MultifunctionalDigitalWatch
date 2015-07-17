----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    20/10/2013 
-- Design Name:    Basisklok
-- Module Name:    DelayedPulsGeneratorTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity DelayedPulsGeneratorTestbench is
end DelayedPulsGeneratorTestbench;
 
architecture struct of DelayedPulsGeneratorTestbench is 
   Component DelayedPulsGenerator
	Port( sysClk : in std_logic;
			reset : in std_logic;
			pulsClk : in std_logic;
			delayClk : in std_logic;
			signalIn : in std_logic;
			pulsOut : out std_logic);
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal reset : std_logic := '0';
signal pulsClk : std_logic := '0';
signal delayClk : std_logic := '0';
signal signalIn : std_logic := '0';
signal pulsOut : std_logic := '0';

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_DelayedPulsGenerator: DelayedPulsGenerator port map( sysClk => sysClk,
																			 reset => reset,
																			 pulsClk => pulsClk,
																			 delayClk => delayClk,
																			 signalIn => signalIn,
																			 pulsOut => pulsOut);

   --Klokpuls genereren (sysClk)
   sysClk_process : process
   begin
		sysClk <= '0';
		wait for sysClk_period/2;
		sysClk <= '1';
		wait for sysClk_period/2;
   end process;
	
	--Klokpuls genereren (pulsClk)
	pulsClk_process : process
	begin
		pulsClk <= '0';
		wait for sysClk_period*2;
		pulsClk <= '1';
		wait for sysClk_period;
	end process;
	
	--Klokpuls genereren (delayClk)
	delayClk_process : process
	begin
		delayClk <= '0';
		wait for sysClk_period*4;
		delayClk <= '1';
		wait for sysClk_period;
	end process;
	
	--Genereer stimulus (reset)
	reset_process : process
   begin
		reset <= '0';
		wait for sysClk_period*50;
		reset <= '1';
		wait for sysClk_period*2;
   end process;
	
   --Genereer stimulus (signalIn)
	signalIn_process : process
   begin
		signalIn <= '0';
		wait for sysClk_period*20;
		signalIn <= '1';
		wait for sysClk_period*17;
		signalIn <= '0';
		Wait for sysClk_period*15;
		signalIn <= '1';
		Wait for sysClk_period*16;
   end process;

end struct;