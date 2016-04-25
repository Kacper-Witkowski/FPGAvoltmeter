--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:50:08 04/12/2016
-- Design Name:   
-- Module Name:   C:/Users/Kacp/Desktop/studia/git/ProjektPUL/rs_tb.vhd
-- Project Name:  ProjektPUL
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RS232_controller
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY rs_tb IS
END rs_tb;
 
ARCHITECTURE behavior OF rs_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RS232_controller
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         par_in : IN  std_logic_vector(8 downto 0);
         par_out : OUT  std_logic_vector(8 downto 0);
         rs_go : IN  std_logic;
         t_busy : OUT  std_logic;
         r_busy : OUT  std_logic;
         RX : IN  std_logic;
         TX : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal par_in : std_logic_vector(8 downto 0) := (others => '0');
   signal rs_go : std_logic := '0';
   signal RX : std_logic := '0';

 	--Outputs
   signal par_out : std_logic_vector(8 downto 0);
   signal t_busy : std_logic;
   signal r_busy : std_logic;
   signal TX : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RS232_controller PORT MAP (
          clk => clk,
          reset => reset,
          par_in => par_in,
          par_out => par_out,
          rs_go => rs_go,
          t_busy => t_busy,
          r_busy => r_busy,
          RX => RX,
          TX => TX
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
      wait for 20 ns;	
		reset <= '1';
		RX <= '1';
		par_in <= "001101010";
		wait for 20ns;	
		reset <= '0';
      wait for clk_period*10;
		RX <= '0';
		wait for clk_period*2;
		RX <= '1';
		wait for clk_period*2;
		rs_go <= '1';
		RX <= '0';
		wait for clk_period*6;
		rs_go <= '0';
		RX <= '1';
		wait for clk_period*4;
		RX <= '0';
		wait for clk_period*2;
		RX <= '1';
		wait for clk_period*2;
		RX <= '0';
		wait for clk_period*2;
		RX <= '1';
		wait for clk_period*15;
		

      assert false severity failure;
   end process;

END;
