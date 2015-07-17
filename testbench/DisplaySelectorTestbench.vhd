----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    02/11/2013 
-- Design Name:    Basisklok
-- Module Name:    DisplaySelectorTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity DisplaySelectorTestbench is
end DisplaySelectorTestbench;
 
architecture struct of DisplaySelectorTestbench is 
   Component DisplaySelector
	Port( huidigWerkingsmode : in std_logic_vector(4 downto 0);
			huidigInstelmode : in std_logic_vector(4 downto 0);
			M0SS : in std_logic_vector(7 downto 0);														--Uitgangen module: uurwerk
			M0MM : in std_logic_vector(7 downto 0);
			M0UU : in std_logic_vector(7 downto 0);
			M1DD : in std_logic_vector(7 downto 0);														--Uitgangen module: datum
			M1MM : in std_logic_vector(7 downto 0);
			M1JJ : in std_logic_vector(7 downto 0);
			M2MM : in std_logic_vector(7 downto 0);														--Uitgangen module: alarm
			M2UU : in std_logic_vector(7 downto 0);
			M3SS : in std_logic_vector(7 downto 0);														--Uitgangen module: timer
			M3MM : in std_logic_vector(7 downto 0);
			M4HH : in std_logic_vector(7 downto 0);														--Uitgangen module: chronometer
			M4SS : in std_logic_vector(7 downto 0);
			M4MM : in std_logic_vector(7 downto 0);
			M4UU : in std_logic_vector(7 downto 0);
			BCDTellerToDis0_1 : out std_logic_vector(3 downto 0);
			BCDTellerToDis2_3 : out std_logic_vector(3 downto 0);
			BCDTeller0 : out std_logic_vector(7 downto 0);	
			BCDTeller1 : out std_logic_vector(7 downto 0);
			BCDTeller2 : out std_logic_vector(7 downto 0);
			BCDTeller3 : out std_logic_vector(7 downto 0);
			disPunt : out std_logic_vector(3 downto 0);													--Laag actief
			disBlink : out std_logic_vector(3 downto 0));	
   End component;
    
--Interne signalen
signal huidigWerkingsmode : std_logic_vector(4 downto 0) := "00000";
signal huidigInstelmode : std_logic_vector(4 downto 0) := "00000";
signal M0SS : std_logic_vector(7 downto 0) := "00000000";
signal M0MM : std_logic_vector(7 downto 0) := "00000000";
signal M0UU : std_logic_vector(7 downto 0) := "00000000";
signal M1DD : std_logic_vector(7 downto 0) := "00000000";
signal M1MM : std_logic_vector(7 downto 0) := "00000000";
signal M1JJ : std_logic_vector(7 downto 0) := "00000000";
signal M2MM : std_logic_vector(7 downto 0) := "00000000";
signal M2UU : std_logic_vector(7 downto 0) := "00000000";
signal M3SS : std_logic_vector(7 downto 0) := "00000000";
signal M3MM : std_logic_vector(7 downto 0) := "00000000";
signal M4HH : std_logic_vector(7 downto 0) := "00000000";
signal M4SS : std_logic_vector(7 downto 0) := "00000000";
signal M4MM : std_logic_vector(7 downto 0) := "00000000";
signal M4UU : std_logic_vector(7 downto 0) := "00000000";
signal BCDTellerToDis0_1 : std_logic_vector(3 downto 0) := "0000";
signal BCDTellerToDis2_3 : std_logic_vector(3 downto 0) := "0000";
signal BCDTeller0 : std_logic_vector(7 downto 0) := "00000000";
signal BCDTeller1 : std_logic_vector(7 downto 0) := "00000000";
signal BCDTeller2 : std_logic_vector(7 downto 0) := "00000000";
signal BCDTeller3 : std_logic_vector(7 downto 0) := "00000000";
signal disPunt : std_logic_vector(3 downto 0) := "0000";
signal disBlink : std_logic_vector(3 downto 0) := "0000";

--Klokperiode constante
constant clk_period : time := 10 ns;
 
