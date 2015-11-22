	sensors_intf u0 (
		.clk_clk                (<connected-to-clk_clk>),                //              clk.clk
		.pio_go_external_export (<connected-to-pio_go_external_export>), //  pio_go_external.export
		.reset_reset_n          (<connected-to-reset_reset_n>),          //            reset.reset_n
		.spi_adc_external_MISO  (<connected-to-spi_adc_external_MISO>),  // spi_adc_external.MISO
		.spi_adc_external_MOSI  (<connected-to-spi_adc_external_MOSI>),  //                 .MOSI
		.spi_adc_external_SCLK  (<connected-to-spi_adc_external_SCLK>),  //                 .SCLK
		.spi_adc_external_SS_n  (<connected-to-spi_adc_external_SS_n>),  //                 .SS_n
		.temperinterface_sda    (<connected-to-temperinterface_sda>),    //  temperinterface.sda
		.temperinterface_scl    (<connected-to-temperinterface_scl>)     //                 .scl
	);

