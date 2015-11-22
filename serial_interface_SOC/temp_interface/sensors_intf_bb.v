
module sensors_intf (
	clk_clk,
	pio_go_external_export,
	reset_reset_n,
	spi_adc_external_MISO,
	spi_adc_external_MOSI,
	spi_adc_external_SCLK,
	spi_adc_external_SS_n,
	temperinterface_sda,
	temperinterface_scl);	

	input		clk_clk;
	input		pio_go_external_export;
	input		reset_reset_n;
	input		spi_adc_external_MISO;
	output		spi_adc_external_MOSI;
	output		spi_adc_external_SCLK;
	output		spi_adc_external_SS_n;
	inout		temperinterface_sda;
	output		temperinterface_scl;
endmodule
