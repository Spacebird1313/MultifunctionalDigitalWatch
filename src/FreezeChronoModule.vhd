----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    25/11/2013 
-- Design Name:    Basisklok
-- Module Name:    FreezeChronoModule
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FreezeChronoModule is
	Port ( sysClk : in STD_LOGIC;
	       freeze : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       HHin : in STD_LOGIC_VECTOR(7 downto 0);
	       SSin : in STD_LOGIC_VECTOR(7 downto 0);
	       MMin : in STD_LOGIC_VECTOR(7 downto 0);
	       UUin : in STD_LOGIC_VECTOR(7 downto 0);
	       HHout : out STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	       SSout : out STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	       MMout : out STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	       UUout : out STD_LOGIC_VECTOR(7 downto 0) := "00000000");
end FreezeChronoModule;

architecture Behavioral of FreezeChronoModule is

Type state is (state1, state2);														--2 toestanden
Signal presentState, nextState : state := state1;
Signal HHFreeze, SSFreeze, MMFreeze, UUFreeze : STD_LOGIC_VECTOR(7 downto 0) := "00000000";

begin
Latchen : process(sysClk)														--Huidige telstand latchen
	begin
		if rising_edge(sysClk) then
			if reset = '1' then
				HHFreeze <= "00000000";
				SSFreeze <= "00000000";
				MMFreeze <= "00000000";
				UUFreeze <= "00000000";
			elsif freeze = '1' then
				HHFreeze <= HHin;
				SSFreeze <= SSin;
				MMFreeze <= MMin;
				UUFreeze <= UUin;
			end if;
		end if;
	end process;
StateRegister : process(sysClk)														--Finite state machine (Mealy - uitgangen afhankelijk van de huidige stand en ingangen)
	begin
		if rising_edge(sysClk) then
			if reset = '1' then
				presentState <= state1;
			else
				presentState <= nextState;
			end if;
		end if;
	end process;
	
Uitgangen : process(presentState, HHin, SSin, MMin, UUin, HHFreeze, SSFreeze, MMFreeze, UUFreeze)
	begin
		case presentState is
			when state1 => 
				HHout <= HHin;
				SSout <= SSin;
				MMout <= MMin;
				UUout <= UUin;
			when state2 =>
				HHout <= HHFreeze;
				SSout <= SSFreeze;
				MMout <= MMFreeze;
				UUout <= UUFreeze;
			when others =>
				HHout <= HHin;
				SSout <= SSin;
				MMout <= MMin;
				UUout <= UUin;
		end case;
	end process;

NxtState : process(presentState, freeze)
	begin
		case presentState is
			when state1 =>													--Continu: Default state
				if freeze = '1' then
					nextState <= state2;
				else
					nextState <= state1;
				end if;	
			when state2 =>													--Freezemode
				if freeze = '1' then
					nextState <= state1;
				else
					nextState <= state2;
				end if;
			when others =>													--Onbekende toestand: naar Continu: Default state
				nextState <= state1;
		end case;	
	end process;

end Behavioral;
