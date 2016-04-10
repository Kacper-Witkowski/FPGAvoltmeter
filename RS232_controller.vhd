----------------------------------------------------------------------------------
-- Company: PWr
-- Engineer: Kacper Witkowski
-- 
-- Module Name:  	 	RS232 controller
-- Project Name: 		FPGA voltmeter
-- Target Devices: 	Spartan3E
-- Description: 		SPI cotroller for comunication with ADC
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity RS232_controller is
    Port ( 	--host side
				p_in : in  STD_LOGIC;
				p_out : out  STD_LOGIC;
				clk : in  STD_LOGIC;
				reset : in  STD_LOGIC;
				
				--serial interface side
				RX : in  STD_LOGIC;
				TX : out  STD_LOGIC
				);
end RS232_controller;

architecture Behavioral of RS232_controller is

begin


end Behavioral;

