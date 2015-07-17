----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    30/11/2013 
-- Design Name:    Basisklok
-- Module Name:    Chronometer
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Chronometer is
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
			 clk100Hz : in STD_LOGIC;
			 clk2Hz : in STD_LOGIC;																--Frequentie blink chronoActief			
			 zet0 : in STD_LOGIC;
			 startStop : in STD_LOGIC;	
			 freeze : in STD_LOGIC;
			 chronoActief : out STD_LOGIC := '0';
			 HH : out STD_LOGIC_VECTOR(7 downto 0) := "00000000";
			 SS : out STD_LOGIC_VECTOR(7 downto 0) := "00000000";
			 MM : out STD_LOGIC_VECTOR(7 downto 0) := "00000000";
			 UU : out STD_LOGIC_VECTOR(7 downto 0) := "00000000");
end Chronometer;

architecture struct of Chronometer is
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
	
	component ChronometerSturing
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
			 enableIn : in STD_LOGIC;
			 startStop : in STD_LOGIC;
			 zet0In : in STD_LOGIC;														
			 enableUit : out STD_LOGIC;
			 updown : out STD_LOGIC;
			 chronoAan : out STD_LOGIC;
			 zet0Uit : out STD_LOGIC_VECTOR(3 downto 0);
			 zetUit : out STD_LOGIC_VECTOR(3 downto 0));
	end component;
	
	component FreezeChronoModule
	Port ( sysClk : in STD_LOGIC;
			 freeze : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 HHin : in STD_LOGIC_VECTOR(7 downto 0);
			 SSin : in STD_LOGIC_VECTOR(7 downto 0);
			 MMin : in STD_LOGIC_VECTOR(7 downto 0);
			 UUin : in STD_LOGIC_VECTOR(7 downto 0);
			 HHout : out STD_LOGIC_VECTOR(7 downto 0);
			 SSout : out STD_LOGIC_VECTOR(7 downto 0);
			 MMout : out STD_LOGIC_VECTOR(7 downto 0);
			 UUout : out STD_LOGIC_VECTOR(7 downto 0));
	end component;
	
	component Pulsmodule
	Port ( sysClk : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 signalIn : in STD_LOGIC;
			 pulsOut : out STD_LOGIC);
	end component;

	--Interne signalen
Signal enable_intern : STD_LOGIC := '0';
Signal updown_intern : STD_LOGIC := '0';
Signal startStop_intern : STD_LOGIC := '0';
Signal freeze_intern : STD_LOGIC := '0';
Signal zet0Puls_intern : STD_LOGIC := '0';
Signal chronoAan_intern : STD_LOGIC := '0';
Signal ct_intern : STD_LOGIC_VECTOR(3 downto 0) := "0000";
Signal zet_intern : STD_LOGIC_VECTOR(3 downto 0) := "0000";
Signal zet0_intern : STD_LOGIC_VECTOR(3 downto 0) := "0000";
Signal dis0Max_intern : STD_LOGIC_VECTOR(7 downto 0) := "10011001";				--dis0Max = 99 (HH)
Signal dis1Max_intern : STD_LOGIC_VECTOR(7 downto 0) := "01011001";				--dis1Max = 59	(Sec)
Signal dis2Max_intern : STD_LOGIC_VECTOR(7 downto 0) := "01011001";				--dis2Max = 59 (Min)
Signal dis3Max_intern : STD_LOGIC_VECTOR(7 downto 0) := "00100011";				--dis3Max = 23 (Uren)
Signal dis0Out_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
Signal dis1Out_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
Signal dis2Out_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
Signal dis3Out_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
Signal HH_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
Signal SS_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
Signal MM_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
Signal UU_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";			

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
					 dis2Max => dis2Max_intern,
					 dis3Max => dis3Max_intern,
			       ct => ct_intern,
			       dis0Out => dis0Out_intern,
					 dis1Out => dis1Out_intern,
					 dis2Out => dis2Out_intern,
					 dis3Out => dis3Out_intern);
	
	Inst_ChronometerSturing : ChronometerSturing
		Port map( sysClk => sysClk,
					 reset => reset,
					 enableIn => clk100Hz,
					 startStop => startStop_intern,
					 zet0In => zet0Puls_intern,
					 enableUit => enable_intern,
					 updown => updown_intern,
					 chronoAan => chronoAan_intern,
					 zet0Uit => zet0_intern,
					 zetUit => zet_intern);
	
	Inst_FreezeChronoModule : FreezeChronoModule
		Port map( sysClk => sysClk,
					 freeze => freeze_intern,
					 reset => reset,
					 HHin => dis0Out_intern,
					 SSin => dis1Out_intern,
					 MMin => dis2Out_intern,
					 UUin => dis3Out_intern,
					 HHout => HH_intern,
					 SSout => SS_intern,
					 MMout => MM_intern,
					 UUout => UU_intern);
	
	Inst_PulsmoduleZet0 : Pulsmodule
		Port map( sysClk => sysClk,
					 reset => reset,
					 signalIn => zet0,
					 pulsOut => zet0Puls_intern);
	
	Inst_PulsmoduleStartStop : Pulsmodule
		Port map( sysClk => sysClk,
					 reset => reset,
					 signalIn => startStop,
					 pulsOut => startStop_intern);
	
	Inst_PulsmoduleFreeze : Pulsmodule
		Port map( sysClk => sysClk,
					 reset => reset,
					 signalIn => freeze,
					 pulsOut => freeze_intern);

chronoActief <= chronoAan_intern and clk2Hz;

HH <= HH_intern;
SS <= SS_intern;
MM <= MM_intern;
UU <= UU_intern;

dis0Max_intern <= "10011001";																	--dis0Max = 99 (HH)
dis1Max_intern <= "01011001";																	--dis1Max = 59	(Sec)
dis2Max_intern <= "01011001";																	--dis2Max = 59 (Min)
dis3Max_intern <= "00100011";																	--dis3Max = 23 (Uren)

end struct;