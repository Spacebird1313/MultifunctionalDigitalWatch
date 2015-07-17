----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    17/11/2013 
-- Design Name:    Basisklok
-- Module Name:    DatumSturingTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity DatumSturingTestbench is
end DatumSturingTestbench;
 
architecture struct of DatumSturingTestbench is 
   Component DatumSturing
	Port( sysClk : in std_logic;
	      reset : in std_logic;
			enableIn : in std_logic;
			clkZet : in std_logic;
			clkDelay : in std_logic;															--Vertraging voor snel zetten (delay = 2x clkDelay)
			zetIn : in std_logic_vector(2 downto 0);										--zet: (0) = zet Sec, (1) = zet Min, (2)	= zet Uur														
			up : in std_logic;
			down : in std_logic;
			MM : in std_logic_vector(7 downto 0);
			JJ : in std_logic_vector(7 downto 0);
			enableUit : out std_logic;
			updown : out std_logic;
			zetUit : out std_logic_vector(3 downto 0);
			DDMax : out std_logic_vector(7 downto 0));
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal reset : std_logic := '0';
signal enableIn : std_logic := '0';
signal clkZet : std_logic := '0';
signal clkDelay : std_logic := '0';
signal zetIn : std_logic_vector(2 downto 0) := "000";
signal up : std_logic := '0';
signal down : std_logic := '0';
signal MM : std_logic_vector(7 downto 0) := "00000000";
signal JJ : std_logic_vector(7 downto 0) := "00000000";
signal enableUit : std_logic := '0';
signal updown : std_logic := '0';
signal zetUit : std_logic_vector(3 downto 0) := "0000";
signal DDMax : std_logic_vector(7 downto 0) := "00000000";

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_DatumSturing: DatumSturing port map( sysClk => sysClk,
														reset => reset,
														enableIn => enableIn,
														clkZet => clkZet,
														clkDelay => clkDelay,
														zetIn => zetIn,
														up => up,
														down => down,
														MM => MM,
														JJ => JJ,
														enableUit => enableUit,
														updown => updown,
														zetUit => zetUit,
														DDMax => DDMax);
												  
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
		wait for sysClk_period*10;
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
		zetIn <= "000";
		wait for sysClk_period*30;
		zetIn <= "001";
		wait for sysClk_period*30;
		zetIn <= "010";
		wait for sysClk_period*30;
		zetIn <= "100";
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
	
	--Genereer stimulus (MM)
   MM_process : process
	begin
		for i in 0 to 1 loop
			for j in 0 to 9 loop
				MM(7 downto 4) <= std_logic_vector(to_unsigned(i, 4));
				MM(3 downto 0) <= std_logic_vector(to_unsigned(j, 4));
			wait for sysClk_period;
			end loop;
		end loop;
		MM <= "00000010";
		wait;
	end process;
	
	--Genereer stimulus (JJ)
   JJ_process : process
	begin
		for i in 0 to 9 loop
			for j in 0 to 9 loop
				JJ(7 downto 4) <= std_logic_vector(to_unsigned(i, 4));
				JJ(3 downto 0) <= std_logic_vector(to_unsigned(j, 4));
			wait for sysClk_period;
			end loop;
		end loop;
		wait;
	end process;
	
end struct;