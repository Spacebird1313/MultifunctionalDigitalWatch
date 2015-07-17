----------------------------------------------------------------------------------
-- Company: Universiteit Antwerpen
-- Engineer: Thomas Huybrechts
-- 
-- Create Date:    19/10/2013 
-- Design Name:    Basisklok
-- Module Name:    Teller4x2DigitsCijfersSturingV2Testbench
-- Project Name:   DigitaalUurwerk
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Teller4x2DigitsCijfersSturingV2Testbench is
end Teller4x2DigitsCijfersSturingV2Testbench;

architecture struct of Teller4x2DigitsCijfersSturingV2Testbench is
	Component Teller4x2DigitsCijfersSturingV2
	Port( sysClk : in std_logic;
			enable : in std_logic;
			reset : in std_logic;
			updownIn : in std_logic;
			disZet : in std_logic_vector(3 downto 0);
			disCt : in std_logic_vector(2 downto 0);
			updownUit : out std_logic;
			disEnable : out std_logic_vector(3 downto 0));
   End component;
    
--Interne signalen
signal sysClk : std_logic := '0';
signal enable : std_logic := '0';
signal reset : std_logic := '0';
signal updownIn : std_logic := '0';
signal disZet : std_logic_vector(3 downto 0) := "0000";
signal disCt : std_logic_vector(2 downto 0) := "000";
signal updownUit : std_logic := '0';
signal disEnable : std_logic_vector(3 downto 0) := "0000";

--Klokperiode constante
constant sysClk_period : time := 10 ns;
 
begin
Inst_Teller4x2DigitsCijfersSturingV2: Teller4x2DigitsCijfersSturingV2 port map( sysClk => sysClk,
																										  enable => enable,
																										  reset => reset,
																										  updownIn => updownIn,
																										  disZet => disZet,
																										  disCt => disCt,
																										  updownUit => updownUit,
																										  disEnable => disEnable);

   --Klokpuls genereren
   sysClk_process : process
   begin
		sysClk <= '0';
		wait for sysClk_period/2;
		sysClk <= '1';
		wait for sysClk_period/2;
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
		wait for sysClk_period*50;
		reset <= '1';
		wait for sysClk_period*2;
   end process;
	
	--Genereer stimulus (updownIn)
	updownIn_process : process
   begin
		updownIn <= '0';
		wait for sysClk_period*2;
		updownIn <= '1';
		wait for sysClk_period;
		updownIn <= '0';
		wait for sysClk_period*3;
   end process;
	
	--Genereer stimulus (disZet)
	disZet_process : process
	begin
		disZet <= "0000";
		wait for sysClk_period*2;
		disZet <= "0001";
		wait for sysClk_period;
		disZet <= "0000";
		wait for sysClk_period*2;
		disZet <= "0010";
		wait for sysClk_period;
		disZet <= "0000";
		wait for sysClk_period*2;
		disZet <= "0100";
		wait for sysClk_period;
		disZet <= "0000";
		wait for sysClk_period*2;
		disZet <= "1000";
		wait for sysClk_period;
		disZet <= "0000";
		wait for sysClk_period*2;
	end process;
	
	--Genereer stimulus (disCt)
	disCt_process : process
	begin
		disCt <= "000";
		wait for sysClk_period*4;
		disCt <= "111";
		wait for sysClk_period;
	end process;
	
end struct;