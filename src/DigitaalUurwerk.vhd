----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    07/10/2013 
-- Design Name:    Basisklok
-- Module Name:    DigitaalUurwerk
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DigitaalUurwerk is
	Port ( sysClk : in STD_LOGIC;
	       drukToetsen : in STD_LOGIC_VECTOR(4 downto 0);							--drukToetsen: (0) = werkingsmodus, (1) = instellingsmodus, (2) = verhogen, (3) = verlagen, (4) = functie afhankelijk van werkingsmodus
	       schakelaar : in STD_LOGIC;									--schakelaar: reset
	       leds : out STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	       displaySelect : out STD_LOGIC_VECTOR(3 downto 0) := "1111";
	       displayOut : out STD_LOGIC_VECTOR(7 downto 0) := "11111111");
end DigitaalUurwerk;

architecture struct of DigitaalUurwerk is
	component Klokdeler
	Port ( sysClk : in  STD_LOGIC;
               enable : in  STD_LOGIC;
               CT_500hz : out  STD_LOGIC;
	       CT_100hz : out STD_LOGIC;
	       CT_4hz : out STD_LOGIC;
	       CT_2hz : out STD_LOGIC;
	       CT_1hz : out STD_LOGIC);
	end component;
	
	component Debouncer
	Port ( clk : in STD_LOGIC;
	       buttonIn : in STD_LOGIC_VECTOR(4 downto 0);
	       buttonUit : out STD_LOGIC_VECTOR(4 downto 0));	
	end component;
	
	component Uurwerk
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       clk1Hz : in STD_LOGIC;
	       clk2Hz : in STD_LOGIC;										--Vertraging voor snel zetten (delay = 1Hz)
	       clk4Hz : in STD_LOGIC;
	       up : in STD_LOGIC;
	       down : in STD_LOGIC;
	       zet : in STD_LOGIC_VECTOR(2 downto 0);								--zet: (0) = instellen Uur, (1) = instellen Min, (2) = reset Sec
	       oD : out STD_LOGIC;
	       SS : out STD_LOGIC_VECTOR(7 downto 0);
	       MM : out STD_LOGIC_VECTOR(7 downto 0);
	       UU : out STD_LOGIC_VECTOR(7 downto 0));
	end component;
	
	component Datum
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       oD : in STD_LOGIC;
	       clk2Hz : in STD_LOGIC;										--Vertraging voor snel zetten (delay = 1Hz)
	       clk4Hz : in STD_LOGIC;
	       up : in STD_LOGIC;
	       down : in STD_LOGIC;
	       zet : in STD_LOGIC_VECTOR(2 downto 0);								--zet: (0) = instellen Dag, (1) = instellen Maand, (2) = instellen Jaar														
	       DD : out STD_LOGIC_VECTOR(7 downto 0);
	       MM : out STD_LOGIC_VECTOR(7 downto 0);
	       JJ : out STD_LOGIC_VECTOR(7 downto 0));
	end component;
	
	component Alarm
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       clk2Hz : in STD_LOGIC;										--Vertraging voor snel zetten (delay = 1Hz)
	       clk4Hz : in STD_LOGIC;
	       up : in STD_LOGIC;
	       down : in STD_LOGIC;
	       toggleAlarm : in STD_LOGIC;									--Alarm: uit-aan
	       alarmUit : in STD_LOGIC;										--Stop het alarmsignaal vroegtijdig
	       zet : in STD_LOGIC_VECTOR(1 downto 0);								--zet: (0) = instellen Uur, (1) = instellen Min												
	       MM : in STD_LOGIC_VECTOR(7 downto 0);
	       UU : in STD_LOGIC_VECTOR(7 downto 0);
	       alarmActief : out STD_LOGIC;
	       alarmSignaal : out STD_LOGIC;
	       alarmMM : out STD_LOGIC_VECTOR(7 downto 0);
	       alarmUU : out STD_LOGIC_VECTOR(7 downto 0));
	end component;
	
	component Timer
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       clk1Hz : in STD_LOGIC;
	       clk2Hz : in STD_LOGIC;										--Vertraging voor snel zetten (delay = 1Hz)
	       clk4Hz : in STD_LOGIC;
	       up : in STD_LOGIC;
	       down : in STD_LOGIC;
	       zet : in STD_LOGIC_VECTOR(1 downto 0);								--zet: (0) = instellen Min, (1) = instellen Sec												
	       SS : out STD_LOGIC_VECTOR(7 downto 0);
	       MM : out STD_LOGIC_VECTOR(7 downto 0));
	end component;
	
	component Chronometer
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       clk100Hz : in STD_LOGIC;
	       clk2Hz : in STD_LOGIC;
	       zet0 : in STD_LOGIC;
	       startStop : in STD_LOGIC;	
	       freeze : in STD_LOGIC;
	       chronoActief : out STD_LOGIC;
	       HH : out STD_LOGIC_VECTOR(7 downto 0);
	       SS : out STD_LOGIC_VECTOR(7 downto 0);
	       MM : out STD_LOGIC_VECTOR(7 downto 0);
	       UU : out STD_LOGIC_VECTOR(7 downto 0));
	end component;
	
	component Display
	Port ( clk : in STD_LOGIC;
	       clkBlink : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       huidigWerkingsmode : in STD_LOGIC_VECTOR(4 downto 0);
	       huidigInstelmode : in STD_LOGIC_VECTOR(4 downto 0);
	       M0SS : in STD_LOGIC_VECTOR(7 downto 0);								--Uitgangen module: uurwerk
	       M0MM : in STD_LOGIC_VECTOR(7 downto 0);
	       M0UU : in STD_LOGIC_VECTOR(7 downto 0);
	       M1DD : in STD_LOGIC_VECTOR(7 downto 0);								--Uitgangen module: datum
	       M1MM : in STD_LOGIC_VECTOR(7 downto 0);
	       M1JJ : in STD_LOGIC_VECTOR(7 downto 0);
	       M2MM : in STD_LOGIC_VECTOR(7 downto 0);								--Uitgangen module: alarm
	       M2UU : in STD_LOGIC_VECTOR(7 downto 0);
	       M3SS : in STD_LOGIC_VECTOR(7 downto 0);								--Uitgangen module: timer
	       M3MM : in STD_LOGIC_VECTOR(7 downto 0);
	       M4HH : in STD_LOGIC_VECTOR(7 downto 0);								--Uitgangen module: chronometer
	       M4SS : in STD_LOGIC_VECTOR(7 downto 0);
	       M4MM : in STD_LOGIC_VECTOR(7 downto 0);
	       M4UU : in STD_LOGIC_VECTOR(7 downto 0);
	       disOut : out STD_LOGIC_VECTOR(7 downto 0);
	       disSelect : out STD_LOGIC_VECTOR(3 downto 0));
	end component;
	
	component DigitaalUurwerkHoofdSturing
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       drukToetsen : in STD_LOGIC_VECTOR(4 downto 0);							--drukToetsen: (0) = werkingsmodus, (1) = instellingsmodus, (2) = verhogen, (3) = verlagen, (4) = functie afhankelijk van werkingsmodus
	       drukToetsActief : out STD_LOGIC;									--alarmsignaal uitschakelen
	       huidigWerkingsmode : out STD_LOGIC_VECTOR(4 downto 0);
	       huidigInstelmode : out STD_LOGIC_VECTOR(4 downto 0);
	       pulsOutM0 : out STD_LOGIC_VECTOR(2 downto 0);							--Module 0: Uurwerk		
	       pulsOutM1 : out STD_LOGIC_VECTOR(2 downto 0);							--Module 1: Datum
	       pulsOutM2 : out STD_LOGIC_VECTOR(2 downto 0);							--Module 2: Alarm
	       pulsOutM3 : out STD_LOGIC_VECTOR(2 downto 0);							--Module 3: Timer
	       pulsOutM4 : out STD_LOGIC_VECTOR(2 downto 0));							--Module 4: Chronometer
	end component;

	--Interne signalen
