----------------------------------------------------------------------------------
-- Company: PWr
-- Engineer: Kacper Witkowski
-- 
-- Module Name:  	 	SPI controller
-- Project Name: 		FPGA voltmeter
-- Target Device: 	Spartan3E
-- Description: 		SPI cotroller for comunication with ADC
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity spi_controller is
    Port ( clk          : in  STD_LOGIC;
           reset     	: in  STD_LOGIC;
			  
			  -- host side
           spi_go     	: in  STD_LOGIC;
			  par_in			: in 	std_logic_vector(9 downto 0); -- 0 to 7: amp order, 8: amp(1) or adc(0), 9: adc channel 0 or 1
           par_out     	: out  STD_LOGIC_vector(13 downto 0);
           busy         : out  STD_LOGIC;
              
           -- adc side
           miso         : in  STD_LOGIC; -- from adc
			  mosi			: out std_logic; -- to amp
           sclk         : out  STD_LOGIC; -- for both devices
           n_cs         : out  STD_LOGIC_vector(5 downto 0) -- enable SPI communication with only one device on board
           );
end spi_controller;

architecture Behavioral of spi_controller is

type states is (idle, adc_conv_start, adc_rdy, adc_recv, gain_rdy, gain_tran);
signal recv  : std_logic_vector(33 downto 0);
signal tran	 : std_logic_vector(7 downto 0);
signal cnt   : std_logic_vector(6 downto 0);
signal ch	 : std_logic;
signal state : states;

begin
	process(clk, reset)
	begin
		 if reset = '1' then
			  recv <= (others => '0');
			  tran <= (others => '0');
			  par_out <= (others => '0');
			  ch <= '0';
			  state <= idle;
		 elsif clk'event and clk = '1' then
			  case state is
					---------------------------
					when idle =>
						sclk <= '0';
						n_cs <= "111110";
						mosi <= 'Z';
						busy <= '0';
						cnt <= (others => '0');
						
						if spi_go = '1' and par_in(8) = '0' then
							busy <= '1';
							ch <= par_in(9);
							state <= adc_conv_start;
						elsif spi_go = '1' and par_in(8) = '1' then
							busy <= '1';
							tran <= par_in(7 downto 0);
							state <= gain_rdy;
						else
							state <= idle;
						end if;
					
					-- adc
					---------------------------
					when adc_conv_start =>
						n_cs(0) <= '1';
						state <= adc_rdy;
					---------------------------
					when adc_rdy =>
						n_cs(0) <= '0';
						sclk <= '1';
						state <= adc_recv;
					---------------------------
					when adc_recv => 
						sclk <= '0';
						recv <= recv(32 downto 0) & miso;
						if cnt < "0100001" then -- 33 cycles
							cnt <= cnt + "01";
							state <= adc_rdy;
						else
							if ch = '0' then
								par_out <= recv(30 downto 17);
							else
								par_out <= recv(14 downto 1);
							end if;
							state <= idle;
						end if;
						
					-- amp
					---------------------------
					when gain_rdy =>
						n_cs(1) <= '0';
						sclk <= '0';
						if cnt > 0 then
							tran <= tran(6 downto 0) & '1';
						end if;
						state <= gain_tran;
					---------------------------
					when gain_tran =>
						sclk <= '1';					
						if cnt < "0000111" then
							cnt <= cnt + "01";
							state <= gain_rdy;
						else
							state <= idle;
						end if;
					---------------------------	
				end case;
			end if;
	end process;

mosi <= tran(7);

end Behavioral;