----------------------------------------------------------------------------------
-- Company: PWr
-- Engineer: Kacper Witkowski
-- 
-- Module Name:  	 	SPI controller - test bench
-- Project Name: 		FPGA voltmeter
-- Target Devices: 	Spartan3E
-- Description: 		SPI cotroller for comunication with ADC
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY spi_tb IS
END spi_tb;
 
ARCHITECTURE behavior OF spi_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT spi_controler
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         spi_go : IN  std_logic;
         par_in : IN  std_logic_vector(9 downto 0);
         par_out : OUT  std_logic_vector(13 downto 0);
         busy : OUT  std_logic;
         miso : IN  std_logic;
         mosi : OUT  std_logic;
         sclk : OUT  std_logic;
         n_cs : OUT  std_logic_vector(5 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal spi_go : std_logic := '0';
   signal par_in : std_logic_vector(9 downto 0) := (others => '0');
   signal miso : std_logic := '0';

 	--Outputs
   signal par_out : std_logic_vector(13 downto 0);
   signal busy : std_logic;
   signal mosi : std_logic;
   signal sclk : std_logic;
   signal n_cs : std_logic_vector(5 downto 0);

   -- Clock period definitions
   constant clk_period : time := 8 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: spi_controler PORT MAP (
          clk => clk,
          reset => reset,
          spi_go => spi_go,
          par_in => par_in,
          par_out => par_out,
          busy => busy,
          miso => miso,
          mosi => mosi,
          sclk => sclk,
          n_cs => n_cs
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
      wait for 20 ns;	
		reset <= '1';
		par_in <= "1101010101";
		wait for 20 ns;
		reset <= '0';
		wait for 20 ns;
		spi_go <= '1';
		wait for clk_period*3;
		spi_go <= '0';
      wait for clk_period*22;
		par_in <= "0011001100";
		miso <= '1';
		wait for clk_period;
		spi_go <= '1';
		wait for clk_period*2;
		spi_go <= '0';
		miso <= '0';
		wait for clk_period*4;
		miso <= '1';
		wait for clk_period*2;
		miso <= '0';
		wait for clk_period*8;
		miso <= '1';
		wait for clk_period*6;
		miso <= '0';
		wait for clk_period*2;
		miso <= '1';
		wait for clk_period*4;
		miso <= '0';
		wait for clk_period*2;
		miso <= '1';
		wait for clk_period*2;
		miso <= '0';
		wait for clk_period*4;
		miso <= '1';
		wait for clk_period*4;
		miso <= '0';
		wait for clk_period*2;
		miso <= '1';
		wait for clk_period*4;
		miso <= '0';
		wait for clk_period*6;
		miso <= '1';
		wait for clk_period*4;
		miso <= '0';
		wait for clk_period*4;
		miso <= '1';
		wait for clk_period*4;
		miso <= '0';
		wait for clk_period*6;
		miso <= '1';
		wait for clk_period*2;
		miso <= '0';
		wait for clk_period*4;
		miso <= '1';
		wait for clk_period*2;
		miso <= '0';
		wait for clk_period*4;
		miso <= '1';
		wait for clk_period*4;
		miso <= '0';
		wait for clk_period*10;

      assert false severity failure;
   end process;

END;
