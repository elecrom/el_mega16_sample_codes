/*****************************************************
Chip type           : ATmega16
Program type        : Application
Clock frequency     : 16.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256
*****************************************************/

#define	LM_FOR	PORTD.6=0;PORTD.4=1;
#define	RM_FOR	PORTD.5=0;PORTD.7=1;

#define	LM_REV	PORTD.6=1;PORTD.4=0;
#define	RM_REV	PORTD.5=1;PORTD.7=0;

#define	LM_OFF	PORTD.6=0;PORTD.4=0;
#define	RM_OFF	PORTD.5=0;PORTD.7=0;


unsigned char sensors[7];

//front left and front right
#define	FL	sensors[1]
#define	FR	sensors[5]

//rear left and rear right
#define	RL	sensors[2]
#define	RR	sensors[3]



unsigned char adcch;
unsigned char tmp;
unsigned char dir;

#define	LEFT	0
#define	RIGHT	1


#define	THRE	100

#define ADC_VREF_TYPE 0x60


#include <mega16.h>
#include<delay.h>
#include<stdlib.h>

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here
TCNT0=128;

	//Read the result
	ADCSRA|=0x10;
	tmp = ADCH;

	//compare
	if(tmp>THRE)
		sensors[adcch]=1;
	else
		sensors[adcch]=0;

	//point to next
	if(adcch>=5)
		adcch=1;
	else if(adcch==1)
		adcch=2;
	else if(adcch==2)
		adcch=3;
	else if(adcch==3)
		adcch=5;
	else
		adcch=1;

	//start next conversion
	ADMUX=adcch|ADC_VREF_TYPE;
	// Start the AD conversion
	ADCSRA|=0x40;

	PORTB = (FL<<1) | (FR<<2) | (RL<<5) | (RR<<6);

}



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

/*
// Declare your global variables here
void follow_track()
{
	if(sensors[1]==1 && sensors[2]==1)
	{
		LM_ON;
		RM_ON;
	}
	else if(sensors[1]==0 && sensors[2]==1)
	{
		LM_ON;
		RM_OFF;
		dir=LEFT;
	}
	else if(sensors[1]==1 && sensors[2]==0)
	{
		LM_OFF;
		RM_ON;
		dir=RIGHT;
	}
	else if(sensors[1]==0 && sensors[2]==0)
	{
		if(dir==LEFT)
		{
			LM_ON;
			RM_OFF;
		}
		else if(dir==RIGHT)
		{
			LM_OFF;
			RM_ON;
		}
	}
}
*/

unsigned int dCtr;									//counter for delay
unsigned char TMOUT = 90;

//To detect edge
void edge_detect(void)
{

	//if all snesors are 1 means robo is on surface
	if(FL==1 && FR==1 && RL==1 && RR==1)
	{
		RM_FOR;
		LM_FOR;
	}

	//if front left goes out...	>> take RTrn, while keeping RL on table.
	else if(FL==0 && FR==1 && RL==1 && RR==1)
	{
		//move back slightly
		LM_REV;RM_REV;delay_ms(600);

		//take turn
		RM_REV;LM_OFF;dCtr=0;
		while(RL==1 && RR==1 && dCtr<TMOUT)
		{
			delay_ms(10);
			dCtr++;
		};

	}

	//if front right goes out...	>> take LTrn, while keeping RR on table.
	else if(FL==1 && FR==0 && RL==1 && RR==1)
	{
		//move back slightly
		LM_REV;RM_REV;delay_ms(600);

		//take turn
		RM_OFF;LM_REV;dCtr=0;
		while(RR==1 && RL==1 && dCtr<TMOUT)
		{
			delay_ms(10);
			dCtr++;
		}

	}

	//if RR and RL both out ...	>> go forward a bit
	else if(FL==1 && FR==1 && RL==0 && RR==0)
	{
		RM_FOR;LM_FOR;dCtr=50;
		while(dCtr<70)
		{
			delay_ms(10);
			dCtr++;
		};

	}

	if((rand() & 1)==0)
		TMOUT = 80;
	else
		TMOUT = 110;

}


void main(void)
{



delay_ms(500);


// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
PORTB=0x55;
DDRB=0xFF;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTC=0x07;
DDRC=0x00;

// Port D initialization
PORTD=0x00;
DDRD=0xFF;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 250.000 kHz
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x03;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer 1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
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
TIMSK=0x01;

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


adcch=0;

// Global enable interrupts
#asm("sei")

//Process keys
dCtr=0;
while(1)
{
	delay_ms(200);
	dCtr++;
	srand(dCtr);

	if(PINC.0==0)			//start
		break;

	if(PINC.1==0)			//motor test
	{
		delay_ms(100);
		LM_FOR;RM_FOR;delay_ms(2000);
	   LM_REV;RM_REV;delay_ms(2000);
		LM_OFF;RM_OFF;
		delay_ms(100);
	}

};




while (1)
      {
      	// Place your code here
			edge_detect();

      };
}
