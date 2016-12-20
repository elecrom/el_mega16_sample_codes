/*****************************************************
This program was produced by the
CodeWizardAVR V1.24.8d Professional
Automatic Program Generator
© Copyright 1998-2006 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 8/9/2007
Author  : F4CG                            
Company : F4CG                            
Comments: 


Chip type           : ATmega16
Program type        : Application
Clock frequency     : 16.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256
*****************************************************/

#include <mega32.h> 
#include <delay.h>

// Standard Input/Output functions
#include <stdio.h>  
#include <stdlib.h>

#define	irPORT	PORTC
#define	irPIN		PINC
#define	irDDR		DDRC
#define	irBIT		6

#include "../include/ir.h" 

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>    


#include "../include/myi2c.c"
/*_______________________________________________________________________________*/
/*										   		My_I2C.H		   				    			 	*/
/*-------------------------------------------------------------------------------*/
/* Description : I2C interfacing using onchip TWI									 		*/
/* AUTHOR : Omkar C Kulkarni                                                     */
//NOTICE  : NO PART OF THIS CODE SHOULD BE                                       //
//¯¯¯¯¯¯¯¯  COPIED  WITHOUT  PERMISSION OF                                       //
//          AUTHOR.                                                              //
/*_______________________________________________________________________________*/

#ifndef	_MYI2C_H_
	#define	_MYI2C_H_

//To simplyfy checking of flags. 

#define	TWINT		7	
#define	TWEA		6
#define	TWSTA		5
#define	TWSTO		4
#define	TWWC		3
#define	TWEN		2
#define 	TWIE		0

//Mask prescaler bits and return only status bits
#define	TWS		(TWSR & 0b11111000)     


//status codes
#define START			0x08
#define RSTART			0x10
	   
#define SLA_W_ACK    0x18      
#define SLA_R_ACK		0x40

#define DATA_TXACK	0x28
#define DATA_TXNOACK	0x30


    
#define SLA_W	0xA0
#define SLA_R	0xA1



//___________________________________________________________________________________
//# To send start condition.
//return : 1 : if successful
//			  0 : if unsuccessful

//unsigned char i2c_start(void)
unsigned char my_i2c_start(void)
{
	
	//send start condition by writing logical one to TWINT (to clear it), TWSTA, TWEN
	TWCR =  (1<<TWINT) | (1<<TWSTA) | (1<<TWEN);
	
	//wait for TWINT flag set (i.e. to become one)
	while( (TWCR & (1<<TWINT))==0);               
	
	//check value of TWI status register if it is diffrent from START, return error
	if((TWS == START) || (TWS==RSTART))
	{
		//PORTD.2=1;				//### 
		//PORTD.1=0;				//###	
		return 1;
	}
	else                                                                              
	{
		//PORTD.1=1;				//###	
		//PORTD.2=0;				//### 	
		return 0;
	}
}

//___________________________________________________________________________________
//# To send stop condition
//void i2c_stop(void)
void my_i2c_stop(void)
{
 	//send STOP condition
 	TWCR	= (1<<TWINT) | (1<<TWSTO) | (1<<TWEN);  
 	
 	//wait till STOP condition is executed
 	//while( (TWCR & (1<<TWSTO))!=0);     
 	
 	//there is some problem in detection of END of STOP transmission hence
 	//delay is being used. 
 	delay_us(40);
}

//________________________________________________________________________________
//#writes one byte to I2C bus
//return : 1 : if slave acknowledges
//			  0 : if not
//unsigned char	i2c_write(unsigned char b)
unsigned char	my_i2c_write(unsigned char b)
{
	//load data
	TWDR = b;  
	
	//start transmission
	TWCR = (1<<TWINT) | (1<<TWEN);
	
	//wait till transmission is finished
	while((TWCR & (1<<TWINT))==0);
	
	//check whether ACK is received or not
	if( (TWS == SLA_W_ACK) || (TWS == DATA_TXACK) || (TWS == SLA_R_ACK))
	{	
		//PORTD.1=1;       //###
	//	PORTD.2=0;        //###
		return 1;
	
	}
	else
	{
		//PORTD.1=0;       //###
		//PORTD.2=1;        //###
		return 0; 
	}
			
}
  
