/*________________________________________________________________________________*/
/*										   		EEPROMMyi2c.H 				    						 */
/*--------------------------------------------------------------------------------*/
/* Description : 32KB eeprom access functions.												 */
/* AUTHOR : Omkar C Kulkarni                                                      */
//NOTICE  : NO PART OF THIS CODE SHOULD BE                                        //
//��������  COPIED  WITHOUT  PERMISSION OF                                        //
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








