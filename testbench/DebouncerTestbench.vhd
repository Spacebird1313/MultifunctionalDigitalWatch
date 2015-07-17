----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    07/05/2013 
-- Design Name:    Basisklok
-- Module Name:    DebouncerTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DebouncerTestbench is
end DebouncerTestbench;

architecture struct of DebouncerTestbench is
	Component Debouncer
	Port ( clk : in STD_LOGIC;
			 buttonIn : in STD_LOGIC_VECTOR(4 downto 0);
			 buttonUit : out STD_LOGIC_VECTOR(4 downto 0));	 
	End component;
		
--Interne signalen
Signal clk: STD_LOGIC := '0';
Signal buttonIn: STD_LOGIC_VECTOR(4 downto 0) := "00000";
Signal buttonUit : STD_LOGIC_VECTOR(4 downto 0) := "00000";

--Klokperiode constante
constant clk_period : time := 250 ns;

begin
Inst_Debouncer: Debouncer Port map( clk => clk,
												buttonIn => buttonIn,
												buttonUit => buttonUit);

   --Klokpuls genereren (clk)
   clk_process : process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
	--Genereer stimulus (buttonIn)
	buttonIn_process : process
	begin
		buttonIn <= "00000";
		wait for clk_period*5;
		buttonIn <= "11111";
		wait for clk_period*10;
		buttonIn <= "00000";
		wait for clk_period/2;
		buttonIn <= "11111";
		wait for clk_period/3;
		buttonIn <= "00000";
		wait for clk_period;
		buttonIn <= "11111";
		wait for clk_period/2;
		buttonIn <= "00000";
		wait for clk_period*2;
		buttonIn <= "11111";
		wait for clk_period*3;
	end process;

end struct;