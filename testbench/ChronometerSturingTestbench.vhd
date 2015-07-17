----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    23/12/2013 
-- Design Name:    Basisklok
-- Module Name:    ChronometerSturingTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity ChronometerSturingTestbench is
end ChronometerSturingTestbench;
 
architecture struct of ChronometerSturingTestbench is 
   Component ChronometerSturing
	Port( sysClk : in std_logic;
	      reset : in std_logic;
			enableIn : in std_logic;
			startStop : in std_logic;
			zet0In : in std_logic;
			enableUit : out std_logic;
			updown : out std_logic;
			chronoAan : out std_logic;
			zet0Uit : out std_logic_vector(3 downto 0);
			zetUit : out std_logic_vector(3 downto 0));
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal reset : std_logic := '0';
signal enableIn : std_logic := '0';
signal startStop : std_logic := '0';
signal zet0In : std_logic := '0';
signal enableUit : std_logic := '0';
signal updown : std_logic := '0';
signal chronoAan : std_logic := '0';
signal zet0Uit : std_logic_vector(3 downto 0) := "0000";
signal zetUit : std_logic_vector(3 downto 0) := "0000";

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_ChronometerSturing: ChronometerSturing port map( sysClk => sysClk,
																		reset => reset,
																		enableIn => enableIn,
																		startStop => startStop,
																		zet0In => zet0In,
																		enableUit => enableUit,
																		updown => updown,
																		chronoAan => chronoAan,
																		zet0Uit => zet0Uit,
																		zetUit => zetUit);
	
	--Klokpuls genereren (sysClk)
   sysClk_process : process
   begin
		sysClk <= '0';
		wait for sysClk_period/2;
		sysClk <= '1';
		wait for sysClk_period/2;
   end process;
	
	--Klokpuls genereren (enableIn)
	enableIn_process : process
	begin
		enableIn <= '0';
		wait for sysClk_period*8;
		enableIn <= '1';
		wait for sysClk_period;
	end process;
	
	--Voer reset uit
	reset_process : process
	begin
		reset <= '0';
		wait for sysClk_period * 1000;
		reset <= '1';
		wait for sysClk_period;
	end process;
	
   --Genereer stimulus (startStop)
	startStop_process : process
   begin
		startStop <= '0';
		wait for sysClk_period*30;
		startStop <= '1';
		wait for sysClk_period;
   end process;
	
	--Genereer stimulus (zet0In)
	zet0In_process : process
   begin
		zet0In <= '0';
		wait for sysClk_period*65;
		zet0In <= '1';
		wait for sysClk_period;
   end process;
	
end struct;