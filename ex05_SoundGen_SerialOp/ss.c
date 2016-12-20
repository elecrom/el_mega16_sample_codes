/*****************************************************
Chip type           : ATmega16
Program type        : Application
Clock frequency     : 16.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256

What does this program do ?
###########################

- Generates sound using the CTC mode of timer 1.
- By changing the OCR1A value, we can generate square
  waves of different frequencies.
- Output is available on PD5(OC1A) pin.
- Connect this pin to on speaker using external
  wire to listen the sound.
- Press SW1 or SW2 to start melody.
- Program all prints the frequency being generated on
  serial interface.
*****************************************************/

#include <mega16.h>

// Standard Input/Output functions
#include <stdio.h>
#include <delay.h>



//Frequency definitions :

//Mandra
#define n_Sa    131
#define n_kRe   139
#define n_Re    147
#define n_Ga    156
#define n_kGa   165
#define n_Ma    175
#define n_tMa   185
#define n_Pa    196
#define n_kDh   208
#define n_Dh    220
#define n_kNi   233
#define n_Ni    247

//Madhya
#define m_Sa    261
#define m_kRe   277
#define m_Re    294
#define m_Ga    311
#define m_kGa   329
#define m_Ma    349
#define m_tMa   370
#define m_Pa    392
#define m_kDh   415
#define m_Dh    440
#define m_kNi   466
#define m_Ni    494

//Taar
#define t_Sa    523
#define t_kRe   554
#define t_Re    587
#define t_Ga    622
#define t_kGa   659
#define t_Ma    698
#define t_tMa   740
#define t_Pa    784
#define t_kDh   831
#define t_Dh    880
#define t_kNi   932
#define t_Ni    988

//Frequency definitions : WESTERN

//Mandra
#define c0      131
//#define n_kRe   139
#define d0      147
#define e0      156
//#define n_kGa   165
#define f0      175
//#define n_tMa   185
#define g0      196
//#define n_kDh   208
#define a0      220
//#define n_kNi   233
#define b0      247


//Madhya
#define c1      261
//#define m_kRe   277
#define d1      294
#define e1      329//             311
//#define m_kGa   329
#define f1      349
//#define m_tMa   370
#define g1      392
//#define m_kDh   415
#define a1      440
//#define m_kNi   466
#define b1      494

//Taar
#define c2      523
//#define t_kRe   554
#define d2      587
#define e2      622
//#define t_kGa   659
#define f2      698
//#define t_tMa   740
#define g2      784
//#define t_kDh   831
#define a2      880
//#define t_kNi   932
#define b2      988


flash unsigned int mel_1[10]={m_Sa,m_Re,m_Ga,m_Ma,m_Pa,m_Dh,m_Ni,t_Sa};
flash unsigned int bhairavi[16]={m_Sa,m_kRe,m_kGa,m_Ma,m_Pa,m_kDh,m_kNi,t_Sa,
                            t_Sa,m_kNi,m_kDh,m_Pa,m_Ma,m_kGa,m_kRe,m_Sa};

flash unsigned int saregama[16]={m_Sa,m_Re,m_Ga,m_Ma,m_Pa,m_Dh,m_Ni,t_Sa,1,
											m_Ni,m_Dh,m_Pa,m_Ma,m_Ga,m_Re,m_Sa};


flash unsigned int twinkle[42]={c1,c1,g1,g1,a1,a1,g1,f1,f1,e1,e1,d1,d1,c1,g1,g1,
                          f1,f1,e1,e1,d1,g1,g1,f1,f1,e1,e1,d1,c1,c1,g1,g1,
                          a1,a1,g1,f1,f1,e1,e1,d1,d1,c1};

unsigned char cnt;                        



// Declare your global variables here
/*__________________________________________________________________________________________*/
//-This function calculates value of OCR1A register to generate desired frequency, when
// timer1 is operating at 2MHz
unsigned int calc_OCR(unsigned int _freq)
{
   return (unsigned int)(2000000/((long int)_freq*2));
}


void main(void)
{

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
PORTC=0b00001100;
DDRC =0b00000000;

// Port D initialization
PORTD=0x00;
DDRD= 0b00100000;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Clock source: System Clock
// Clock value: 2000.000 kHz
// Mode: CTC top=OCR1A
// OC1A output: Toggle
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x40;
TCCR1B=0x0A;
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
TIMSK=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: Off
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 56000
UCSRA=0x00;
UCSRB=0x08;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x11;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

delay_ms(200);

while (1)
   {
      // Place your code here
		PORTD.5=0;
		OCR1A=0;

		if(PINC.2==0)
		{
			for(cnt=0;cnt<42;cnt++)
			{
				OCR1A = calc_OCR(twinkle[cnt]);
				printf("%d ",OCR1A);
				delay_ms(300);
				OCR1A=0;
				delay_ms(100);

			}
		}
		else if(PINC.3==0)
		{
			for(cnt=0;cnt<16;cnt++)
			{
				OCR1A = calc_OCR(saregama[cnt]);
				printf("%d ",OCR1A);
				delay_ms(300);
				OCR1A=0;
				delay_ms(100);

			}

		}

	};
}
