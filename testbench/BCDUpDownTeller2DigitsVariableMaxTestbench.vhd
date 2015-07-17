----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    05/10/2013 
-- Design Name:    Basisklok
-- Module Name:    BCDUpDownTeller2DigitsVariableMaxTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity BCDUpDownTeller2DigitsVariableMaxTestbench is
end BCDUpDownTeller2DigitsVariableMaxTestbench;
 
architecture struct of BCDUpDownTeller2DigitsVariableMaxTestbench is 
   Component BCDUpDownTeller2DigitsVariableMax
   Generic( min : integer := 0);
	Port( sysClk : in std_logic;
			updown : in std_logic;
	      reset : in std_logic;
			enable : in std_logic;
			max : in STD_LOGIC_VECTOR (7 downto 0);
			ct : out std_logic;
			cnt : out std_logic_vector(7 downto 0));
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal enable : std_logic := '0';
signal updown : std_logic := '0';
signal reset : std_logic := '0';
signal max : std_logic_vector(7 downto 0) := "00000000";
signal ct : std_logic := '0';
signal cnt : std_logic_vector(7 downto 0) := "00000000";

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_BCDUpDownTeller2DigitsVariableMax: BCDUpDownTeller2DigitsVariableMax port map( sysClk => sysClk,
																												enable => enable,
																												reset => reset,
																												updown => updown,
																												max => max,
																												ct => ct,
																												cnt => cnt);

   -- Klokpuls genereren
   sysClk_process : process
   begin
		sysClk <= '0';
		wait for sysClk_period/2;
		sysClk <= '1';
		wait for sysClk_period/2;
   end process;
 
   -- Genereer stimulus (enable)
	enable_process : process
   begin
		enable <= '0';
		wait for sysClk_period;
		enable <= '1';
		wait for sysClk_period;
   end process;
    
	-- Voer reset uit
	reset_process : process
	begin
		reset <= '0';
		wait for sysClk_period * 1000;
		reset <= '1';
		wait for sysClk_period;
	end process;
	
	-- Genereer stimulus (updown)
   updown_process : process
	begin
		updown <= '0'; --optellen
		wait for sysClk_period * 100;
		updown <= '1'; --aftrekken
		wait for sysClk_period * 100;
	end process;
	
	-- Zet maximum telstand
	max_process : process
	begin
		max <= "00110000"; --tel tot 30
		wait for sysClk_period * 35;
		max <= "00101000"; --tel tot 28
		wait for sysClk_period * 32;
	end process;
	
end struct;