----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    14/10/2013 
-- Design Name:    Basisklok
-- Module Name:    Teller4x2DigitsCijfers
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Teller4x2DigitsCijfers is
	Generic ( minDis0 : integer := 0;
				 minDis1 : integer := 0;
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
			 ct : out STD_LOGIC_VECTOR(3 downto 0) := "0000";
			 dis0Out : out STD_LOGIC_VECTOR(7 downto 0) := "00000000";
			 dis1Out : out STD_LOGIC_VECTOR(7 downto 0) := "00000000";
			 dis2Out : out STD_LOGIC_VECTOR(7 downto 0) := "00000000";
			 dis3Out : out STD_LOGIC_VECTOR(7 downto 0) := "00000000");
end Teller4x2DigitsCijfers;

architecture struct of Teller4x2DigitsCijfers is
	component BCDUpDownTeller2DigitsVariableMax
	Generic ( min : integer);
	Port ( sysClk : in STD_LOGIC;
			 updown : in STD_LOGIC;
	       reset : in STD_LOGIC;
			 enable : in STD_LOGIC;
			 max : in STD_LOGIC_VECTOR (7 downto 0);
			 ct : out STD_LOGIC := '0';
			 cnt : out STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	component Teller4x2DigitsCijfersSturingV2
	Port ( sysClk : in STD_LOGIC;
			 enable : in STD_LOGIC;
			 reset : in STD_LOGIC;
			 updownIn : in STD_LOGIC;
			 disZet : in STD_LOGIC_VECTOR(3 downto 0);
			 disCt : in STD_LOGIC_VECTOR(2 downto 0);
			 updownUit : out STD_LOGIC;
			 disEnable : out STD_LOGIC_VECTOR(3 downto 0));
	end component;

	--interne signalen
Signal updown_intern : STD_LOGIC := '0';
Signal reset_intern : STD_LOGIC_VECTOR(3 downto 0) := "0000";
Signal enable_intern : STD_LOGIC_VECTOR(3 downto 0) := "0000";
Signal ct_intern : STD_LOGIC_VECTOR(3 downto 0) := "0000";
Signal ctBuf_intern : STD_LOGIC_VECTOR(3 downto 0) := "0000";
Signal zetBuf1_intern : STD_LOGIC_VECTOR(3 downto 0) := "0000";
Signal zetBuf2_intern : STD_LOGIC_VECTOR(3 downto 0) := "0000";

begin
	Inst_Teller4x2DigitsCijfersSturingV2 : Teller4x2DigitsCijfersSturingV2
		Port map( sysClk => sysClk,
					 enable => enable,
					 reset => reset,
					 updownIn => updown,
					 disZet => zet,
					 disCt => ctBuf_intern(2 downto 0),
					 updownUit => updown_intern,
					 disEnable => enable_intern);

	Inst_Dis0 : BCDUpDownTeller2DigitsVariableMax
		Generic map( min => minDis0)
		Port map( sysClk => sysClk,
				    updown => updown_intern,
	             reset => reset_intern(0),
			       enable => enable_intern(0),
					 max => dis0Max,
			       ct => ct_intern(0),
			       cnt => dis0Out);
	
	Inst_Dis1 : BCDUpDownTeller2DigitsVariableMax
		Generic map( min => minDis1)
		Port map( sysClk => sysClk,
				    updown => updown_intern,
	             reset => reset_intern(1),
			       enable => enable_intern(1),
					 max => dis1Max,
			       ct => ct_intern(1),
			       cnt => dis1Out);
	
	Inst_Dis2 : BCDUpDownTeller2DigitsVariableMax
		Generic map( min => minDis2)
		Port map( sysClk => sysClk,
				    updown => updown_intern,
	             reset => reset_intern(2),
			       enable => enable_intern(2),
					 max => dis2Max,
			       ct => ct_intern(2),
			       cnt => dis2Out);
	
	Inst_Dis3 : BCDUpDownTeller2DigitsVariableMax
		Generic map( min => minDis3)
		Port map( sysClk => sysClk,
				    updown => updown_intern,
	             reset => reset_intern(3),
			       enable => enable_intern(3),
					 max => dis3Max,
			       ct => ct_intern(3),
			       cnt => dis3Out);
	
	zetBuffer : process(sysClk)
	begin
		if rising_edge(sysClk) then
			if reset = '1' then
				zetBuf1_intern <= "0000";
				zetBuf2_intern <= "0000";
			else
				zetBuf1_intern <= zet;
				zetBuf2_intern <= zetBuf1_intern;
			end if;
		end if;
	end process;
	
	ctBuffer : process(sysClk)
		begin
			if rising_edge(sysClk) then
				if reset = '1' then
					ctBuf_intern <= "0000";
				else
					if zetBuf2_intern(0) = '0' then
						ctBuf_intern(0) <= ct_intern(0);
					else
						ctBuf_intern(0) <= '0';
					end if;
					if zetBuf2_intern(1) = '0' then
						ctBuf_intern(1) <= ct_intern(1);
					else
						ctBuf_intern(1) <= '0';
					end if;
					if zetBuf2_intern(2) = '0' then
						ctBuf_intern(2) <= ct_intern(2);
					else
						ctBuf_intern(2) <= '0';
					end if;
					if zetBuf2_intern(3) = '0' then
						ctBuf_intern(3) <= ct_intern(3);
					else
						ctBuf_intern(3) <= '0';
					end if;
				end if;
			end if;
		end process;	

reset_intern(0) <= zet0(0) or reset;
reset_intern(1) <= zet0(1) or reset;
reset_intern(2) <= zet0(2) or reset;
reset_intern(3) <= zet0(3) or reset;
ct <= ctBuf_intern;

end struct;

