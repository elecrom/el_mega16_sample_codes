


/*
	FreeRTOS.org V5.0.4 - Copyright (C) 2003-2008 Richard Barry.

	This file is part of the FreeRTOS.org distribution.

	FreeRTOS.org is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.

	FreeRTOS.org is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with FreeRTOS.org; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

	A special exception to the GPL can be applied should you wish to distribute
	a combined work that includes FreeRTOS.org, without being obliged to provide
	the source code for any proprietary components.  See the licensing section 
	of http://www.FreeRTOS.org for full details of how and when the exception
	can be applied.

    ***************************************************************************
    ***************************************************************************
    *                                                                         *
    * SAVE TIME AND MONEY!  We can port FreeRTOS.org to your own hardware,    *
    * and even write all or part of your application on your behalf.          *
    * See http://www.OpenRTOS.com for details of the services we provide to   *
    * expedite your project.                                                  *
    *                                                                         *
    ***************************************************************************
    ***************************************************************************

	Please ensure to read the configuration and relevant port sections of the
	online documentation.

	http://www.FreeRTOS.org - Documentation, latest information, license and 
	contact details.

	http://www.SafeRTOS.com - A version that is certified for use in safety 
	critical systems.

	http://www.OpenRTOS.com - Commercial support, development, porting, 
	licensing and training services.
*/

/*
 * Creates all the demo application tasks, then starts the scheduler.  The WEB
 * documentation provides more details of the demo application tasks.
 * 
 * Main. c also creates a task called "Check".  This only executes every three 
 * seconds but has the highest priority so is guaranteed to get processor time.  
 * Its main function is to check that all the other tasks are still operational.  
 * Each task that does not flash an LED maintains a unique count that is 
 * incremented each time the task successfully completes its function.  Should 
 * any error occur within such a task the count is permanently halted.  The 
 * check task inspects the count of each task to ensure it has changed since
 * the last time the check task executed.  If all the count variables have 
 * changed all the tasks are still executing error free, and the check task
 * toggles an LED.  Should any task contain an error at any time the LED toggle
 * will stop.
 *
 * The LED flash and communications test tasks do not maintain a count.
 */

/*
Changes from V1.2.0
	
	+ Changed the baud rate for the serial test from 19200 to 57600.

Changes from V1.2.3

	+ The integer and comtest tasks are now used when the cooperative scheduler 
	  is being used.  Previously they were only used with the preemptive
	  scheduler.

Changes from V1.2.5

	+ Set the baud rate to 38400.  This has a smaller error percentage with an
	  8MHz clock (according to the manual).

Changes from V2.0.0

	+ Delay periods are now specified using variables and constants of
	  portTickType rather than unsigned portLONG.

Changes from V2.6.1

	+ The IAR and WinAVR AVR ports are now maintained separately.

Changes from V4.0.5

	+ Modified to demonstrate the use of co-routines.

*/

#include <stdlib.h>
#include <string.h>
#include <avr/io.h>
#include <avr/sfr_defs.h>
#include <avr/power.h>

#ifdef GCC_MEGA_AVR
	/* EEPROM routines used only with the WinAVR compiler. */
	#include <avr/eeprom.h> 
#endif

/* Scheduler include files. */
#include "FreeRTOS.h"
#include "task.h"
//#include "croutine.h"

/*-----------------------------------------------------------*/
void vLED_1(void *param)
{
	while(1)
	{
		PORTB = PORTB ^ _BV(0); //>>0b00000001
		vTaskDelay(500);		
	};
}
/*-----------------------------------------------------------*/
void vLED_2(void *param)
{
	while(1)
	{
		PORTB = PORTB ^ _BV(1);
		vTaskDelay(250);		
	};
}
/*-----------------------------------------------------------*/
void vLED_3(void *param)
{
	while(1)
	{
		PORTB = PORTB ^ _BV(2);
		vTaskDelay(125);		
	};
}

/*-----------------------------------------------------------------------------*/
void vApplicationIdleHook(void)
{
	//PORTC = PORTC ^ 1;
	//Enable Sleep mode
	//MCUCR = 0b01000000;
	//asm volatile("sleep \n\t");
	while(1);
}


/*-----------------------------------------------------------------------------*/
//AVR Initialization
void AVR_init()
{
	DDRB =  0b11111111;
	PORTB = 0b00000000;
	
	DDRC  = 0b00000001;
	PORTC = 0;	
	
}

/*-----------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------*/

portSHORT main( void )
{
	xTaskHandle xH1,xH2,xH3;
	
	AVR_init(); 
	
		 
	xTaskCreate(vLED_1,(const portCHAR *)"T1",configMINIMAL_STACK_SIZE,NULL,1,xH1);
	xTaskCreate(vLED_2,(const portCHAR *)"T2",configMINIMAL_STACK_SIZE,NULL,2,xH2);
	xTaskCreate(vLED_3,(const portCHAR *)"T3",configMINIMAL_STACK_SIZE,NULL,3,xH3);
		
	/* In this port, to use preemptive scheduler define configUSE_PREEMPTION 
	as 1 in portmacro.h.  To use the cooperative scheduler define 
	configUSE_PREEMPTION as 0. */
	vTaskStartScheduler();

	return 0;
}
/*-----------------------------------------------------------*/

