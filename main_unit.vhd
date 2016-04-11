----------------------------------------------------------------------------------
-- Company: PWr
-- Engineer: Kacper Witkowski
-- 
-- Module Name:  	 	Main unit
-- Project Name: 		FPGA voltmeter
-- Target Devices: 	Spartan3E
-- Description: 		SPI cotroller for comunication with ADC
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main_unit is
	port(	clk 		: in std_logic;
			reset 	: in std_logic;
			
			--adc
			spi_go 	: out std_logic;
			spi_out 	: out std_logic_vector(9 downto 0);
			spi_busy : in std_logic;
			spi_in 	: in std_logic_vector(13 downto 0);
			
			--rs
			rs_go 	: out std_logic;
			rs_out 	: out std_logic_vector(7 downto 0);
			rs_busy 	: in std_logic;
			rs_in 	: in std_logic_vector(7 downto 0)
			);
end main_unit;

architecture Behavioral of main_unit is

begin


end Behavioral;

