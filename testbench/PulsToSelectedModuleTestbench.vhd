----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    12/10/2013 
-- Design Name:    Basisklok
-- Module Name:    PulsToSelectedModuleTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity PulsToSelectedModuleTestbench is
end PulsToSelectedModuleTestbench;
 
architecture struct of PulsToSelectedModuleTestbench is 
   Component PulsToSelectedModule
	Port( sysClk : in std_logic;
			reset : in std_logic;
			selectedModus : in std_logic_vector(4 downto 0);
			pulsIn : in std_logic_vector(2 downto 0);
			pulsOutM0 : out std_logic_vector(2 downto 0);					
			pulsOutM1 : out std_logic_vector(2 downto 0);		
			pulsOutM2 : out std_logic_vector(2 downto 0);
			pulsOutM3 : out std_logic_vector(2 downto 0);
			pulsOutM4 : out std_logic_vector(2 downto 0));
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal reset : std_logic := '0';
signal selectedModus : std_logic_vector(4 downto 0) := "00001";
signal pulsIn : std_logic_vector(2 downto 0) := "000";
signal pulsOutM0 : std_logic_vector(2 downto 0) := "000";
signal pulsOutM1 : std_logic_vector(2 downto 0) := "000";
signal pulsOutM2 : std_logic_vector(2 downto 0) := "000";
signal pulsOutM3 : std_logic_vector(2 downto 0) := "000";
signal pulsOutM4 : std_logic_vector(2 downto 0) := "000";

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_PulsToSelectedModule: PulsToSelectedModule port map( sysClk => sysClk,
																			 reset => reset,
																			 selectedModus => selectedModus,
																			 pulsIn => pulsIn,
																			 pulsOutM0 => pulsOutM0,
																			 pulsOutM1 => pulsOutM1,
																			 pulsOutM2 => pulsOutM2,
																			 pulsOutM3 => pulsOutM3,
																			 pulsOutM4 => pulsOutM4);

   -- Klokpuls genereren
   sysClk_process : process
   begin
		sysClk <= '0';
		wait for sysClk_period/2;
		sysClk <= '1';
		wait for sysClk_period/2;
   end process;
 
   -- Genereer stimulus (selectedModus)
	selectedModus_process : process
   begin
		selectedModus <= "00001";
		wait for sysClk_period*4;
		selectedModus <= "00010";
		wait for sysClk_period*4;
		selectedModus <= "00100";
		wait for sysClk_period*4;
		selectedModus <= "01000";
		wait for sysClk_period*4;
		selectedModus <= "10000";
		wait for sysClk_period*4;
   end process;
	
	-- Genereer stimulus (pulsIn)
	pulsIn_process : process
   begin
		pulsIn <= "000";
		wait for sysClk_period;
		pulsIn <= "001";
		wait for sysClk_period;
		pulsIn <= "110";
		wait for sysClk_period;
		pulsIn <= "100";
		wait for sysClk_period;
   end process;
	
	-- Genereer stimulus (reset)
	reset_process : process
   begin
		reset <= '0';
		wait for sysClk_period*25;
		reset <= '1';
		wait for sysClk_period;
   end process;
	
end struct;