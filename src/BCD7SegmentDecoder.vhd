----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    26/04/2013 
-- Design Name:    Basisklok
-- Module Name:    BCD7SegmentDecoder
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

entity BCD7SegmentDecoder is
	Port( BCD : in STD_LOGIC_VECTOR(3 downto 0);
				reset : in STD_LOGIC;
				Seg7 : out STD_LOGIC_VECTOR(6 downto 0));
end BCD7SegmentDecoder;

architecture Behavioral of BCD7SegmentDecoder is

begin
--DECODING: zet BCD-input om in 7 segment notatie
	dec : process(BCD, Reset)
	begin
		if reset = '1' then
			Seg7 <= "1111111";
		else
			case BCD is             -- actief-0		-- Decimaal   -- HEX
			
				when "0000" => Seg7 <= "1000000";   -- 0          -- 40
				when "0001" => Seg7 <= "1111001";   -- 1          -- 79
				when "0010" => Seg7 <= "0100100";   -- 2          -- 24
				when "0011" => Seg7 <= "0110000";   -- 3          -- 30
				when "0100" => Seg7 <= "0011001";   -- 4          -- 19
				when "0101" => Seg7 <= "0010010";   -- 5          -- 12
				when "0110" => Seg7 <= "0000010";		-- 6          -- 02
				when "0111" => Seg7 <= "1011000";   -- 7          -- 58
				when "1000" => Seg7 <= "0000000";   -- 8          -- 00
				when "1001" => Seg7 <= "0010000";   -- 9          -- 10
				when others => Seg7 <= "1111111";   -- uit				-- 7f
			
			end case;
		end if;
	end process;
end Behavioral;