//________________________________________________________________________________
//#reads one byte from I2C bus
//params : a=1 : sends acknowledge
//			  a=0 : doesn't send ACK
//return : byte received
//unsigned char	i2c_read(unsigned char a)
unsigned char	my_i2c_read(unsigned char a)
{
	if(a==1)
	{
		//start data reception with ACK generation
   	TWCR = (1<<TWINT) | (1<<TWEA) | (1<<TWEN);
//		TWCR = 0b11000100;
	                                          
		//wait for transmission to complete
		while( (TWCR & (1<<TWINT))==0);
	
		return	TWDR;
	}
	else if(a==0)
	{
   	//start data reception with NOACK
   	TWCR = (1<<TWINT) | (1<<TWEN);
//		TWCR = 0b10000100;
	                                          
		//wait for transmission to complete
		while( (TWCR & (1<<TWINT))==0);
	
		return	TWDR;
	}
}

//________________________________________________________________________________
#endif


#include "../include/eeprommyi2c.c"
/*________________________________________________________________________________*/
/*										   		EEPROMMyi2c.H 				    						 */
/*--------------------------------------------------------------------------------*/
/* Description : 32KB eeprom access functions.												 */
/* AUTHOR : Omkar C Kulkarni                                                      */
//NOTICE  : NO PART OF THIS CODE SHOULD BE                                        //
//¯¯¯¯¯¯¯¯  COPIED  WITHOUT  PERMISSION OF                                        //
//          AUTHOR.                                                               //
/*________________________________________________________________________________*/

#ifndef	_EMYI2C_H_

	#define _EMYI2C_H_


unsigned int readRecord(unsigned int add,unsigned char *bAdd);
unsigned int getNextRecord(unsigned int add);
unsigned int getPrevRecord(unsigned int add);
unsigned int readInt(unsigned int add);   
void writeByte(unsigned char eB,unsigned int add);
unsigned char readByte(unsigned int add);


unsigned char iH,				//High byte of add
			  		iL,       	//Low byte of add
              my_i2c_rv;   	//Buffer to store data read
//              DBuff[25],

unsigned int t,
				i1=0,i2=0;		//To hold integer used by readInt().   
//EADD=0,

				

#define EEP_ADD 0xa0              
              
/*Function to read one record from eeprom, starting from current address. */
/*-Each record is seperated by NULL										  */
/*-Function will return size of current record(i.e. number of bytes read )*/
unsigned int readRecord(unsigned int add,unsigned char *bAdd)
{                      	
unsigned int addOLD;	
	
	my_i2c_stop();	
	
	addOLD=add;	
	iL=(unsigned char)add & 0x00FF;    				//split given address to high and low bytes
	t=(unsigned int)add & 0xFF00;  					//
	t=t>>8;                             			//
	iH=(unsigned char)t;                         //

	//my_i2c_start();
	while(my_i2c_start()==0)
	{	my_i2c_stop();};
	my_i2c_write(EEP_ADD);
	my_i2c_write(iH);
	my_i2c_write(iL);
	my_i2c_start();
	my_i2c_write(EEP_ADD|1);			//Read the eeprom  
         
	while(1)
	{
		*bAdd=my_i2c_read(1);
		if(*bAdd==0)
			break;

		bAdd++;
		add++;
	};
	
	my_i2c_read(0);		
	my_i2c_stop();
	
	return (add-addOLD);
}

/************************************************************************************************/
/*This function will return address of next record, from current record					*/
//-It will seek to 00, as it founds 00, address next to 00 will be returned.
unsigned int getNextRecord(unsigned int add)
{                      	
	
	iL=(unsigned char)add & 0x00FF;    				//split given address to high and low bytes
	t=(unsigned int)add & 0xFF00;  					//
	t=t>>8;                             			//
	iH=(unsigned char)t;                            //
	
	while(my_i2c_start()==0)
	{	my_i2c_stop();};
	my_i2c_write(EEP_ADD);
	my_i2c_write(iH);
	my_i2c_write(iL);
	my_i2c_start();
	my_i2c_write(EEP_ADD|1);			//Read the eeprom  

	while(1)
	{
		if(my_i2c_read(1)==0)
			break;
		add++;
	};
	
	my_i2c_read(0);		
	my_i2c_stop();
	
	add++;								//now add is pointing to next record in EEPROM
	
	return (add);
}

