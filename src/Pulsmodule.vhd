----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    05/10/2013 
-- Design Name:    Basisklok
-- Module Name:    Pulsmodule
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Pulsmodule is
	Port ( sysClk : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 signalIn : in STD_LOGIC;
			 pulsOut : out STD_LOGIC:= '0');
end Pulsmodule;

architecture Behavioral of Pulsmodule is	

Type state is (state1, state2, state3);						--3 toestanden
Signal presentState, nextState : state := state1;

begin																		--Finite state machine (Moore - houd enkel rekening met huidige toestand)
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

Uitgangen : process(presentState)
	begin
		case presentState is
			when state2 => pulsOut <= '1';
			when others => pulsOut <= '0';
		end case;
	end process;

NxtState : process(presentState, signalIn)
	begin
		case presentState is
			when state1 =>												--Begin toestand
				if signalIn = '1' then
					nextState <= state2;
				else
					nextState <= state1;
				end if;
			when state2 =>												--Toets indrukken
				if signalIn = '0' then
					nextState <= state1;
				else
					nextState <= state3;
				end if;
			when others =>												--Toets ingedrukt houden (state3)
				if signalIn = '0' then
					nextState <= state1;
				else
					nextState <= state3;
				end if;
		end case;
	end process;
	
end Behavioral;

