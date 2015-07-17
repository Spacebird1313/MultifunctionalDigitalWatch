----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    27/10/2013 
-- Design Name:    Basisklok
-- Module Name:    InstelmodusSturingTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity InstelmodusSturingTestbench is
end InstelmodusSturingTestbench;
 
architecture struct of InstelmodusSturingTestbench is 
   Component InstelmodusSturing
	Port( sysClk : in std_logic;
			reset : in std_logic;
			nextModeIn : in std_logic;
			huidigWerkingsmodus : in std_logic_vector(4 downto 0);
			huidigInstelmodus : in std_logic_vector(4 downto 0);
			nextModeOut : out std_logic;
			instelmodeReset : out std_logic);
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal reset : std_logic := '0';
signal nextModeIn : std_logic := '0';
signal huidigWerkingsmodus : std_logic_vector(4 downto 0) := "00001";
signal huidigInstelmodus : std_logic_vector(4 downto 0) := "00001";
signal nextModeOut : std_logic := '0';
signal instelmodeReset : std_logic := '0';

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_InstelmodusSturing: InstelmodusSturing port map( sysClk => sysClk,
																		reset => reset,
																		nextModeIn => nextModeIn,
																		huidigWerkingsmodus => huidigWerkingsmodus,
																		huidigInstelmodus => huidigInstelmodus,
																		nextModeOut => nextModeOut,
																		instelmodeReset => instelmodeReset);

   -- Klokpuls genereren
   sysClk_process : process
   begin
		sysClk <= '0';
		wait for sysClk_period/2;
		sysClk <= '1';
		wait for sysClk_period/2;
   end process;
   
	-- Genereer stimulus (reset)
	reset_process : process
   begin
		reset <= '0';
		wait for sysClk_period*100;
		reset <= '1';
		wait for sysClk_period*2;
   end process;
	
   -- Genereer stimulus (nextModeIn)
	nextModeIn_process : process
   begin
		nextModeIn <= '0';
		wait for sysClk_period*4;
		nextModeIn <= '1';
		wait for sysClk_period;
   end process;
	
	-- Genereer stimulus (huidigWerkingsmodus)
	huidigWerkingsmodus_process : process
   begin
		huidigWerkingsmodus <= "00001";
		wait for sysClk_period*10;
		huidigWerkingsmodus <= "00010";
		wait for sysClk_period*10;
		huidigWerkingsmodus <= "00100";
		wait for sysClk_period*10;
		huidigWerkingsmodus <= "01000";
		wait for sysClk_period*10;
		huidigWerkingsmodus <= "10000";
		wait for sysClk_period*10;
   end process;
	
	-- Genereer stimulus (huidigInstelmodus)
	huidigInstelmodus_process : process
   begin
		huidigInstelmodus <= "00001";
		wait for sysClk_period*5;
		huidigInstelmodus <= "00010";
		wait for sysClk_period*5;
		huidigInstelmodus <= "00100";
		wait for sysClk_period*5;
		huidigInstelmodus <= "01000";
		wait for sysClk_period*5;
		huidigInstelmodus <= "10000";
		wait for sysClk_period*5;
   end process;
	
end struct;