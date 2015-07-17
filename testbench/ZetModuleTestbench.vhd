----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    20/10/2013 
-- Design Name:    Basisklok
-- Module Name:    ZetModuleTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity ZetModuleTestbench is
end ZetModuleTestbench;
 
architecture struct of ZetModuleTestbench is 
   Component ZetModule
	Port( sysClk : in std_logic;
	      reset : in std_logic;
			enableIn : in std_logic;
			clkZet : in std_logic;
			clkDelay : in std_logic;															--Vertraging voor snel zetten (delay = 2x clkDelay)
			up : in std_logic;
			down : in std_logic;
			updownCount : in std_logic;														--Telrichting in defaultmodus tellen
			zetIn : in std_logic_vector(3 downto 0);										--zet: (0) = zet Dis0, (1) = zet Dis1, (2) = zet Dis2, (3) = zet Dis3	
			enableUit : out std_logic;
			updown : out std_logic;
			zetUit : out std_logic_vector(3 downto 0));	
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal enableIn : std_logic := '0';
signal clkZet : std_logic := '0';
signal clkDelay : std_logic := '0';
signal reset : std_logic := '0';
signal up : std_logic := '0';
signal down : std_logic := '0';
signal updownCount : std_logic := '0';
signal zetIn : std_logic_vector(3 downto 0) := "0000";
signal enableUit : std_logic := '0';
signal updown : std_logic := '0';
signal zetUit : std_logic_vector(3 downto 0) := "0000";

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_ZetModule: ZetModule port map( sysClk => sysClk,
												reset => reset,
												enableIn => enableIn,
												clkZet => clkZet,
												clkDelay => clkDelay,
												up => up,
												down => down,
												updownCount => updownCount,
												zetIn => zetIn,
												enableUit => enableUit,
												updown => updown,
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
		wait for sysClk_period*2;
		clkZet <= '1';
		wait for sysClk_period;
   end process;

	--Klokpuls genereren (clkDelay)
   clkDelay_process : process
   begin
		clkDelay <= '0';
		wait for sysClk_period*4;
		clkDelay <= '1';
		wait for sysClk_period;
   end process;
	
	--Genereer stimulus (reset)
	reset_process : process
   begin
		reset <= '0';
		wait for sysClk_period*100;
		reset <= '1';
		wait for sysClk_period*2;
   end process;
	
	--Genereer stimulus (up - down)
	up_down_process : process
   begin
		up <= '0';
		down <= '0';
		wait for sysClk_period*20;
		up <= '1';
		down <= '0';
		wait for sysClk_period*15;
		up <= '0';
		down <= '0';
		wait for sysClk_period*13;
		up <= '0';
		down <= '1';
		wait for sysClk_period*23;
   end process;
	
	--Genereer stimulus (updownCount)
	updownCount_process : process
	begin
		updownCount <= '0';
		wait for sysClk_period*50;
		updownCount <= '1';
		wait for sysClk_period*50;
	end process;
	
	--Genereer stimulus (zetIn)
	zetIn_process : process
	begin
		zetIn <= "0000";
		wait for sysClk_period*15;
		zetIn <= "0001";
		wait for sysClk_period*15;
		zetIn <= "0010";
		wait for sysClk_period*15;
		zetIn <= "0100";
		wait for sysClk_period*15;
		zetIn <= "1000";
		wait for sysClk_period*15;
		zetIn <= "0000";
		wait for sysClk_period*15;
		zetIn <= "1111";
		wait for sysClk_period*15;
		zetIn <= "0000";
		wait for sysClk_period*10;
	end process;

end struct;