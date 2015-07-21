----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    17/11/2013 
-- Design Name:    Basisklok
-- Module Name:    Datum
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Datum is
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       oD : in STD_LOGIC;
	       clk2Hz : in STD_LOGIC;								--Vertraging voor snel zetten (delay = 1Hz)
	       clk4Hz : in STD_LOGIC;
	       up : in STD_LOGIC;
	       down : in STD_LOGIC;
	       zet : in STD_LOGIC_VECTOR(2 downto 0);						--zet: (0) = instellen Dag, (1) = instellen Maand, (2) = instellen Jaar														
	       DD : out STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	       MM : out STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	       JJ : out STD_LOGIC_VECTOR(7 downto 0) := "00000000");
end Datum;

architecture struct of Datum is
	component Teller4x2DigitsCijfers
	Generic ( minDis0 : integer := 1;
		  minDis1 : integer := 1;
		  minDis2 : integer := 0;
		  minDis3 : integer := 0);
	Port ( sysClk : in STD_LOGIC;
	       updown : in STD_LOGIC;
	       enable : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       zet : in STD_LOGIC_VECTOR(3 downto 0);
	       zet0 : in STD_LOGIC_VECTOR(3 downto 0);
	       dis0Max : in STD_LOGIC_VECTOR(7 downto 0);
	       dis1Max : in STD_LOGIC_VECTOR(7 downto 0);
	       dis2Max : in STD_LOGIC_VECTOR(7 downto 0);
	       dis3Max : in STD_LOGIC_VECTOR(7 downto 0);
	       ct : out STD_LOGIC_VECTOR(3 downto 0);
	       dis0Out : out STD_LOGIC_VECTOR(7 downto 0);
	       dis1Out : out STD_LOGIC_VECTOR(7 downto 0);
	       dis2Out : out STD_LOGIC_VECTOR(7 downto 0);
	       dis3Out : out STD_LOGIC_VECTOR(7 downto 0));
	end component;
	
	component DatumSturing
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       enableIn : in STD_LOGIC;
	       clkZet : in STD_LOGIC;
	       clkDelay : in STD_LOGIC;								--Vertraging voor snel zetten (delay = 2x clkDelay)
	       zetIn : in STD_LOGIC_VECTOR(2 downto 0);						--zet: (0) = zet Dag, (1) = zet Maand, (2) = zet Jaar														
	       up : in STD_LOGIC;
	       down : in STD_LOGIC;
	       MM : in STD_LOGIC_VECTOR(7 downto 0);
	       JJ : in STD_LOGIC_VECTOR(7 downto 0);
	       enableUit : out STD_LOGIC;
	       updown : out STD_LOGIC;
	       zetUit : out STD_LOGIC_VECTOR(3 downto 0);
	       DDMax : out STD_LOGIC_VECTOR(7 downto 0));
	end component;

	--Interne signalen
Signal enable_intern : STD_LOGIC := '0';
Signal updown_intern : STD_LOGIC := '0';
Signal ct_intern : STD_LOGIC_VECTOR(3 downto 0) := "0000";
Signal zet_intern : STD_LOGIC_VECTOR(3 downto 0) := "0000";
Signal zet0_intern : STD_LOGIC_VECTOR(3 downto 0) := "0000";
Signal dis0Max_intern : STD_LOGIC_VECTOR(7 downto 0) := "00110001";				--dis0Max = 31 (Dag: variabel 28-29-30-31)
Signal dis1Max_intern : STD_LOGIC_VECTOR(7 downto 0) := "00010010";				--dis1Max = 12	(Maand)
Signal dis2Max_intern : STD_LOGIC_VECTOR(7 downto 0) := "10011001";				--dis2Max = 99 (Jaar)
Signal dis3Max_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000001";				--dis3Max (ongebruikte teller)
Signal dis0Out_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
Signal dis1Out_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
Signal dis2Out_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
Signal dis3Out_intern : STD_LOGIC_VECTOR(7 downto 0) := "00000000";			

begin
	Inst_Teller4x2DigitsCijfers : Teller4x2DigitsCijfers
		Generic map( minDis0 => 1,
			     minDis1 => 1,
			     minDis2 => 0,
			     minDis3 => 0)
		Port map( sysClk => sysClk,
			  updown => updown_intern,
			  enable => enable_intern,
	             	  reset => reset,
			  zet => zet_intern,
			  zet0 => zet0_intern,
			  dis0Max => dis0Max_intern,
			  dis1Max => dis1Max_intern,
			  dis2Max => dis2Max_intern,
			  dis3Max => dis3Max_intern,						--Dis3 niet gebruikt
			  ct => ct_intern,
			  dis0Out => dis0Out_intern,
			  dis1Out => dis1Out_intern,
			  dis2Out => dis2Out_intern,
			  dis3Out => dis3Out_intern);						--Dis3 niet gebruikt
 
	Inst_DatumSturing : DatumSturing
		Port map( sysClk => sysClk,
			  reset => reset,
			  enableIn => oD,
			  clkZet => clk4Hz,
			  clkDelay => clk2Hz,
			  zetIn => zet,
			  up => up,
			  down => down,
			  MM => dis1Out_intern,
			  JJ => dis2Out_intern,
			  enableUit => enable_intern,
			  updown => updown_intern,
			  zetUit => zet_intern,
			  DDMax => dis0Max_intern);

DD <= dis0Out_intern;
MM <= dis1Out_intern;
JJ <= dis2Out_intern;

dis1Max_intern <= "00010010";									--dis1Max = 12	(Maand)
dis2Max_intern <= "10011001";									--dis2Max = 99 (Jaar)
dis3Max_intern <= "00000001";									--dis3Max (ongebruikte teller)
zet0_intern <= "0000";										--Tellers niet individueel resetten

end struct;
