
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

typedef char *va_list;

#pragma used+

char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);

char *gets(char *str,unsigned int len);

void printf(char flash *fmtstr,...);
void sprintf(char *str, char flash *fmtstr,...);
void snprintf(char *str, unsigned int size, char flash *fmtstr,...);
void vprintf (char flash * fmtstr, va_list argptr);
void vsprintf (char *str, char flash * fmtstr, va_list argptr);
void vsnprintf (char *str, unsigned int size, char flash * fmtstr, va_list argptr);
signed char scanf(char flash *fmtstr,...);
signed char sscanf(char *str, char flash *fmtstr,...);

#pragma used-

#pragma library stdio.lib

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

unsigned int getKeyIR_basic(void)
{
unsigned char b1,b2; 
unsigned int rec_byte;
unsigned char i;

rec_byte=0;
DDRC.6  = 0;							
PORTC.6 = 1;

while(PINC.6==1);					
while(PINC.6==0);					

while(PINC.6==1);					
delay_us(1263);							

for(i=0;i<12;i++)
{ 
b1 = PINC.6;
delay_us(1684);

rec_byte = rec_byte << 1;
rec_byte = rec_byte | (unsigned int)b1;
}   

return rec_byte;
}  

unsigned char getKeyIR(void)
{
unsigned char c1,c2;

do
{
c1 = (unsigned char) (getKeyIR_basic() & 0x003F);
c2 = (unsigned char) (getKeyIR_basic() & 0x003F);
}while(c1!=c2);

return c2;
}

#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm

#pragma used+

void _lcd_ready(void);
void _lcd_write_data(unsigned char data);

void lcd_write_byte(unsigned char addr, unsigned char data);

unsigned char lcd_read_byte(unsigned char addr);

void lcd_gotoxy(unsigned char x, unsigned char y);

void lcd_clear(void);
void lcd_putchar(char c);

void lcd_puts(char *str);

void lcd_putsf(char flash *str);

unsigned char lcd_init(unsigned char lcd_columns);

void lcd_control (unsigned char control);

#pragma used-
#pragma library lcd.lib

#asm
   .equ __i2c_port=0x15 ;PORTC
   .equ __sda_bit=1
   .equ __scl_bit=0
#endasm

#pragma used+
void i2c_init(void);
unsigned char i2c_start(void);
void i2c_stop(void);
unsigned char i2c_read(unsigned char ack);
unsigned char i2c_write(unsigned char data);
#pragma used-

unsigned int readRecord(unsigned int add,unsigned char *bAdd);
unsigned int getNextRecord(unsigned int add);
unsigned int getPrevRecord(unsigned int add);
unsigned int readInt(unsigned int add);   
void writeByte(unsigned char eB,unsigned int add);
unsigned char readByte(unsigned int add);

unsigned char iH,				
iL,       	
i2c_rv;   	

unsigned int t,
i1=0,i2=0;		

unsigned int readRecord(unsigned int add,unsigned char *bAdd)
{                      	
unsigned int addOLD;	

addOLD=add;	
iL=(unsigned char)add & 0x00FF;    				
t=(unsigned int)add & 0xFF00;  					
t=t>>8;                             			
iH=(unsigned char)t;                         

i2c_start();
i2c_write(0xa0              );
i2c_write(iH);
i2c_write(iL);
i2c_start();
i2c_write(0xa0              |1);			

while(1)
{
*bAdd=i2c_read(1);
if(*bAdd==0)
break;

bAdd++;
add++;
};

i2c_read(0);		
i2c_stop();

return (add-addOLD);
}

unsigned int getNextRecord(unsigned int add)
{                      	
iL=(unsigned char)add & 0x00FF;    				
t=(unsigned int)add & 0xFF00;  					
t=t>>8;                             			
iH=(unsigned char)t;                            

delay_us(4);

i2c_start();
i2c_write(0xa0              );
i2c_write(iH);
i2c_write(iL);
i2c_start();
i2c_write(0xa0              |1);			

while(1)
{
if(i2c_read(1)==0)
break;
add++;
};

i2c_read(0);		
i2c_stop();

add++;								

return (add);
}

