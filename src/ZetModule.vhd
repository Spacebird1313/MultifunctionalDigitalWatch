----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    20/10/2013 
-- Design Name:    Basisklok
-- Module Name:    ZetModule
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ZetModule is
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       enableIn : in STD_LOGIC;
	       clkZet : in STD_LOGIC;
	       clkDelay : in STD_LOGIC;						--Vertraging voor snel zetten (delay = 2x clkDelay)
	       up : in STD_LOGIC;
	       down : in STD_LOGIC;
	       updownCount : in STD_LOGIC;					--Telrichting in defaultmodus tellen
	       zetIn : in STD_LOGIC_VECTOR(3 downto 0);				--zet: (0) = zet Dis0, (1) = zet Dis1, (2) = zet Dis2, (3) = zet Dis3	
	       enableUit : out STD_LOGIC := '0';
	       updown : out STD_LOGIC := '0';
	       zetUit : out STD_LOGIC_VECTOR(3 downto 0) := "0000");		 
end ZetModule;

architecture struct of ZetModule is
	component ZetSelector
	Port ( sysClk : in STD_LOGIC;
	       enableIn : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       up : in STD_LOGIC;
	       down : in STD_LOGIC;
	       updownCount : in STD_LOGIC;
	       zetIn : in STD_LOGIC_VECTOR(3 downto 0);
	       enableUit : out STD_LOGIC;
	       updown : out STD_LOGIC;
	       zetUit : out STD_LOGIC_VECTOR(3 downto 0));
	end component;
	
	component Pulsmodule
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       signalIn : in STD_LOGIC;
	       pulsOut : out STD_LOGIC);
	end component;
	
	component DelayedPulsGenerator
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       pulsClk : in STD_LOGIC;
	       delayClk : in STD_LOGIC;
	       signalIn : in STD_LOGIC;
	       pulsOut : out STD_LOGIC);
	end component;

	--Interne signalen
Signal up_intern : STD_LOGIC := '0';
Signal down_intern : STD_LOGIC := '0';
Signal upPuls_intern : STD_LOGIC := '0';
Signal upDelayPuls_intern : STD_LOGIC := '0';
Signal downPuls_intern : STD_LOGIC := '0';
Signal downDelayPuls_intern : STD_LOGIC := '0';


begin
	Inst_zetSelector : zetSelector
		Port map( sysClk => sysClk,
			  enableIn => enableIn,
			  reset => reset,
			  up => up_intern,
			  down => down_intern,
			  updownCount => updownCount,
			  zetIn => zetIn,
			  enableUit => enableUit,
			  updown => updown,
			  zetUit => zetUit);					 
	
	Inst_PulsmoduleUp : Pulsmodule
		Port map( sysClk => sysClk,
			  reset => reset,
			  signalIn => up,
			  pulsOut => upPuls_intern);

	Inst_PulsmoduleDown : Pulsmodule
		Port map( sysClk => sysClk,
			  reset => reset,
			  signalIn => down,
			  pulsOut => downPuls_intern);

	Inst_DelaydPulsGeneratorUp : DelayedPulsGenerator
		Port map( sysClk => sysClk,
			  reset => reset,
			  pulsClk => clkZet,
			  delayClk => clkDelay,
			  signalIn => up,
			  pulsOut => upDelayPuls_intern);

	Inst_DelaydPulsGeneratorDown : DelayedPulsGenerator
		Port map( sysClk => sysClk,
			  reset => reset,
			  pulsClk => clkZet,
			  delayClk => clkDelay,
			  signalIn => down,
			  pulsOut => downDelayPuls_intern);

up_intern <= upPuls_intern or upDelayPuls_intern;
down_intern <= downPuls_intern or downDelayPuls_intern;

end struct;
