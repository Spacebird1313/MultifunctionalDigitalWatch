----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    20/10/2013 
-- Design Name:    Basisklok
-- Module Name:    UurwerkTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity UurwerkTestbench is
end UurwerkTestbench;
 
architecture struct of UurwerkTestbench is 
   Component Uurwerk
	Port( sysClk : in std_logic;
	      reset : in std_logic;
			clk1Hz : in std_logic;
			clk2Hz : in std_logic;	
			clk4Hz : in std_logic;
			up : in std_logic;
			down : in std_logic;
			zet : in std_logic_vector(2 downto 0);																
			oD : out std_logic;
			SS : out std_logic_vector(7 downto 0);
			MM : out std_logic_vector(7 downto 0);
			UU : out std_logic_vector(7 downto 0));
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal reset : std_logic := '0';
signal clk1Hz : std_logic := '0';
signal clk2Hz : std_logic := '0';
signal clk4Hz : std_logic := '0';
signal up : std_logic := '1';
signal down : std_logic := '0';
signal zet : std_logic_vector(2 downto 0) := "000";
signal oD : std_logic := '0';
signal SS : std_logic_vector(7 downto 0) := "00000000";
signal MM : std_logic_vector(7 downto 0) := "00000000";
signal UU : std_logic_vector(7 downto 0) := "00000000";

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_Uurwerk: Uurwerk port map( sysClk => sysClk,
										  reset => reset,
										  clk1Hz => clk1Hz,
										  clk2Hz => clk2Hz,
										  clk4Hz => clk4Hz,
										  up => up,
										  down => down,
										  zet => zet,
										  oD => oD,
										  SS => SS,
										  MM => MM,
										  UU => UU);

   --Klokpuls genereren (sysClk)
   sysClk_process : process
   begin
		sysClk <= '0';
		wait for sysClk_period/2;
		sysClk <= '1';
		wait for sysClk_period/2;
   end process;

	--Klokpuls genereren (clk1Hz)
   clk1Hz_process : process
   begin
		clk1Hz <= '0';
		wait for sysClk_period*10;
		clk1Hz <= '1';
		wait for sysClk_period;
   end process;
	
	--Klokpuls genereren (clk4Hz)
   clk4Hz_process : process
   begin
		clk4Hz <= '0';
		wait for sysClk_period*4;
		clk4Hz <= '1';
		wait for sysClk_period;
   end process;
	
	--Klokpuls genereren (clk2Hz)
   clk2Hzprocess : process
   begin
		clk2Hz <= '0';
		wait for sysClk_period*5;
		clk2Hz <= '1';
		wait for sysClk_period;
   end process;
    
	--Voer reset uit
	reset_process : process
	begin
		reset <= '0';
		wait for sysClk_period * 10000;
		reset <= '1';
		wait for sysClk_period;
	end process;
	
   --Genereer stimulus (zet)
	zet_process : process
   begin
		zet <= "000";
		wait for sysClk_period*30;
		zet <= "001";
		wait for sysClk_period*30;
		zet <= "010";
		wait for sysClk_period*30;
		zet <= "100";
		wait for sysClk_period*30;
   end process;
	
	--Genereer stimulus (up - down)
	up_down_process : process
	begin
		up <= '0';
		down <= '0';
		wait for sysClk_period * 300;
		up <= '1';
		down <= '0';
		wait for sysClk_period * 200;
		up <= '0';
		down <= '0';
		wait for sysClk_period * 100;
		up <= '1';
		down <= '0';
		wait for sysClk_period * 20;
		up <= '0';
		down <= '1';
		wait for sysClk_period * 200;
		up <= '0';
		down <= '0';
		wait for sysClk_period * 100;
		up <= '0';
		down <= '1';
		wait for sysClk_period * 200;
	end process;
	
end struct;