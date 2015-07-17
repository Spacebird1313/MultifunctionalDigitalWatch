----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    30/11/2013 
-- Design Name:    Basisklok
-- Module Name:    TimerSturing
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TimerSturing is
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
			 enableIn : in STD_LOGIC;
			 clkZet : in STD_LOGIC;
			 clkDelay : in STD_LOGIC;															--Vertraging voor snel zetten (delay = 2x clkDelay)
			 zetIn : in STD_LOGIC_VECTOR(1 downto 0);										--zet: (0) = zet Min, (1) = zet Sec													
			 up : in STD_LOGIC;
			 down : in STD_LOGIC;
			 enableUit : out STD_LOGIC := '0';
			 updown : out STD_LOGIC := '0';
			 zet0 : out STD_LOGIC_VECTOR(3 downto 0) := "0000";
			 zetUit : out STD_LOGIC_VECTOR(3 downto 0) := "0000");
end TimerSturing;

architecture struct of TimerSturing is
	component ZetModule
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
			 enableIn : in STD_LOGIC;
			 clkZet : in STD_LOGIC;
			 clkDelay : in STD_LOGIC;															--Vertraging voor snel zetten (delay = 2x clkDelay)
			 up : in STD_LOGIC;
			 down : in STD_LOGIC;
			 updownCount : in STD_LOGIC;														--Telrichting in defaultmodus tellen
			 zetIn : in STD_LOGIC_VECTOR(3 downto 0);										--zet: (0) = zet Dis0, (1) = zet Dis1, (2) = zet Dis2, (3) = zet Dis3	
			 enableUit : out STD_LOGIC;
			 updown : out STD_LOGIC;
			 zetUit : out STD_LOGIC_VECTOR(3 downto 0));	
	end component;
			 
	--Interne signalen
Signal updownCount_intern : STD_LOGIC := '0';
Signal zetIn_intern : STD_LOGIC_VECTOR(3 downto 0) := "0000";
Signal zetUit_intern : STD_LOGIC_VECTOR(3 downto 0) := "0000";

begin
	Inst_ZetModule : ZetModule
		Port map( sysClk => sysClk,
				    reset => reset,
					 enableIn => enableIn,
					 clkZet => clkZet,
					 clkDelay => clkDelay,
					 up => up,
					 down => down,
					 updownCount => updownCount_intern,
					 zetIn => zetIn_intern,
					 enableUit => enableUit,
					 updown => updown,
					 zetUit => zetUit_intern);	 

updownCount_intern <= '1';																		--Default telrichting: aftellen (down = '1')

zetIn_intern(0) <= zetIn(1);																	--Sec instellen
zetIn_intern(1) <= zetIn(0);																	--Min instellen
zetIn_intern(2) <= '0';																			--Dis2 niet gebruikt
zetIn_intern(3) <= '0';																			--Dis3 niet gebruikt

zetUit(1 downto 0) <= zetUit_intern(1 downto 0);
zetUit(3 downto 2) <= "00";																	--Dis2, Dis3 niet gebruikt

zet0(3 downto 0) <= "0000";																	--Sec, Min niet resetten
																										--Dis2, Dis3 niet gebruikt
	 
end struct;