/************************************************************************************************/
/*This function will return address of Previous record, from current record					*/
//-It will seek to 00, as it founds 00, address next to 00 will be returned.
//
//e.g:  ... 22 00 22 33 55 22 65 66 67 00  11 11 22 22 55 98 98 98 00 22 33 ...
//																							 |
//                                                                   add of curr rec.
unsigned int getPrevRecord(unsigned int add)
{                      	
	add=add-2;													//to skip 00 before every record
   
  	my_i2c_stop();           
	
	while(1)
	{  
		delay_us(4);
		
		iL=(unsigned char)add & 0x00FF;    				//split given address to high and low bytes
		t=(unsigned int)add & 0xFF00;  					//
		t=t>>8;                             			//
		iH=(unsigned char)t;                         //

		my_i2c_start();
		my_i2c_write(EEP_ADD);
		my_i2c_write(iH);
		my_i2c_write(iL);
		my_i2c_start();
		my_i2c_write(EEP_ADD|1);								//Read the eeprom  

		if(my_i2c_read(0)==0)
			break;         
		
		my_i2c_stop();
		
		add--;
	};
	
	my_i2c_read(0);		
	my_i2c_stop();
	
	add++;														//now add is pointing to next record in EEPROM
	
	return (add);
}



/************************************************************************************************/
/*This function will read integer(i.e. 2Bytes) starting from given address			*/
/*-This is used to read train numbers and eeprom address stored in the EEPROM in	*/
/* binary format e.g. 1104 will be stored directly as "11 04"(dec) "0B 04"(hex)	*/

unsigned int readInt(unsigned int add)
{

	iL=(unsigned char)add & 0x00FF;    				//split given address to high and low bytes
	t=(unsigned int)add & 0xFF00;  					//
	t=t>>8;                             			//
	iH=(unsigned char)t;                         //

	my_i2c_stop();	
	my_i2c_start();
	my_i2c_write(EEP_ADD);
	my_i2c_write(iH);
	my_i2c_write(iL);
	my_i2c_start();
	my_i2c_write(EEP_ADD|1);							//Read the eeprom  
	
	i1=my_i2c_read(1);
	i2=my_i2c_read(0);
	
	my_i2c_stop();
	
return(((unsigned int)i1*0x100+(unsigned int)i2));//return correct int.
//e.g. i1=11,i2=04 => 1104
//i.e (11 *100) + (4) = 1104
}

/************************************************************************************************/
/*This function will read single byte from EEPROM at the given address */
unsigned char readByte(unsigned int add)
{

	iL=(unsigned char)add & 0x00FF;
	t=(unsigned int) add & 0xFF00;
	t=t>>8;
	iH=(unsigned char)t;
	
	my_i2c_rv=0;            
	while(my_i2c_rv==0)
	{
    	while(my_i2c_start()==0);         		 //wait till bus is free
	    
		my_i2c_rv=my_i2c_write(EEP_ADD);
    	if(my_i2c_rv==1)               			 //if slave acknowledges
	        break;   
    };
   
	my_i2c_write(iH);
	my_i2c_write(iL);
	my_i2c_start();
	my_i2c_write(EEP_ADD | 1);
   
	i1=my_i2c_read(0);
	
	my_i2c_stop(); 

	return i1;
}    
/************************************************************************************************/
/*This function will write single byte at the given address */        
void writeByte(unsigned char eB,unsigned int add)
{    
	iL=(unsigned char)(add & 0x00FF);
	t=(unsigned int) (add & 0xFF00);
	t=t>>8;
	iH=(unsigned char)t;
	
	my_i2c_rv=0;        
	my_i2c_stop();       

	while(my_i2c_rv==0)
	{
    	while(my_i2c_start()==0);          //wait till bus is free
	    
	    my_i2c_rv=my_i2c_write(EEP_ADD);
    	if(my_i2c_rv==1)                   //if slave acknowledges
	        break; 
    };
   
	my_i2c_write(iH);
	my_i2c_write(iL);
	my_i2c_write(eB);
	my_i2c_stop();
	
	delay_ms(5);	 							//This is required as EEPROM takes 5ms to complete
													//write operation
}


#endif









/*
// I2C Bus functions
#asm
   .equ __i2c_port=0x15 ;PORTC
   .equ __sda_bit=1
   .equ __scl_bit=0
#endasm
#include <i2c.h>
#include   "../include/eeprom.h"
  */



#define ADC_VREF_TYPE 0x60   

unsigned int i; 
unsigned char j;
unsigned char adc_val;
unsigned char lcdPresent;
unsigned int adc_volt;


//_____________________________________________________________________________________
// Read the 8 most significant bits
// of the AD conversion result
unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input|ADC_VREF_TYPE;
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
}   

//_______________________________________________________________________________________
//# To display given number at given location on LCD
void display_num(unsigned char nX,unsigned char nY,unsigned int nNum)
{
unsigned char *stnum="000000";
	
	ltoa(nNum,stnum);
	lcd_gotoxy(nX,nY);
	lcd_puts(stnum);

 return;
}

