	component sensors_intf is
		port (
			clk_clk                : in    std_logic := 'X'; -- clk
			pio_go_external_export : in    std_logic := 'X'; -- export
			reset_reset_n          : in    std_logic := 'X'; -- reset_n
			spi_adc_external_MISO  : in    std_logic := 'X'; -- MISO
			spi_adc_external_MOSI  : out   std_logic;        -- MOSI
			spi_adc_external_SCLK  : out   std_logic;        -- SCLK
			spi_adc_external_SS_n  : out   std_logic;        -- SS_n
			temperinterface_sda    : inout std_logic := 'X'; -- sda
			temperinterface_scl    : out   std_logic         -- scl
		);
	end component sensors_intf;

	u0 : component sensors_intf
		port map (
			clk_clk                => CONNECTED_TO_clk_clk,                --              clk.clk
			pio_go_external_export => CONNECTED_TO_pio_go_external_export, --  pio_go_external.export
			reset_reset_n          => CONNECTED_TO_reset_reset_n,          --            reset.reset_n
			spi_adc_external_MISO  => CONNECTED_TO_spi_adc_external_MISO,  -- spi_adc_external.MISO
			spi_adc_external_MOSI  => CONNECTED_TO_spi_adc_external_MOSI,  --                 .MOSI
			spi_adc_external_SCLK  => CONNECTED_TO_spi_adc_external_SCLK,  --                 .SCLK
			spi_adc_external_SS_n  => CONNECTED_TO_spi_adc_external_SS_n,  --                 .SS_n
			temperinterface_sda    => CONNECTED_TO_temperinterface_sda,    --  temperinterface.sda
			temperinterface_scl    => CONNECTED_TO_temperinterface_scl     --                 .scl
		);

