----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    20/10/2013 
-- Design Name:    Basisklok
-- Module Name:    ZetSelector
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ZetSelector is
	Port ( sysClk : in STD_LOGIC;
			 enableIn : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 up : in STD_LOGIC;
			 down : in STD_LOGIC;
			 updownCount : in STD_LOGIC;																				--Telrichting in defaultmodus tellen
			 zetIn : in STD_LOGIC_VECTOR(3 downto 0);
			 enableUit : out STD_LOGIC := '0';
			 updown : out STD_LOGIC := '0';
			 zetUit : out STD_LOGIC_VECTOR(3 downto 0) := "0000");
end ZetSelector;

architecture Behavioral of ZetSelector is

Type state is (state1, state2, state3);																			--3 toestanden
Signal presentState, nextState : state := state1;
Signal up_intern, down_intern : STD_LOGIC := '0';
Signal zetIn_intern : STD_LOGIC_VECTOR(3 downto 0) := "0000";

begin
upBuffer : process(sysClk)
	begin
		if rising_edge(sysclk) then
			if reset = '1' then
				up_intern <= '0';
			else
				up_intern <= up;
			end if;
		end if;
	end process;

downBuffer : process(sysClk)
	begin
		if rising_edge(sysclk) then
			if reset = '1' then
				down_intern <= '0';
			else
				down_intern <= down;
			end if;
		end if;
	end process;	

disZetBuffer : process(sysClk)
	begin
		if rising_edge(sysClk) then
			if reset = '1' then
				zetIn_intern <= "0000";
			else
				zetIn_intern <= zetIn;
			end if;
		end if;
	end process;

StateRegister : process(sysClk)																					--Finite state machine (Mealy - uitgangen afhankelijk van de huidige stand en ingangen)
	begin
		if rising_edge(sysClk) then
			if reset = '1' then
				presentState <= state1;
			else
				presentState <= nextState;
			end if;
		end if;
	end process;

Uitgangen : process(presentState, enableIn, updownCount, zetIn_intern, up_intern, down_intern)
	begin
		case presentState is
			when state1 =>
				enableUit <= enableIn;
				updown <= updownCount;
				zetUit <= "0000";
			when state2 =>
				if enableIn = '1' then
					enableUit <= enableIn;
					updown <= updownCount;
					zetUit <= "0000";
				else
					enableUit <= up_intern;
					updown <= '0';
					zetUit <= zetIn_intern;
				end if;
			when state3 =>
				if enableIn = '1' then
					enableUit <= enableIn;
					updown <= updownCount;
					zetUit <= "0000";
				else
					enableUit <= down_intern;
					updown <= '1';
					zetUit <= zetIn_intern;
				end if;
		end case;
	end process;

NxtState : process(presentState, zetIn, up, down)
	begin
		case presentState is
			when state1 =>																									--Modus: default standaard tellen
				if zetIn = "0000" then
					nextState <= state1;
				else
					if up = '0' and down = '0' then
						nextState <= state1;
					elsif up = '1' then
						nextState <= state2;
					elsif down = '1' then
						nextState <= state3;
					else
						nextState <= state1;
					end if;
				end if;
			when state2 =>																									--Modus: teller zetten (up)
				if zetIn = "0000" then
					nextState <= state1;
				else
					if up = '0' then
						nextState <= state1;
					else
						nextState <= state2;
					end if;
				end if;
			when state3 =>																									--Modus: teller zetten (down)
				if zetIn = "0000" then
					nextState <= state1;
				else
					if down = '0' then
						nextState <= state1;
					else
						nextState <= state3;
					end if;
				end if;
			when others =>																									--Onbekende toestand: default standaard tellen
				nextState <= state1;
		end case;
	end process;

end Behavioral;

