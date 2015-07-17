----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    18/10/2013 
-- Design Name:    Basisklok
-- Module Name:    Teller4x2DigitsCijfersSturingTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Teller4x2DigitsCijfersSturingTestbench is
end Teller4x2DigitsCijfersSturingTestbench;

architecture struct of Teller4x2DigitsCijfersSturingTestbench is
	Component Teller4x2DigitsCijfersSturing
	Port( sysClk : in std_logic;
			enable : in std_logic;
			reset : in std_logic;
			disSet : in std_logic_vector(3 downto 0);
			disCt : in std_logic_vector(3 downto 0);
			disEnable : out std_logic_vector(3 downto 0));
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal enable : std_logic := '0';
signal reset : std_logic := '0';
signal disSet : std_logic_vector(3 downto 0) := "0000";
signal disCt : std_logic_vector(3 downto 0) := "0000";
signal disEnable : std_logic_vector(3 downto 0) := "0000";

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_Teller4x2DigitsCijfersSturing: Teller4x2DigitsCijfersSturing port map( sysClk => sysClk,
																									 enable => enable,
																									 reset => reset,
																									 disSet => disSet,
																									 disCt => disCt,
																									 disEnable => disEnable);

   --Klokpuls genereren
   sysClk_process : process
   begin
		sysClk <= '0';
		wait for sysClk_period/2;
		sysClk <= '1';
		wait for sysClk_period/2;
   end process;
 
   --Genereer stimulus (enable)
	enable_process : process
   begin
		enable <= '0';
		wait for sysClk_period*2;
		enable <= '1';
		wait for sysClk_period;
   end process;
	
	--Genereer stimulus (reset)
	reset_process : process
   begin
		reset <= '0';
		wait for sysClk_period*50;
		reset <= '1';
		wait for sysClk_period*2;
   end process;
	
	--Genereer stimulus (disSet)
	disSet_process : process
	begin
		disSet <= "0000";
		wait for sysClk_period*4;
		disSet <= "0001";
		wait for sysClk_period*4;
		disSet <= "0010";
		wait for sysClk_period*4;
		disSet <= "0100";
		wait for sysClk_period*4;
		disSet <= "1000";
		wait for sysClk_period*4;
	end process;
	
	--Genereer stimulus (disCt)
	disCt_process : process
	begin
		disCt <= "0000";
		wait for sysClk_period*4;
		disCt <= "1111";
		wait for sysClk_period;
	end process;
	
end struct;