unsigned int getPrevRecord(unsigned int add)
{                      	
add=add-2;													

while(1)
{  
delay_us(4);

iL=(unsigned char)add & 0x00FF;    				
t=(unsigned int)add & 0xFF00;  					
t=t>>8;                             			
iH=(unsigned char)t;                         

i2c_start();
i2c_write(0xa0              );
i2c_write(iH);
i2c_write(iL);
i2c_start();
i2c_write(0xa0              |1);								

if(i2c_read(0)==0)
break;         

i2c_stop();

add--;
};

i2c_read(0);		
i2c_stop();

add++;														

return (add);
}

unsigned int readInt(unsigned int add)
{

iL=(unsigned char)add & 0x00FF;    				
t=(unsigned int)add & 0xFF00;  					
t=t>>8;                             			
iH=(unsigned char)t;                            

i2c_start();
i2c_write(0xa0              );
i2c_write(iH);
i2c_write(iL);
i2c_start();
i2c_write(0xa0              |1);							

i1=i2c_read(1);
i2=i2c_read(0);

i2c_stop();

return(((unsigned int)i1*0x100+(unsigned int)i2));

}

unsigned char readByte(unsigned int add)
{

iL=(unsigned char)add & 0x00FF;
t=(unsigned int) add & 0xFF00;
t=t>>8;
iH=(unsigned char)t;

i2c_rv=0;
while(i2c_rv==0)
{
while(i2c_start()==0);         		 

i2c_rv=i2c_write(0xa0              );
if(i2c_rv==1)               			 
break;   
};

i2c_write(iH);
i2c_write(iL);
i2c_start();
i2c_write(0xa0               | 1);

i1=i2c_read(0);

i2c_stop(); 

return i1;
}    

void writeByte(unsigned char eB,unsigned int add)
{    
i2c_stop(); 

iL=(unsigned char)(add & 0x00FF);
t=(unsigned int) (add & 0xFF00);
t=t>>8;
iH=(unsigned char)t;

i2c_rv=0;

i2c_start();
i2c_rv=i2c_write(0xa0              );
i2c_write(iH);
i2c_write(iL);
i2c_write(eB);
i2c_stop();

delay_ms(5);	 							

}

unsigned int i;
unsigned char j;
unsigned char adc_val;
unsigned char lcdPresent;
unsigned int adc_volt;

unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input|0x60;

ADCSRA|=0x40;

while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
}

void display_num(unsigned char nX,unsigned char nY,unsigned int nNum)
{
unsigned char *stnum="000000";

ltoa(nNum,stnum);
lcd_gotoxy(nX,nY);
lcd_puts(stnum);

return;
}

interrupt [9] void timer1_ovf_isr(void)
{
TCNT1 = 57723;

PORTB.3 = !PORTB.3;

}

void io_test()
{
unsigned char pa,pb,pc,pd;
unsigned char da,db,dc,dd;

pa = PORTA; pb = PORTB; pc = PORTC; pd = PORTD;
da = DDRA;	db = DDRB; 	dc = DDRC;	dd = DDRD;

DDRC.2 = 0;
PORTC.2 = 1;
while(PINC.2 == 1)
{

PORTA = PORTB = PORTC = PORTD = 0;
DDRA = DDRB = DDRC = DDRD = 0xFF;

PORTA = PORTB = PORTC = PORTD = 0xFF;
delay_ms(500);
PORTA = PORTB = PORTC = PORTD = 0;
delay_ms(500);

PORTC.2 = 1;
DDRC.2 = 0;
delay_ms(10);

};

PORTA = pa; PORTB = pb; PORTC = pc; PORTD =pd;
DDRA = da; DDRB = db; DDRC = dc;	DDRD = dd;
}

