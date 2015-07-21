----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    30/09/2013 
-- Design Name:    Basisklok
-- Module Name:    Klokdeler
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity Klokdeler is
	Port ( sysClk : in  STD_LOGIC;
               enable : in  STD_LOGIC;
               CT_500hz : out  STD_LOGIC := '0';
	       CT_100hz : out STD_LOGIC := '0';
	       CT_4hz : out STD_LOGIC := '0';
	       CT_2hz : out STD_LOGIC := '0';
	       CT_1hz : out STD_LOGIC := '0');
end Klokdeler;

architecture struct of Klokdeler is
	Component deler
	Generic ( max : positive);
	Port ( sysClk : in STD_LOGIC;
	       enable : in STD_LOGIC;
	       CT : out STD_LOGIC);
   End component;
	
	--Interne signalen
Signal CT_div50MHz_intern : STD_LOGIC := '0';
Signal CT_div500Hz_intern : STD_LOGIC := '0';
Signal CT_div100Hz_intern : STD_LOGIC := '0';
Signal CT_div4Hz_intern : STD_LOGIC := '0';
Signal CT_div2Hz_intern : STD_LOGIC := '0';
Signal CT_div1Hz_intern : STD_LOGIC := '0';

begin
	Inst_div50MHz : deler
		Generic map( max => 2)
		Port map( sysClk => sysClk,
			  enable => enable,
			  CT => CT_div50MHz_intern);
	 
	Inst_div500Hz : deler
		Generic map( max => 100000)
		Port map( sysClk => sysClk,
			  enable => CT_div50MHz_intern,
			  CT => CT_div500Hz_intern);
	 
	Inst_div100Hz : deler
		Generic map( max => 5)
		Port map( sysClk => sysClk,
			  enable => CT_div500Hz_intern,
			  CT => CT_div100Hz_intern);
	 
	Inst_div4Hz : deler
		Generic map( max => 25)
		Port map( sysClk => sysClk,
			  enable => CT_div100Hz_intern,
			  CT => CT_div4Hz_intern);
	 
	Inst_div2Hz : deler
		Generic map( max => 2)
		Port map( sysClk => sysClk,
			  enable => CT_div4Hz_intern,
			  CT => CT_div2Hz_intern);
	 
	Inst_div1Hz : deler
		Generic map( max => 2)
		Port map( sysClk => sysClk,
			  enable => CT_div2Hz_intern,
			  CT => CT_div1Hz_intern);

	CT_500hz <= CT_div500Hz_intern;
	CT_100hz <= CT_div100Hz_intern;
	CT_4hz <= CT_div4Hz_intern;
	CT_2hz <= CT_div2Hz_intern;
	CT_1hz <= CT_div1Hz_intern;

end struct;
