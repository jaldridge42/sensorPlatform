library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity temperature_sensor_serial_interface is
	port (CLK		: in  	std_logic; -- clock for component
		  RST_n		: in  	std_logic; -- reset_n for component
		  CS_n		: in 	std_logic; --chip select for component
		  
		  
		  write_en	: in    std_logic; --write enable for serial component
		  read_en	: in    std_logic; -- read enable for serial component
		  
		  write_data: in  	std_logic_vector (15 downto 0); -- one byte data to send to the slave
		  read_data	: out   std_logic_vector (15 downto 0);
		  
		  --start		: in    std_logic; -- sending a positive edge on start will cause the interface to read or write 
		  reg_adrs  : in    std_logic_vector (1 downto 0);
		  SDA		: inout std_logic; -- serial data to or from temperature sensor salve interface
		  SCL		: out 	std_logic -- serial clock to temperature sensor slave interface
		  
		  );
end entity;
architecture behavioural of temperature_sensor_serial_interface is

	constant NWR						: std_logic:= '0';
	constant RD							: std_logic:= '1';
	constant SLAVE_ADDRESS				: std_logic_vector(2 downto 0) := (others => '0'); -- A2 A1 A0 = "000"
	type   state_type is (IDLE, SEND_SLAVE_ADRS, GET_DATA, SEND_REG_ADRS, SEND_DATA, STOP);
	signal write_read_state 			: state_type;
	signal clk_div_counter				: std_logic_vector (5 downto 0);
	signal shift_count 					: std_logic_vector (3 downto 0);
	signal shift_data					: std_logic_vector (15 downto 0);
	--signal start_q						: std_logic;
	signal start2						: std_logic;
	signal startR2						: std_logic;
	signal startW2						: std_logic;
	signal start						: std_logic;
	signal startR						: std_logic;
	signal startW						: std_logic;
	signal reg_adrs_q					: std_logic_vector (1 downto 0); --Registered address from avalon fabric
	signal write_data_q					: std_logic_vector (15 downto 0);-- ''
	signal clk_78KHz					: std_logic;
	signal scl_en						: std_logic;
	signal start_write					: std_logic;
	signal start_read					: std_logic;
	signal second_time_slave_address	: std_logic;
	signal SDA_internal					: std_logic;
	signal first_get_data				: std_logic;
	signal capture_data_out				: std_logic;
	signal firt_time_send				: std_logic;
	signal write_valid					: std_logic;
	signal read_valid					: std_logic;
	signal write_pos_edge				: std_logic;
	signal read_pos_edge				: std_logic;
	signal write_valid_q				: std_logic;
	signal read_valid_q					: std_logic;
	
