----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    26/10/2013 
-- Design Name:    Basisklok
-- Module Name:    InstelmodusSturing
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InstelmodusSturing is
	Port ( sysClk : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 nextModeIn : in STD_LOGIC;
			 huidigWerkingsmodus : in STD_LOGIC_VECTOR(4 downto 0);
			 huidigInstelmodus : in STD_LOGIC_VECTOR(4 downto 0);
			 nextModeOut : out STD_LOGIC := '0';
			 instelmodeReset : out STD_LOGIC := '0');
end InstelmodusSturing;

architecture Behavioral of InstelmodusSturing is

Signal vorigWerkingsmodus : STD_LOGIC_VECTOR(4 downto 0) := "00001";

begin
instelmodeSelectorSturing : process(sysClk)
	begin
		if rising_edge(sysClk) then
			if reset = '1' then
				nextModeOut <= '0';
				instelmodeReset <= '0';
			elsif huidigWerkingsmodus = vorigWerkingsmodus then
				if nextModeIn = '1' then
					case huidigWerkingsmodus is
						when "00001" =>														--Modus: Uurwerk
							case huidigInstelmodus is
								when "00001" =>												--Normale werking
									nextModeOut <= '1';
									instelmodeReset <= '0';
								when "00010" =>												--Instellen uren
									nextModeOut <= '1';
									instelmodeReset <= '0';
								when "00100" =>												--Instellen minuten
									nextModeOut <= '1';
									instelmodeReset <= '0';
								when "01000" =>												--Reset seconden
									nextModeOut <= '0';
									instelmodeReset <= '1';
								when others =>													--Ongeldige instelmodus: reset InstelmodeSelector
									nextModeOut <= '0';
									instelmodeReset <= '1';
							end case;
						when "00010" =>														--Modus: Datum
							case huidigInstelmodus is
								when "00001" =>												--Normale werking
									nextModeOut <= '1';
									instelmodeReset <= '0';
								when "00010" =>												--Instellen dag
									nextModeOut <= '1';
									instelmodeReset <= '0';
								when "00100" =>												--Instellen maand
									nextModeOut <= '1';
									instelmodeReset <= '0';
								when "01000" =>												--Instellen jaren
									nextModeOut <= '0';
									instelmodeReset <= '1';
								when others =>													--Ongeldige instelmodus: reset InstelmodeSelector
									nextModeOut <= '0';
									instelmodeReset <= '1';
							end case;
						when "00100" =>														--Modus: Alarm
							case huidigInstelmodus is
								when "00001" =>												--Normale werking
									nextModeOut <= '1';
									instelmodeReset <= '0';
								when "00010" =>												--Instellen alarmuur
									nextModeOut <= '1';
									instelmodeReset <= '0';
								when "00100" =>												--Instellen alarmminuten
									nextModeOut <= '0';
									instelmodeReset <= '1';
								when others =>													--Ongeldige instelmodus: reset InstelmodeSelector
									nextModeOut <= '0';
									instelmodeReset <= '1';
							end case;
						when "01000" =>														--Modus: Timer
							case huidigInstelmodus is
								when "00001" =>												--Start timer
									nextModeOut <= '1';
									instelmodeReset <= '0';
								when "00010" =>												--Instellen minuten
									nextModeOut <= '1';
									instelmodeReset <= '0';
								when "00100" =>												--Instellen seconden
									nextModeOut <= '0';
									instelmodeReset <= '1';
								when others =>													--Ongeldige instelmodus: reset InstelmodeSelector
									nextModeOut <= '0';
									instelmodeReset <= '1';
							end case;
						when "10000" =>														--Modus: Chronometer
							case huidigInstelmodus is
								when "00001" =>												--Toon SS:HH
									nextModeOut <= '1';
									instelmodeReset <= '0';
								when "00010" =>												--Toon UU:MM
									nextModeOut <= '0';
									instelmodeReset <= '1';
								when others =>													--Ongeldige instelmodus: reset InstelmodeSelector
									nextModeOut <= '0';
									instelmodeReset <= '1';
							end case;
						when others =>															--Ongeldige werkingsmodus
							nextModeOut <= '0';
							instelmodeReset <= '0';
					end case;
				else																				--Nieuwe werkingsmodus
					nextModeOut <= '0';
					instelmodeReset <= '0';
				end if;
			else
				nextModeOut <= '0';
				instelmodeReset <= '1';
				vorigWerkingsmodus <= huidigWerkingsmodus;
			end if;
		end if;
	end process;

end Behavioral;

