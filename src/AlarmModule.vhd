----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    25/11/2013 
-- Design Name:    Basisklok
-- Module Name:    AlarmModule
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AlarmModule is
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
			 toggleAlarm : in STD_LOGIC;
			 alarmUit : in STD_LOGIC;
			 MM : in STD_LOGIC_VECTOR(7 downto 0);
			 UU : in STD_LOGIC_VECTOR(7 downto 0);
			 alarmMM : in STD_LOGIC_VECTOR(7 downto 0);
			 alarmUU : in STD_LOGIC_VECTOR(7 downto 0);
			 alarmActief : out STD_LOGIC := '0';
			 alarmSignaal : out STD_LOGIC := '0');
end AlarmModule;

architecture struct of AlarmModule is

Type state is (state1, state2, state3, state4);															--4 toestanden
Signal presentState, nextState : state := state1;

begin																													--Finite state machine (Moore - houd enkel rekening met huidige toestand)
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
			when state1 => 
				alarmActief <= '0';
				alarmSignaal <= '0';
			when state2 =>
				alarmActief <= '1';
				alarmSignaal <= '0';
			when state3 =>
				alarmActief <= '1';
				alarmSignaal <= '1';
			when state4 =>
				alarmActief <= '1';
				alarmSignaal <= '0';
			when others =>
				alarmActief <= '0';
				alarmSignaal <= '0';
		end case;
	end process;

NxtState : process(presentState, toggleAlarm, alarmUit, MM, UU, alarmMM, alarmUU)
	begin
		case presentState is
			when state1 =>																							--Alarm uit: Default state
				if toggleAlarm = '1' then
					nextState <= state2;
				else
					nextState <= state1;
				end if;				
			when state2 =>																							--Alarm aan
				if toggleAlarm = '1' then
					nextState <= state1;
				else
					if MM = alarmMM and UU = alarmUU then
						nextState <= state3;
					else
						nextState <= state2;
					end if;
				end if;
			when state3 =>																							--Alarm actief (signaal voor 1 min of tot toetsindrukking)
				if toggleAlarm = '1' then
					nextState <= state1;
				else
					if MM /= alarmMM or UU /= alarmUU then
						nextState <= state2;
					elsif alarmUit = '1' then
						nextState <= state4;
					else
						nextState <= state3;
					end if;
				end if;
			when state4 =>																							--Alarm stil
				if toggleAlarm = '1' then
					nextState <= state1;
				elsif MM /= alarmMM or UU /= alarmUU then
					nextState <= state2;
				else
					nextState <= state4;
				end if;
			when others =>																							--Onbekende toestand: naar Alarm uit: Default state
				nextState <= state1;
		end case;	
	end process;

end struct;