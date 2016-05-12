----------------------------------------------------------------------------------
-- Company: PWr
-- Engineer: Kacper Witkowski
-- 
-- Module Name:  	 	FPGA voltmeter - top level entity
-- Project Name: 		FPGA voltmeter
-- Target Device: 	Spartan3E
-- Description: 		SPI cotroller for comunication with ADC

-- algorytm inicjalizacji: wzmocnienie -> czêstotliwoœæ próbkowania -> wybór kana³u -> wpisanie iloœci pomiarów
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity voltmeter is
    Port ( --SPI
			  miso 	: in  STD_LOGIC;
           mosi 	: out  STD_LOGIC;
           sck 	: out  STD_LOGIC;
           ncs 	: out  STD_LOGIC_vector(5 downto 0);
			  --RS232
           rx 		: in  STD_LOGIC;
           tx 		: out  STD_LOGIC;
			  --OTHER
           reset 	: in  STD_LOGIC;
           clk 	: in  STD_LOGIC);
end voltmeter;

architecture Behavioral of voltmeter is

component main_unit is
	port(	clk, reset	: in std_logic;
			--adc
			spi_go 		: out std_logic;
			spi_out 		: out std_logic_vector(9 downto 0);
			spi_busy		: in std_logic;
			spi_in 		: in std_logic_vector(13 downto 0);			
			--rs
			rs_go 		: out std_logic;
			rs_out 		: out std_logic_vector(8 downto 0);
			r_busy 		: in std_logic;
			t_busy 		: in std_logic;
			rs_in 		: in std_logic_vector(8 downto 0)
	);
end component;

component spi_controller is
	port(	  clk,reset		: in  STD_LOGIC;
			  -- host side
           spi_go     	: in  STD_LOGIC;
			  par_in			: in 	std_logic_vector(9 downto 0);
           par_out     	: out  STD_LOGIC_vector(13 downto 0);
           busy         : out  STD_LOGIC;       
           -- adc side
           miso         : in  STD_LOGIC;
			  mosi			: out std_logic;
           sclk         : out  STD_LOGIC;
           n_cs         : out  STD_LOGIC_vector(5 downto 0)	
	);
end component;

component RS232_controller is
	port(		clk,reset 	: in  STD_LOGIC;
				--host side
				par_in 		: in  STD_LOGIC_vector(8 downto 0);
				par_out 		: out  STD_LOGIC_vector(8 downto 0);
				rs_go 		: in std_logic;
				t_busy 		: out std_logic;
				r_busy 		: out std_logic;
				
				--serial interface side
				RX 			: in  STD_LOGIC;
				TX 			: out  STD_LOGIC	
	);
end component;

--internal signals
signal spi_go : std_logic;
signal spi_busy : std_logic;
signal spi_out : std_logic_vector(9 downto 0);
signal spi_in : std_logic_vector(13 downto 0);
signal rs_go : std_logic;
signal t_busy : std_logic;
signal r_busy : std_logic;
signal rs_out : std_logic_vector(8 downto 0);
signal rs_in : std_logic_vector(8 downto 0);

begin
	comp1: main_unit 			port map (	clk => clk, reset => reset, 
													spi_go => spi_go, spi_out => spi_out, spi_busy => spi_busy, spi_in => spi_in,
													rs_go => rs_go, rs_out => rs_out, r_busy => r_busy, t_busy => t_busy, rs_in => rs_in);
	comp2: spi_controller 	port map (	clk => clk, reset => reset, 
													spi_go => spi_go, par_in => spi_out, busy => spi_busy, par_out => spi_in,
													miso => miso, mosi => mosi, sclk => sck, n_cs => ncs);
	comp3: RS232_controller port map (	clk => clk, reset => reset, 
													rs_go => rs_go, par_in => rs_out, r_busy => r_busy, t_busy => t_busy, par_out => rs_in,
													RX => RX, TX => TX);	
end Behavioral;