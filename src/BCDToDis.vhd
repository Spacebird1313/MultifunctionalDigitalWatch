----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    01/11/2013 
-- Design Name:    Basisklok
-- Module Name:    BCDToDis
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BCDToDis is
	Port ( BCDTellerToDis0_1 : in STD_LOGIC_VECTOR(3 downto 0);
	       BCDTellerToDis2_3 : in STD_LOGIC_VECTOR(3 downto 0);
	       BCDTeller0 : in STD_LOGIC_VECTOR(7 downto 0);	
	       BCDTeller1 : in STD_LOGIC_VECTOR(7 downto 0);
	       BCDTeller2 : in STD_LOGIC_VECTOR(7 downto 0);
	       BCDTeller3 : in STD_LOGIC_VECTOR(7 downto 0);
	       disPunt : in STD_LOGIC_VECTOR(3 downto 0);					--Laag actief															
	       dis0 : out STD_LOGIC_VECTOR(4 downto 0) := "10000";
	       dis1 : out STD_LOGIC_VECTOR(4 downto 0) := "10000";
	       dis2 : out STD_LOGIC_VECTOR(4 downto 0) := "10000";
	       dis3 : out STD_LOGIC_VECTOR(4 downto 0) := "10000");
end BCDToDis;

architecture struct of BCDToDis is

begin
BCDToDis0_1 : process(BCDTellerToDis0_1, BCDTeller0, BCDTeller1, BCDTeller2, BCDTeller3)
	begin
		case BCDTellerToDis0_1 is
			when "0001" =>
				dis0(3 downto 0) <= BCDTeller0(3 downto 0);
				dis1(3 downto 0) <= BCDTeller0(7 downto 4);
			when "0010" =>
				dis0(3 downto 0) <= BCDTeller1(3 downto 0);
				dis1(3 downto 0) <= BCDTeller1(7 downto 4);
			when "0100" =>
				dis0(3 downto 0) <= BCDTeller2(3 downto 0);
				dis1(3 downto 0) <= BCDTeller2(7 downto 4);
			when "1000" =>
				dis0(3 downto 0) <= BCDTeller3(3 downto 0);
				dis1(3 downto 0) <= BCDTeller3(7 downto 4);
			when others =>								--Ongeldige toestand
				dis0(3 downto 0) <= "1111";
				dis1(3 downto 0) <= "1111";
		end case;
	end process;
	
BCDToDis2_3 : process(BCDTellerToDis2_3, BCDTeller0, BCDTeller1, BCDTeller2, BCDTeller3)
	begin
		case BCDTellerToDis2_3 is
			when "0001" =>
				dis2(3 downto 0) <= BCDTeller0(3 downto 0);
				dis3(3 downto 0) <= BCDTeller0(7 downto 4);
			when "0010" =>
				dis2(3 downto 0) <= BCDTeller1(3 downto 0);
				dis3(3 downto 0) <= BCDTeller1(7 downto 4);
			when "0100" =>
				dis2(3 downto 0) <= BCDTeller2(3 downto 0);
				dis3(3 downto 0) <= BCDTeller2(7 downto 4);
			when "1000" =>
				dis2(3 downto 0) <= BCDTeller3(3 downto 0);
				dis3(3 downto 0) <= BCDTeller3(7 downto 4);
			when others =>								--Ongeldige toestand
				dis2(3 downto 0) <= "1111";
				dis3(3 downto 0) <= "1111";
		end case;
	end process;

dis0(4) <= disPunt(0);
dis1(4) <= disPunt(1);
dis2(4) <= disPunt(2);
dis3(4) <= disPunt(3);

end struct;
