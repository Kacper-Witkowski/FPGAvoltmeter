LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY main_unit_tb IS
END main_unit_tb;
 
ARCHITECTURE behavior OF main_unit_tb IS 
 
    COMPONENT main_unit
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         spi_go : OUT  std_logic;
         spi_out : OUT  std_logic_vector(9 downto 0);
         spi_busy : IN  std_logic;
         spi_in : IN  std_logic_vector(13 downto 0);
         rs_go : OUT  std_logic;
         rs_out : OUT  std_logic_vector(8 downto 0);
         t_busy : IN  std_logic;
         r_busy : IN  std_logic;
         rs_in : IN  std_logic_vector(8 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal spi_busy : std_logic := '0';
   signal spi_in : std_logic_vector(13 downto 0) := (others => '0');
   signal t_busy : std_logic := '0';
   signal r_busy : std_logic := '0';
   signal rs_in : std_logic_vector(8 downto 0) := (others => '0');

 	--Outputs
   signal spi_go : std_logic;
   signal spi_out : std_logic_vector(9 downto 0);
   signal rs_go : std_logic;
   signal rs_out : std_logic_vector(8 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: main_unit PORT MAP (
          clk => clk,
          reset => reset,
          spi_go => spi_go,
          spi_out => spi_out,
          spi_busy => spi_busy,
          spi_in => spi_in,
          rs_go => rs_go,
          rs_out => rs_out,
          t_busy => t_busy,
          r_busy => r_busy,
          rs_in => rs_in
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
      wait for 30 ns;	
		reset <= '1';
		rs_in <= "010000010"; -- amp programming
      wait for clk_period*2.4;
		reset <= '0';
		wait for clk_period*2;
		r_busy <= '1';
		wait for clk_period*1;
		r_busy <= '0';
		wait for clk_period*6;
		rs_in <= "010101010";
		wait for clk_period*2;
		r_busy <= '1';
		wait for clk_period*1;
		r_busy <= '0';
		wait for clk_period*6;
		rs_in <= "110000000"; -- rate programming
      wait for clk_period*2;
		r_busy <= '1';
		wait for clk_period*1;
		r_busy <= '0';
		wait for clk_period*6;
		rs_in <= "000000000";
		wait for clk_period*2;
		r_busy <= '1';
		wait for clk_period*1;
		r_busy <= '0';
		wait for clk_period*6;
		rs_in <= "100000001"; -- counter programming
      wait for clk_period*2;
		r_busy <= '1';
		wait for clk_period*1;
		r_busy <= '0';
		wait for clk_period*6;
		rs_in <= "000000110";
		r_busy <= '1';
		wait for clk_period*1;
		r_busy <= '0';
		wait for clk_period*6;
		rs_in <= "010000001";		-- adc channel set and measure
		spi_busy <= '1';
		t_busy <= '1';
		spi_in <= "10101010101010";
      wait for clk_period*2.4;
		reset <= '0';
		wait for clk_period*2;
		r_busy <= '1';
		wait for clk_period*1;
		r_busy <= '0';
		wait for clk_period*6;
		rs_in <= "010101010";
		wait for clk_period*2;
		r_busy <= '1';
		wait for clk_period*1;
		r_busy <= '0';
		wait for clk_period*6;
		spi_busy <= '0';
		wait for clk_period*10;
		t_busy <= '0';
		spi_busy <= '1';
		wait for clk_period*1;
		t_busy <= '1';
		wait for clk_period*15;
		t_busy <= '0';
		wait for clk_period*1;
		t_busy <= '1';
		wait for clk_period*6;
		spi_in <= "10011011001110";
		wait for clk_period*6;
		spi_busy <= '0';
		wait for clk_period*10;
		t_busy <= '0';
		spi_busy <= '1';
		wait for clk_period*1;
		t_busy <= '1';
		wait for clk_period*15;
		t_busy <= '0';
		wait for clk_period*1;
		t_busy <= '1';
		wait for clk_period*6;
		spi_in <= "10001110001100";
		wait for clk_period*6;
		spi_busy <= '0';
		wait for clk_period*10;
		t_busy <= '0';
		spi_busy <= '1';
		wait for clk_period*1;
		t_busy <= '1';
		wait for clk_period*15;
		t_busy <= '0';
		wait for clk_period*1;
		t_busy <= '1';
		wait for clk_period*6;
		spi_in <= "11011010001110";
		

      assert false severity failure;
   end process;

END;
