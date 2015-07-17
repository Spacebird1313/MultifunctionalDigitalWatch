----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    01/10/2013 
-- Design Name:    Basisklok
-- Module Name:    PulsmoduleTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity PulsmoduleTestbench is
end PulsmoduleTestbench;
 
architecture struct of PulsmoduleTestbench is 
   Component Pulsmodule
	Port( sysClk : in std_logic;
			reset : in std_logic;
			signalIn : in std_logic;
			pulsOut : out std_logic);
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal reset : std_logic := '0';
signal signalIn : std_logic := '0';
signal pulsOut : std_logic := '0';

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_Pulsmodule: Pulsmodule port map( sysClk => sysClk,
												  reset => reset,
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
 
   --Genereer stimulus (signalIn)
	signalIn_process : process
   begin
		signalIn <= '0';
		wait for sysClk_period*3;
		signalIn <= '1';
		wait for sysClk_period*8;
		signalIn <= '0';
		Wait for sysClk_period*4;
		signalIn <= '1';
		Wait for sysClk_period*2;
   end process;
	
	--Genereer stimulus (reset)
	reset_process : process
   begin
		reset <= '0';
		wait for sysClk_period*80;
		reset <= '1';
		wait for sysClk_period*2;
   end process;
	
end struct;