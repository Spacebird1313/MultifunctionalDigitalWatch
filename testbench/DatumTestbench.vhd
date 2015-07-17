----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    17/11/2013 
-- Design Name:    Basisklok
-- Module Name:    DatumTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity DatumTestbench is
end DatumTestbench;
 
architecture struct of DatumTestbench is 
   Component Datum
	Port( sysClk : in std_logic;
	      reset : in std_logic;
			oD : in std_logic;
			clk2Hz : in std_logic;	
			clk4Hz : in std_logic;
			up : in std_logic;
			down : in std_logic;
			zet : in std_logic_vector(2 downto 0);																
			DD : out std_logic_vector(7 downto 0);
			MM : out std_logic_vector(7 downto 0);
			JJ : out std_logic_vector(7 downto 0));
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal reset : std_logic := '0';
signal oD : std_logic := '0';
signal clk2Hz : std_logic := '0';
signal clk4Hz : std_logic := '0';
signal up : std_logic := '0';
signal down : std_logic := '0';
signal zet : std_logic_vector(2 downto 0) := "000";
signal DD : std_logic_vector(7 downto 0) := "00000000";
signal MM : std_logic_vector(7 downto 0) := "00000000";
signal JJ : std_logic_vector(7 downto 0) := "00000000";

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_Datum: Datum port map( sysClk => sysClk,
									 reset => reset,
									 oD => oD,
									 clk2Hz => clk2Hz,
									 clk4Hz => clk4Hz,
									 up => up,
									 down => down,
									 zet => zet,
									 DD => DD,
									 MM => MM,
									 JJ => JJ);

   --Klokpuls genereren (sysClk)
   sysClk_process : process
   begin
		sysClk <= '0';
		wait for sysClk_period/2;
		sysClk <= '1';
		wait for sysClk_period/2;
   end process;

	--Klokpuls genereren (oD)
   oD_process : process
   begin
		oD <= '0';
		wait for sysClk_period*10;
		oD <= '1';
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