----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    23/12/2013 
-- Design Name:    Basisklok
-- Module Name:    TimerSturingTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity TimerSturingTestbench is
end TimerSturingTestbench;
 
architecture struct of TimerSturingTestbench is 
   Component TimerSturing
	Port( sysClk : in std_logic;
	      reset : in std_logic;
			enableIn : in std_logic;
			clkZet : in std_logic;
			clkDelay : in std_logic;															--Vertraging voor snel zetten (delay = 2x clkDelay)
			zetIn : in std_logic_vector(1 downto 0);										--zet: (0) = zet Uur, (1) = zet Min													
			up : in std_logic;
			down : in std_logic;
			enableUit : out std_logic;
			updown : out std_logic;
			zet0 : out std_logic_vector(3 downto 0);
			zetUit : out std_logic_vector(3 downto 0));
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal reset : std_logic := '0';
signal enableIn : std_logic := '0';
signal clkZet : std_logic := '0';
signal clkDelay : std_logic := '0';
signal zetIn : std_logic_vector(1 downto 0) := "00";
signal up : std_logic := '0';
signal down : std_logic := '0';
signal enableUit : std_logic := '0';
signal updown : std_logic := '0';
signal zet0 : std_logic_vector(3 downto 0) := "0000";
signal zetUit : std_logic_vector(3 downto 0) := "0000";

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_TimerSturing: TimerSturing port map( sysClk => sysClk,
														reset => reset,
														enableIn => enableIn,
														clkZet => clkZet,
														clkDelay => clkDelay,
														zetIn => zetIn,
														up => up,
														down => down,
														enableUit => enableUit,
														updown => updown,
														zet0 => zet0,
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
	
	--Klokpuls genereren (clkZet)
   clkZet_process : process
   begin
		clkZet <= '0';
		wait for sysClk_period*4;
		clkZet <= '1';
		wait for sysClk_period;
   end process;
	
	--Klokpuls genereren (clkDelay)
   clkDelay_process : process
   begin
		clkDelay <= '0';
		wait for sysClk_period*5;
		clkDelay <= '1';
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
	
   --Genereer stimulus (zetIn)
	zetIn_process : process
   begin
		zetIn <= "00";
		wait for sysClk_period*30;
		zetIn <= "01";
		wait for sysClk_period*30;
		zetIn <= "10";
		wait for sysClk_period*30;
   end process;
	
	--Genereer stimulus (up - down)
   up_down_process : process
	begin
		up <= '0';
		down <= '0';
		wait for sysClk_period * 10;
		up <= '1';
		down <= '0';
		wait for sysClk_period * 2;
		up <= '0';
		down <= '0';
		wait for sysClk_period * 10;
		up <= '1';
		down <= '0';
		wait for sysClk_period * 20;
		up <= '0';
		down <= '1';
		wait for sysClk_period * 2;
		up <= '0';
		down <= '0';
		wait for sysClk_period * 10;
		up <= '0';
		down <= '1';
		wait for sysClk_period * 20;
	end process;
	
end struct;