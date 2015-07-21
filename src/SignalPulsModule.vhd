----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    02/12/2013 
-- Design Name:    Basisklok
-- Module Name:    SignalPulsModule
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SignalPulsModule is
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       pulsFrequentie : in STD_LOGIC;
	       signalIn : in STD_LOGIC;
	       pulsOut : out STD_LOGIC := '0');
end SignalPulsModule;

architecture struct of SignalPulsModule is

Signal puls_intern : STD_LOGIC := '0';

begin
signalPuls : process(sysClk)
	begin
		if rising_edge(sysClk) then
			if reset = '1' then
				puls_intern <= '0';
			else
				if signalIn = '1' then
					if pulsFrequentie = '1' then
						puls_intern <= not puls_intern;
					end if;
				else
					puls_intern <= '0';
				end if;
			end if;
		end if;
	end process;

pulsOut <= puls_intern;

end struct;
