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
	#include "altera_avalon_temp_sensor_routins.h"	

    #define bool  _Bool
    #define true  1
    #define false 0
    #define DELAY 1000
    #define LONG_DELAY 50000
	#define HEART_SENSOR_ADRS 0x0000
	#define GSR_SENSOR_ADRS 0x0808
	#define TEMPERATURE_REG_CONFIG_DISABLED 0
	#define TEMPERATURE_REG_CONFIG_ENABLED 0

#define HR_MAX 120		//120 BPM
#define TEMP_MAX 41.1	//41.1deg C
#define GSR_MAX 15		//15MegOhm
//Struct with reference values
struct
{
	alt_u16 heartRateReference, gsrReference, temperatureReference; //Reference values for when reference is taken.
} ReferenceValues;

//Struct with threshold values
struct
{
	alt_u16 HR_Yellow, HR_Orange, HR_Red;
	alt_u16 GSR_Yellow, GSR_Orange, GSR_Red;
	alt_u16 TEMP_Yellow, TEMP_Orange, TEMP_Red;

}ThresholdValues;
bool referenceTaken = false;

	// CONFIG_DATA for temperature sensor configuration registers
	// OS = 0 => no one shot, 
	// R1 R0 = 11 => 12 bit conversion, 
	// F1 F0 = 11 => 6 time fault, 
	// POL = 1 => alert is active high, 
	// TM = 1 => compare mode, 
	// SD = 0 => continuous conversion
	#define CONFIG_DATA 0x7C 


    void SPI_write16(alt_u16  c);
    bool  SPI_read16(alt_u16 * data);
    alt_u16 get_sensor_value(alt_u16 address);
    void get_all_sensor_values(alt_u16* heart_rate_sensor, alt_u16* gsr_sensor, alt_u16* temperature, int temp_sensor_address);
    void print_all_sensor_values(alt_u16 heart_rate_sensor, alt_u16 gsr_sensor, alt_u16 temperature_sensor );
	void altera_avalon_temp_sensor_config(unsigned int address, unsigned int init_data, unsigned int temp_threshold_enable, unsigned int temp_threshold_low, unsigned int temp_threshold_high);
	int altera_avalon_temp_sensor_read_temperature(unsigned int address);
	void setThresholdValues(alt_u16 heartRateRef, alt_u16 gsrRef, alt_u16 temperatureRef);	//Sets reference/threshold values
	alt_u16 detectMood(alt_u16 heartRate, alt_u16 gsr, alt_u16 temperature);					//Detects mood 1 = Relaxed, 2 = yellow, 3 = orange, 4  = red

	int main()
    {

		alt_u16 heart_rate_value, gsr_value, temperature_value;
    	bool done = false;

		altera_avalon_temp_sensor_config(TEMP_SENSOR_BASE, CONFIG_DATA,TEMPERATURE_REG_CONFIG_DISABLED,0,0); // configure the temperature sensor	
	  	while (IORD(PIO_GO_BASE,0)){}// wait for start button
		
    	while (!done)
    	{
			usleep(1000000); //1 second between readings

			// get all the sensors together
			get_all_sensor_values(&heart_rate_value, &gsr_value, &temperature_value, TEMP_SENSOR_BASE);

			//For simplicity, make the first readings of the values the reference values:
			if (!referenceTaken)
			{
				printf("Reference values:\n");
				setThresholdValues(heart_rate_value, gsr_ value, temperature_value);
			}
			// print out sensor values
			print_all_sensor_values(heart_rate_value, gsr_value, temperature_value);

			pritf("Mood: %d\n", detectMood(heart_rate_value, gsr_value, temperature_value));

			
			//done = true;
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
            usleep(100000);
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
    	alt_u16 garbage, temp;
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
    	*(gsr_sensor) = get_sensor_value(GSR_SENSOR_ADRS); //reading from channel1
    	*(temperature) = altera_avalon_temp_sensor_read_temperature(temp_sensor_address);
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
	return void;	
}

// read the temperature from sensor 
int altera_avalon_temp_sensor_read_temperature(unsigned int address)
{
	return IORD_ALTERA_AVALON_TEMP_SENSOR_TEMPERATURE(address);
}	

//Sets warning levels
void setThresholdValues(alt_u16 heartRateRef, alt_u16 gsrRef, alt_u16 temperatureRef)
{
	//Set reference values
	ReferenceValues.heartRateReference = heartRateRef;
	ReferenceValues.gsrReference = gsrRef;
	ReferenceValues.temperatureReference = temperatureRef;


	//For HR yellow area is 10BPM above ref
	ThresholdValues.HR_Yellow = heartRateRef + 10.;
	float levelSeparation = (HR_MAX - ThresholdValues.HR_Yellow) / 3;
	ThresholdValues.HR_Orange = ThresholdValues.HR_Yellow + levelSeparation;
	ThresholdValues.HR_Red = ThresholdValues.HR_Orange + levelSeparation;

	//for temperature, 1 degree C above reference
	ThresholdValues.TEMP_Yellow = temperatureRef + 1;
	levelSeparation = (TEMP_MAX - ThresholdValues.TEMP_Yellow) / 3;
	ThresholdValues.TEMP_Orange = ThresholdValues.TEMP_Yellow + levelSeparation;
	ThresholdValues.TEMP_Red = ThresholdValues.TEMP_Orange + levelSeparation;

	//for gsr, 3 MegOhm under reference
	ThresholdValues.GSR_Yellow = gsrRef - 3;
	levelSeparation = (ThresholdValues.GSR_Yellow) / 3;
	ThresholdValues.GSR_Orange = ThresholdValues.GSR_Yellow - levelSeparation;
	ThresholdValues.GSR_Red = ThresholdValues.GSR_Orange - levelSeparation;
}

//Sets warning levels
alt_u16 detectMood(alt_u16 heartRate, alt_u16 gsr, alt_u16 temperature)
{
	if (gsr <= ThresholdValues.GSR_Yellow)
	{
		if (heartRate >= ThresholdValues.HR_Yellow && heartRate < ThresholdValues.HR_Orange)
		{
			return 2;//Yellow
		}
		else if (heartRate >= ThresholdValues.HR_Orange && heartRate < ThresholdValues.HR_Red)
		{
			return 3;//Orange
		}
		else if (heartRate >= ThresholdValues.HR_Red)
		{
			return 4; //Red
		}
	}
	return 1; //Relaxed
}





