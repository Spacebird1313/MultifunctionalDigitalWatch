----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    16/11/2013 
-- Design Name:    Basisklok
-- Module Name:    DatumController
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DatumController is
	Port ( MM : in STD_LOGIC_VECTOR(7 downto 0);
			 JJ : in STD_LOGIC_VECTOR(7 downto 0);
			 DDMax : out STD_LOGIC_VECTOR(7 downto 0) := "00110001");
end DatumController;

architecture struct of DatumController is

Signal jaar : integer range 0 to 99 := 0;

begin

jaar <= to_integer(unsigned(JJ(7 downto 4)))*10 + to_integer(unsigned(JJ(3 downto 0)));

DatumControl : process(MM, jaar)
	begin
		case MM is
			when "00000001" => DDMax <= "00110001";																			--januari: 31
			when "00000010" =>																										--februari:
				case jaar is
					when 04|08|12|16|20|24|28|32|36|40|44|48|52|56|60|64|68|72|76|80|84|88|92|96 =>
					DDMax <= "00101001";																								--schikkeljaar: 29
					when others => DDMax <= "00101000";																			--normaal jaar: 28
				end case;
			when "00000011" => DDMax <= "00110001";																			--maart: 31
			when "00000100" => DDMax <= "00110000";																			--april: 30
			when "00000101" => DDMax <= "00110001";																			--mei: 31
			when "00000110" => DDMax <= "00110000";																			--juni: 30
			when "00000111" => DDMax <= "00110001";																			--juli: 31
			when "00001000" => DDMax <= "00110001";																			--augustus: 31
			when "00001001" => DDMax <= "00110000";																			--september: 30
			when "00010000" => DDMax <= "00110001";																			--oktober: 31
			when "00010001" => DDMax <= "00110000";																			--november: 30
			when "00010010" => DDMax <= "00110001";																			--december: 31
			when others => DDMax <= "00110001";																					--ongeldige toestand
		end case;
	end process;

end struct;
