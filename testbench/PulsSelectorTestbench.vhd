----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    12/10/2013 
-- Design Name:    Basisklok
-- Module Name:    PulsSelectorTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity PulsSelectorTestbench is
end PulsSelectorTestbench;
 
architecture struct of PulsSelectorTestbench is 
   Component PulsSelector
	Port( sysClk : in  std_logic;
         puls0 : in  std_logic;
         puls1 : in  std_logic;
         selectPuls : in  std_logic;
         reset : in  std_logic;
         pulsUit : out  std_logic);
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal puls0: std_logic := '0';
signal puls1: std_logic := '0';
signal selectPuls : std_logic := '0';
signal reset : std_logic := '0';
signal PulsUit : std_logic := '0';

--Klokperiode constante
constant sysClk_period : time := 10 ns;
constant puls0_period : time := 30 ns; 									--trage puls
constant puls1_period : time := 20 ns;										--snelle puls
 
begin
Inst_PulsSelector: PulsSelector port map( sysClk => sysClk,
														puls0 => puls0,
														puls1 => puls1,
														selectPuls => selectPuls,
														reset => reset,
														pulsUit => pulsUit);

   -- Klokpuls genereren (sysclk)
   sysClk_process : process
   begin
		sysClk <= '0';
		wait for sysClk_period/2;
		sysClk <= '1';
		wait for sysClk_period/2;
   end process;
 
   -- Klokpuls genereren (puls0)
	puls0_process : process
   begin
		puls0 <= '0';
		wait for puls0_period;
		puls0 <= '1';
		wait for sysClk_period;
   end process;
	
	-- Klokpuls genereren (puls1)
	puls1_process : process
   begin
		puls1 <= '0';
		wait for puls1_period;
		puls1 <= '1';
		wait for sysClk_period;
   end process;
	
	-- Genereer stimulus (reset)
	reset_process : process
   begin
		reset <= '0';
		wait for sysClk_period*20;
		reset <= '1';
		wait for sysClk_period*2;
   end process;
	
	-- Genereer stimulus (pulsSelect)
	selectPuls_process : process
   begin
		selectPuls <= '0';
		wait for sysClk_period*15;
		selectPuls <= '1';
		wait for sysClk_period*15;
   end process;
	
end struct;