/*_______________________________________________________________________________*/
/*										   		IR.H	 		   				    			 	*/
/*-------------------------------------------------------------------------------*/
/* Description : Infrared remote control interfacing 										*/
/* AUTHOR : Omkar C Kulkarni                                                     */
//NOTICE  : NO PART OF THIS CODE SHOULD BE                                       //
//¯¯¯¯¯¯¯¯  COPIED  WITHOUT  PERMISSION OF                                       //
//          AUTHOR.                                                              //
/*_______________________________________________________________________________*/

#ifndef irDDR
	#warning "irDDR not defined. e.g : #define irDDR DDRB"
#endif

#ifndef irPORT
	#warning "irPORT not defined. e.g : #define irPORT PORTB"
#endif

#ifndef irPIN
	#warning "irPIN not defined. e.g : #define irPIN PINB"
#endif

#ifndef irBIT
	#warning "irBIT not defined. e.g : #define irBIT 0"
#endif                                                


//# This function will recive a keystroke from IR remote and will return entire key 
//  stroke (including all bits at output)
//NOTEs:
//-Idle state : 1
//-bit 0      : 0 to 1 transition
//-bit 1      : 1 to 0 transition in bit time (inverted manchester encoding, 
//             as output of TSOP1738 is inverted)
//
//-total bit time: 1778 uS
//
//-return     : return complete received data, which includes :
//				  1 toggle bit (chng everytime when a new btn is prsd on the ir TX)
//				  5 address bits for the systemaddress
//				  6 instruction bits for the pressed key    
unsigned int getKeyIR_basic(void)
{
unsigned char b1,b2; 
unsigned int rec_byte;
unsigned char i;

 	rec_byte=0;
 	irDDR.irBIT  = 0;							//set input pullup mode
 	irPORT.irBIT = 1;
 	
	//# detect first: 1
 	while(irPIN.irBIT==1);					//wait for first 1 to 0
 	while(irPIN.irBIT==0);					//now wait for 0 to 1 
 	
 	//#detect 2nd   :1
 	while(irPIN.irBIT==1);					//wait for 1 to 0 
 	delay_us(1263);							//wait till we reach half way through,
 													//first half of next toggle bit
	
	//# start sampling the both parts of the bits (i.e. both halves) at their 
	//  centre
	for(i=0;i<12;i++)
	{ 
		b1 = irPIN.irBIT;
		delay_us(1684);
		
		rec_byte = rec_byte << 1;
		rec_byte = rec_byte | (unsigned int)b1;
	}   
	
return rec_byte;
}  

//________________________________________________________________________________
//# This function will use above function and will return ONLY instruction bits to
//  the user. This fuction will not return pressed key, until it receives same code
//  twice. This is done for protection against noise.
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


                                                     


