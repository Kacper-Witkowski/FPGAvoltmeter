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
    Port ( 	clk 		: in  STD_LOGIC;
				reset 	: in  STD_LOGIC;
				
				--host side
				par_in 	: in  STD_LOGIC_vector(7 downto 0);
				par_out 	: out  STD_LOGIC_vector(7 downto 0);
				rs_go 	: in std_logic;
				busy 		: out std_logic;
				
				--serial interface side
				RX 		: in  STD_LOGIC;
				TX 		: out  STD_LOGIC
				);
end RS232_controller;

architecture Behavioral of RS232_controller is

begin


end Behavioral;

