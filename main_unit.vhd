----------------------------------------------------------------------------------
-- Company: PWr
-- Engineer: Kacper Witkowski
-- 
-- Module Name:           Main unit
-- Project Name:         FPGA voltmeter
-- Target Device:     Spartan3E
-- Description:         SPI cotroller for comunication with ADC
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity main_unit is
    port(   clk         : in std_logic;
            reset     	: in std_logic;
            
            --adc
            spi_go     	: out std_logic;
            spi_out     : out std_logic_vector(9 downto 0);
            spi_busy 	: in std_logic;
            spi_in     	: in std_logic_vector(13 downto 0);
            
            --rs
            rs_go     	: out std_logic;
            rs_out     	: out std_logic_vector(8 downto 0);
            t_busy     	: in std_logic;
            r_busy    	: in std_logic;
            rs_in     	: in std_logic_vector(8 downto 0)
            );
end main_unit;

architecture Behavioral of main_unit is
--state types
type delay_states is (idle, cnt_run);
type meas_states is (idle, prog, measure, send_fst_byte, semi_idle, send_snd_byte);
type dec_states is (idle, recv_byte);
type con_states is (idle, decode, rate, counter, adc);
--state signals
signal delay_state : delay_states;
signal meas_state : meas_states;
signal dec_state : dec_states;
signal con_state : con_states;

--status registers
signal sample_rate : std_logic_vector(9 downto 0);
signal sample_cnt : std_logic_vector(9 downto 0);
signal wrong : std_logic;
signal ack_set : std_logic;
signal ack_clear : std_logic;
signal ack : std_logic_vector(1 downto 0);

--meas signals
signal sample, sample_cnt_set : std_logic;
signal spi_go_s : std_logic;
signal meas_unable : std_logic;
signal delay_cnt : std_logic_vector(20 downto 0);
signal spi_cnt : std_logic_vector(9 downto 0); -- measurments clock. Helps switch spi_go to '0'
signal adc_ord : std_logic_vector(9 downto 0); -- adc order
signal adc_result : std_logic_vector(13 downto 0); -- last adc mesurment
signal amp_prog_done, amp_prog_td, amp_prog_d : std_logic;
signal rs_buf : std_logic_vector(8 downto 0);

--decoder signals
signal msg : std_logic_vector(15 downto 0); -- received from rs
signal dec : std_logic;

--parser signals
signal par_en : std_logic;

