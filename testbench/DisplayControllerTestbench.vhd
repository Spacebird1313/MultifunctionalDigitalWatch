----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    26/04/2013 
-- Design Name:    Basisklok
-- Module Name:    DisplayControllerTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DisplayControllerTestbench is
end DisplayControllerTestbench;

architecture struct of DisplayControllerTestbench is
	Component DisplayController
	Port( clk : in std_logic;
			reset : in std_logic;
			dis0 : in std_logic_vector(4 downto 0);
			dis1 : in std_logic_vector(4 downto 0);
			dis2 : in std_logic_vector(4 downto 0);
			dis3 : in std_logic_vector(4 downto 0);
			disOut : out std_logic_vector(4 downto 0);
			disSelect : out std_logic_vector(3 downto 0));
   End component;
    
--Interne signalen
signal clk : std_logic := '0';
signal reset : std_logic := '0';
signal dis0 : std_logic_vector(4 downto 0) := "00000";
signal dis1 : std_logic_vector(4 downto 0) := "00000";
signal dis2 : std_logic_vector(4 downto 0) := "00000";
signal dis3 : std_logic_vector(4 downto 0) := "00000";
signal disOut : std_logic_vector(4 downto 0) := "00000";
signal disSelect : std_logic_vector(3 downto 0) := "0000";

--Klokperiode constante
constant clk_period : time := 10 ns;
 
begin
Inst_DisplayController: DisplayController port map( clk => clk,
																	 reset => reset,
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
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
   --Genereer stimulus (dis0)
	dis0_process : process
   begin
		dis0 <= "00000";
		wait for clk_period*4;
		dis0 <= "00001";
		wait for clk_period*4;
		dis0 <= "00010";
		wait for clk_period*4;
		dis0 <= "00011";
		wait for clk_period*4;
   end process;
	
	--Genereer stimulus (dis1)
	dis1_process : process
   begin
		dis1 <= "00100";
		wait for clk_period*4;
		dis1 <= "00101";
		wait for clk_period*4;
		dis1 <= "00110";
		wait for clk_period*4;
		dis1 <= "00111";
		wait for clk_period*4;
   end process;
	
	--Genereer stimulus (dis2)
	dis2_process : process
   begin
		dis2 <= "11000";
		wait for clk_period*4;
		dis2 <= "11001";
		wait for clk_period*4;
		dis2 <= "10000";
		wait for clk_period*4;
		dis2 <= "10001";
		wait for clk_period*4;
   end process;
	
	--Genereer stimulus (dis3)
	dis3_process : process
   begin
		dis3 <= "10010";
		wait for clk_period*4;
		dis3 <= "10011";
		wait for clk_period*4;
		dis3 <= "10100";
		wait for clk_period*4;
		dis3 <= "10101";
		wait for clk_period*4;
   end process;
	
	--Genereer stimulus (reset)
	reset_process : process
   begin
		Reset <= '0';
		wait for clk_period*50;
		Reset <= '1';
		wait for clk_period*2;
   end process;
	
end struct;