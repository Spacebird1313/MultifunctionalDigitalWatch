----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    01/10/2013 
-- Design Name:    Basisklok
-- Module Name:    BCDUpDownTeller2DigitsV2
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BCDUpDownTeller2DigitsV2 is
	Generic ( max : integer := 99;
				 min : integer := 0);
	Port ( sysClk : in STD_LOGIC;
			 updown : in STD_LOGIC;
	       reset : in STD_LOGIC;
			 enable : in STD_LOGIC;
			 ct : out STD_LOGIC := '0';
			 cnt : out STD_LOGIC_VECTOR (7 downto 0) := "00000000");
end BCDUpDownTeller2DigitsV2;

architecture Behavioral of BCDUpDownTeller2DigitsV2 is

Signal cnt_int : integer range min to max := min;

begin
Teller : process(sysClk)
	begin
		if rising_edge(sysClk) then
			ct <= '0';
			if reset = '1' then
				cnt_int <= min;
			elsif enable = '1' then
				if updown = '0' then      --Optellen
					if cnt_int = max then  --Maximale waarde bereikt, zet waarde terug op minimaal
						cnt_int <= min;
						ct <= '1';
					else
						cnt_int <= cnt_int + 1;
					end if;
				else                      --Aftrekken
					if cnt_int = min then  --Minimale waarde bereikt, zet waarde terug op maximaal
			         cnt_int <= max;
					   ct <= '1';
				   else
					   cnt_int <= cnt_int - 1;
				      end if;
			   end if;
		   end if;
		end if;
	end process;
	
cnt(3 downto 0) <= std_logic_vector(to_unsigned(cnt_int REM 10, 4));
cnt(7 downto 4) <= std_logic_vector(to_unsigned(cnt_int/10, 4));
			
end Behavioral;