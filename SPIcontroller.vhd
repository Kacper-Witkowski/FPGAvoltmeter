----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:26:33 04/08/2016 
-- Design Name: 
-- Module Name:    SPIcontroller - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SPIcontroller is
    Port ( clk : in  STD_LOGIC;
           nreset : in  STD_LOGIC;
           spi_go : in  STD_LOGIC;
           par_out : out  STD_LOGIC;
           busy : out  STD_LOGIC;
           miso : in  STD_LOGIC;
           sclk : out  STD_LOGIC;
           n_cs : out  STD_LOGIC);
end SPIcontroller;

architecture Behavioral of SPIcontroller is

begin


end Behavioral;

