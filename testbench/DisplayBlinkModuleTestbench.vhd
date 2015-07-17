----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    25/10/2013 
-- Design Name:    Basisklok
-- Module Name:    DisplayBlinkModuleTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity DisplayBlinkModuleTestbench is
end DisplayBlinkModuleTestbench;
 
architecture struct of DisplayBlinkModuleTestbench is 
   Component DisplayBlinkModule
	Port( clkBlink : in std_logic;
			disBlink : in std_logic_vector(3 downto 0);
			disSelectIn : in std_logic_vector(3 downto 0);
			disSelectUit : out std_logic_vector(3 downto 0));
   End component;
    
--Interne signalen
signal clkBlink : std_logic := '0';
signal disBlink : std_logic_vector(3 downto 0) := "0000";
signal disSelectIn : std_logic_vector(3 downto 0) := "0000";
signal disSelectUit : std_logic_vector(3 downto 0) := "0000";

--Klokperiode constante
constant clk_period : time := 10 ns;
 
begin
Inst_DisplayBlinkModule: DisplayBlinkModule port map( clkBlink => clkBlink,
																		disBlink => disBlink,
																		disSelectIn => disSelectIn,
																		disSelectUit => disSelectUit);

  	--Klokpuls genereren (clkBlink)
   clkBlink_process : process
   begin
		clkBlink <= '0';
		wait for clk_period*4;
		clkBlink <= '1';
		wait for clk_period;
   end process;

   --Genereer stimulus (disBlink)
	disBlink_process : process
   begin
		disBlink <= "0000";
		wait for clk_period*3;
		disBlink <= "0001";
		wait for clk_period*3;
		disBlink <= "0011";
		wait for clk_period*3;
		disBlink <= "1100";
		wait for clk_period*3;
		disBlink <= "1111";
		wait for clk_period*3;
   end process;
	
	--Genereer stimulus (disSelectIn)
	disSelectIn_process : process
	begin
		disSelectIn <= "1110";
		wait for clk_period;
		disSelectIn <= "1101";
		wait for clk_period;
		disSelectIn <= "1011";
		wait for clk_period;
		disSelectIn <= "0111";
		wait for clk_period;
	end process;

end struct;

