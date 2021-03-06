----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    01/10/2013 
-- Design Name:    Basisklok
-- Module Name:    BCDUpDownTeller2Digits
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BCDUpDownTeller2Digits is
	Generic ( max : integer := 99;
		  min : integer := 0);
	Port ( sysClk : in STD_LOGIC;
	       updown : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       enable : in STD_LOGIC;
	       ct : out STD_LOGIC := '0';
	       cnt : out STD_LOGIC_VECTOR (7 downto 0) := "00000000");
end BCDUpDownTeller2Digits;

architecture Behavioral of BCDUpDownTeller2Digits is

constant eenheid_max : integer := max REM 10;
constant tiental_max : integer := max/10;
constant eenheid_min : integer := min REM 10;
constant tiental_min : integer := min/10;
Signal cnt_eenheid_int : integer range 0 to 9 := eenheid_min;
Signal cnt_tiental_int : integer range 0 to 9 := tiental_min;

begin
Teller : process(sysClk)
	begin
		if rising_edge(sysClk) then
			ct <= '0';
			if reset = '1' then                                                            			--Voer reset uit, zet alle waardes terug op minimaal
				cnt_eenheid_int <= eenheid_min;
				cnt_tiental_int <= tiental_min;
			elsif enable = '1' then
				if updown = '0' then                                                        		--Optellen
					if cnt_eenheid_int = eenheid_max and cnt_tiental_int = tiental_max then  	--Maximale waarde bereikt, zet waarde terug op minimaal
						cnt_eenheid_int <= eenheid_min;
						cnt_tiental_int <= tiental_min;
						ct <= '1';
					elsif cnt_eenheid_int = 9 then
						cnt_eenheid_int <= 0;
						cnt_tiental_int <= cnt_tiental_int + 1;
					else
						cnt_eenheid_int <= cnt_eenheid_int + 1;
					end if;
				else                                                                        		--Aftrekken
					if cnt_eenheid_int = eenheid_min and cnt_tiental_int = tiental_min then  	--Minimale waarde bereikt, zet waarde terug op maximaal
			         		cnt_eenheid_int <= eenheid_max;
			  	      		cnt_tiental_int <= tiental_max;
					   	ct <= '1';
				   	elsif cnt_eenheid_int = 0 then
				 	   	cnt_eenheid_int <= 9;
					   	cnt_tiental_int <= cnt_tiental_int - 1;
				   	else
					   	cnt_eenheid_int <= cnt_eenheid_int - 1;
				   	end if;
				end if;
		   	end if;
		end if;
	end process;
	
cnt(3 downto 0) <= std_logic_vector(to_unsigned(cnt_eenheid_int, 4));
cnt(7 downto 4) <= std_logic_vector(to_unsigned(cnt_tiental_int, 4));
	
end Behavioral;
