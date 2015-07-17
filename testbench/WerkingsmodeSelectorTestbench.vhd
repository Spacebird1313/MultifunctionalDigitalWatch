----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    12/10/2013 
-- Design Name:    Basisklok
-- Module Name:    WerkingsmodeSelectorTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity WerkingsmodeSelectorTestbench is
end WerkingsmodeSelectorTestbench;
 
architecture struct of WerkingsmodeSelectorTestbench is 
   Component WerkingsmodeSelector
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

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_WerkingsmodeSelector: WerkingsmodeSelector port map( sysClk => sysClk,
																			 nextMode => nextMode,
																			 reset => reset,
																			 currentMode => currentMode);

   -- Klokpuls genereren
   sysClk_process : process
   begin
		sysClk <= '0';
		wait for sysClk_period/2;
		sysClk <= '1';
		wait for sysClk_period/2;
   end process;
 
   -- Genereer stimulus (nextMode)
	nextMode_process : process
   begin
		nextMode <= '0';
		wait for sysClk_period*4;
		nextMode <= '1';
		wait for sysClk_period;
   end process;
	
	-- Genereer stimulus (reset)
	reset_process : process
   begin
		reset <= '0';
		wait for sysClk_period*25;
		reset <= '1';
		wait for sysClk_period*2;
   end process;
	
end struct;