----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    07/10/2013 
-- Design Name:    Basisklok
-- Module Name:    WerkingsmodeSelector
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity WerkingsmodeSelector is
	Port ( sysClk : in STD_LOGIC;
			 nextMode : in STD_LOGIC;
	       reset : in STD_LOGIC;
			 currentMode : out STD_LOGIC_VECTOR(4 downto 0) := "00001");
end WerkingsmodeSelector;

architecture Behavioral of WerkingsmodeSelector is

Type state is (state1, state2, state3, state4, state5);				--5 toestanden
Signal presentState, nextState : state := state1;

begin																					--Finite state machine (Moore - houd enkel rekening met huidige toestand)
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
			when state1 => currentMode <= "00001";
			when state2 => currentMode <= "00010";
			when state3 => currentMode <= "00100";
			when state4 => currentMode <= "01000";
			when state5 => currentMode <= "10000";
			when others => currentMode <= "00001";
		end case;
	end process;

NxtState : process(presentState, nextMode)
	begin
		case presentState is
			when state1 =>															--Modus: tijdfunctie (Default state)
				if nextMode = '1' then
					nextState <= state2;
				else
					nextState <= state1;
				end if;
			when state2 =>															--Modus: datumfunctie
				if nextMode = '1' then
					nextState <= state3;
				else
					nextState <= state2;
				end if;
			when state3 =>															--Modus: alarmfunctie
				if nextMode = '1' then
					nextState <= state4;
				else
					nextState <= state3;
				end if;
			when state4 =>															--Modus: timerfunctie
				if nextMode = '1' then
					nextState <= state5;
				else
					nextState <= state4;
				end if;
			when state5 =>															--Modus: chronometerfunctie
				if nextMode = '1' then
					nextState <= state1;
				else
					nextState <= state5;
				end if;
			when others =>															--Onbekende toestand: naar modus: tijdsfunctie
				nextState <= state1;
		end case;
	end process;

end Behavioral;

