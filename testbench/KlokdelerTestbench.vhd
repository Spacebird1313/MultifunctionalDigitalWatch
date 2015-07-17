----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    30/09/2013 
-- Design Name:    Basisklok
-- Module Name:    KlokdelerTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity KlokdelerTestbench is
end KlokdelerTestbench;
 
architecture struct of KlokdelerTestbench is 
   Component Klokdeler
   Port( sysClk : in  std_logic;
         enable : in  std_logic;
         CT_500hz : out  std_logic;
			CT_100hz : out std_logic;
         CT_4hz : out  std_logic;
			CT_2hz : out std_logic;
         CT_1hz : out  std_logic);
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal enable : std_logic := '0';
signal CT_500hz : std_logic := '0';
signal CT_100hz : std_logic := '0';
signal CT_4hz : std_logic := '0';
signal CT_2hz : std_logic := '0';
signal CT_1hz : std_logic := '0';

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_klokdeler: Klokdeler port map( sysClk => sysClk,
												enable => enable,
												CT_500hz => CT_500hz,
												CT_100hz => CT_100hz,
												CT_4hz => CT_4hz,
												CT_2hz => CT_2hz,
												CT_1hz => CT_1hz);

   -- Klokpuls genereren
   sysClk_process : process
   begin
		sysClk <= '0';
		wait for sysClk_period/2;
		sysClk <= '1';
		wait for sysClk_period/2;
   end process;
 
   -- Zet enable op high	
    enable <= '1';

end struct;