----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    02/11/2013 
-- Design Name:    Basisklok
-- Module Name:    BCDToDisTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity BCDToDisTestbench is
end BCDToDisTestbench;
 
architecture struct of BCDToDisTestbench is 
   Component BCDToDis
	Port( BCDTellerToDis0_1 : in std_logic_vector(3 downto 0);
			BCDTellerToDis2_3 : in std_logic_vector(3 downto 0);
			BCDTeller0 : in std_logic_vector(7 downto 0);	
			BCDTeller1 : in std_logic_vector(7 downto 0);
			BCDTeller2 : in std_logic_vector(7 downto 0);
			BCDTeller3 : in std_logic_vector(7 downto 0);
			disPunt : in std_logic_vector(3 downto 0);									
			dis0 : out std_logic_vector(4 downto 0);
			dis1 : out std_logic_vector(4 downto 0);
			dis2 : out std_logic_vector(4 downto 0);
			dis3 : out std_logic_vector(4 downto 0));
   End component;
    
--Interne signalen
signal BCDTellerToDis0_1 : std_logic_vector(3 downto 0) := "0000";
signal BCDTellerToDis2_3 : std_logic_vector(3 downto 0) := "0000";
signal BCDTeller0 : std_logic_vector(7 downto 0) := "00000000";
signal BCDTeller1 : std_logic_vector(7 downto 0) := "00000000";
signal BCDTeller2 : std_logic_vector(7 downto 0) := "00000000";
signal BCDTeller3 : std_logic_vector(7 downto 0) := "00000000";
signal disPunt : std_logic_vector(3 downto 0) := "0000";
signal dis0 : std_logic_vector(4 downto 0) := "10000";
signal dis1 : std_logic_vector(4 downto 0) := "10000";
signal dis2 : std_logic_vector(4 downto 0) := "10000";
signal dis3 : std_logic_vector(4 downto 0) := "10000";

--Klokperiode constante
constant clk_period : time := 10 ns;
 
begin
Inst_BCDToDis: BCDToDis port map( BCDTellerToDis0_1 => BCDTellerToDis0_1,
											 BCDTellerToDis2_3 => BCDTellerToDis2_3,
											 BCDTeller0 => BCDTeller0,
											 BCDTeller1 => BCDTeller1,
											 BCDTeller2 => BCDTeller2,
											 BCDTeller3 => BCDTeller3,
											 disPunt => disPunt,
											 dis0 => dis0,
											 dis1 => dis1,
											 dis2 => dis2,
											 dis3 => dis3);

   --Genereer stimulus (BCDTellerToDis 0_1 + 2_3)
	BCDTellerToDis_process : process
   begin
		BCDTellerToDis0_1 <= "0001";
		BCDTellerToDis2_3 <= "0010";
		wait for clk_period*8;
		BCDTellerToDis0_1 <= "0100";
		BCDTellerToDis2_3 <= "1000";
		wait for clk_period*8;
   end process;
	
	--Genereer stimulus (BCDTeller0)
	BCDTeller0_process : process
	begin
		BCDTeller0 <= "00000000";
		wait for clk_period*2;
		BCDTeller0 <= "00010001";
		wait for clk_period*2;
		BCDTeller0 <= "00100010";
		wait for clk_period*2;
		BCDTeller0 <= "00110011";
		wait for clk_period*2;
		BCDTeller0 <= "01000100";
		wait for clk_period*2;
		BCDTeller0 <= "01010101";
		wait for clk_period*2;
		BCDTeller0 <= "01110111";
		wait for clk_period*2;
		BCDTeller0 <= "10001000";
		wait for clk_period*2;
	end process;
	
	--Genereer stimulus (BCDTeller1)
	BCDTeller1_process : process
	begin
		BCDTeller1 <= "10011001";
		wait for clk_period*2;
		BCDTeller1 <= "10001000";
		wait for clk_period*2;
		BCDTeller1 <= "01110111";
		wait for clk_period*2;
		BCDTeller1 <= "01100110";
		wait for clk_period*2;
		BCDTeller1 <= "01000100";
		wait for clk_period*2;
		BCDTeller1 <= "00110011";
		wait for clk_period*2;
		BCDTeller1 <= "00100010";
		wait for clk_period*2;
		BCDTeller1 <= "00010001";
		wait for clk_period*2;
	end process;
	
	--Genereer stimulus (BCDTeller2)
	BCDTeller2_process : process
	begin
		BCDTeller2 <= "00000001";
		wait for clk_period*2;
		BCDTeller2 <= "00000010";
		wait for clk_period*2;
		BCDTeller2 <= "00000011";
		wait for clk_period*2;
		BCDTeller2 <= "00000100";
		wait for clk_period*2;
		BCDTeller2 <= "00000101";
		wait for clk_period*2;
		BCDTeller2 <= "00000111";
		wait for clk_period*2;
		BCDTeller2 <= "00001000";
		wait for clk_period*2;
		BCDTeller2 <= "00001001";
		wait for clk_period*2;
	end process;
	
	--Genereer stimulus (BCDTeller3)
	BCDTeller3_process : process
	begin
		BCDTeller3 <= "00010000";
		wait for clk_period*2;
		BCDTeller3 <= "00100000";
		wait for clk_period*2;
		BCDTeller3 <= "00110000";
		wait for clk_period*2;
		BCDTeller3 <= "01000000";
		wait for clk_period*2;
		BCDTeller3 <= "01010000";
		wait for clk_period*2;
		BCDTeller3 <= "01110000";
		wait for clk_period*2;
		BCDTeller3 <= "10000000";
		wait for clk_period*2;
		BCDTeller3 <= "10010000";
		wait for clk_period*2;
	end process;
	
	--Genereer stimulus (disPunt)
	disPunt_process : process
	begin
		disPunt <= "1111";
		wait for clk_period*2;
		disPunt <= "0101";
		wait for clk_period*2;
		disPunt <= "0000";
		wait for clk_period*2;
		disPunt <= "1010";
		wait for clk_period*2;
	end process;
	
end struct;