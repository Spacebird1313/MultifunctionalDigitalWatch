----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    20/10/2013 
-- Design Name:    Basisklok
-- Module Name:    DelayedPulsGenerator
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DelayedPulsGenerator is
	Port ( sysClk : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 pulsClk : in STD_LOGIC;
			 delayClk : in STD_LOGIC;
			 signalIn : in STD_LOGIC;
			 pulsOut : out STD_LOGIC := '0');
end DelayedPulsGenerator;

architecture Behavioral of DelayedPulsGenerator is

Type state is (state1, state2, state3);						--3 toestanden
Signal presentState, nextState : state := state1;

begin																		--Finite state machine (Mealy - uitgangen afhankelijk van de huidige stand en ingangen)
StateRegister : process(sysClk)
	begin
		if rising_edge(sysClk) then
			if reset = '1' then
				presentState <= state1;
			else
				presentState <= nextState;
			end if;
		end if;
	end process;				

Uitgangen : process(presentState, pulsClk)
	begin
		case presentState is
			when state3 =>
				if pulsClk = '1' then
					pulsOut <= '1';
				else
					pulsOut <= '0';
				end if;
			when others =>
				pulsOut <= '0';
		end case;
	end process;

NxtState : process(presentState, delayClk, signalIn)
	begin
		case presentState is
			when state1 =>												--Begin toestand
				if signalIn = '1' then
					if delayClk = '1' then
						nextState <= state2;
					else
						nextState <= state1;
					end if;
				else
					nextState <= state1;
				end if;
			when state2 =>												--Toets indrukken (delay = delayClk)
				if signalIn = '1' then
					if delayClk = '1' then
						nextState <= state3;
					else
						nextState <= state2;
					end if;
				else
					nextState <= state1;
				end if;
			when state3 =>												--Toets ingedrukt houden (state3)
				if signalIn = '1' then
					nextState <= state3;
				else
					nextState <= state1;
				end if;
			when others =>												--Onbekende toestand
				nextState <= state1;
		end case;
	end process;

end Behavioral;