Signal enable_intern : STD_LOGIC := '1';									--enable (Klokdeler) is HIGH								
Signal CT_500hz_intern, CT_100hz_intern, CT_4hz_intern, CT_2hz_intern, CT_1hz_intern : STD_LOGIC := '0';
Signal CT_Uurwerk : STD_LOGIC := '0';
Signal drukToetsActief_intern : STD_LOGIC := '0';
Signal alarmActief_intern, alarmSignaal_intern : STD_LOGIC := '0';
Signal chronoActief_intern : STD_LOGIC := '0';
Signal drukToetsen_intern : STD_LOGIC_VECTOR(4 downto 0) := "00000";
Signal ContinuUpDown_intern : STD_LOGIC_VECTOR(1 downto 0) := "00";
Signal M0SS_intern, M0MM_intern, M0UU_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
Signal M1DD_intern, M1MM_intern, M1JJ_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
Signal M2UU_intern, M2MM_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
Signal M3MM_intern, M3SS_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
Signal M4HH_intern, M4SS_intern, M4MM_intern, M4UU_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
Signal huidigWerkingsmode_intern, huidigInstelmode_intern : STD_LOGIC_VECTOR(4 downto 0) := "00000";
Signal pulsOutM0_intern, pulsOutM1_intern, pulsOutM2_intern : STD_LOGIC_VECTOR(2 downto 0) := "000";
Signal pulsOutM3_intern, pulsOutM4_intern : STD_LOGIC_VECTOR(2 downto 0) := "000";