begin

	 meas_delay : process(clk, reset)
	 begin
		 if reset = '1' then
			 delay_cnt <= (5|3|2 => '1', others =>'0');
			 meas_unable <= '0';
		 elsif clk'event and clk = '1' then
			 case delay_state is
				 when idle => 
					 if adc_ord(8) = '0' and spi_go_s = '1' then
						 delay_cnt(20 downto 11) <= sample_rate;
						 meas_unable <= '1';
						 delay_state <= cnt_run;
					 end if;
					 
				 when cnt_run =>
					 delay_cnt <= delay_cnt - "01";
					 if delay_cnt = "1" then
						 meas_unable <= '0';
						 delay_state <= idle;
					 end if;

			 end case;
		 end if;
	 end process;
	 
	 amp_prog : process(amp_prog_d, amp_prog_td, reset)
	 begin
	 if reset = '1' or (amp_prog_d'event and amp_prog_d = '1') then
		 amp_prog_done <= '1';
	 elsif amp_prog_td'event and amp_prog_td = '1' then
		 amp_prog_done <= '0';	 
	 end if;
	 end process;
	 
	 sample_counter : process(reset, sample_cnt_set, sample)
	 begin
		if reset = '1' then
			sample_cnt <= (others => '0');
		elsif sample_cnt_set'event and sample_cnt_set = '1' then
			sample_cnt <= msg(9 downto 0);
		elsif sample'event and sample = '1' then
			if sample_cnt < "1111111111" then
				sample_cnt <= sample_cnt - "01";
			end if;
		end if;
	 end process;
	 
    measure_proc : process (clk, reset) -- measurements state machine
    begin
        if reset = '1' then
            meas_state <= idle;
            spi_cnt <= (others => '0');
            adc_result <= (others => '0');
            rs_buf <= (others => '0');
				spi_go_s <= '0';
				ack_clear <= '0';
				amp_prog_d <= '0';
				rs_go <= '0';
            
        elsif clk'event and clk = '1' then
            case meas_state is
                ---------------------------
                when idle =>
					 amp_prog_d <= '0';
                spi_out <= adc_ord;
                spi_go_s <= '0';
					 spi_cnt <= (others => '0');
					 ack_clear <= '0';
					 sample <= '0';
					 rs_go <= '0';
                if amp_prog_done = '0' then -- when programming amps wasn't done
                    meas_state <= prog;
                elsif sample_cnt > "0000000000" and meas_unable = '0' then -- when are samples to do
                    meas_state <= measure;
                end if;
                ---------------------------
                when prog =>
                    amp_prog_d <= '1';
                    spi_go_s <= '1';
                    meas_state <= idle;
                ---------------------------
                when measure =>
						  sample <= '1';
                    spi_go_s <= '1';
                    spi_cnt <= spi_cnt + "01";
                    if spi_cnt = "00000010" then
                        spi_go_s <= '0';
                    elsif spi_busy = '0' and spi_cnt >= "0000000100" then
                        adc_result <= spi_in;
                        meas_state <= send_fst_byte;
                    end if;
                ---------------------------
                when send_fst_byte => 
						  if t_busy = '0' then
							   rs_buf(8 downto 7) <= ack;
							   rs_buf(6 downto 1) <= adc_result(13 downto 8);
							   rs_buf(0) <= (rs_buf(8) xor rs_buf(7) xor rs_buf(6) xor rs_buf(5) xor rs_buf(4) xor rs_buf(3) xor rs_buf(2) xor rs_buf(1));
							   rs_go <= '1';
							   meas_state <= semi_idle;
						  end if;
                ---------------------------
                when semi_idle =>
                    rs_go <= '0';
                    if t_busy = '0' then
                        meas_state <= send_snd_byte;
                    end if;
                ---------------------------
                when send_snd_byte =>
                    rs_buf(8 downto 1) <= adc_result(7 downto 0);
                    rs_buf(0) <= (rs_buf(8) xor rs_buf(7) xor rs_buf(6) xor rs_buf(5) xor rs_buf(4) xor rs_buf(3) xor rs_buf(2) xor rs_buf(1));
                    rs_go <= '1';
						  ack_clear <= '1';
                    meas_state <= idle;
                ---------------------------
            end case;
        end if;
    end process;
    
	 spi_go <= spi_go_s;
    rs_out <= rs_buf;
        
    parser_en : process(r_busy, clk, reset) -- <- TODO
    begin
        if reset = '1' then
            par_en <= '0';
        elsif r_busy'event and r_busy = '1' then
            par_en <= '1';
        elsif clk'event and clk = '1' then
            par_en <= '0';
        end if;
    end process;
    
    join_bytes : process (clk, reset) -- instruction parser state machine -- DONE!
    begin
        if reset = '1' then
            msg <= (others => '0');
            dec <= '0';
            wrong <= '0';
            
        elsif clk'event and clk = '1' then
            case dec_state is
                ---------------------------
                when idle =>
					 ack_set <= '0';
                wrong <= '0';
                dec <= '0';
                if par_en = '1' then
                    if (rs_in(8) xor rs_in(7) xor rs_in(6) xor rs_in(5) xor rs_in(4) xor rs_in(3) xor rs_in(2) xor rs_in(1)) = rs_in(0) then -- even parity check
                        msg(15 downto 8) <= rs_in(8 downto 1);
                    else
                        wrong <= '1';
                    end if;
						  if rs_in(8 downto 7) = "00" then
								wrong <= '1';
						  end if;
                    dec_state <= recv_byte;
                end if;                
                ---------------------------
                when recv_byte =>    
                if par_en = '1' then
                    if (rs_in(8) xor rs_in(7) xor rs_in(6) xor rs_in(5) xor rs_in(4) xor rs_in(3) xor rs_in(2) xor rs_in(1)) = rs_in(0) then -- even parity check
                        msg(7 downto 0) <= rs_in(8 downto 1);
                        dec <= '1'; -- decode only if second byte is correct
                    else
                        wrong <= '1';
                    end if;
						  ack_set <= '1';
                    dec_state <= idle;
                end if;
                ---------------------------
            end case;
        end if;
    end process;
	 
	 acknowledge : process(reset, ack_set, ack_clear)
	 begin
		  if reset = '1' or (ack_clear'event and ack_clear = '1') then
			  ack <= "00";
		  elsif (ack_set'event and ack_set = '1') then
			   if wrong = '1' then
				   ack <= "10";
			   else
				   ack <= "11";
			   end if;
		  end if;
	 end process;
    
    decoder : process(clk, reset) -- configurator state machine -- DONE!
    begin
        if reset = '1' then
            sample_rate <= (others => '0');
            sample_cnt_set <= '0';
            adc_ord <= (others => '0');
            con_state <= idle;
				amp_prog_td <= '0';
            
        elsif clk'event and clk = '1' then
            case con_state is
                ---------------------------
                when idle =>
					 amp_prog_td <= '0';
					 sample_cnt_set <= '0';
                if wrong = '0' and dec = '1' then -- decode only if first & secound byte was correct
                    con_state <= decode;
                end if;
                ---------------------------
                when decode =>
                    case msg(15 downto 14) is
                        when "11" =>
                            con_state <= rate;
                        when "10" =>
                            con_state <= counter;
                        when "01" =>
                            con_state <= adc;
								when others =>
									 con_state <= idle;
                    end case;
                ---------------------------
                when rate => 
                    sample_rate <= msg(9 downto 0);
                    con_state <= idle;
                ---------------------------
                when counter =>
                    sample_cnt_set <= '1';
                    con_state <= idle;
                ---------------------------
                when adc =>
                    adc_ord <= msg(9 downto 0);
						  if msg(8) = '1' then
								amp_prog_td <= '1';
						  end if;
                    con_state <= idle;
                ---------------------------
            end case;
        end if;
    end process;
end Behavioral;