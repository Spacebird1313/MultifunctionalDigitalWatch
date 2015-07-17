----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    24/12/2013 
-- Design Name:    Basisklok
-- Module Name:    BCD7SegmentDecoderZelftestendeTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BCD7SegmentDecoderZelftestendeTestbench is
end BCD7SegmentDecoderZelftestendeTestbench;

architecture struct of BCD7SegmentDecoderZelftestendeTestbench is
	Component BCD7SegmentDecoder
	Port( BCD : in std_logic_vector(3 downto 0);
			reset : in std_logic;
			Seg7 : out std_logic_vector(6 downto 0));
   End component;
    
--Interne signalen
signal BCD : std_logic_vector(3 downto 0) := "0000";
signal Reset : std_logic := '0';
signal Seg7 : std_logic_vector(6 downto 0) := "0000000";
signal testUitkomst : std_logic_vector(6 downto 0) := "0000000";

--Klokperiode constante
constant clk_period : time := 10 ns;

--Controlevector declaratie
type testVector is record
	input : std_logic_vector(3 downto 0);
	output : std_logic_vector(6 downto 0);
end record;
type controleVectorTabel is array (natural range <>) of testVector;

--Controlevector definiëren
constant controleVector : controleVectorTabel := (("0000", "1000000"),			-- 0
																  ("0001", "1111001"),			-- 1
																  ("0010", "0100100"),			-- 2
																  ("0011", "0110000"),			-- 3
																  ("0100", "0011001"),			-- 4
																  ("0101", "0010010"),			-- 5
																  ("0110", "0000010"),			-- 6
																  ("0111", "1011000"),			-- 7
																  ("1000", "0000000"),			-- 8
																  ("1001", "0010000"),			-- 9
																  ("1111", "1111111"));			-- uit
begin
Inst_BCD7SegmentDecoder: BCD7SegmentDecoder port map( BCD => BCD,
																		reset => reset,
																		Seg7 => Seg7);

	--Zelftestende testbench
	ModeSelector5Toestanden_Test_process : process
	variable i : integer;
	begin
		report "Simulatie: BCD7SegmentDecoder";
		i := 0;
		BCD <= "0000";
		reset <= '0';
		wait for 20 ns;
		
		report "Start: waardes 0 tot 9 binaire invoeren.";
		while i < controleVector'length - 1 loop
			BCD <= controleVector(i).input;
			testUitkomst <= controleVector(i).output;
			
			wait for 20 ns;
			
			assert(testUitkomst = Seg7) report "De waarde van Seg7 is niet correct voor de waarde: " & integer'image(i) & " !" severity error;

			i := i + 1;
		end loop;
		
		report "Test uitgang voor ongeldige inputwaarde.";
		BCD <= controleVector(controleVector'length - 1).input;
		testUitkomst <= controleVector(controleVector'length - 1).output;
		
		wait for 20 ns;
		
		assert(testUitkomst = Seg7) report "De waarde van Seg7 is niet correct voor ongeldige ingangswaardes!" severity error;
		
		report "Simulatie geëindigd";
		wait;
	end process;
	
end struct;