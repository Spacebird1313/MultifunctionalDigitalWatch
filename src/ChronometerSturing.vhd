----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    30/11/2013 
-- Design Name:    Basisklok
-- Module Name:    ChronometerSturing
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ChronometerSturing is
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
			 enableIn : in STD_LOGIC;
			 startStop : in STD_LOGIC;
			 zet0In : in STD_LOGIC;														
			 enableUit : out STD_LOGIC := '0';
			 updown : out STD_LOGIC := '0';
			 chronoAan : out STD_LOGIC := '0';
			 zet0Uit : out STD_LOGIC_VECTOR(3 downto 0) :="0000";
			 zetUit : out STD_LOGIC_VECTOR(3 downto 0) := "0000");
end ChronometerSturing;

architecture Behavioral of ChronometerSturing is
			 
	--Interne signalen
Signal startStop_intern : STD_LOGIC := '0';
Signal zetUit_intern : STD_LOGIC_VECTOR(3 downto 0) := "0000";

begin
toggleStartStop : process(sysClk)
	begin
		if rising_edge(sysClk) then
			if reset = '1' then
				startStop_intern <= '0';
			else
				if startStop = '1' then
					startStop_intern <= not startStop_intern;
				end if;
			end if;
		end if;
	end process;

chronoAan <= startStop_intern;																--Signaalaanduiding chronometer telt

enableUit <= enableIn and startStop_intern;												--startStop = 0 (stop); startStop = 1 (start)			

updown <= '0';																						--Default telrichting: optellen (up = '0')

zetUit <= "0000";																					--Tellers niet instellen

zet0Uit(3 downto 0) <= (others => zet0In);																	
	 
end Behavioral;