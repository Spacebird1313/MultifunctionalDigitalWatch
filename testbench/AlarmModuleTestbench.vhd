----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    23/12/2013
-- Design Name:    Basisklok
-- Module Name:    AlarmModuleTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity AlarmModuleTestbench is
end AlarmModuleTestbench;
 
architecture struct of AlarmModuleTestbench is 
   Component AlarmModule
	Port( sysClk : in std_logic;
	      reset : in std_logic;
			toggleAlarm : in std_logic;
			alarmUit : in std_logic;
			MM : in std_logic_vector(7 downto 0);
			UU : in std_logic_vector(7 downto 0);
			alarmMM : in std_logic_vector(7 downto 0);
			alarmUU : in std_logic_vector(7 downto 0);
			alarmActief : out std_logic;
			alarmSignaal : out std_logic);
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal reset : std_logic := '0';
signal toggleAlarm : std_logic := '0';
signal alarmUit : std_logic := '0';
signal MM : std_logic_vector(7 downto 0) := "00000000";
signal UU : std_logic_vector(7 downto 0) := "00000000";
signal alarmMM : std_logic_vector(7 downto 0) := "00000000";
signal alarmUU : std_logic_vector(7 downto 0) := "00000000";
signal alarmActief : std_logic := '0';
signal alarmSignaal : std_logic := '0';

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_AlarmModule: AlarmModule port map( sysClk => sysClk,
													 reset => reset,
													 toggleAlarm => toggleAlarm,
													 alarmUit => alarmUit,
													 MM => MM,
													 UU => UU,
													 alarmMM => alarmMM,
													 alarmUU => alarmUU,
													 alarmActief => alarmActief,
													 alarmSignaal => alarmSignaal);
	
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
		wait for sysClk_period*1000;
		reset <= '1';
		wait for sysClk_period;
	end process;
	
   --Genereer stimulus (toggleAlarm)
	toggleAlarm_process : process
   begin
		toggleAlarm <= '0';
		wait for sysClk_period*100;
		toggleAlarm <= '1';
		wait for sysClk_period;
   end process;
	
	   --Genereer stimulus (alarmUit)
	alarmUit_process : process
   begin
		alarmUit <= '0';
		wait for sysClk_period*24;
		alarmUit<= '1';
		wait for sysClk_period;
   end process;
	
	--Genereer stimulus (UU_MM_Alarm)
	UU_MM_Alarm_process : process
	begin
		MM <= "00000000";
		UU <= "00000000";
		alarmMM <= "00000001";
		alarmUU <= "00000001";
		wait for sysClk_period*10;
		MM <= "00000001";
		UU <= "00000000";
		alarmMM <= "00000001";
		alarmUU <= "00000001";
		wait for sysClk_period*10;
		MM <= "00000001";
		UU <= "00000001";
		alarmMM <= "00000001";
		alarmUU <= "00000001";
		wait for sysClk_period*20;
		MM <= "00000000";
		UU <= "00000001";
		alarmMM <= "00000001";
		alarmUU <= "00000001";
		wait for sysClk_period*20;
	end process;

end struct;