----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    18/10/2013 
-- Design Name:    Basisklok
-- Module Name:    Teller4x2DigitsCijfersTestbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Teller4x2DigitsCijfersTestbench is
end Teller4x2DigitsCijfersTestbench;

architecture struct of Teller4x2DigitsCijfersTestbench is
	Component Teller4x2DigitsCijfers
	Generic ( minDis0 : integer;
				 minDis1 : integer;
				 minDis2 : integer;
				 minDis3 : integer);
	Port( sysClk : in std_logic;
			updown : in std_logic;
			enable : in std_logic;
			reset : in std_logic;
			zet : in std_logic_vector(3 downto 0);
			zet0 : in std_logic_vector(3 downto 0);
			dis0Max : in std_logic_vector(7 downto 0);
			dis1Max : in std_logic_vector(7 downto 0);
			dis2Max : in std_logic_vector(7 downto 0);
			dis3Max : in std_logic_vector(7 downto 0);
			ct : out std_logic_vector(3 downto 0);
			dis0Out : out std_logic_vector(7 downto 0);
			dis1Out : out std_logic_vector(7 downto 0);
			dis2Out : out std_logic_vector(7 downto 0);
			dis3Out : out std_logic_vector(7 downto 0));
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal updown : std_logic := '0';
signal enable : std_logic := '0';
signal reset : std_logic := '0';
signal zet : std_logic_vector(3 downto 0) := "0000";
signal zet0 : std_logic_vector(3 downto 0) := "0000";
signal dis0Max : std_logic_vector(7 downto 0) := "10011001";
signal dis1Max : std_logic_vector(7 downto 0) := "10011001";
signal dis2Max : std_logic_vector(7 downto 0) := "10011001";
signal dis3Max : std_logic_vector(7 downto 0) := "10011001";
signal ct : std_logic_vector(3 downto 0) := "0000";
signal dis0Out : std_logic_vector(7 downto 0) := "00000000";
signal dis1Out : std_logic_vector(7 downto 0) := "00000000";
signal dis2Out : std_logic_vector(7 downto 0) := "00000000";
signal dis3Out : std_logic_vector(7 downto 0) := "00000000";

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_Teller4x2DigitsCijfers: Teller4x2DigitsCijfers generic map( minDis0 => 0,
																					  minDis1 => 0,
																					  minDis2 => 0,
																					  minDis3 => 0)
																	 port map( sysClk => sysClk,
																				  updown => updown,
																				  enable => enable,
																				  reset => reset,
																				  zet => zet,
																				  zet0 => zet0,
																				  dis0Max => dis0Max,
																				  dis1Max => dis1Max,
																				  dis2Max => dis2Max,
																				  dis3Max => dis3Max,
																				  ct => ct,
																				  dis0Out => dis0Out,
																				  dis1Out => dis1Out,
																				  dis2Out => dis2Out,
																				  dis3Out => dis3Out);

   --Klokpuls genereren
   sysClk_process : process
   begin
		sysClk <= '0';
		wait for sysClk_period/2;
		sysClk <= '1';
		wait for sysClk_period/2;
   end process;

	--Genereer stimulus (updown)
	updown_process : process
	begin
		updown <= '0';
		wait for sysClk_period*50;
		updown <= '1';
		wait for sysClk_period*30;
	end process;

   --Genereer stimulus (enable)
	enable_process : process
   begin
		enable <= '0';
		wait for sysClk_period*2;
		enable <= '1';
		wait for sysClk_period;
   end process;
	
	--Genereer stimulus (reset)
	reset_process : process
   begin
		reset <= '0';
		wait for sysClk_period*100;
		reset <= '1';
		wait for sysClk_period*2;
   end process;
	
	--Genereer stimulus (zet)
	zet_process : process
	begin
		zet <= "0000";
		wait for sysClk_period*6;
		zet <= "0001";
		wait for sysClk_period*4;
		zet <= "0010";
		wait for sysClk_period*4;
		zet <= "0100";
		wait for sysClk_period*4;
		zet <= "1000";
		wait for sysClk_period*4;
	end process;
	
	--Genereer stimulus (zet0)
	zet0_process : process
	begin
		zet0 <= "0000";
		wait for sysClk_period*35;
		zet0 <= "0001";
		wait for sysClk_period;
	end process;
	
	--Genereer stimulus (dis0Max)
	dis0Max_process : process
	begin
		dis0Max <= "01100000";																					--Max = 60
		wait for sysClk_period*40;
		dis0Max <= "00110000";																					--Max = 30
		wait for sysClk_period*40;
	end process;
	
	--Zet waarde (dis1max)
	dis1Max <= "00100101";																						--Max = 25
	
	--Zet waarde (dis2max)
	dis2Max <= "00010100";																						--Max = 14
	
	--Zet waarde (dis3max)
	dis3Max <= "00000101";																						--Max = 05
	
end struct;