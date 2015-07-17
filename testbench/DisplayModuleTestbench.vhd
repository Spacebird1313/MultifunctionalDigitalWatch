----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    25/10/2013 
-- Design Name:    Basisklok
-- Module Name:    DisplayModuleTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity DisplayModuleTestbench is
end DisplayModuleTestbench;
 
architecture struct of DisplayModuleTestbench is 
   Component DisplayModule
	Port( clk : in std_logic;
			clkBlink : in std_logic;
			reset : in std_logic;
			disBlink : in std_logic_vector(3 downto 0);
			dis0 : in std_logic_vector(4 downto 0);
			dis1 : in std_logic_vector(4 downto 0);
			dis2 : in std_logic_vector(4 downto 0);
			dis3 : in std_logic_vector(4 downto 0);
			disOut : out std_logic_vector(7 downto 0);
			disSelect : out std_logic_vector(3 downto 0));
   End component;
    
--Interne signalen
signal clk : std_logic := '0';
signal clkBlink : std_logic := '0';
signal reset : std_logic := '0';
signal disBlink : std_logic_vector(3 downto 0) := "0000";
signal dis0 : std_logic_vector(4 downto 0) := "00000";
signal dis1 : std_logic_vector(4 downto 0) := "00000";
signal dis2 : std_logic_vector(4 downto 0) := "00000";
signal dis3 : std_logic_vector(4 downto 0) := "00000";
signal disOut : std_logic_vector(7 downto 0) := "00000000";
signal disSelect : std_logic_vector(3 downto 0) := "0000";

--Klokperiode constante
constant clk_period : time := 10 ns;
 
begin
Inst_DisplayModule: DisplayModule port map( clk => clk,
														  clkBlink => clkBlink,
														  reset => reset,
														  disBlink => disBlink,
														  dis0 => dis0,
														  dis1 => dis1,
														  dis2 => dis2,
														  dis3 => dis3,
														  disOut => disOut,
														  disSelect => disSelect);
	
   --Klokpuls genereren (clk)
   clk_process : process
   begin
		clk <= '0';
		wait for clk_period*2;
		clk <= '1';
		wait for clk_period;
   end process;

	--Klokpuls genereren (clkBlink)
   clkBlink_process : process
   begin
		clkBlink <= '0';
		wait for clk_period*5;
		clkBlink <= '1';
		wait for clk_period;
   end process;
    
	--Voer reset uit
	reset_process : process
	begin
		reset <= '0';
		wait for clk_period*1000;
		reset <= '1';
		wait for clk_period;
	end process;
	
   --Genereer stimulus (disBlink)
	disBlink_process : process
   begin
		disBlink <= "0000";
		wait for clk_period*10;
		disBlink <= "0001";
		wait for clk_period*10;
		disBlink <= "0011";
		wait for clk_period*10;
		disBlink <= "1100";
		wait for clk_period*10;
		disBlink <= "1111";
		wait for clk_period*10;
   end process;
	
	--Genereer stimulus (dis0)
	dis0_process : process
	begin
		dis0 <= "00000";
		wait for clk_period*6;
		dis0 <= "00001";
		wait for clk_period*6;
		dis0 <= "00010";
		wait for clk_period*6;
		dis0 <= "00011";
		wait for clk_period*6;
		dis0 <= "00100";
		wait for clk_period*6;
	end process;
	
	--Genereer stimulus (dis1)
	dis1_process : process
   begin
		dis1 <= "10000";
		wait for clk_period*6;
		dis1 <= "10001";
		wait for clk_period*6;
		dis1 <= "10010";
		wait for clk_period*6;
		dis1 <= "10011";
		wait for clk_period*6;
		dis1 <= "10100";
		wait for clk_period*6;
   end process;
	
	--Genereer stimulus (dis2)
	dis2_process : process
   begin
		dis2 <= "00101";
		wait for clk_period*6;
		dis2 <= "00110";
		wait for clk_period*6;
		dis2 <= "00111";
		wait for clk_period*6;
		dis2 <= "01000";
		wait for clk_period*6;
		dis2 <= "01001";
		wait for clk_period*6;
   end process;
	
	--Genereer stimulus (dis3)
	dis3_process : process
   begin
		dis3 <= "11001";
		wait for clk_period*6;
		dis3 <= "11000";
		wait for clk_period*6;
		dis3 <= "10111";
		wait for clk_period*6;
		dis3 <= "10110";
		wait for clk_period*6;
		dis3 <= "10100";
		wait for clk_period*6;
   end process;
	
end struct;