void i2c_test_withLCD()
{

lcd_clear();
lcd_putsf("Write:");
printf("\r\nWrite:");
for(i=0;i<5;i++)
{
#asm("cli");					
writeByte(i+65,i);
#asm("sei");         		
lcd_putchar(i+65);
putchar(i+65);
delay_ms(300);
}

delay_ms(1000);
lcd_clear();
delay_ms(500);
lcd_putsf("Read :");
printf("\r\nRead:");
for(i=0;i<5;i++)
{
#asm("cli");					
j = readByte(i);
#asm("sei");         		
lcd_putchar(j);
putchar(j);
delay_ms(300);
}

delay_ms(3000);

}

void i2c_test()
{

i2c_init();
i2c_init();
printf("\r\nWrite:");
for(i=0;i<5;i++)
{
writeByte(i+65,i);
putchar(i+65);
delay_ms(300);
}

delay_ms(1000);
printf("\r\nRead:");
for(i=0;i<5;i++)
{
j = readByte(i);
putchar(j);
delay_ms(300);
}

delay_ms(3000);
}

void l293d1_test()
{

printf("\r\nL293D_1 Test ... ");

PORTD.4=1;								
PORTD.6=0;
PORTD.5=1;
PORTD.7=0;
delay_ms(3000);

PORTD.4=0;								
PORTD.6=1;
PORTD.5=0;
PORTD.7=1;
delay_ms(3000);

PORTD.4=0;								
PORTD.5=0;
PORTD.6=0;
PORTD.7=0;

printf(" done");
}

void l293d2_test()
{

printf("\r\nL293D_2 Test ... ");

DDRB=0x0F;								
PORTB=0x00;

PORTB.0=1;                       
PORTB.1=0;
PORTB.2=1;
PORTB.3=0;
delay_ms(3000);

PORTB.0=0;                       
PORTB.1=1;
PORTB.2=0;
PORTB.3=1;
delay_ms(3000);

PORTB.0=0;                       
PORTB.1=0;
PORTB.2=0;
PORTB.3=0;

printf(" done");
}

void lcd_test()
{
unsigned char j,k;
unsigned char rows=2;
unsigned char cols=16;

printf("\r\nLCD_test");
lcd_init(cols);
lcd_clear();

lcd_gotoxy((cols/2)-3,(rows/2)-1);
lcd_putsf("MEGA16");
lcd_gotoxy((cols/2)-7,(rows/2));
lcd_putsf("DEVELOPMENT BRD");
delay_ms(1000);

}

void led_test()
{

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

void adc_test()
{

printf("\r\nADC Test ...");

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

switch(i)
{

case 0:
lcd_test();
break;

case 1:
l293d1_test();
break;

case 2:
l293d2_test();
break;

case 3:
adc_test();
break;

case 4:
led_test();
break;

case 5:
i2c_test();
break;

case 6:
i2c_test_withLCD();
break;
default:
break;
}
};
}

void main(void)
{

WDTCR = 0b00011000;
WDTCR = 0b00010000;

PORTA=0x00;
DDRA=0x00;

DDRB=0xFF;

PORTC=0x00;
DDRC=0x00;

PORTD=0x00;
DDRD=0xFC;

TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

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

ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

MCUCR=0x00;
MCUCSR=0x00;

TIMSK=0x04;

UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x11;

ACSR=0x80;
SFIOR=0x00;

ADMUX=0x60;
ADCSRA=0x86;

i2c_init();

#asm("sei")

DDRC.7 = 1;
for(i=0; i<2000; i++)
{
PORTC.7=1;
delay_us(125);
PORTC.7=0;
delay_us(125);
}	

while (1)
{

printf("\r\n\n\nMega16 development board for project/product/robotics development");

i=0;
DDRC.2=0; 				
PORTC.2=1;				
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

if(lcdPresent==1)
{

lcd_test();

while(PINC.2==0){delay_ms(100);};
i2c_test_withLCD();

while(PINC.2==0){delay_ms(100);};
l293d1_test();

while(PINC.2==0){delay_ms(100);};
adc_test();

ir_test();
}

else
{

led_test();

while(PINC.2==0){delay_ms(100);};
i2c_test();

while(PINC.2==0){delay_ms(100);};
l293d1_test();
l293d2_test();

while(PINC.2==0){delay_ms(100);};
adc_test();

ir_test();
}

while(1);

};
}
