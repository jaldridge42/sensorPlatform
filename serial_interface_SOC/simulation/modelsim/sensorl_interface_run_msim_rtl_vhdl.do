transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlib sensors_intf
vmap sensors_intf sensors_intf
vlog -vlog01compat -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/altera_reset_controller.v}
vlog -vlog01compat -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/altera_reset_synchronizer.v}
vlog -vlog01compat -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_mm_interconnect_0.v}
vlog -vlog01compat -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_mm_interconnect_0_avalon_st_adapter_001.v}
vlog -vlog01compat -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_mm_interconnect_0_avalon_st_adapter.v}
vlog -vlog01compat -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_sysid_qsys_0.v}
vlog -vlog01compat -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_spi_ADC.v}
vlog -vlog01compat -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_pio_GO.v}
vlog -vlog01compat -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_onchip_mem.v}
vlog -vlog01compat -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_jtag_uart.v}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_irq_mapper.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_mm_interconnect_0_avalon_st_adapter_001_error_adapter_0.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_mm_interconnect_0_avalon_st_adapter_error_adapter_0.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/altera_merlin_width_adapter.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/altera_merlin_burst_uncompressor.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/altera_merlin_arbitrator.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_mm_interconnect_0_rsp_mux_001.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_mm_interconnect_0_rsp_mux.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_mm_interconnect_0_rsp_demux_003.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_mm_interconnect_0_rsp_demux.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_mm_interconnect_0_cmd_mux_003.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_mm_interconnect_0_cmd_mux.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_mm_interconnect_0_cmd_demux_001.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_mm_interconnect_0_cmd_demux.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/altera_merlin_burst_adapter.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/altera_merlin_burst_adapter_uncmpr.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/altera_merlin_traffic_limiter.sv}
vlog -vlog01compat -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/altera_avalon_sc_fifo.v}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_mm_interconnect_0_router_005.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_mm_interconnect_0_router_003.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_mm_interconnect_0_router_002.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_mm_interconnect_0_router_001.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/sensors_intf_mm_interconnect_0_router.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/altera_merlin_slave_agent.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/altera_merlin_master_agent.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/altera_merlin_slave_translator.sv}
vlog -sv -work sensors_intf +incdir+C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/altera_merlin_master_translator.sv}
vcom -93 -work sensors_intf {C:/Courses/serial_interface_SOC/temp_interface/synthesis/sensors_intf.vhd}
vcom -93 -work sensors_intf {C:/Courses/serial_interface_SOC/temp_interface/synthesis/submodules/temperature_sensor_serial_interface_new2.vhd}