begin
Inst_DisplaySelector: DisplaySelector port map( huidigWerkingsmode => huidigWerkingsmode,
																huidigInstelmode => huidigInstelmode,
																M0SS => M0SS,
																M0MM => M0MM,
																M0UU => M0UU,
																M1DD => M1DD,
																M1MM => M1MM,
																M1JJ => M1JJ,
																M2MM => M2MM,
																M2UU => M2UU,
																M3SS => M3SS,
																M3MM => M3MM,
																M4HH => M4HH,
																M4SS => M4SS,
																M4MM => M4MM,
																M4UU => M4UU,
																BCDTellerToDis0_1 => BCDTellerToDis0_1,
																BCDTellerToDis2_3 => BCDTellerToDis2_3,
																BCDTeller0 => BCDTeller0,
																BCDTeller1 => BCDTeller1,
																BCDTeller2 => BCDTeller2,
																BCDTeller3 => BCDTeller3,
																disPunt => disPunt,
																disBlink => disBlink);

	--Genereer stimulus (huidigWerkingsmode)
	huidigWerkingsmode_process : process
   begin
		huidigWerkingsmode <= "00001";
		wait for clk_period*8;
		huidigWerkingsmode <= "00010";
		wait for clk_period*8;
		huidigWerkingsmode <= "00100";
		wait for clk_period*8;
		huidigWerkingsmode <= "01000";
		wait for clk_period*8;
		huidigWerkingsmode <= "10000";
		wait for clk_period*8;
   end process;
	
	--Genereer stimulus (huidigInstelmode)
	huidigInstelmode_process : process
   begin
		huidigInstelmode <= "00001";
		wait for clk_period*16;
		huidigInstelmode <= "00010";
		wait for clk_period*16;
		huidigInstelmode <= "00100";
		wait for clk_period*16;
   end process;
	
	--Genereer stimulus (M0 SS + MM + UU)
	M0_process : process
   begin
		M0SS <= "00000001";
		M0MM <= "00000010";
		M0UU <= "00000011";
		wait for clk_period*2;
		M0SS <= "00000100";
		M0MM <= "00000101";
		M0UU <= "00000110";
		wait for clk_period*2;
		M0SS <= "00010000";
		M0MM <= "00100000";
		M0UU <= "00110000";
		wait for clk_period*2;
   end process;
	
	--Genereer stimulus (M1 DD + MM + JJ)
	M1_process : process
   begin
		M1DD <= "10000001";
		M1MM <= "10000010";
		M1JJ <= "10000011";
		wait for clk_period*5;
		M1DD <= "10000100";
		M1MM <= "10000101";
		M1JJ <= "10000110";
		wait for clk_period*5;
		M1DD <= "10010000";
		M1MM <= "10100000";
		M1JJ <= "10110000";
		wait for clk_period*5;
   end process;
	
	--Genereer stimulus (M2 MM + UU)
	M2_process : process
   begin
		M2MM <= "01000001";
		M2UU <= "01000010";
		wait for clk_period*5;
		M2MM <= "01000010";
		M2UU <= "01000100";
		wait for clk_period*5;
		M2MM <= "01000000";
		M2UU <= "01000000";
		wait for clk_period*5;
   end process;
	
	--Genereer stimulus (M3 SS + MM)
	M3_process : process
   begin
		M3MM <= "00100001";
		M3SS <= "00100010";
		wait for clk_period*5;
		M3MM <= "00100010";
		M3SS <= "00100100";
		wait for clk_period*5;
		M3MM <= "00100000";
		M3SS <= "00100000";
		wait for clk_period*5;
   end process;
	
	--Genereer stimulus (M4 HH + SS + MM + UU)
	M4_process : process
   begin
		M4HH <= "00010001";
		M4SS <= "00010010";
		M4MM <= "00010011";
		M4UU <= "00010100";
		wait for clk_period*5;
		M4HH <= "00011000";
		M4SS <= "00010100";
		M4MM <= "00010010";
		M4UU <= "00010001";
		wait for clk_period*5;
		M4HH <= "00010000";
		M4SS <= "00010000";
		M4MM <= "00010000";
		M4UU <= "00010000";
		wait for clk_period*5;
   end process;	
	
end struct;