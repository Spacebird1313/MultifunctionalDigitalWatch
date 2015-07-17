----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    02/12/2013 
-- Design Name:    Basisklok
-- Module Name:    TimerModuleTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TimerModuleTestbench is
end TimerModuleTestbench;

architecture struct of TimerModuleTestbench is
	Component TimerModule
	Port( sysClk : in std_logic;
			reset : in std_logic;
			enableIn : in std_logic;
			instelmodus : in std_logic_vector(1 downto 0);
			SS : in std_logic_vector(7 downto 0);
			MM : in std_logic_vector(7 downto 0);
			enableOut : out std_logic);
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal reset : std_logic := '0';
signal enableIn : std_logic := '0';
signal instelmodus : std_logic_vector(1 downto 0) := "00";
signal SS : std_logic_vector(7 downto 0) := "00000000";
signal MM : std_logic_vector(7 downto 0) := "00000000";
signal enableOut : std_logic := '0';

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_TimerModule: TimerModule port map( sysClk => sysClk,
													 reset => reset,
													 enableIn => enableIn,
													 instelmodus => instelmodus,
													 SS => SS,
													 MM => MM,
													 enableOut => enableOut);
 
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
		wait for sysClk_period * 10000;
		reset <= '1';
		wait for sysClk_period;
	end process;
	
   --Genereer stimulus (enableIn)
	enableIn_process : process
   begin
		enableIn <= '0';
		wait for sysClk_period*5;
		enableIn <= '1';
		wait for sysClk_period;
   end process;
	
	--Genereer stimulus (instelmodus)
	instelmodus_process : process
	begin
		instelmodus <= "00";
		wait for sysClk_period * 20;
		instelmodus <= "10";
		wait for sysClk_period * 10;
		instelmodus <= "01";
		wait for sysClk_period * 10;
	end process;
	
	--Genereer stimulus (SS, MM)
	SS_MM_process : process
   begin
		SS <= "00000001";
		MM <= "00000001";
		wait for sysClk_period*4;
		SS <= "00000000";
		MM <= "00000001";
		wait for sysClk_period*4;
		SS <= "00000001";
		MM <= "00000000";
		wait for sysClk_period*4;
		SS <= "00000000";
		MM <= "00000000";
		wait for sysClk_period*4;
   end process;
	
end struct;