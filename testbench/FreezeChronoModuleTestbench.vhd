----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    23/12/2013
-- Design Name:    Basisklok
-- Module Name:    FreezeChronoModuleTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity FreezeChronoModuleTestbench is
end FreezeChronoModuleTestbench;
 
architecture struct of FreezeChronoModuleTestbench is 
   Component FreezeChronoModule
	Port( sysClk : in std_logic;
			freeze : in std_logic;
			reset : in std_logic;
			HHin : in std_logic_vector(7 downto 0);
			SSin : in std_logic_vector(7 downto 0);
			MMin : in std_logic_vector(7 downto 0);
			UUin : in std_logic_vector(7 downto 0);
			HHout : out std_logic_vector(7 downto 0);
			SSout : out std_logic_vector(7 downto 0);
			MMout : out std_logic_vector(7 downto 0);
			UUout : out std_logic_vector(7 downto 0));
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal freeze : std_logic := '0';
signal reset : std_logic := '0';
signal HHin : std_logic_vector(7 downto 0) := "00000000";
signal SSin : std_logic_vector(7 downto 0) := "00000000";
signal MMin : std_logic_vector(7 downto 0) := "00000000";
signal UUin : std_logic_vector(7 downto 0) := "00000000";
signal HHout : std_logic_vector(7 downto 0) := "00000000";
signal SSout : std_logic_vector(7 downto 0) := "00000000";
signal MMout : std_logic_vector(7 downto 0) := "00000000";
signal UUout : std_logic_vector(7 downto 0) := "00000000";

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_FreezeChronoModule: FreezeChronoModule port map( sysClk => sysClk,
																		freeze => freeze,
																		reset => reset,
																		HHin => HHin,
																		SSin => SSin,
																		MMin => MMin,
																		UUin => UUin,
																		HHout => HHout,
																		SSout => SSout,
																		MMout => MMout,
																		UUout => UUout);

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
	
   --Genereer stimulus (freeze)
	freeze_process : process
   begin
		freeze <= '0';
		wait for sysClk_period*30;
		freeze <= '1';
		wait for sysClk_period;
   end process;
	
	--Genereer stimulus (HH_SS_MM_UU_in)
	HH_SS_MM_UU_in_process : process
	begin
		HHin <= "00000000";
		SSin <= "00000000";
		MMin <= "00000000";
		UUin <= "00000000";
		wait for sysClk_period*5;
		HHin <= "00000010";
		SSin <= "00000100";
		MMin <= "00001000";
		UUin <= "00010000";
		wait for sysClk_period*5;
		HHin <= "10000000";
		SSin <= "01000000";
		MMin <= "00100000";
		UUin <= "00000001";
		wait for sysClk_period*5;
		HHin <= "00100000";
		SSin <= "00010000";
		MMin <= "00000100";
		UUin <= "00000010";
		wait for sysClk_period*5;
	end process;

end struct;