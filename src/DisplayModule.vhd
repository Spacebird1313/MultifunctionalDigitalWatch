----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    07/10/2013 
-- Design Name:    Basisklok
-- Module Name:    DisplayModule
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DisplayModule is
	Port ( clk : in STD_LOGIC;
	       clkBlink : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       disBlink : in STD_LOGIC_VECTOR(3 downto 0);
	       dis0 : in STD_LOGIC_VECTOR(4 downto 0);
	       dis1 : in STD_LOGIC_VECTOR(4 downto 0);
	       dis2 : in STD_LOGIC_VECTOR(4 downto 0);
	       dis3 : in STD_LOGIC_VECTOR(4 downto 0);
	       disOut : out STD_LOGIC_VECTOR(7 downto 0) := "11111111";
	       disSelect : out STD_LOGIC_VECTOR(3 downto 0) := "1111");
end DisplayModule;

architecture struct of DisplayModule is
	component BCD7SegmentDecoder
	Port ( BCD : in STD_LOGIC_VECTOR(3 downto 0);
	       reset : in STD_LOGIC;
	       Seg7 : out STD_LOGIC_VECTOR(6 downto 0));
	end component;
	
	component DisplayController
	Port ( clk : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       dis0 : in STD_LOGIC_VECTOR(4 downto 0);
	       dis1 : in STD_LOGIC_VECTOR(4 downto 0);
	       dis2 : in STD_LOGIC_VECTOR(4 downto 0);
	       dis3 : in STD_LOGIC_VECTOR(4 downto 0);
	       disOut : out STD_LOGIC_VECTOR(4 downto 0); 
	       disSelect : out STD_LOGIC_VECTOR(3 downto 0));
	end component;
	
	component DisplayBlinkModule
	Port ( clkBlink : in STD_LOGIC;
	       disBlink : in STD_LOGIC_VECTOR(3 downto 0);
	       disSelectIn : in STD_LOGIC_VECTOR(3 downto 0);
	       disSelectUit : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

--Interne signalen
Signal disSelect_intern : STD_LOGIC_VECTOR(3 downto 0);
Signal disOut_intern : STD_LOGIC_VECTOR(4 downto 0);

begin
	Inst_BCD7SegmentDecoder : BCD7SegmentDecoder Port map ( BCD => disOut_intern(3 downto 0),
								reset => reset,
								Seg7 => disOut(6 downto 0));

	Inst_DisplayController : DisplayController Port map ( clk => clk,
							      reset => reset,
							      dis0 => dis0,
							      dis1 => dis1,
							      dis2 => dis2,
							      dis3 => dis3,
							      disOut => disOut_intern,
							      disSelect => disSelect_intern);
	
	Inst_DisplayBlinkModule : DisplayBlinkModule	Port map ( clkBlink => clkBlink,
								   disBlink => disBlink,
								   disSelectIn => DisSelect_intern,
								   disSelectUit => DisSelect);

disOut(7) <= disOut_intern(4);
  
end struct;