begin
	Inst_Klokdeler : Klokdeler Port map ( sysClk => sysClk,
					      enable => enable_intern,
					      CT_500hz => CT_500hz_intern,
					      CT_100hz => CT_100hz_intern,
					      CT_4hz => CT_4hz_intern,
					      CT_2hz => CT_2hz_intern,
					      CT_1hz => CT_1hz_intern);
	
	Inst_Debouncer : Debouncer Port map ( clk => CT_100hz_intern,
					      buttonIn => drukToetsen,
					      buttonUit => drukToetsen_intern);
	
	Inst_DigitaalUurwerkHoofdsturing : DigitaalUurwerkHoofdsturing Port map ( sysClk => sysClk,
										  reset => schakelaar,
										  drukToetsen => drukToetsen_intern,
										  drukToetsActief => drukToetsActief_intern,
										  huidigWerkingsmode => huidigWerkingsmode_intern,
										  huidigInstelmode => huidigInstelmode_intern,
										  pulsOutM0 => pulsOutM0_intern,
										  pulsOutM1 => pulsOutM1_intern,
										  pulsOutM2 => pulsOutM2_intern,
										  pulsOutM3 => pulsOutM3_intern,
										  pulsOutM4 => pulsOutM4_intern);

	Inst_Uurwerk : Uurwerk Port map ( sysClk => sysClk,
					  reset => schakelaar,
					  clk1Hz => CT_1hz_intern,
					  clk2Hz => CT_2hz_intern,						--Vertraging voor snel zetten (delay = 1Hz)
					  clk4Hz => CT_4hz_intern,
					  up => pulsOutM0_intern(0),
					  down => pulsOutM0_intern(1),
					  zet => huidigInstelmode_intern(3 downto 1),				--zet: (0) = instellen Uur, (1) = instellen Min, (2) = reset Sec
					  oD => CT_Uurwerk,
					  SS => M0SS_intern,
					  MM => M0MM_intern,
					  UU => M0UU_intern);
	
	Inst_Datum : Datum Port map ( sysClk => sysClk,
				      reset => schakelaar,
				      oD => CT_Uurwerk,
				      clk2Hz => CT_2hz_intern,							--Vertraging voor snel zetten (delay = 1Hz)
				      clk4Hz => CT_4hz_intern,
				      up => pulsOutM1_intern(0),
				      down => pulsOutM1_intern(1),
				      zet => huidigInstelmode_intern(3 downto 1),				--zet: (0) = instellen Dag, (1) = instellen Maand, (2) = instellen Jaar
				      DD => M1DD_intern,
				      MM => M1MM_intern,
				      JJ => M1JJ_intern);
	
	Inst_Alarm : Alarm Port map ( sysClk => sysClk,
				      reset => schakelaar,
				      clk2Hz => CT_2hz_intern,							--Vertraging voor snel zetten (delay = 1Hz) + alarmSignaal blink frequentie
				      clk4Hz => CT_4hz_intern,
				      up => pulsOutM2_intern(0),
				      down => pulsOutM2_intern(1),
				      toggleAlarm => pulsOutM2_intern(2),					--Alarm: uit-aan
				      alarmUit => drukToetsActief_intern,					--Stop het alarmsignaal vroegtijdig
				      zet => huidigInstelmode_intern(2 downto 1),				--zet: (0) = instellen Uur, (1) = instellen Min
				      MM => M0MM_intern,
				      UU => M0UU_intern,
				      alarmActief => alarmActief_intern,
				      alarmSignaal => alarmSignaal_intern,
				      alarmMM => M2MM_intern,
				      alarmUU => M2UU_intern);
	
	Inst_Timer : Timer Port map ( sysClk => sysClk,
				      reset => schakelaar,
				      clk1Hz => CT_1hz_intern,
				      clk2Hz => CT_2hz_intern,							--Vertraging voor snel zetten (delay = 1Hz)
				      clk4Hz => CT_4hz_intern,
				      up => pulsOutM3_intern(0),
				      down => pulsOutM3_intern(1),
				      zet => huidigInstelmode_intern(2 downto 1),				--zet: (0) = instellen Min, (1) = instellen Sec
				      SS => M3SS_intern,
				      MM => M3MM_intern);
	
	Inst_Chronometer : Chronometer Port map ( sysClk => sysClk,
						  reset => schakelaar,
						  clk100Hz => CT_100hz_intern,
						  clk2Hz => CT_2hz_intern,
						  zet0 => pulsOutM4_intern(1),
						  startStop => pulsOutM4_intern(0),
						  freeze => pulsOutM4_intern(2),
						  chronoActief => chronoActief_intern,
						  HH => M4HH_intern,
						  SS => M4SS_intern,
						  MM => M4MM_intern,
						  UU => M4UU_intern);

	Inst_Display : Display Port map ( clk => CT_500hz_intern,
					  clkBlink => CT_2hz_intern,
					  reset => schakelaar,
					  huidigWerkingsmode => huidigWerkingsmode_intern,
					  huidigInstelmode => huidigInstelmode_intern,
					  M0SS => M0SS_intern,
					  M0MM => M0MM_intern,
					  M0UU => M0UU_intern,
					  M1DD => M1DD_intern,
					  M1MM => M1MM_intern,
					  M1JJ => M1JJ_intern,
					  M2MM => M2MM_intern,
					  M2UU => M2UU_intern,
					  M3SS => M3SS_intern,
					  M3MM => M3MM_intern,
					  M4HH => M4HH_intern,
					  M4SS => M4SS_intern,
					  M4MM => M4MM_intern,
					  M4UU => M4UU_intern,
					  disOut => displayOut,
					  disSelect => displaySelect);

leds(4 downto 0) <= huidigWerkingsmode_intern;
leds(5) <= chronoActief_intern;
leds(6) <= alarmSignaal_intern;
leds(7) <= alarmActief_intern;

enable_intern <= '1';												--Enable klokdeler: high (sysClk-frequentie wordt gedeeld)			

end struct;