begin


	-- write enable and read enable decode
	write_valid <= (NOT (CS_n) AND write_en);
	read_valid 	<= (NOT (CS_n) AND read_en);
	
	 write_read_pos_edge: process (CLK) is -- temporary for simulation purposes
	 begin

		 if ( rising_edge (CLK)) then
			 write_valid_q <= write_valid;
			 read_valid_q  <= read_valid;
			 if ( write_valid_q = '0' and write_valid = '1') then
				 write_pos_edge <= '1';
			 else
				 write_pos_edge <= '0';
			 end if;
			 if ( read_valid_q = '0' and read_valid = '1') then
				 read_pos_edge <= '1';
			 else
				 read_pos_edge <= '0';
			 end if;	
			 if (read_pos_edge = '1') then
				 startR2 <= '1';
				 reg_adrs_q <= reg_adrs; --Register address
			 elsif(write_pos_edge = '1') then
				 startW2 <= '1';
				 reg_adrs_q <= reg_adrs;
				 write_data_q <= write_data; --Also register write data
			 elsif(startR = '1' or startW = '1') then
				 startR2 <= '0';
				 startW2 <= '0';
			 end if;
			
		 end if;
	 end process;
	
	process(clk_78KHz) is
	begin
		if(rising_edge(clk_78KHz))then
			if(startR2 = '1')then
				startR <= '1';
			elsif(startW2 = '1') then
				startW <= '1';
			else
				startR <= '0';
				startW <= '0';
			end if;
		end if;
	end process;
	
	-- process(write_valid, read_valid, clk_78KHz)is
	-- begin
		-- if(rising_edge(write_valid)) then
			-- start <= '1';	
		-- elsif(rising_edge(read_valid)) then
			-- start <= '1';
		-- elsif(rising_edge(clk_78KHz)) then
			-- start <= '0';
		-- end if;
	-- end process;
	
		
		CLK_DIVISION: process (CLK) is -- temporary for simulation purposes
		begin
			if (RST_n = '0') then
				clk_div_counter <= (others => '0');
			elsif ( rising_edge (CLK)) then
				clk_div_counter <= clk_div_counter + 1;
			end if;
		end process;
		clk_78KHz <= clk_div_counter(5); --divide clock 50 MHz by 64 to generate 78 KHz clock for SCL
		
		WRITE_READ_PROCESS: process ( clk_78KHz)
		begin
			if ( RST_n = '0') then 
				scl_en 					<= '0';
				write_read_state 		<= IDLE;
			elsif (rising_edge(clk_78KHz)) then
				case write_read_state is
					when (IDLE) =>
						if (start_write = '1' or start_read = '1') then
							write_read_state 	<= SEND_SLAVE_ADRS;
							shift_count 		<= (others => '0');
							scl_en 				<= '1';
						else			
							scl_en 				<= '0';
						end if;
					when (SEND_SLAVE_ADRS) => 
						if (shift_count = 0) then
							if (second_time_slave_address = '1' and start_read = '1') then
								shift_data 				<= "1001" & SLAVE_ADDRESS & RD & EXT("00",8);
							else
								shift_data 				<= "1001" & SLAVE_ADDRESS & NWR & EXT("00",8);
							end if;
						end if;
						shift_count 				<= shift_count + 1;
						if (shift_count = 8) then
							if ( start_read = '1' and second_time_slave_address = '1') then -- we've sent the second slave address
								write_read_state 	<= GET_DATA;
								capture_data_out	<= '0';
								first_get_data		<= '1';
							else			
								write_read_state 	<= SEND_REG_ADRS;
							end if;
							shift_count <= (others => '0');
						end if;
						
					when (SEND_REG_ADRS) =>
						if (shift_count = 0) then
							shift_data 						<= "000000" & reg_adrs_q & EXT("00",8);
						end if;
						shift_count <= shift_count + 1;
						if (shift_count = 8) then
							if ( start_write = '1') then 
								write_read_state 			<= SEND_DATA;
								firt_time_send				<= '1';
							else 
								write_read_state 			<= SEND_SLAVE_ADRS;
								second_time_slave_address 	<= '1';
							end if;
							shift_count 					<= (others => '0');
						end if;		
						
					when (SEND_DATA) =>
						if (shift_count = 0 and firt_time_send = '1') then
							shift_data			<=  write_data_q ; -- shift SDA into shifter
						end if;					
						shift_count <= shift_count + 1;
						if (shift_count = 8 )then
							if (firt_time_send = '1' and reg_adrs_q /= "01" ) then
								write_read_state 	<= SEND_DATA;
								firt_time_send 		<= '0';							
							else
								write_read_state 	<= STOP;
								firt_time_send 		<= '0';
							end if;
							shift_count 		<= (others => '0');
						end if;	
						
					when (GET_DATA) =>
						
						shift_count 			<= shift_count + 1;
						if (shift_count = 8) then
							if (first_get_data = '1') then -- this is the firt byte of data get the second byte
								write_read_state 	<= GET_DATA;
								first_get_data		<= '0';
							else
								write_read_state 	<= STOP;
								capture_data_out	<= '1';								
							end if;
							shift_count 		<= (others => '0');
						end if;	
						if (shift_count /= 0) then
							shift_data			<=  shift_data( 14 downto 0) & SDA; -- shift SDA into shifter
						end if;
							
					when (STOP) =>
						scl_en					<= '0';
						write_read_state 		<= IDLE;
						if (capture_data_out = '1') then
							read_data			<= shift_data; -- send data out 
						end if;
					when others =>
						write_read_state 		<= IDLE;
				end case;
				
				if (shift_count > 0 and write_read_state /= GET_DATA) then
					shift_data 					<= shift_data(14 downto 0) & '0';
				end if;
			end if;
			
		end process WRITE_READ_PROCESS;

		SDA_internal <= shift_data(15); -- use this internal signal to send proper data to SDA port 
		
		-- When shift_count is under 8 we are sending the data out 
		-- but when shift counter is equal to 8 we are waiting for ack from slave so SDA should be Hi-Z.
		-- or ( )
		--SDA <= SDA_internal when ((write_valid = '1' and shift_count > "0000") or (read_valid = '1' and write_read_state /= GET_DATA and shift_count > "0000"))  else 'Z'; 
		SDA <= SDA_internal when (write_read_state /= GET_DATA and shift_count > 0)  else 'Z';
		
		SCL <= clk_78KHz when scl_en = '1' else '1';
		
		RISE_FALL_EDGE_DETECTION: process (clk_78KHz) is
		begin
			if (rising_edge(clk_78KHz)) then
				--start_q <= start;
				--if (start_q = '0' and start = '1') then -- positive_edge has happened
				if (startW = '1') then -- positive_edge read has happened
						-- write data
						start_write <= '1';
				elsif(startR = '1') then -- read
						start_read 	<= '1';
				end if;
				
				if (write_read_state = SEND_DATA) then
					start_write 	<= '0';
				end if;
				if (write_read_state = GET_DATA) then
					start_read 		<= '0';
				end if;				
			end if;
		end process RISE_FALL_EDGE_DETECTION;

end behavioural;