//_____________________________________________________________________________________
// Timer 1 overflow interrupt service routine
//# This will flash LED on PORTB.7 at a rate of 1Hz.
//  -Interrupt period 	= Timer Clk period * (65536 - TCNT1 )
//	 						 	= (1/15625) * (65536 - 57723)
//							 	= 64uS  * 7813
//							 	= 500.032s => 0.5 sec
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
	TCNT1 = 57723;

	// Place your code here                      
	PORTB.3 = !PORTB.3;

}

//_____________________________________________________________________________________
//I2C test routine, with output messages on LCD and UART.
void i2c_test_withLCD()
{                        
unsigned char tmp;

	//I2C test   
   lcd_clear();
	lcd_putsf("Write:");
	printf("\r\nWrite:");
	tmp=(TCNT1 & 0x0F)+65;
	for(i=0;i<26;i++)
	{
      #asm("cli");					//disable all interrupts
		writeByte(i+tmp,i);
		#asm("sei");         		//enable all interrupts
		lcd_putchar(i+tmp);
		putchar(i+tmp);			 
		delay_ms(300);
	}
      
	delay_ms(1000); 
   lcd_clear();
	delay_ms(500);
	lcd_putsf("Read :");
	printf("\r\nRead:");				
	for(i=0;i<26;i++)
	{
      #asm("cli");					//disable all interrupts
		j = readByte(i);  
		#asm("sei");         		//enable all interrupts
		lcd_putchar(j); 
		putchar(j);		
		delay_ms(300);
	}
		  
	delay_ms(3000); 

}

//_____________________________________________________________________________________
//I2C test routine. Output messages only on UART
void i2c_test()
{          
unsigned char tmp;
	
	//I2C test
	//i2c_init();     
	//i2c_init();
	printf("\r\nWrite:");
	tmp=(TCNT1 & 0x0F)+65;
	for(i=0;i<26;i++)
	{
		writeByte(i+tmp,i);
		putchar(i+tmp);			 
		delay_ms(300);
	}
      
	delay_ms(1000); 
	printf("\r\nRead:");				
	for(i=0;i<26;i++)
	{
		j = readByte(i);
		putchar(j);		
		delay_ms(300);
	}
		  
	delay_ms(3000); 
}

//_____________________________________________________________________________________
//L293D test routine. for L293D connected on PORTD.
void l293d1_test()
{
	//#L293D test : 
	printf("\r\nL293D_1 Test ... ");

	PORTD.4=1;								//start motors..
	PORTD.6=0;
	PORTD.5=1;
	PORTD.7=0;	
	delay_ms(3000);

	PORTD.4=0;								//reverse direction
	PORTD.6=1;
	PORTD.5=0;
	PORTD.7=1;	                       
	delay_ms(3000);

	PORTD.4=0;								//stop motors
	PORTD.5=0;
	PORTD.6=0;
	PORTD.7=0;

	printf(" done");
}

//_____________________________________________________________________________________
//L293D test routine.for L293D connected on PORTB.
void l293d2_test()
{
	//#L293D test : 
	printf("\r\nL293D_2 Test ... ");

	DDRB=0x0F;								//set lower nibble of PORTB as output
	PORTB=0x00;

	PORTB.0=1;                       //start motors in one direction
	PORTB.1=0;
	PORTB.2=1;
	PORTB.3=0;
	delay_ms(3000);

	PORTB.0=0;                       //reverse directions
	PORTB.1=1;
	PORTB.2=0;
	PORTB.3=1;
	delay_ms(3000);

	PORTB.0=0;                       //stop motors
	PORTB.1=0;
	PORTB.2=0;
	PORTB.3=0;     

	printf(" done");
}


//_____________________________________________________________________________________
//LCD test routine
void lcd_test()
{
unsigned char j,k;   
unsigned char rows=4;
unsigned char cols=20;	   

	//#LCD TEST		: 
	printf("\r\nLCD_test");
	lcd_init(cols); 
	lcd_clear();
                
	lcd_gotoxy((cols/2)-3,(rows/2)-1);
	lcd_putsf("MEGA16");
	lcd_gotoxy((cols/2)-7,(rows/2));
	lcd_putsf("DEVELOPMENT BRD");
	delay_ms(1000);

}

//_____________________________________________________________________________________
//Test on board LEDs if LCD is not present   
void led_test()
{
	//#LED TEST   :   
	printf("\r\nLED Test ... ");
	i = 1;
	for(i=1;i<0x0100;)
	{
		PORTB=(unsigned char)i;
		delay_ms(200); 
		i = i<<1;		
	}                
   PORTB=0x00;
	printf(" done");   
}

