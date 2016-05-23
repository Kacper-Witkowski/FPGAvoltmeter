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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY voltmeter_tb IS
END voltmeter_tb;
 
ARCHITECTURE behavior OF voltmeter_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT voltmeter
    PORT(
         miso : IN  std_logic;
         mosi : OUT  std_logic;
         sck : OUT  std_logic;
         ncs : OUT  std_logic_vector(5 downto 0);
         rx : IN  std_logic;
         tx : OUT  std_logic;
         reset : IN  std_logic;
         clk : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal miso : std_logic := '0';
   signal rx : std_logic := '0';
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal mosi : std_logic;
   signal sck : std_logic;
   signal ncs : std_logic_vector(5 downto 0);
   signal tx : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: voltmeter PORT MAP (
          miso => miso,
          mosi => mosi,
          sck => sck,
          ncs => ncs,
          rx => rx,
          tx => tx,
          reset => reset,
          clk => clk
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		reset <= '0';
		rx <= '1';
		miso <= '0';
      wait for 20 ns;	
		reset <= '1';
      wait for clk_period*5;
		reset <= '0';
		wait for clk_period*3;
		
		-- gain programming first byte
		rx <= '0';
		wait for clk_period*4;
		rx <= '1';
		wait for clk_period*2;
		rx <= '0';
		wait for clk_period*10;
		rx <= '1';
		wait for clk_period*2;
		rx <= '0';
		wait for clk_period*2;
		rx <= '1';
		wait for clk_period*4;
		-- gain programming second byte
		rx <= '0';
		wait for clk_period*4;
		rx <= '1';
		wait for clk_period*2;
		rx <= '0';
		wait for clk_period*2;
		rx <= '1';
		wait for clk_period*2;
		rx <= '0';
		wait for clk_period*2;
		rx <= '1';
		wait for clk_period*2;
		rx <= '0';
		wait for clk_period*2;
		rx <= '1';
		wait for clk_period*2;
		rx <= '0';
		wait for clk_period*2;
		rx <= '1';
		wait for clk_period*8;
		
		-- sample rate first byte
		rx <= '0';
		wait for clk_period*2;
		rx <= '1';
		wait for clk_period*4;
		rx <= '0';
		wait for clk_period*14;
		rx <= '1';
		wait for clk_period*4;
		-- sample rate second byte
		rx <= '0';
		wait for clk_period*20;
		rx <= '1';
		wait for clk_period*8;
		
		
		-- set channel first byte
		rx <= '0';
		wait for clk_period*4;
		rx <= '1';
		wait for clk_period*2;
		rx <= '0';
		wait for clk_period*12;
		rx <= '1';
		wait for clk_period*6;
		-- set channel second byte
		rx <= '0';
		wait for clk_period*4;
		rx <= '1';
		wait for clk_period*2;
		rx <= '0';
		wait for clk_period*12;
		rx <= '1';
		wait for clk_period*10;
		
		
		-- sample counter first byte
		rx <= '0';
		wait for clk_period*2;
		rx <= '1';
		wait for clk_period*2;
		rx <= '0';
		wait for clk_period*14;
		rx <= '1';
		wait for clk_period*6;
		-- sample counter second byte
		rx <= '0';
		wait for clk_period*14;
		rx <= '1';
		wait for clk_period*4;
		rx <= '0';
		wait for clk_period*2;
		rx <= '1';
		
		-- adc
		miso <= '0';
		wait for clk_period*6;
		miso <= '1';
		wait for clk_period*4;
		miso <= '0';
		wait for clk_period*8;
		miso <= '1';
		wait for clk_period*2;
		miso <= '0';
		wait for clk_period*10;
		miso <= '1';
		wait for clk_period*6;
		miso <= '0';
		wait for clk_period*12;
		miso <= '1';
		wait for clk_period*8;
		miso <= '0';
		wait for clk_period*16;
		miso <= '1';
		wait for clk_period*80;

      assert false severity failure;
   end process;

END;
