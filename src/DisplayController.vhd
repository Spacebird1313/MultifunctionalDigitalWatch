----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    26/04/2013 
-- Design Name:    Basisklok
-- Module Name:    DisplayController
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity DisplayController is
	Port( clk : in STD_LOGIC;
	      reset : in STD_LOGIC;
	      dis0 : in STD_LOGIC_VECTOR(4 downto 0);
	      dis1 : in STD_LOGIC_VECTOR(4 downto 0);
	      dis2 : in STD_LOGIC_VECTOR(4 downto 0);
	      dis3 : in STD_LOGIC_VECTOR(4 downto 0);
	      disOut : out STD_LOGIC_VECTOR(4 downto 0);     -- Kathode
	      disSelect : out STD_LOGIC_VECTOR(3 downto 0)); -- Anode
end DisplayController;

architecture Behavioral of DisplayController is

Signal disCount_int : integer range 0 to 3 := 0;

begin
	displayScan : process(clk, reset)
		begin
			if reset = '1' then
				disCount_int <= 0;
			elsif rising_edge(clk) then
				if disCount_int = 3 then
					disCount_int <= 0;
				else
					disCount_int <= disCount_int + 1;
				end if;
			end if;
		 end process;
		 
	displaySelect : process(disCount_int)
		begin
			case disCount_int is
				when 0 => disSelect <= "0111";
				when 1 => disSelect <= "1011";
				when 2 => disSelect <= "1101";
				when 3 => disSelect <= "1110";
			end case;
		end process;
		
	displayValue : process(disCount_int, dis0, dis1, dis2, dis3)
		begin
			case disCount_int is 
				when 0 => disOut <= dis3;
				when 1 => disOut <= dis2;
				when 2 => disOut <= dis1;
				when 3 => disOut <= dis0;
			end case;
		end process;
		
end Behavioral;
