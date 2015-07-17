----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    15/11/2013 
-- Design Name:    Basisklok
-- Module Name:    DatumSturing
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DatumSturing is
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
			 enableIn : in STD_LOGIC;
			 clkZet : in STD_LOGIC;
			 clkDelay : in STD_LOGIC;															--Vertraging voor snel zetten (delay = 2x clkDelay)
			 zetIn : in STD_LOGIC_VECTOR(2 downto 0);										--zet: (0) = zet Dag, (1) = zet Maand, (2) = zet Jaar													
			 up : in STD_LOGIC;
			 down : in STD_LOGIC;
			 MM : in STD_LOGIC_VECTOR(7 downto 0);
			 JJ : in STD_LOGIC_VECTOR(7 downto 0);
			 enableUit : out STD_LOGIC := '0';
			 updown : out STD_LOGIC := '0';
			 zetUit : out STD_LOGIC_VECTOR(3 downto 0) := "0000";
			 DDMax : out STD_LOGIC_VECTOR(7 downto 0) := "00110001");
end DatumSturing;

architecture struct of DatumSturing is
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
			 enableUit : out STD_LOGIC := '0';
			 updown : out STD_LOGIC := '0';
			 zetUit : out STD_LOGIC_VECTOR(3 downto 0));	
	end component;
	
	component DatumController
	Port ( MM : in STD_LOGIC_VECTOR(7 downto 0);
			 JJ : in STD_LOGIC_VECTOR(7 downto 0);
			 DDMax : out STD_LOGIC_VECTOR(7 downto 0));
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
					 
	Inst_DatumController : DatumController
		Port map( MM => MM,
					 JJ => JJ,
					 DDMax => DDMax);

updownCount_intern <= '0';																		--Default telrichting: optellen (up = '0')

zetIn_intern(2 downto 0) <= zetIn(2 downto 0);											--Dag, Maand, Jaar instellen
zetIn_intern(3) <= '0';																			--Dis3 niet gebruikt

zetUit(2 downto 0) <= zetUit_intern(2 downto 0);
zetUit(3) <= '0';																					--Dis3 niet gebruikt
		 
end struct;
