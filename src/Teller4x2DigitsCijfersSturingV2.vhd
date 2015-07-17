----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    19/10/2013 
-- Design Name:    Basisklok
-- Module Name:    Teller4x2DigitsCijfersSturingV2
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Teller4x2DigitsCijfersSturingV2 is
	Port ( sysClk : in STD_LOGIC;
			 enable : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 updownIn : in STD_LOGIC;
			 disZet : in STD_LOGIC_VECTOR(3 downto 0);
			 disCt : in STD_LOGIC_VECTOR(2 downto 0);
			 updownUit : out STD_LOGIC := '0';
			 disEnable : out STD_LOGIC_VECTOR(3 downto 0) := "0000");		 
end Teller4x2DigitsCijfersSturingV2;

architecture Behavioral of Teller4x2DigitsCijfersSturingV2 is

Type state is (state1, state2);																	--2 toestanden
Signal presentState, nextState : state := state1;
Signal enable_intern : STD_LOGIC := '0';
Signal disZet_intern : STD_LOGIC_VECTOR(3 downto 0) := "0000";

begin						
enableBuffer : process(sysClk)
	begin
		if rising_edge(sysclk) then
			if reset = '1' then
				enable_intern <= '0';
			else
				enable_intern <= enable;
			end if;
		end if;
	end process;				

disZetBuffer : process(sysClk)
	begin
		if rising_edge(sysClk) then
			if reset = '1' then
				disZet_intern <= "0000";
			else
				disZet_intern <= disZet;
			end if;
		end if;
	end process;

updownBuffer : process(sysClk)
	begin
		if rising_edge(sysClk) then
			if reset = '1' then
				updownUit <= '0';
			else
				updownUit <= updownIn;
			end if;
		end if;
	end process;

StateRegister : process(sysClk)																	--Finite state machine (Mealy - uitgangen afhankelijk van de huidige stand en ingangen)
	begin
		if rising_edge(sysClk) then
			if reset = '1' then
				presentState <= state1;
			else
				presentState <= nextState;
			end if;
		end if;
	end process;

Uitgangen : process(presentState, disZet_intern, disCt, enable_intern)
	begin
		case presentState is
			when state1 =>
				disEnable(0) <= enable_intern;
				disEnable(1) <= disCt(0);
				disEnable(2) <= disCt(1);
				disEnable(3) <= disCt(2);
			when state2 =>
				if disZet_intern(0) = '1' then
					disEnable(0) <= enable_intern;
				else
					disEnable(0) <= '0';
				end if;
				if disZet_intern(1) = '1' then
					disEnable(1) <= enable_intern;
				else
					disEnable(1) <= '0';
				end if;
				if disZet_intern(2) = '1' then
					disEnable(2) <= enable_intern;
				else
					disEnable(2) <= '0';
				end if;
				if disZet_intern(3) = '1' then
					disEnable(3) <= enable_intern;
				else
					disEnable(3) <= '0';
				end if;			
			when others =>																				--Onbekende toestand: stop tellen
				disEnable <= "0000";
		end case;
	end process;

NxtState : process(presentState, disZet)
	begin
		case presentState is
			when state1 =>																				--Modus: default tellen
				if disZet = "0000" then
					nextState <= state1;
				else
					nextState <= state2;
				end if;
			when state2 =>																				--Modus: instellen
				if disZet = "0000" then
					nextState <= state1;
				else
					nextState <= state2;
				end if;
			when others =>																				--Onbekende toestand: default tellen
				nextState <= state1;
		end case;
	end process;
	
end Behavioral;

