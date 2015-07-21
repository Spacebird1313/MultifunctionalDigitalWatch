----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    05/10/2013 
-- Design Name:    Basisklok
-- Module Name:    Debouncer
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Debouncer is
	Port ( clk : in STD_LOGIC;
	       buttonIn : in STD_LOGIC_VECTOR(4 downto 0);
	       buttonUit : out STD_LOGIC_VECTOR(4 downto 0) := "00000");	 
end Debouncer;

architecture Behavioral of Debouncer is

Signal delay1, delay2, delay3: STD_LOGIC_VECTOR(4 downto 0) := "00000";

begin
debounce : process(clk)
	begin
		if rising_edge(clk) then
			delay1 <= buttonIn;
			delay2 <= delay1;
			delay3 <= delay2;
		end if;
	end process;
	
buttonUit(4 downto 0) <= delay1(4 downto 0) and delay2(4 downto 0) and delay3(4 downto 0);

end Behavioral;
