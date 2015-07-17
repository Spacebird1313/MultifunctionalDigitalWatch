----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    03/11/2013 
-- Design Name:    Basisklok
-- Module Name:    DigitaalUurwerkTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
 
entity DigitaalUurwerkTestbench is
end DigitaalUurwerkTestbench;
 
architecture struct of DigitaalUurwerkTestbench is 
   Component DigitaalUurwerk
	Port( sysClk : in STD_LOGIC;
			drukToetsen : in STD_LOGIC_VECTOR(4 downto 0);																										--drukToetsen: (0) = werkingsmodus, (1) = instellingsmodus, (2) = verhogen, (3) = verlagen, (4) = functie afhankelijk van werkingsmodus
			schakelaar : in STD_LOGIC;																																	--schakelaar: reset
			leds : out STD_LOGIC_VECTOR(7 downto 0);
			displaySelect : out STD_LOGIC_VECTOR(3 downto 0);
			displayOut : out STD_LOGIC_VECTOR(7 downto 0));
   End component;			 			 
			 
--Interne signalen
signal sysClk : std_logic := '0';
signal drukToetsen : std_logic_vector(4 downto 0) := "00000";
signal schakelaar : std_logic := '0';
signal leds : std_logic_vector(7 downto 0) := "00000000";
signal displaySelect : std_logic_vector(3 downto 0) := "0000";
signal displayOut : std_logic_vector(7 downto 0) := "00000000";

--Klokperiode constante
constant sysClk_period : time := 2 ps;
 
begin
Inst_DigitaalUurwerk: DigitaalUurwerk port map( sysClk => sysClk,
																drukToetsen => drukToetsen,
																schakelaar => schakelaar,
																leds => leds,
																displaySelect => displaySelect,
																displayOut => displayOut);

	
	--Klokpuls genereren (sysClk)
   sysClk_process : process
   begin
		sysClk <= '0';
		wait for sysClk_period/2;
		sysClk <= '1';
		wait for sysClk_period/2;
   end process;
    
	--Voer reset uit (schakelaar)
	schakelaar_process : process
	begin
		schakelaar <= '0';
		--wait for sysClk_period*1000000;
		--schakelaar <= '1';
		--wait for sysClk_period;
		wait;
	end process;
	
	--Genereer stimulus (drukToetsen)
	drukToetsen_process : process
   begin
--		drukToetsen <= "00000";
--		wait for sysClk_period*40;
--		drukToetsen <= "00010";
--		wait for sysClk_period*5;
--		drukToetsen <= "00100";
--		wait for sysClk_period*40;
--		drukToetsen <= "00010";
--		wait for sysClk_period*5;
--		drukToetsen <= "00100";
--		wait for sysClk_period*40;
--		drukToetsen <= "00010";
--		wait for sysClk_period*5;
--		drukToetsen <= "00100";
--		wait for sysClk_period*5;
--		drukToetsen <= "00010";
--		wait for sysClk_period*5;
		drukToetsen <= "00010";
		wait for sysClk_period*100;
		drukToetsen <= "00100";
		wait;
   end process;

end struct;