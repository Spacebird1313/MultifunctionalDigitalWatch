----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    07/10/2013 
-- Design Name:    Basisklok
-- Module Name:    PulsSelector
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PulsSelector is
	Port ( sysClk : in STD_LOGIC;
			 puls0 : in STD_LOGIC;
			 puls1 : in STD_LOGIC;
			 selectPuls : in STD_LOGIC;
	       reset : in STD_LOGIC;
			 pulsUit : out STD_LOGIC := '0');
end PulsSelector;

architecture Behavioral of PulsSelector is

Type state is (state1, state2);							--2 toestanden
Signal presentState, nextState : state := state1;

begin																--Finite state machine (Mealy - uitgang afhankelijk van de huidige stand en ingangen)
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

NxtState : process(presentState, selectPuls)
	begin
		case presentState is									
			when state1 =>										--Stuur puls 0 door
				if selectPuls = '1' then
					nextState <= state2;
				else
					nextState <= state1;
				end if;
			when others =>										--Stuur puls 1 door
				if selectPuls <= '0' then
					nextState <= state1;
				else
					nextState <= state2;
				end if;
		end case;
	end process;

pulsUit <= puls0 when presentState = state1 else   --Uitgang FSM
			  puls1;
							
end Behavioral;

