----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    27/10/2013 
-- Design Name:    Basisklok
-- Module Name:    DigitaalUurwerkHoofdsturingTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity DigitaalUurwerkHoofdsturingTestbench is
end DigitaalUurwerkHoofdsturingTestbench;
 
architecture struct of DigitaalUurwerkHoofdsturingTestbench is 
   Component DigitaalUurwerkHoofdsturing
	Port( sysClk : in std_logic;
	      reset : in std_logic;
			drukToetsen : in std_logic_vector(4 downto 0);																		--drukToetsen: (0) = werkingsmodus, (1) = instellingsmodus, (2) = verhogen, (3) = verlagen, (4) = functie afhankelijk van werkingsmodus
			drukToetsActief : out std_logic;																							--alarmsignaal uitschakelen
			huidigWerkingsmode : out std_logic_vector(4 downto 0);
			huidigInstelmode : out std_logic_vector(4 downto 0);
			pulsOutM0 : out std_logic_vector(2 downto 0);																		--Module 0: Uurwerk		
			pulsOutM1 : out std_logic_vector(2 downto 0);																		--Module 1: Datum
			pulsOutM2 : out std_logic_vector(2 downto 0);																		--Module 2: Alarm
			pulsOutM3 : out std_logic_vector(2 downto 0);																		--Module 3: Timer
			pulsOutM4 : out std_logic_vector(2 downto 0));																		--Module 4: Chronometer
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal reset : std_logic := '0';
signal drukToetsen : std_logic_vector(4 downto 0) := "00000";
signal drukToetsActief : std_logic := '0';
signal huidigWerkingsmode : std_logic_vector(4 downto 0) := "00001";
signal huidigInstelmode : std_logic_vector(4 downto 0) := "00001";
signal pulsOutM0 : std_logic_vector(2 downto 0) := "000";
signal pulsOutM1 : std_logic_vector(2 downto 0) := "000";
signal pulsOutM2 : std_logic_vector(2 downto 0) := "000";
signal pulsOutM3 : std_logic_vector(2 downto 0) := "000";
signal pulsOutM4 : std_logic_vector(2 downto 0) := "000";

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_DigitaalUurwerkHoofdsturing: DigitaalUurwerkHoofdsturing port map( sysClk => sysClk,
																								reset => reset,
																								drukToetsen => drukToetsen,
																								drukToetsActief => drukToetsActief,
																								huidigWerkingsmode => huidigWerkingsmode,
																								huidigInstelmode => huidigInstelmode,
																								pulsOutM0 => pulsOutM0,
																								pulsOutM1 => pulsOutM1,
																								pulsOutM2 => pulsOutM2,
																								pulsOutM3 => pulsOutM3,
																								pulsOutM4 => pulsOutM4);
																								
   --Klokpuls genereren (sysClk)
   sysClk_process : process
   begin
		sysClk <= '0';
		wait for sysClk_period/2;
		sysClk <= '1';
		wait for sysClk_period/2;
   end process;

	--Voer reset uit
	reset_process : process
	begin
		reset <= '0';
		wait for sysClk_period * 100;
		reset <= '1';
		wait for sysClk_period;
	end process;
	
   --Genereer stimulus (drukToetsen(0) : werkingsmode selecteren)
	drukToetsen0_process : process
   begin
		drukToetsen(0) <= '0';
		wait for sysClk_period*25;
		drukToetsen(0) <= '1';
		wait for sysClk_period*3;
   end process;
	
	--Genereer stimulus (drukToetsen(1) : instelmode selecteren)
	drukToetsen1_process : process
   begin
		drukToetsen(1) <= '0';
		wait for sysClk_period*5;
		drukToetsen(1) <= '1';
		wait for sysClk_period*3;
   end process;
	
	--Genereer stimulus (drukToetsen(4 downto 2) : drukToetsen doorvoer)
	drukToetsen4downto2_process : process
   begin
		drukToetsen(4 downto 2) <= "000";
		wait for sysClk_period*4;
		drukToetsen(4 downto 2) <= "001";
		wait for sysClk_period*4;
		drukToetsen(4 downto 2) <= "010";
		wait for sysClk_period*4;
		drukToetsen(4 downto 2) <= "100";
		wait for sysClk_period*4;
   end process;
	
end struct;