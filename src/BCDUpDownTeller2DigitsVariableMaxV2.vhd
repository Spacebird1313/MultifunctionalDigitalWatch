----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    05/10/2013 
-- Design Name:    Basisklok
-- Module Name:    BCDUpDownTeller2DigitsVariableMaxV2
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BCDUpDownTeller2DigitsVariableMaxV2 is
	Generic ( min : integer := 0);
	Port ( sysClk : in STD_LOGIC;
	       updown : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       enable : in STD_LOGIC;
	       max : in STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	       ct : out STD_LOGIC := '0';
	       cnt : out STD_LOGIC_VECTOR (7 downto 0) := "00000000");
end BCDUpDownTeller2DigitsVariableMaxV2;

architecture Behavioral of BCDUpDownTeller2DigitsVariableMaxV2 is

Signal cnt_int : integer range min to 99 := min;
Signal max_int : integer range min to 99 := min;																												 --Wacht op input (max) voor instellen van max

begin

max_int <= (to_integer(unsigned(max(7 downto 4))))*10 + (to_integer(unsigned(max(3 downto 0))));  												 --Stel maximum in (conversie STD_LOGIC_VECTOR(BCD) naar integer)

Teller : process(sysClk)
	begin
		if rising_edge(sysClk) then
			ct <= '0';
			if reset = '1' then
				cnt_int <= min;
			elsif cnt_int > max_int then
				cnt_int <= max_int;
			elsif enable = '1' then
				if updown = '0' then          																														 --Optellen
					if cnt_int >= max_int then  																														 --Maximale waarde bereikt, zet waarde terug op minimaal
						cnt_int <= min;
						ct <= '1';
					else
						cnt_int <= cnt_int + 1;
					end if;
				else                         																															 --Aftrekken
					if cnt_int = min then     																															 --Minimale waarde bereikt, zet waarde terug op maximaal
			         		cnt_int <= max_int;
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
