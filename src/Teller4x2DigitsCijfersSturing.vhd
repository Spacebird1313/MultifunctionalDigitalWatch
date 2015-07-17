----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    14/10/2013 
-- Design Name:    Basisklok
-- Module Name:    Teller4x2DigitsCijfersSturing
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Teller4x2DigitsCijfersSturing is
	Port ( sysClk : in STD_LOGIC;
			 enable : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 disSet : in STD_LOGIC_VECTOR(3 downto 0);
			 disCt : in STD_LOGIC_VECTOR(2 downto 0);
			 disEnable : out STD_LOGIC_VECTOR(3 downto 0));
			 
end Teller4x2DigitsCijfersSturing;

architecture Behavioral of Teller4x2DigitsCijfersSturing is

Type state is (state1, state2, state3, state4, state5);				--5 toestanden
Signal presentState, nextState : state := state1;

begin																					--Finite state machine (Mealy - uitgangen afhankelijk van de huidige stand en ingangen)
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

Uitgangen : process(presentState, disCt, enable)
	begin
		case presentState is
			when state1 =>
				disEnable(0) <= enable;
				disEnable(1) <= disCt(0);
				disEnable(2) <= disCt(1);
				disEnable(3) <= disCt(2);
			when state2 =>
				disEnable(0) <= enable;
				disEnable(1) <= '0';
				disEnable(2) <= '0';
				disEnable(3) <= '0';
			when state3 =>
				disEnable(0) <= '0';
				disEnable(1) <= enable;
				disEnable(2) <= '0';
				disEnable(3) <= '0';
			when state4 =>
				disEnable(0) <= '0';
				disEnable(1) <= '0';
				disEnable(2) <= enable;
				disEnable(3) <= '0';
			when state5 =>
				disEnable(0) <= '0';
				disEnable(1) <= '0';
				disEnable(2) <= '0';
				disEnable(3) <= enable;
			when others =>
				disEnable <= "0000";
		end case;
	end process;

NxtState : process(disSet)
	begin
		case disSet is
			when "0000" =>															--Modus: default teller
				nextState <= state1;
			when "0001" =>															--Modus: stel teller 1 in
				nextState <= state2;
			when "0010" =>															--Modus: stel teller 2 in
				nextState <= state3;
			when "0100" =>															--Modus: stel teller 3 in
				nextState <= state4;												
			when "1000" =>															--Modus: stel teller 4 in
				nextState <= state5;
			when others =>															--Onbekende toestand: default teller
				nextState <= state1;
		end case;
	end process;
	
end Behavioral;

