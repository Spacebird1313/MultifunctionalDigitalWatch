----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    30/09/2013 
-- Design Name:    Basisklok
-- Module Name:    Deler
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity Deler is
    Generic ( max : positive := 10);
    Port ( sysClk : in  STD_LOGIC;
      	   enable : in  STD_LOGIC;
           CT : out  STD_LOGIC := '0');
end Deler;

architecture Behavioral of Deler is

Signal count : integer range 0 to max := 0;

begin
--DIVIDE: tel aantal impulsen (max) waarna één puls wordt gestuurd (CT)
div : process(sysClk)
	begin
		if rising_edge(sysClk) then
			if enable = '1' then
				if count = max-1 then
					count <= 0;
					CT <= '1';
				else
					count <= count + 1;
					CT <= '0';
				end if;
			else
				CT <= '0';
			end if;
		end if;
	end process;
	
end Behavioral;
