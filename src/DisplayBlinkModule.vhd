----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    14/10/2013 
-- Design Name:    Basisklok
-- Module Name:    DisplayBlinkModule
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DisplayBlinkModule is
	Port ( clkBlink : in STD_LOGIC;
	       disBlink : in STD_LOGIC_VECTOR(3 downto 0);
	       disSelectIn : in STD_LOGIC_VECTOR(3 downto 0);
	       disSelectUit : out STD_LOGIC_VECTOR(3 downto 0) := "1111");
end DisplayBlinkModule;

architecture Behavioral of DisplayBlinkModule is

	--Interne signalen
Signal blink : STD_LOGIC := '1';

begin
DisplayBlink : process(clkBlink)
	begin
		if rising_edge(clkBlink) then
			if blink = '0' then
				blink <= '1';
			else
				blink <= '0';
			end if;
		end if;
	end process;

disSelectUit(0) <= '1' when disBlink(0) = '1' and blink = '0' else
						 disSelectIn(0);
disSelectUit(1) <= '1' when disBlink(1) = '1' and blink = '0' else
						 disSelectIn(1);
disSelectUit(2) <= '1' when disBlink(2) = '1' and blink = '0' else
						 disSelectIn(2);
disSelectUit(3) <= '1' when disBlink(3) = '1' and blink = '0' else
						 disSelectIn(3);

end Behavioral;