//_____________________________________________________________________________________
//Test the ADC.
void adc_test()
{
	//#ADC test
	printf("\r\nADC Test ...");

	//this will read input voltage on each ADC port, 3 times, and will output it.
	for(j=0;j<3;j++)
	{
		for(i=0;i<6;i++)
		{
			adc_val = read_adc(i);
			adc_volt = (adc_val * 195.3)/10;
			printf("\r\nCH %d: %03d => %04d mV",i,adc_val,adc_volt);
		}
		delay_ms(500); 
		printf("\r\n");
	}	

   printf("\r\n\n# DONE.");     
}


//_____________________________________________________________________________________
//Infrared remote test ..
//This routine will call above functions based on a keyPress
void ir_test()
{
	printf("\r\n\n Now press keys on remote\r\n");	
	if(lcdPresent)
	{
		lcd_clear();
		lcd_putsf("Press remote keys");
	}
	
	while(1)
	{
		i = getKeyIR();
		printf("\r\n\nKey : %d ",i);
		if(lcdPresent)
		{
			lcd_clear();
			display_num(0,0,i);
		}

		//Process the keys ...
		switch(i)
		{
			//Key 0: Execute LCD test 
			case 0:
					lcd_test();
					break;
                                                    
			//Key 1: L293D 1 test
			case 1:
					l293d1_test();
					break;

			//Key 2: L293D 2 test
			case 2:
					l293d2_test();
					break;    

			//Key 3: ADC Test
			case 3:   
					adc_test();	
					break;
			                               
			//Key 4 : LED test
			case 4:
					led_test();
					break;
			
			//Key 5: I2C test without LCD
			case 5:
					i2c_test();
					break;
			
			//Key 6: I2C test with LCD
			case 6:
					i2c_test_withLCD();
					break;
			default:
					break;
		}                          
	};
}


//_____________________________________________________________________________________
void main(void)
{
// Declare your local variables here


////disable watchdog
//WDTCR = 0b00011000;
//WDTCR = 0b00010000;

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0xFF;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0xFC;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;


// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 15.625 kHz
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x05;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer 2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x04;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud rate: 56000
UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x11;



// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 250.000 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: None
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE;
ADCSRA=0x86;  

//Initialize I2C bus                      
//i2c_init();           
    
// 2 Wire Bus initialization
// Generate Acknowledge Pulse: Off
// 2 Wire Bus Slave Address: 0h
// General Call Recognition: Off
// Bit Rate: 100.000 kHz
TWSR=0x00;
TWBR=0x48;
TWAR=0x00;
TWCR=0x04;




// Global enable interrupts
#asm("sei")
                     

while (1)
      {

		//#MAX 232 TEST :
		printf("\r\n\n\nMega16 development board for project/product/robotics development");		                
		

		//#Wait for SW0(PC.2) press for LCD detection. If user presses the SW0 within 3 seconds then
		//LCD is assumed to be present and LCD test routines will be run and visual feebback will 
		//be displayed on LCD. If not, then LCD is assumed to be absent.
		i=0;     
		DDRC.2=0; 				//set 2nd bit of PC as input bit
		PORTC.2=1;				//turn on internal pull-up for that bit 
		while(i<3000)
		{
			if(PINC.2==0)
			{
				lcdPresent = 1;
				break;
			}
			else
				lcdPresent = 0;                                    

			i++;
			delay_ms(1);
		};
             
      if(lcdPresent==1)
			printf("\n\rLCD is assumed to be present.");		
		else
			printf("\n\rLCD is assumed to be absent.");			
		
		
		//# If LCD is present ... initialize the LCD and display message and execute test routines
		if(lcdPresent==1)
		{
       	//Initialize and test LCD
			lcd_test();     
                      
			//Test the L293D
			l293d1_test();
			                
			//Test the ADC
			adc_test();     

			//Now wait for key press on IR remote. And execute test routines according to remote key press.
			ir_test();
		}

		//# If LCD is absent we can also test 2nd L293D which is connected on PORTB.
		else
		{   
       	//Initialize and test LCD
			led_test();   
                      
			//Test the L293D
			l293d1_test();  
			l293d2_test();  
			                
			//Test the ADC
			adc_test();     

			//Now wait for key press on IR remote. And execute test routines according to remote key press.
			ir_test(); 
		}
                    	

		while(1);

      };
}
