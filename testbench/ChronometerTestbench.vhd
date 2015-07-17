----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    23/12/2013 
-- Design Name:    Basisklok
-- Module Name:    ChronometerTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity ChronometerTestbench is
end ChronometerTestbench;
 
architecture struct of ChronometerTestbench is 
   Component Chronometer
	Port( sysClk : in std_logic;
	      reset : in std_logic;
			clk100Hz : in std_logic;
			clk2Hz : in std_logic;																--Frequentie blink chronoActief			
			zet0 : in std_logic;
			startStop : in std_logic;	
			freeze : in std_logic;
			chronoActief : out std_logic;
			HH : out std_logic_vector(7 downto 0);
			SS : out std_logic_vector(7 downto 0);
			MM : out std_logic_vector(7 downto 0);
			UU : out std_logic_vector(7 downto 0));
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal reset : std_logic := '0';
signal clk100Hz : std_logic := '0';
signal clk2Hz : std_logic := '0';
signal zet0 : std_logic := '0';
signal startStop : std_logic := '0';
signal freeze : std_logic := '0';
signal chronoActief : std_logic := '0';
signal HH : std_logic_vector(7 downto 0) := "00000000";
signal SS : std_logic_vector(7 downto 0) := "00000000";
signal MM : std_logic_vector(7 downto 0) := "00000000";
signal UU : std_logic_vector(7 downto 0) := "00000000";

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_Chronometer: Chronometer port map( sysClk => sysClk,
													 reset => reset,
													 clk100Hz => clk100Hz,
													 clk2Hz => clk2Hz,
													 zet0 => zet0,
													 startStop => startStop,
													 freeze => freeze,
													 chronoActief => chronoActief,
													 HH => HH,
													 SS => SS,
													 MM => MM,
													 UU => UU);

   --Klokpuls genereren (sysClk)
   sysClk_process : process
   begin
		sysClk <= '0';
		wait for sysClk_period/2;
		sysClk <= '1';
		wait for sysClk_period/2;
   end process;
	
	--Klokpuls genereren (clk100Hz)
   clk4Hz_process : process
   begin
		clk100Hz <= '0';
		wait for sysClk_period*2;
		clk100Hz <= '1';
		wait for sysClk_period;
   end process;
	
	--Klokpuls genereren (clk2Hz)
   clk2Hz_process : process
   begin
		clk2Hz <= '0';
		wait for sysClk_period*8;
		clk2Hz <= '1';
		wait for sysClk_period;
   end process;
    
	--Voer reset uit
	reset_process : process
	begin
		reset <= '0';
		wait for sysClk_period * 10000;
		reset <= '1';
		wait for sysClk_period;
	end process;
	
   --Genereer stimulus (startStop)
	startStop_process : process
   begin
		startStop <= '0';
		wait for sysClk_period*20;
		startStop <= '1';
		wait for sysClk_period;
   end process;
	
	--Genereer stimulus (freeze)
	freeze_process : process
	begin
		freeze <= '0';
		wait for sysClk_period * 11;
		freeze <= '1';
		wait for sysClk_period;
	end process;
	
end struct;