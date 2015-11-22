/*
Student Name: Ameneh Akbari			IEEE Micromouse Competition
Revision: 6.0						date: 3/31/13
California State University, Northridge
Debug the whole system
 */

	#include <stdio.h>
	#include <stdlib.h>
	#include <stdbool.h>
	#include <io.h>
	#include "alt_types.h"
	#include "altera_avalon_pio_regs.h"
	#include "sys/alt_irq.h"
	#include "system.h"
	#include "sys/alt_stdio.h"
	#include "alt_types.h"
	#include "altera_avalon_spi_regs.h"
	#include "altera_avalon_spi.h"
	#include "altera_avalon_temp_sensor_regs.h"
	#include "altera_avalon_temp_sensor_routines.h"

    #define bool  _Bool
    #define true  1
    #define false 0
    #define DELAY 1000
    #define LONG_DELAY 100000
	#define HEART_SENSOR_ADRS 0x0000
	#define GSR_SENSOR_ADRS 0x0808
	#define TEMPERATURE_REG_CONFIG_DISABLED 0
	#define TEMPERATURE_REG_CONFIG_ENABLED 0
	// 12 bit resolution , 1 bit sign bit => 2^11 = 2048
	// 0111 1111 1111 => 128 degree Centigrade
	// each digital output unit = 128/20148 = 0.0625
	#define TEMP_PRECISION 0.0625
	// CONFIG_DATA for temperature sensor configuration registers
	// OS = 0 => no one shot,
	// R1 R0 = 11 => 12 bit conversion,
	// F1 F0 = 11 => 6 time fault,
	// POL = 1 => alert is active high,
	// TM = 1 => compare mode,
	// SD = 0 => continuous conversion
	#define CONFIG_DATA 0x7C
	//Constants for ADC sensor reading/Stress evaluating
	#define HR_max  1200   //120.0 BPM max
	#define GSR_max  150  //15 megOhm max
	#define HR_min  0
	#define GSR_min  0    //0 megOhm min
	#define m_HR  25 //((HR_max - HR_min)/(3-0)) # slope for linear changes of HR  (40BPM/V => 25mV/BPM)
	#define m_GSR  -200 //((GSR_min - GSR_max)/(3-0)) # slope for linear changes of GSR (3V/15Meg => 200mV/Meg)


    void SPI_write16(alt_u16  c);
    bool  SPI_read16(alt_u16 * data);
    alt_u16 get_sensor_value(alt_u16 address);
    void get_all_sensor_values(alt_u16* heart_rate_sensor, alt_u16* gsr_sensor, alt_u16* temperature, int temp_sensor_address);
    void print_all_sensor_values(alt_u16 heart_rate_sensor, alt_u16 gsr_sensor, alt_u16 temperature_sensor );
	void altera_avalon_temp_sensor_config(unsigned int address, unsigned int init_data, unsigned int temp_threshold_enable, unsigned int temp_threshold_low, unsigned int temp_threshold_high);
	int altera_avalon_temp_sensor_read_temperature(unsigned int address);

	int main()
    {

		alt_u16 heart_rate_value, gsr_value, temperature_value;
    	bool done = false;

		altera_avalon_temp_sensor_config(TEMP_SENSOR_BASE, CONFIG_DATA,TEMPERATURE_REG_CONFIG_DISABLED,0,0); // configure the temperature sensor
	  	while (IORD(PIO_GO_BASE,0)){}// wait for start button

    	while (!done)
    	{
			// get all the sensors together
			get_all_sensor_values(&heart_rate_value, &gsr_value, &temperature_value, TEMP_SENSOR_BASE);
			// print out sensor values
			print_all_sensor_values(heart_rate_value, gsr_value, temperature_value);
			done = true;
    	}
    	return 0;
    }

    // This module is used to write the control data to the A/D through SPI interface.
    // The control data is the address of channel that we want to get data from at that time
    void SPI_write16(alt_u16  c)
    {
    	while (( IORD_ALTERA_AVALON_SPI_STATUS(SPI_ADC_BASE) & ALTERA_AVALON_SPI_STATUS_TRDY_MSK ) == 0) ; // wait till SPI ready to write to tx data
    		IOWR_ALTERA_AVALON_SPI_TXDATA(SPI_ADC_BASE, c); // write to txdata
    }


    bool  SPI_read16(alt_u16 * data)
    {
        int cnt = 0;
        while (( IORD_ALTERA_AVALON_SPI_STATUS(SPI_ADC_BASE) & ALTERA_AVALON_SPI_STATUS_RRDY_MSK ) == 0)
        {
            cnt++;
            usleep(LONG_DELAY);
            if (cnt >= 3)       //give it three chances
                return false ; // signify error
         }
        *(data) = IORD_ALTERA_AVALON_SPI_RXDATA(SPI_ADC_BASE); // read rxdata
        return true; //successful read
    }

    // get the address and give the distance for that address
    // Address for heart rate sensor is 0x0000
    // Address for GSR sensor is 0x0808
    alt_u16 get_sensor_value(alt_u16 address)
    {
    	//alt_u16 garbage =  SPI_read16(); // clear garbage just in case
    	//alt_u16 garbage = IORD_ALTERA_AVALON_SPI_RXDATA(SPI_ADC_BASE);????? replace with this
    	alt_u16 garbage;
    	alt_u16 sensor_value;
    	SPI_write16(address); // set address for desired channel
    	SPI_read16(&garbage);
    	SPI_write16(address); // set address for desired channel
    	while (!SPI_read16(&sensor_value))// wait until you read correctly
    	{
    		SPI_write16(address); // set address for desired channel
    	}
    	SPI_write16(address); // set address for desired channel
    	while (!SPI_read16(&sensor_value))// wait until you read correctly
    	{
    		SPI_write16(address); // set address for desired channel
    	}
    	SPI_write16(address); // set address for desired channel
    	while (!SPI_read16(&sensor_value))// wait until you read correctly
    	{
    		SPI_write16(address); // set address for desired channel
    	}
    	return sensor_value; // reading data from desired channel
    }

    // get all the sensors together
    void get_all_sensor_values(alt_u16* heart_rate_sensor, alt_u16* gsr_sensor, alt_u16* temperature, int temp_sensor_address)
    {
    	*(heart_rate_sensor) = get_sensor_value(HEART_SENSOR_ADRS); //reading from channel0
    	// should add the real heart rate calculation here
    	//HR_value = (template_var / m_HR) + HR_min
    	*(gsr_sensor) = get_sensor_value(GSR_SENSOR_ADRS); //reading from channel1
    	// should add the real gsr value calculation here
    	//GSR_value = template_var / m_GSR + GSR_max
    	*(temperature) = altera_avalon_temp_sensor_read_temperature(temp_sensor_address);
    	// float temperature_real = temperature * TEMP_PRECISION; // real temperature value
    }

    void print_all_sensor_values(alt_u16 heart_rate_sensor, alt_u16 gsr_sensor, alt_u16 temperature_sensor )
    {

		printf("Heart Rate sensor value :  %d  \n", heart_rate_sensor); // print heart rate sensor value
		printf("GSR sensor value:  %d  \n", gsr_sensor); // print GSR sensor value
		printf("Temperature sensor value:  %d  \n", temperature_sensor); // print temperature sensor value
    }

void altera_avalon_temp_sensor_config(unsigned int address, unsigned int init_data, unsigned int temp_threshold_enable, unsigned int temp_threshold_low, unsigned int temp_threshold_high)
{
	IOWR_ALTERA_AVALON_TEMP_SENSOR_CONFIGURATION(address, init_data);
	if (temp_threshold_enable = 1 )
	{
		IOWR_ALTERA_AVALON_TEMP_SENSOR_THRESHOLD_LOW (address, temp_threshold_low );
		IOWR_ALTERA_AVALON_TEMP_SENSOR_THRESHOLD_HIGH(address, temp_threshold_high);
	}
	return;
}

// read the temperature from sensor
int altera_avalon_temp_sensor_read_temperature(unsigned int address)
{
	return IORD_ALTERA_AVALON_TEMP_SENSOR_TEMPERATURE(address);
}








