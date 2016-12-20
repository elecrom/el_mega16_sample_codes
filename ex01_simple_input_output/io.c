/*****************************************************
Chip type           : ATmega16
Program type        : Application
Clock frequency     : 16.000000 MHz
Memory model        : Small
External RAM size   : 0
Data Stack size     : 256

What does this program do ?
###########################

- It will monitor SW1 and SW2 on the kit
- When SW1 is pressed, LEDs will be flashed in one
  pattern.
  When SW2 is pressed, LEDs will be flashed in another
  pattern
*****************************************************/
#include <mega16.h>
#include <delay.h>

unsigned char A[8]={1,2,4,8,16,32,64,128};
unsigned char B[8]={2,8,32,128,1,4,16,64};
unsigned char i;

void main()
{
DDRB=0xFF; 					//portb will be used for outputing data
PORTB=0;   					//Cleaning portb

DDRC =0b00000000; 		//portc will be used for input
PORTC=0b00001100;       //PC2,PC3 > Pulled up

while(1)
{
	if(PINC.2==0) 			//if 1st button is pressed(grounded)
	{
		for(i=0;i<8;i++)
		{
			PORTB=A[i];
			delay_ms(500);
		}
	}
	else if(PINC.3==0) 	//if 2nd button is pressed(grounded)
	{
		for(i=0;i<8;i++)
		{
			PORTB=B[i];
			delay_ms(500);
		}
	}

};
}
