----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    18/11/2013 
-- Design Name:    Basisklok
-- Module Name:    Alarm
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Alarm is
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       clk2Hz : in STD_LOGIC;																--Vertraging voor snel zetten (delay = 1Hz)
	       clk4Hz : in STD_LOGIC;
	       up : in STD_LOGIC;
	       down : in STD_LOGIC;
	       toggleAlarm : in STD_LOGIC;														--Alarm: uit-aan
	       alarmUit : in STD_LOGIC;															--Stop het alarmsignaal vroegtijdig
	       zet : in STD_LOGIC_VECTOR(1 downto 0);										--zet: (0) = instellen Uur, (1) = instellen Min												
	       MM : in STD_LOGIC_VECTOR(7 downto 0);
	       UU : in STD_LOGIC_VECTOR(7 downto 0);
	       alarmActief : out STD_LOGIC := '0';
	       alarmSignaal : out STD_LOGIC := '0';
	       alarmMM : out STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	       alarmUU : out STD_LOGIC_VECTOR(7 downto 0) := "00000000");
end Alarm;

architecture struct of Alarm is
	component Teller4x2DigitsCijfers
	Generic ( minDis0 : integer := 0;
		  minDis1 : integer := 0;
		  minDis2 : integer := 0;
		  minDis3 : integer := 0);
	Port ( sysClk : in STD_LOGIC;
	       updown : in STD_LOGIC;
	       enable : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       zet : in STD_LOGIC_VECTOR(3 downto 0);
	       zet0 : in STD_LOGIC_VECTOR(3 downto 0);
	       dis0Max : in STD_LOGIC_VECTOR(7 downto 0);
	       dis1Max : in STD_LOGIC_VECTOR(7 downto 0);
	       dis2Max : in STD_LOGIC_VECTOR(7 downto 0);
	       dis3Max : in STD_LOGIC_VECTOR(7 downto 0);
	       ct : out STD_LOGIC_VECTOR(3 downto 0);
	       dis0Out : out STD_LOGIC_VECTOR(7 downto 0);
	       dis1Out : out STD_LOGIC_VECTOR(7 downto 0);
	       dis2Out : out STD_LOGIC_VECTOR(7 downto 0);
	       dis3Out : out STD_LOGIC_VECTOR(7 downto 0));
	end component;
	
	component AlarmSturing
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       clkZet : in STD_LOGIC;
	       clkDelay : in STD_LOGIC;															--Vertraging voor snel zetten (delay = 2x clkDelay)
	       zetIn : in STD_LOGIC_VECTOR(1 downto 0);										--zet: (0) = zet Uur, (1) = zet Min													
	       up : in STD_LOGIC;
	       down : in STD_LOGIC;
	       enableUit : out STD_LOGIC := '0';
	       updown : out STD_LOGIC := '0';
	       zet0 : out STD_LOGIC_VECTOR(3 downto 0) := "0000";
	       zetUit : out STD_LOGIC_VECTOR(3 downto 0) := "0000");
	end component;
	
	component AlarmModule
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       toggleAlarm : in STD_LOGIC;
	       alarmUit : in STD_LOGIC;
	       MM : in STD_LOGIC_VECTOR(7 downto 0);
	       UU : in STD_LOGIC_VECTOR(7 downto 0);
	       alarmMM : in STD_LOGIC_VECTOR(7 downto 0);
	       alarmUU : in STD_LOGIC_VECTOR(7 downto 0);
	       alarmActief : out STD_LOGIC;
	       alarmSignaal : out STD_LOGIC);
	end component;
	
	component Pulsmodule
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       signalIn : in STD_LOGIC;
	       pulsOut : out STD_LOGIC);
	end component;
	
	component SignalPulsModule
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       pulsFrequentie : in STD_LOGIC;
	       signalIn : in STD_LOGIC;
	       pulsOut : out STD_LOGIC);
	end component;

	--Interne signalen
Signal enable_intern : STD_LOGIC := '0';
Signal updown_intern : STD_LOGIC := '0';
Signal alarmSignaal_intern : STD_LOGIC := '0';
Signal toggleAlarm_intern : STD_LOGIC := '0';
Signal ct_intern : STD_LOGIC_VECTOR(3 downto 0) := "0000";
Signal zet_intern : STD_LOGIC_VECTOR(3 downto 0) := "0000";
Signal zet0_intern : STD_LOGIC_VECTOR(3 downto 0) := "0000";
Signal dis0Max_intern : STD_LOGIC_VECTOR(7 downto 0) := "01011001";				--dis0Max = 59 (Min)
Signal dis1Max_intern : STD_LOGIC_VECTOR(7 downto 0) := "00100011";				--dis1Max = 23	(Uren)
Signal dis2Max_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000001";				--dis2Max (ongebruikte teller)
Signal dis3Max_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000001";				--dis3Max (ongebruikte teller)
Signal dis0Out_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
Signal dis1Out_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
Signal dis2Out_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
Signal dis3Out_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";	

begin
	Inst_Teller4x2DigitsCijfers : Teller4x2DigitsCijfers
		Generic map( minDis0 => 0,
			     minDis1 => 0,
			     minDis2 => 0,
			     minDis3 => 0)
		Port map( sysClk => sysClk,
			  updown => updown_intern,
			  enable => enable_intern,
	             	  reset => reset,
			  zet => zet_intern,
			  zet0 => zet0_intern,
			  dis0Max => dis0Max_intern,
			  dis1Max => dis1Max_intern,
			  dis2Max => dis2Max_intern,												--Dis2 niet gebruikt
			  dis3Max => dis3Max_intern,												--Dis3 niet gebruikt
			  ct => ct_intern,
			  dis0Out => dis0Out_intern,
			  dis1Out => dis1Out_intern,
			  dis2Out => dis2Out_intern,												--Dis2 niet gebruikt
			  dis3Out => dis3Out_intern);												--Dis3 niet gebruikt
		Inst_AlarmSturing : AlarmSturing
		Port map( sysClk => sysClk,
					 reset => reset,
					 clkZet => clk4Hz,
					 clkDelay => clk2Hz,
					 zetIn => zet,
					 up => up,
					 down => down,
					 enableUit => enable_intern,
					 updown => updown_intern,
					 zet0 => zet0_intern,
					 zetUit => zet_intern);
	
	Inst_AlarmModule : AlarmModule
		Port map( sysClk => sysClk,
			  reset => reset,
			  toggleAlarm => toggleAlarm_intern,
			  alarmUit => alarmUit,
			  MM => MM,
			  UU => UU,
			  alarmMM => dis0Out_intern,
			  alarmUU => dis1Out_intern,
			  alarmActief => alarmActief,
			  alarmSignaal => alarmSignaal_intern);
	
	Inst_PulsmoduleToggleAlarm : Pulsmodule
		Port map( sysClk => sysClk,
			  reset => reset,
			  signalIn => toggleAlarm,
			  pulsOut => toggleAlarm_intern);
	
	Inst_AlarmSignaalPulsModule : SignalPulsModule
		Port map( sysClk => sysClk,
			  reset => reset,
			  pulsFrequentie => clk2Hz,
			  signalIn => alarmSignaal_intern,
			  pulsOut => alarmSignaal);

alarmMM <= dis0Out_intern;
alarmUU <= dis1Out_intern;

dis0Max_intern <= "01011001";																	--dis0Max = 59 (Min)
dis1Max_intern <= "00100011";																	--dis1Max = 23	(Uren)
dis2Max_intern <= "00000001";																	--dis2Max (ongebruikte teller)
dis3Max_intern <= "00000001";																	--dis3Max (ongebruikte teller)

end struct;
