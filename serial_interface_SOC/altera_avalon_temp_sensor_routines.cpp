//altera_avalon_temp_sensor_routines.c for HAL
// Functions that user can use
#include "altera_avalon_temp_sensor_routines.h"
//configure temperature sensor registers
void altera_avalon_temp_sensor_config(unsigned int address, unsigned int init_data, unsigned int temp_threshold_enable, unsigned int temp_threshold_low, unsigned int temp_threshold_high)
{
	IOWR_ALTERA_AVALON_TEMP_SENSOR_CONFIGURATION(address, init_data);
	if (temp_threshold_enable = 1 )
	{
		IOWR_ALTERA_AVALON_TEMP_SENSOR_THRESHOLD_LOW (address, temp_threshold_low );
		IOWR_ALTERA_AVALON_TEMP_SENSOR_THRESHOLD_HIGH(address, temp_threshold_high);
	}
	return void;	
}

// read the temperature from sensor 
int altera_avalon_temp_sensor_read_temperature(unsigned int address)
{
	return IORD_ALTERA_AVALON_TEMP_SENSOR_TEMPERATURE(address);
}
