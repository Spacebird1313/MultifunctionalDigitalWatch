----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    19/10/2013 
-- Design Name:    Basisklok
-- Module Name:    UurwerkSturing
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UurwerkSturing is
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       enableIn : in STD_LOGIC;
	       clkZet : in STD_LOGIC;
	       clkDelay : in STD_LOGIC;								--Vertraging voor snel zetten (delay = 2x clkDelay)
	       zetIn : in STD_LOGIC_VECTOR(2 downto 0);						--zet: (0) = zet Uur, (1) = zet Min, (2) = zet Sec														
	       up : in STD_LOGIC;
	       down : in STD_LOGIC;
	       enableUit : out STD_LOGIC := '0';
	       updown : out STD_LOGIC := '0';
	       zet0 : out STD_LOGIC_VECTOR(3 downto 0) := "0000";
	       zetUit : out STD_LOGIC_VECTOR(3 downto 0) := "0000");
end UurwerkSturing;

architecture struct of UurwerkSturing is
	component ZetModule
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       enableIn : in STD_LOGIC;
	       clkZet : in STD_LOGIC;
	       clkDelay : in STD_LOGIC;								--Vertraging voor snel zetten (delay = 2x clkDelay)
	       up : in STD_LOGIC;
	       down : in STD_LOGIC;
	       updownCount : in STD_LOGIC;							--Telrichting in defaultmodus tellen
	       zetIn : in STD_LOGIC_VECTOR(3 downto 0);						--zet: (0) = zet Dis0, (1) = zet Dis1, (2) = zet Dis2, (3) = zet Dis3	
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

updownCount_intern <= '0';									--Default telrichting: optellen (up = '0')

zetIn_intern(0) <= '0';										--Sec niet instellen
zetIn_intern(1) <= zetIn(1);									--Min instellen
zetIn_intern(2) <= zetIn(0);									--Uur instellen
zetIn_intern(3) <= '0';										--Dis3 niet gebruikt

zetUit(0) <= '0';										--Sec niet instellen
zetUit(2 downto 1) <= zetUit_intern(2 downto 1);
zetUit(3) <= '0';										--Dis3 niet gebruikt

zet0(0) <= zetIn(2) and up;
zet0(2 downto 1) <= "00";									--Min, Uren niet resetten
zet0(3) <= '0';											--Dis3 niet gebruikt
	 
end struct;
