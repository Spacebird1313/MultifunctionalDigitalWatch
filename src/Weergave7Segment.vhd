----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    26/04/2013 
-- Design Name:    Basisklok
-- Module Name:    Weergave7Segment
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity Weergave7Segment is
	Port ( clk : in STD_LOGIC;
			 Reset : in STD_LOGIC;
			 Dis0 : in STD_LOGIC_VECTOR(4 downto 0);
			 Dis1 : in STD_LOGIC_VECTOR(4 downto 0);
			 Dis2 : in STD_LOGIC_VECTOR(4 downto 0);
			 Dis3 : in STD_LOGIC_VECTOR(4 downto 0);
			 disBlink : in STD_LOGIC_VECTOR(3 downto 0);
			 clkBlink : in STD_LOGIC;
			 DisOut : out STD_LOGIC_VECTOR(7 downto 0);
			 DisSelect : out STD_LOGIC_VECTOR(3 downto 0));
end Weergave7Segment;

architecture struct of Weergave7Segment is
	component BCD7SegmentDecoder
	Port ( BCD : in STD_LOGIC_VECTOR(3 downto 0);
			 Reset : in STD_LOGIC;
	       Seg7 : out STD_LOGIC_VECTOR(6 downto 0));
	end component;
	
	component DisplayController
	Port ( clk, Reset : in STD_LOGIC;
			 Dis0, Dis1, Dis2, Dis3 : in STD_LOGIC_VECTOR(4 downto 0);
			 DisOut : out STD_LOGIC_VECTOR(4 downto 0);
			 DisSelect : out STD_LOGIC_VECTOR(3 downto 0));
	end component;
	
	component DisplayBlinkModule
	Port ( clkBlink : in STD_LOGIC;
			 disBlink : in STD_LOGIC_VECTOR(3 downto 0);
			 disSelectIn : in STD_LOGIC_VECTOR(3 downto 0);
			 disSelectUit : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

 --Interne signalen
Signal DisOut_intern : STD_LOGIC_VECTOR(4 downto 0);
Signal DisSelect_intern : STD_LOGIC_VECTOR(3 downto 0);

begin
	Inst_BCD7SegmentDecoder : BCD7SegmentDecoder Port map ( BCD => DisOut_intern(3 downto 0),
																			  Reset => Reset,
																			  Seg7 => DisOut(6 downto 0));
	
	Inst_DisplayController : DisplayController Port map ( clk => clk,
																			Reset => Reset,
																			Dis0 => Dis0,
																			Dis1 => Dis1,
																			Dis2 => Dis2,
																			Dis3 => Dis3,
																			DisOut => DisOut_intern,
																			DisSelect => DisSelect_intern);
	
	Inst_DisplayBlinkModule : DisplayBlinkModule	Port map ( clkBlink => clkBlink,
																			  disBlink => disBlink,
																			  disSelectIn => DisSelect_intern,
																			  disSelectUit => DisSelect);
	
	DisOut(7) <= DisOut_intern(4);

end struct;

