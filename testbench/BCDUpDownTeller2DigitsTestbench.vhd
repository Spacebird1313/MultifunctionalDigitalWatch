----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    01/10/2013 
-- Design Name:    Basisklok
-- Module Name:    BCDUpDownTeller2DigitsTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity BCDUpDownTeller2DigitsTestbench is
end BCDUpDownTeller2DigitsTestbench;
 
architecture struct of BCDUpDownTeller2DigitsTestbench is 
   Component BCDUpDownTeller2Digits
   Generic( max : integer := 99;
				min : integer := 0);
	Port( sysClk : in std_logic;
			updown : in std_logic;
	      reset : in std_logic;
			enable : in std_logic;
			ct : out std_logic;
			cnt : out std_logic_vector(7 downto 0));
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal enable : std_logic := '0';
signal updown : std_logic := '0';
signal reset : std_logic := '0';
signal ct : std_logic;
signal cnt : std_logic_vector(7 downto 0);

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_BCDUpDownTeller2Digits: BCDUpDownTeller2Digits port map( sysClk => sysClk,
																				  enable => enable,
																				  reset => reset,
												                          updown => updown,
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
		wait for sysClk_period*10;
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
		wait for sysClk_period * 50;
		updown <= '1'; --aftrekken
		wait for sysClk_period * 50;
	end process;
	
end struct;