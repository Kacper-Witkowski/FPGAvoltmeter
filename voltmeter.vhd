----------------------------------------------------------------------------------
-- Company: PWr
-- Engineer: Kacper Witkowski
-- 
-- Module Name:  	 	FPGA voltmeter - top level entity
-- Project Name: 		FPGA voltmeter
-- Target Devices: 	Spartan3E
-- Description: 		SPI cotroller for comunication with ADC
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity voltmeter is
    Port ( --SPI
			  miso : in  STD_LOGIC;
           mosi : out  STD_LOGIC;
           sck : out  STD_LOGIC;
           ncs : out  STD_LOGIC_vector(5 downto 0);
			  --RS232
           rx : in  STD_LOGIC;
           tx : out  STD_LOGIC;
			  --OTHER
           reset : in  STD_LOGIC;
           clk : in  STD_LOGIC);
end voltmeter;

architecture Behavioral of voltmeter is

--component main_unit is
	--port(
	--
	--);
--end component;

component spi_controller is
	port(
	
	);
end component;

component RS232_controller is
	port(
	
	);
end component;

--internal signals

begin
	comp1: main_unit port map ();
	comp2: spi_controller port map ();
	comp3: RS232_controller port map ();
	
end Behavioral;

