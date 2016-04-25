----------------------------------------------------------------------------------
-- Company: PWr
-- Engineer: Kacper Witkowski
-- 
-- Module Name:  	 	RS232 controller
-- Project Name: 		FPGA voltmeter
-- Target Device: 	Spartan3E
-- Description: 		RS232 controller for comunication with PC
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity RS232_controller is
    Port ( 	clk 		: in  STD_LOGIC;
				reset 	: in  STD_LOGIC;
				
				--host side
				par_in 	: in  STD_LOGIC_vector(8 downto 0);
				par_out 	: out  STD_LOGIC_vector(8 downto 0);
				rs_go 	: in std_logic;
				t_busy 	: out std_logic;
				r_busy	: out std_logic;
				
				--serial interface side
				RX 		: in  STD_LOGIC;
				TX 		: out  STD_LOGIC
				);
end RS232_controller;

architecture Behavioral of RS232_controller is

type t_states is (idle, tran_rdy, tran_chck);
type r_states is (idle, recv_rdy, recv_chck);
signal t_cnt : std_logic_vector(3 downto 0);
signal r_cnt : std_logic_vector(3 downto 0);
signal t_shift : std_logic_vector(8 downto 0);
signal r_shift : std_logic_vector(8 downto 0);
signal t_state : t_states;
signal r_state : r_states;

begin

	tran : process(clk, reset)
	begin
	if reset = '1' then
		t_state <= idle;
		t_cnt <= (others => '0');
		t_shift <= (others => '0');
		
	elsif clk'event and clk = '1' then
		case t_state is
			---------------------------
			when idle =>
				t_busy <= '0';
				TX <= '1';
				if rs_go = '1' then
					t_busy <= '1';
					t_shift <= par_in; -- todo: counting parity bit(solution: counting done in main unit)
					t_state <= tran_rdy;
				else
					t_state <= idle;
				end if;				
			---------------------------
			when tran_rdy =>
				if t_cnt = 0 then
					TX <= '0';
				else
					t_shift <= t_shift(7 downto 0) & '1';
					TX <= t_shift(8);
				end if;
				t_state <= tran_chck;			
			---------------------------
			when tran_chck =>				
				if t_cnt < "1011" then
					t_cnt <= t_cnt + "01";
					t_state <= tran_rdy;
				else
					t_busy <= '0';
					t_cnt <= (others => '0');
					t_state <= idle;
				end if;
			---------------------------
		end case;
	end if;
	end process;
	
	recv : process(clk, reset)
	begin
	if reset = '1' then
		r_state <= idle;
		r_cnt <= (others => '0');
		r_shift <= (others => '0');
		par_out <= (others => '0');
		
	elsif clk'event and clk = '1' then
		case r_state is
			---------------------------
			when idle =>
				r_busy <= '0';				
				if RX = '0' then
					r_state <= recv_rdy;
				end if;
			---------------------------	
			when recv_rdy =>				
				r_state <= recv_chck;
			---------------------------					
			when recv_chck =>
				r_shift <= r_shift(7 downto 0) & RX;
				if r_cnt < "1001" then
					r_cnt <= r_cnt + "01";
					r_state <= recv_rdy;
				else
					r_busy <= '1';
					r_cnt <= (others => '0');
					par_out <= r_shift;
					r_state <= idle;
				end if;
			---------------------------
		end case;
	end if;
	end process;
end Behavioral;