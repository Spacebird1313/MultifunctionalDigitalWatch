----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    26/04/2013 
-- Design Name:    Basisklok
-- Module Name:    BCD7SegmentDecoderTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BCD7SegmentDecoderTestbench is
end BCD7SegmentDecoderTestbench;

architecture struct of BCD7SegmentDecoderTestbench is
	Component BCD7SegmentDecoder
	Port( BCD : in std_logic_vector(3 downto 0);
			reset : in std_logic;
			Seg7 : out std_logic_vector(6 downto 0));
   End component;
    
--Interne signalen
signal BCD : std_logic_vector(3 downto 0) := "0000";
signal Reset : std_logic := '0';
signal Seg7 : std_logic_vector(6 downto 0) := "0000000";

--Klokperiode constante
constant clk_period : time := 10 ns;
 
begin
Inst_BCD7SegmentDecoder: BCD7SegmentDecoder port map( BCD => BCD,
																		reset => reset,
																		Seg7 => Seg7);
 
   --Genereer stimulus (BCD)
	BCD_process : process
   begin
		BCD <= "0000";
		wait for clk_period;
		BCD <= "0001";
		wait for clk_period;
		BCD <= "0010";
		wait for clk_period;
		BCD <= "0011";
		wait for clk_period;
		BCD <= "0100";
		wait for clk_period;
		BCD <= "0101";
		wait for clk_period;
		BCD <= "0110";
		wait for clk_period;
		BCD <= "0111";
		wait for clk_period;
		BCD <= "1000";
		wait for clk_period;
		BCD <= "1001";
		wait for clk_period;
		BCD <= "1111";																					--Ongeldige waarde (Seg7 = "111111111")
		wait for clk_period;
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