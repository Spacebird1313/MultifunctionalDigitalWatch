----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    30/09/2013 
-- Design Name:    Basisklok
-- Module Name:    DelerTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;
  
entity DelerTestbench is
end DelerTestbench;
 
architecture struct of DelerTestbench is
	Component Deler
	Port ( sysClk : in  std_logic;
          enable : in  std_logic;
          CT : out  std_logic);
	End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal enable : std_logic := '0';
signal CT : std_logic := '0';

-- Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
   Div: Deler port map( sysClk => sysClk,
								 enable => enable,
								 CT => CT);

   -- Klokpuls genereren
   sysClk_process : process
   begin
		sysClk <= '0';
		wait for sysClk_period/2;
		sysClk <= '1';
		wait for sysClk_period/2;
   end process;
 

   -- Stimulus genereren
   stim_proc : process
   begin		
      enable <= '0';
      wait for sysClk_period;	
		enable <= '1';
      wait for sysClk_period;
   end process;

end struct;
