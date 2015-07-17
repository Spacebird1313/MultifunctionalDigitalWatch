----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    17/11/2013 
-- Design Name:    Basisklok
-- Module Name:    DatumControllerTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity DatumControllerTestbench is
end DatumControllerTestbench;
 
architecture struct of DatumControllerTestbench is 
   Component DatumController
	Port( MM : in std_logic_vector(7 downto 0);
			JJ : in std_logic_vector(7 downto 0);
			DDMax : out std_logic_vector(7 downto 0));
   End component;
    
--Interne signalen
signal MM : std_logic_vector(7 downto 0) := "00000000";
signal JJ : std_logic_vector(7 downto 0) := "00000000";
signal DDMax : std_logic_vector(7 downto 0) := "00000000";

--Klokperiode constante
constant clk_period : time := 10 ns;
 
begin
Inst_DatumController: DatumController port map( MM => MM,
																JJ => JJ,
																DDMax => DDMax);
 
   -- Genereer stimulus (MM)
	MM_process : process
   begin
		for i in 0 to 1 loop
			for j in 0 to 9 loop
				MM(7 downto 4) <= std_logic_vector(to_unsigned(i, 4));
				MM(3 downto 0) <= std_logic_vector(to_unsigned(j, 4));
			wait for clk_period;
			end loop;
		end loop;
		MM <= "00000010";
		wait;
   end process;
	
	-- Genereer stimulus (MM)
	JJ_process : process
   begin
		for i in 0 to 9 loop
			for j in 0 to 9 loop
				JJ(7 downto 4) <= std_logic_vector(to_unsigned(i, 4));
				JJ(3 downto 0) <= std_logic_vector(to_unsigned(j, 4));
			wait for clk_period;
			end loop;
		end loop;
   end process;
	
end struct;