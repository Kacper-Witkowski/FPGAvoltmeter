----------------------------------------------------------------------------------
-- Company: PWr
-- Engineer: Kacper Witkowski
-- 
-- Module Name:  	 	Main unit
-- Project Name: 		FPGA voltmeter
-- Target Device: 	Spartan3E
-- Description: 		SPI cotroller for comunication with ADC
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main_unit is
	port(	clk 		: in std_logic;
			reset 	: in std_logic;
			
			--adc
			spi_go 	: out std_logic;
			spi_out 	: out std_logic_vector(9 downto 0);
			spi_busy : in std_logic;
			spi_in 	: in std_logic_vector(13 downto 0);
			
			--rs
			rs_go 	: out std_logic;
			rs_out 	: out std_logic_vector(8 downto 0);
			t_busy 	: in std_logic;
			r_busy	: in std_logic;
			rs_in 	: in std_logic_vector(8 downto 0)
			);
end main_unit;

architecture Behavioral of main_unit is
--state types
type meas_states is (idle, prog, measure, send_fst_byte, send_snd_byte);
type dec_states is (idle, recv_fst_byte);
type con_states is (idle, decode, config);
--signals & registers
signal cnt : std_logic_vector(7 downto 0); -- measurments counter
signal sreg : std_logic_vector(7 downto 0); -- status register
signal adc_ord : std_logic_vector(9 downto 0); -- adc order
signal adc_mes : std_logic_vector(13 downto 0); -- last adc mesurment
signal msg : std_logic_vector(15 downto 0); -- received from rs
signal meas_state : meas_states;
signal dec_state : dec_states;
signal con_state : con_states;
signal done : std_logic;
signal wrong : std_logic;
signal par_en : std_logic;

begin
	meas : process (clk, reset) -- measurements state machine
	begin
		if reset = '1' then
			meas_state <= idle;
			cnt <= (others => '0');
			adc_mes <= (others => '0');
			done <= '1';
			
		elsif clk'event and clk = '1' then
			case meas_state is
				---------------------------
				when idle =>
				spi_out <= adc_ord;
				spi_go <= '0';
				if cnt > '0' and adc_ord = '0' then
					meas_state <= measure;
				elsif done = '0' and adc_ord  = '1' then 
					meas_state <= prog;
				end if;
				---------------------------
				when prog =>
					done <= '1';
					spi_go <= '1';
					meas_state <= idle;
				---------------------------
				when measure =>
					spi_go <= '1';
					cnt <= cnt + "01";
					if cnt = "00000010" then
						spi_go <= '0';
					elsif spi_busy = '0' and spi_cnt >= "00000100" then
						meas_state <= send_fst_byte;
					end if;
				---------------------------
				when send_fst_byte => 
				
				meas_state <= send_snd_byte;
				---------------------------
				when send_snd_byte =>
				
				meas_state <= idle;
				---------------------------
			end case;
		end if;
	end process;
		
	parser_en : process(r_busy, clk, reset)
	begin
		if reset = '1' then
			par_en <= '0';
			par_cnt <= '1';
		elsif r_busy'event and r_busy = '1' then
			par_en <= '1';
		elsif clk'event and clk = '1' then
			if par_en = '1' and par_cnt = '1' then
				par_cnt <= not par_cnt;
			else
				par_en <= '0';
				par_cnt <= '1';
			end if;
		end if;
	end process;
	
	dec : process (r_busy, reset) -- instruction parser state machine
	begin
		if reset = '1' then
			msg <= (others => '0');
			wrong <= '0';
			
		elsif clk'event and clk = '1' then -- todo: two state machines: one for communication with adc and one for decode and configuration
			case dec_state is
				---------------------------
				when idle =>
				wrong <= '0';
				if par_en = '1' then
					if (rs_in(8) xor rs_in(7) xor rs_in(6) xor rs_in(5) xor rs_in(4) xor rs_in(3) xor rs_in(2) xor rs_in(1)) = rs_in(0) then -- even parity check
						msg(15 downto 8) <= rs_in(8 downto 1);
					else
						wrong <= '1';
					end if;
					dec_state <= recv_fst_byte;
				end if;				
				---------------------------
				when recv_fst_byte =>	
				if par_en = '1' then
					if (rs_in(8) xor rs_in(7) xor rs_in(6) xor rs_in(5) xor rs_in(4) xor rs_in(3) xor rs_in(2) xor rs_in(1)) = rs_in(0) then -- even parity check
						msg(7 downto 0) <= rs_in(8 downto 1);
					else
						wrong <= '1';
					end if;
					dec_state <= idle;
				end if;
				---------------------------
			end case;
		end if;
	end process;
	
	parser : process(clk, reset) -- configurator state machine
	begin
		if reset = '1' then
		
		elsif clk'event and clk = '1' then
			case con_state is
				---------------------------
				when idle =>
				
				---------------------------
				when decode =>
					
				---------------------------
				when config => 
				
				---------------------------
				when measure =>
				
				---------------------------
				when gain =>
				
				---------------------------
			end case;
		end if;
	end process;
end Behavioral;