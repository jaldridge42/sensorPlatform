// altera_avalon_temp_sensor_routines.h for HAL
// To define the constants and functions declarations for altera_avalon_ routines.c
#include "altera_avalon_temp_sensor_regs.h"
//#define ALTERA_AVALON_PWM_TYPE (volatile unsigned int*)
void altera_avalon_temp_sensor_config(unsigned int address, unsigned int init_data, unsigned int temp_threshold_enable, unsigned int temp_threshold_low, unsigned int temp_threshold_high);
int altera_avalon_temp_sensor_read_temperature(unsigned int address);
