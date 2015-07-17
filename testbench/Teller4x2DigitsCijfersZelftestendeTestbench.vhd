----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    25/12/2013 
-- Design Name:    Basisklok
-- Module Name:    Teller4x2DigitsCijfersZelftestendeTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
library HuybrechtsThomas_Library;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use HuybrechtsThomas_Library.TestbenchPackage.ALL;
 
entity Teller4x2DigitsCijfersZelftestendeTestbench is
end Teller4x2DigitsCijfersZelftestendeTestbench;

architecture struct of Teller4x2DigitsCijfersZelftestendeTestbench is
	Component Teller4x2DigitsCijfers
	Generic ( minDis0 : integer;
				 minDis1 : integer;
				 minDis2 : integer;
				 minDis3 : integer);
	Port( sysClk : in std_logic;
			updown : in std_logic;
			enable : in std_logic;
			reset : in std_logic;
			zet : in std_logic_vector(3 downto 0);
			zet0 : in std_logic_vector(3 downto 0);
			dis0Max : in std_logic_vector(7 downto 0);
			dis1Max : in std_logic_vector(7 downto 0);
			dis2Max : in std_logic_vector(7 downto 0);
			dis3Max : in std_logic_vector(7 downto 0);
			ct : out std_logic_vector(3 downto 0);
			dis0Out : out std_logic_vector(7 downto 0);
			dis1Out : out std_logic_vector(7 downto 0);
			dis2Out : out std_logic_vector(7 downto 0);
			dis3Out : out std_logic_vector(7 downto 0));
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal updown : std_logic := '0';
signal enable : std_logic := '0';
signal reset : std_logic := '0';
signal zet : std_logic_vector(3 downto 0) := "0000";
signal zet0 : std_logic_vector(3 downto 0) := "0000";
signal dis0Max : std_logic_vector(7 downto 0) := "10011001";
signal dis1Max : std_logic_vector(7 downto 0) := "10011001";
signal dis2Max : std_logic_vector(7 downto 0) := "10011001";
signal dis3Max : std_logic_vector(7 downto 0) := "10011001";
signal ct : std_logic_vector(3 downto 0) := "0000";
signal dis0Out : std_logic_vector(7 downto 0) := "00000000";
signal dis1Out : std_logic_vector(7 downto 0) := "00000000";
signal dis2Out : std_logic_vector(7 downto 0) := "00000000";
signal dis3Out : std_logic_vector(7 downto 0) := "00000000";
signal simulatieActief : std_logic := '0';

--Klokperiode constante
constant sysClk_period : time := 10 ns;

--Controle procedure
procedure testTellerOutput(dis0Out, dis0Correct, dis1, dis1Correct, dis2, dis2Correct, dis3, dis3Correct : in std_logic_vector(7 downto 0)) is
	begin
		if(dis0Out = dis0Correct and dis1Out = dis1Correct and dis2Out = dis2Correct and dis3Out = dis3Correct) then
			report "Geslaagd!";
		else
			assert(false) report "De teller duidt incorrecte waardes aan!" severity warning;
		end if;
end testTellerOutput;

begin
Inst_Teller4x2DigitsCijfers: Teller4x2DigitsCijfers generic map( minDis0 => 0,
																					  minDis1 => 0,
																					  minDis2 => 0,
																					  minDis3 => 0)
																	 port map( sysClk => sysClk,
																				  updown => updown,
																				  enable => enable,
																				  reset => reset,
																				  zet => zet,
																				  zet0 => zet0,
																				  dis0Max => dis0Max,
																				  dis1Max => dis1Max,
																				  dis2Max => dis2Max,
																				  dis3Max => dis3Max,
																				  ct => ct,
																				  dis0Out => dis0Out,
																				  dis1Out => dis1Out,
																				  dis2Out => dis2Out,
																				  dis3Out => dis3Out);
	
	--sysClk stimulatie
	sysClk_process : clockStimulus(sysClk_period, sysClk_period/2, simulatieActief, sysClk);
	
	--Zelftestende testbench
	Uurwerk_Test_process : process
	begin
		report "Simulatie: Teller4x2DigitsCijfers";
		updown <= '0';
		enable <= '0';
		reset <= '0';
		zet <= "0000";
		zet0 <= "0000";
		dis0Max <= "00100000";	-- 20
		dis1Max <= "00010101";  -- 15
		dis2Max <= "00010000";  -- 10
		dis3Max <= "00000011";  -- 3
		simulatieActief <= '0';
		
		wait for 20 ns;
		
		report "Start-up: Alle uitgangswaarde op 0.";
		testTellerOutput(dis0Out, "00000000", dis1Out, "00000000", dis2Out, "00000000", dis3Out, "00000000");
		 
		report "Start simulatie";
		simulatieActief <= '1';
		
		report "Zet dis0 10 tellen vooruit";
		zet <= "0001";
		buttonSimulatie(10, sysClk_period, sysClk_period*2, enable);
		
		wait for 20 ns;
		
		testTellerOutput(dis0Out, "00010000", dis1Out, "00000000", dis2Out, "00000000", dis3Out, "00000000");
		
		report "Zet dis1 10 tellen achteruit";
		zet <= "0010";
		updown <= '1';
		buttonSimulatie(10, sysClk_period, sysClk_period*2, enable);
		
		wait for 20 ns;
		
		testTellerOutput(dis0Out, "00010000", dis1Out, "00000110", dis2Out, "00000000", dis3Out, "00000000");
		
		report "Zet dis2 10 tellen vooruit";
		zet <= "0100";
		updown <= '0';
		buttonSimulatie(10, sysClk_period, sysClk_period*2, enable);
		
		wait for 20 ns;
		
		testTellerOutput(dis0Out, "00010000", dis1Out, "00000110", dis2Out, "00010000", dis3Out, "00000000"); 
		
		report "Zet dis2 op 0";
		zet <= "0000";
		zet0 <= "0100";
		updown <= '0';
		
		wait for 20 ns;
		
		testTellerOutput(dis0Out, "00010000", dis1Out, "00000110", dis2Out, "00000000", dis3Out, "00000000");
		
		report "Laat teller 11 keer voorttellen";
		zet <= "0000";
		zet0 <= "0000";
		updown <= '0';
		buttonSimulatie(11, sysClk_period, sysClk_period*2, enable);
		
		wait for 20 ns;
		
		testTellerOutput(dis0Out, "00000000", dis1Out, "00000111", dis2Out, "00000000", dis3Out, "00000000");
		
		report "Voer reset uit";
		zet <= "0000";
		zet0 <= "0000";
		updown <= '0';
		reset <= '1';
		
		wait for sysClk_period;
		reset <= '0';
		
		testTellerOutput(dis0Out, "00000000", dis1Out, "00000000", dis2Out, "00000000", dis3Out, "00000000");
		
		simulatieActief <= '0';
		report "Simulatie geëindigd";
		wait;
	end process;
	
end struct;