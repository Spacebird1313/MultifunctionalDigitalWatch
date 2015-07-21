----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    12/10/2013 
-- Design Name:    Basisklok
-- Module Name:    PulsToSelectedModule
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PulsToSelectedModule is
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       selectedModus : in STD_LOGIC_VECTOR(4 downto 0);
	       pulsIn : in STD_LOGIC_VECTOR(2 downto 0);
	       pulsOutM0 : out STD_LOGIC_VECTOR(2 downto 0) := "000";				--Module 0
	       pulsOutM1 : out STD_LOGIC_VECTOR(2 downto 0) := "000";				--Module 1
	       pulsOutM2 : out STD_LOGIC_VECTOR(2 downto 0) := "000";				--Module 2
	       pulsOutM3 : out STD_LOGIC_VECTOR(2 downto 0) := "000";				--Module 3
	       pulsOutM4 : out STD_LOGIC_VECTOR(2 downto 0) := "000");				--Module 4
			 
end PulsToSelectedModule;

architecture Behavioral of PulsToSelectedModule is

Type state is (state1, state2, state3, state4, state5);						--5 toestanden
Signal presentState, nextState : state := state1;

begin												--Finite state machine (Mealy - uitgangen afhankelijk van de huidige stand en ingangen)
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

Uitgangen : process(presentState, pulsIn)
	begin
		case presentState is
			when state1 =>
				pulsOutM0(1 downto 0) <= pulsIn(1 downto 0);
				pulsOutM0(2) <= '0';
				pulsOutM1 <= "000";
				pulsOutM2(1 downto 0) <= "00";
				pulsOutM2(2) <= pulsIn(2);
				pulsOutM3 <= "000";
				pulsOutM4 <= "000";
			when state2 =>
				pulsOutM0 <= "000";
				pulsOutM1 <= pulsIn;
				pulsOutM2 <= "000";
				pulsOutM3 <= "000";
				pulsOutM4 <= "000";
			when state3 =>
				pulsOutM0 <= "000";
				pulsOutM1 <= "000";
				pulsOutM2 <= pulsIn;
				pulsOutM3 <= "000";
				pulsOutM4 <= "000";
			when state4 =>
				pulsOutM0 <= "000";
				pulsOutM1 <= "000";
				pulsOutM2 <= "000";
				pulsOutM3 <= pulsIn;
				pulsOutM4 <= "000";
			when state5 =>
				pulsOutM0 <= "000";
				pulsOutM1 <= "000";
				pulsOutM2 <= "000";
				pulsOutM3 <= "000";
				pulsOutM4 <= pulsIn;
			when others =>
				pulsOutM0 <= "000";
				pulsOutM1 <= "000";
				pulsOutM2 <= "000";
				pulsOutM3 <= "000";
				pulsOutM4 <= "000";
		end case;
	end process;
	
NxtState : process(selectedModus)
	begin
		case selectedModus is
			when "00001" =>								--Ingang naar module 0 schakelen
				nextState <= state1;
			when "00010" =>								--Ingang naar module 1 schakelen
				nextState <= state2;
			when "00100" =>								--Ingang naar module 2 schakelen
				nextState <= state3;
			when "01000" =>								--Ingang naar module 3 schakelen
				nextState <= state4;
			when "10000" =>								--Ingang naar module 4 schakelen
				nextState <= state5;
			when others =>								--Onbekende toestand: Ingang naar module 0 schakelen
				nextState <= state1;
		end case;
	end process;

end Behavioral;
