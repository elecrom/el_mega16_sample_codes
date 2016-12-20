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


