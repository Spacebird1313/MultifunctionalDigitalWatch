----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    12/10/2013 
-- Design Name:    Basisklok
-- Module Name:    WerkingsmodeSelector
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DigitaalUurwerkHoofdsturing is
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       drukToetsen : in STD_LOGIC_VECTOR(4 downto 0);								--drukToetsen: (0) = werkingsmodus, (1) = instellingsmodus, (2) = verhogen, (3) = verlagen, (4) = functie afhankelijk van werkingsmodus
	       drukToetsActief : out STD_LOGIC := '0';									--alarmsignaal uitschakelen
	       huidigWerkingsmode : out STD_LOGIC_VECTOR(4 downto 0) := "00001";
	       huidigInstelmode : out STD_LOGIC_VECTOR(4 downto 0) := "00001";
	       pulsOutM0 : out STD_LOGIC_VECTOR(2 downto 0) := "000";							--Module 0: Uurwerk		
	       pulsOutM1 : out STD_LOGIC_VECTOR(2 downto 0) := "000";							--Module 1: Datum
	       pulsOutM2 : out STD_LOGIC_VECTOR(2 downto 0) := "000";							--Module 2: Alarm
	       pulsOutM3 : out STD_LOGIC_VECTOR(2 downto 0) := "000";							--Module 3: Timer
	       pulsOutM4 : out STD_LOGIC_VECTOR(2 downto 0) := "000");							--Module 4: Chronometer
end DigitaalUurwerkHoofdsturing;

architecture struct of DigitaalUurwerkHoofdsturing is
	component ModeSelector5Toestanden
	Port ( sysClk : in STD_LOGIC;
	       nextMode : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       currentMode : out STD_LOGIC_VECTOR(4 downto 0));
	end component;
	 
	component InstelmodusSturing
	Port ( sysClk : in STD_LOGIC;
	       reset : in STD_LOGIC;
	       nextModeIn : in STD_LOGIC;
	       huidigWerkingsmodus : in STD_LOGIC_VECTOR(4 downto 0);
	       huidigInstelmodus : in STD_LOGIC_VECTOR(4 downto 0);
	       nextModeOut : out STD_LOGIC;
	       instelmodeReset : out STD_LOGIC);
	 end component;
	 
	 component PulsToSelectedModule
	 Port ( sysClk : in STD_LOGIC;
	        reset : in STD_LOGIC;
	        selectedModus : in STD_LOGIC_VECTOR(4 downto 0);
	        pulsIn : in STD_LOGIC_VECTOR(2 downto 0);
		pulsOutM0 : out STD_LOGIC_VECTOR(2 downto 0);											
		pulsOutM1 : out STD_LOGIC_VECTOR(2 downto 0);
		pulsOutM2 : out STD_LOGIC_VECTOR(2 downto 0);
		pulsOutM3 : out STD_LOGIC_VECTOR(2 downto 0);
		pulsOutM4 : out STD_LOGIC_VECTOR(2 downto 0));
	 end component;
	 
	 component Pulsmodule
	 Port ( sysClk : in STD_LOGIC;
		reset : in STD_LOGIC;
		signalIn : in STD_LOGIC;
		pulsOut : out STD_LOGIC);
	 end component;

	--Interne signalen
Signal huidigWerkingsmodus_intern : STD_LOGIC_VECTOR(4 downto 0) := "00001";
Signal huidigInstelmodus_intern : STD_LOGIC_VECTOR(4 downto 0) := "00001";
Signal instelmodeReset_intern : STD_LOGIC := '0';
Signal instelmodeSelectorReset_intern : STD_LOGIC := '0';
Signal instelmodeSelectorNextMode_intern : STD_LOGIC := '0';
Signal nextWerkingsmode_intern : STD_LOGIC := '0';
Signal nextInstelmode_intern : STD_LOGIC := '0';
Signal upToets_intern : STD_LOGIC := '0';
Signal downToets_intern : STD_LOGIC := '0';

begin
	Inst_WerkingsmodeSelector : ModeSelector5Toestanden Port map ( sysClk => sysClk,
								       nextMode => nextWerkingsmode_intern,
								       reset => reset,
								       currentMode => huidigWerkingsmodus_intern);
	
	Inst_PulsmoduleNextWerkingsmode : Pulsmodule Port map( sysClk => sysClk,
							       reset => reset,
							       signalIn => drukToetsen(0),
							       pulsOut => nextWerkingsmode_intern);
	
	Inst_InstelmodeSelector : ModeSelector5Toestanden Port map ( sysClk => sysClk,
								     nextMode => instelmodeSelectorNextMode_intern,
								     reset => instelmodeSelectorReset_intern,
								     currentMode => huidigInstelmodus_intern);
	
	Inst_InstelmodusSturing : InstelmodusSturing Port map ( sysClk => sysClk,
								reset => reset,
								nextModeIn => nextInstelmode_intern,
								huidigWerkingsmodus => huidigWerkingsmodus_intern,
								huidigInstelmodus => huidigInstelmodus_intern,
								nextModeOut => instelmodeSelectorNextMode_intern,
								instelmodeReset => instelmodeReset_intern);
	
	Inst_PulsmoduleNextInstelmode : Pulsmodule Port map( sysClk => sysClk,
							     reset => reset,
							     signalIn => drukToetsen(1),
							     pulsOut => nextInstelmode_intern);
	
	Inst_PulsToSelectedModule : PulsToSelectedModule Port map ( sysClk => sysClk,
								    reset => reset,
								    selectedModus => huidigWerkingsmodus_intern,
								    pulsIn => drukToetsen(4 downto 2),
								    pulsOutM0 => pulsOutM0,
								    pulsOutM1 => pulsOutM1,
								    pulsOutM2 => pulsOutM2,
								    pulsOutM3 => pulsOutM3,
								    pulsOutM4 => pulsOutM4);
	
	Inst_PulsmoduleUpToets : Pulsmodule Port map( sysClk => sysClk,
						      reset => reset,
						      signalIn => drukToetsen(2),
						      pulsOut => upToets_intern);
	
	Inst_PulsmoduleDownToets : Pulsmodule Port map( sysClk => sysClk,
							reset => reset,
							signalIn => drukToetsen(3),
							pulsOut => downToets_intern);

huidigWerkingsmode <= huidigWerkingsmodus_intern;
huidigInstelmode <= huidigInstelmodus_intern;
instelmodeSelectorReset_intern <= reset or instelmodeReset_intern;
drukToetsActief <= nextWerkingsmode_intern or nextInstelmode_intern or upToets_intern or downToets_intern;

end struct;
