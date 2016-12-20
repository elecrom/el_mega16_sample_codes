
unsigned char sensors[7];

unsigned char adcch;
unsigned char tmp;
unsigned char dir;

#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb OCDR=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb OCR0=0X3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

#pragma used+

unsigned char cabs(signed char x);
unsigned int abs(int x);
unsigned long labs(long x);
float fabs(float x);
int atoi(char *str);
long int atol(char *str);
float atof(char *str);
void itoa(int n,char *str);
void ltoa(long int n,char *str);
void ftoa(float n,unsigned char decimals,char *str);
void ftoe(float n,unsigned char decimals,char *str);
void srand(int seed);
int rand(void);
void *malloc(unsigned int size);
void *calloc(unsigned int num, unsigned int size);
void *realloc(void *ptr, unsigned int size); 
void free(void *ptr);

#pragma used-
#pragma library stdlib.lib

interrupt [10] void timer0_ovf_isr(void)
{

TCNT0=128;

ADCSRA|=0x10;
tmp = ADCH;

if(tmp>100)
sensors[adcch]=1;
else
sensors[adcch]=0;

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

ADMUX=adcch|0x60;

ADCSRA|=0x40;

PORTB = (sensors[1]<<1) | (sensors[5]<<2) | (sensors[2]<<5) | (sensors[3]<<6);

}

unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input|0x60;

ADCSRA|=0x40;

while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
}

unsigned int dCtr;									
unsigned char TMOUT = 90;

void edge_detect(void)
{

if(sensors[1]==1 && sensors[5]==1 && sensors[2]==1 && sensors[3]==1)
{
PORTD.5=0;PORTD.7=1;;
PORTD.6=0;PORTD.4=1;;
}

else if(sensors[1]==0 && sensors[5]==1 && sensors[2]==1 && sensors[3]==1)
{

PORTD.6=1;PORTD.4=0;;PORTD.5=1;PORTD.7=0;;delay_ms(600);

PORTD.5=1;PORTD.7=0;;PORTD.6=0;PORTD.4=0;;dCtr=0;
while(sensors[2]==1 && sensors[3]==1 && dCtr<TMOUT)
{
delay_ms(10);
dCtr++;
};

}

else if(sensors[1]==1 && sensors[5]==0 && sensors[2]==1 && sensors[3]==1)
{

PORTD.6=1;PORTD.4=0;;PORTD.5=1;PORTD.7=0;;delay_ms(600);

PORTD.5=0;PORTD.7=0;;PORTD.6=1;PORTD.4=0;;dCtr=0;
while(sensors[3]==1 && sensors[2]==1 && dCtr<TMOUT)
{
delay_ms(10);
dCtr++;
}

}

else if(sensors[1]==1 && sensors[5]==1 && sensors[2]==0 && sensors[3]==0)
{
PORTD.5=0;PORTD.7=1;;PORTD.6=0;PORTD.4=1;;dCtr=50;
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

PORTA=0x00;
DDRA=0x00;

PORTB=0x55;
DDRB=0xFF;

PORTC=0x07;
DDRC=0x00;

PORTD=0x00;
DDRD=0xFF;

TCCR0=0x03;
TCNT0=0x00;
OCR0=0x00;

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

ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

MCUCR=0x00;
MCUCSR=0x00;

TIMSK=0x01;

ACSR=0x80;
SFIOR=0x00;

ADMUX=0x60;
ADCSRA=0x86;

adcch=0;

#asm("sei")

dCtr=0;
while(1)
{
delay_ms(200);
dCtr++;
srand(dCtr);

if(PINC.0==0)			
break;

if(PINC.1==0)			
{
delay_ms(100);
PORTD.6=0;PORTD.4=1;;PORTD.5=0;PORTD.7=1;;delay_ms(2000);
PORTD.6=1;PORTD.4=0;;PORTD.5=1;PORTD.7=0;;delay_ms(2000);
PORTD.6=0;PORTD.4=0;;PORTD.5=0;PORTD.7=0;;
delay_ms(100);
}

};

while (1)
{

edge_detect();

};
}
