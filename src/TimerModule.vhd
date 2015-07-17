----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    30/11/2013 
-- Design Name:    Basisklok
-- Module Name:    TimerModule
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TimerModule is
	Port ( sysClk : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 enableIn : in STD_LOGIC;
			 instelmodus : in STD_LOGIC_VECTOR(1 downto 0);
			 SS : in STD_LOGIC_VECTOR(7 downto 0);
			 MM : in STD_LOGIC_VECTOR(7 downto 0);
			 enableOut : out STD_LOGIC := '0');
end TimerModule;

architecture Behavioral of TimerModule is

begin	
Timer : process(sysClk)
	begin
		if rising_edge(sysClk) then
			if reset = '1' then
				enableOut <= '0';
			else
				if instelmodus = "00" and (SS /= "00000000" or MM /= "00000000") then
					enableOut <= enableIn;
				else
					enableOut <= '0';
				end if;
			end if;
		end if;
	end process;

end Behavioral;