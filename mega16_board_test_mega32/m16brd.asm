
;CodeVisionAVR C Compiler V2.03.4 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : long, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;global const stored in FLASH  : No
;8 bit enums            : Yes
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	LDI  R23,BYTE4(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+@1,R0
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _iH=R5
	.DEF _iL=R4
	.DEF _i2c_rv=R7
	.DEF _t=R8
	.DEF _i1=R10
	.DEF _i2=R12
	.DEF _j=R6

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0xB7:
	.DB  0x0,0x0,0x0,0x0
_0x0:
	.DB  0x30,0x30,0x30,0x30,0x30,0x30,0x0,0x57
	.DB  0x72,0x69,0x74,0x65,0x3A,0x0,0xD,0xA
	.DB  0x57,0x72,0x69,0x74,0x65,0x3A,0x0,0x52
	.DB  0x65,0x61,0x64,0x20,0x3A,0x0,0xD,0xA
	.DB  0x52,0x65,0x61,0x64,0x3A,0x0,0xD,0xA
	.DB  0x4C,0x32,0x39,0x33,0x44,0x5F,0x31,0x20
	.DB  0x54,0x65,0x73,0x74,0x20,0x2E,0x2E,0x2E
	.DB  0x20,0x0,0x20,0x64,0x6F,0x6E,0x65,0x0
	.DB  0xD,0xA,0x4C,0x32,0x39,0x33,0x44,0x5F
	.DB  0x32,0x20,0x54,0x65,0x73,0x74,0x20,0x2E
	.DB  0x2E,0x2E,0x20,0x0,0xD,0xA,0x4C,0x43
	.DB  0x44,0x5F,0x74,0x65,0x73,0x74,0x0,0x4D
	.DB  0x45,0x47,0x41,0x31,0x36,0x0,0x44,0x45
	.DB  0x56,0x45,0x4C,0x4F,0x50,0x4D,0x45,0x4E
	.DB  0x54,0x20,0x42,0x52,0x44,0x0,0xD,0xA
	.DB  0x4C,0x45,0x44,0x20,0x54,0x65,0x73,0x74
	.DB  0x20,0x2E,0x2E,0x2E,0x20,0x0,0xD,0xA
	.DB  0x41,0x44,0x43,0x20,0x54,0x65,0x73,0x74
	.DB  0x20,0x2E,0x2E,0x2E,0x0,0xD,0xA,0x43
	.DB  0x48,0x20,0x25,0x64,0x3A,0x20,0x25,0x30
	.DB  0x33,0x64,0x20,0x3D,0x3E,0x20,0x25,0x30
	.DB  0x34,0x64,0x20,0x6D,0x56,0x0,0xD,0xA
	.DB  0x0,0xD,0xA,0xA,0x23,0x20,0x44,0x4F
	.DB  0x4E,0x45,0x2E,0x0,0xD,0xA,0xA,0x20
	.DB  0x4E,0x6F,0x77,0x20,0x70,0x72,0x65,0x73
	.DB  0x73,0x20,0x6B,0x65,0x79,0x73,0x20,0x6F
	.DB  0x6E,0x20,0x72,0x65,0x6D,0x6F,0x74,0x65
	.DB  0xD,0xA,0x0,0x50,0x72,0x65,0x73,0x73
	.DB  0x20,0x72,0x65,0x6D,0x6F,0x74,0x65,0x20
	.DB  0x6B,0x65,0x79,0x73,0x0,0xD,0xA,0xA
	.DB  0x4B,0x65,0x79,0x20,0x3A,0x20,0x25,0x64
	.DB  0x20,0x0,0xD,0xA,0xA,0xA,0x4D,0x65
	.DB  0x67,0x61,0x31,0x36,0x20,0x64,0x65,0x76
	.DB  0x65,0x6C,0x6F,0x70,0x6D,0x65,0x6E,0x74
	.DB  0x20,0x62,0x6F,0x61,0x72,0x64,0x20,0x66
	.DB  0x6F,0x72,0x20,0x70,0x72,0x6F,0x6A,0x65
	.DB  0x63,0x74,0x2F,0x70,0x72,0x6F,0x64,0x75
	.DB  0x63,0x74,0x2F,0x72,0x6F,0x62,0x6F,0x74
	.DB  0x69,0x63,0x73,0x20,0x64,0x65,0x76,0x65
	.DB  0x6C,0x6F,0x70,0x6D,0x65,0x6E,0x74,0x0
	.DB  0xA,0xD,0x4C,0x43,0x44,0x20,0x69,0x73
	.DB  0x20,0x61,0x73,0x73,0x75,0x6D,0x65,0x64
	.DB  0x20,0x74,0x6F,0x20,0x62,0x65,0x20,0x70
	.DB  0x72,0x65,0x73,0x65,0x6E,0x74,0x2E,0x0
	.DB  0xA,0xD,0x4C,0x43,0x44,0x20,0x69,0x73
	.DB  0x20,0x61,0x73,0x73,0x75,0x6D,0x65,0x64
	.DB  0x20,0x74,0x6F,0x20,0x62,0x65,0x20,0x61
	.DB  0x62,0x73,0x65,0x6E,0x74,0x2E,0x0
_0x202005F:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2040003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x07
	.DW  _0x2C
	.DW  _0x0*2

	.DW  0x04
	.DW  0x0A
	.DW  _0xB7*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x202005F*2

	.DW  0x02
	.DW  __base_y_G102
	.DW  _0x2040003*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x800)
	LDI  R25,HIGH(0x800)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x85F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x85F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x260)
	LDI  R29,HIGH(0x260)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*****************************************************
;Chip type           : ATmega16
;Program type        : Application
;Clock frequency     : 16.000000 MHz
;Memory model        : Small
;External SRAM size  : 0
;Data Stack size     : 256
;*****************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;// Standard Input/Output functions
;#include <stdio.h>
;#include <stdlib.h>
;
;#define	irPORT	PORTC
;#define	irPIN		PINC
;#define	irDDR		DDRC
;#define	irBIT		6
;
;#include "../include/ir.h"

	.CSEG
_getKeyIR_basic:
	CALL __SAVELOCR6
;	b1 -> R17
;	b2 -> R16
;	rec_byte -> R18,R19
;	i -> R21
	__GETWRN 18,19,0
	CBI  0x14,6
	SBI  0x15,6
_0x7:
	LDI  R26,0
	SBIC 0x13,6
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BREQ _0x7
_0xA:
	SBIS 0x13,6
	RJMP _0xA
_0xD:
	LDI  R26,0
	SBIC 0x13,6
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BREQ _0xD
	__DELAY_USW 5052
	LDI  R21,LOW(0)
_0x11:
	CPI  R21,12
	BRSH _0x12
	LDI  R30,0
	SBIC 0x13,6
	LDI  R30,1
	MOV  R17,R30
	__DELAY_USW 6736
	LSL  R18
	ROL  R19
	MOV  R30,R17
	LDI  R31,0
	__ORWRR 18,19,30,31
	SUBI R21,-1
	RJMP _0x11
_0x12:
	MOVW R30,R18
	CALL __LOADLOCR6
	RJMP _0x20C0006
_getKeyIR:
	ST   -Y,R17
	ST   -Y,R16
;	c1 -> R17
;	c2 -> R16
_0x14:
	RCALL _getKeyIR_basic
	ANDI R30,LOW(0x3F)
	ANDI R31,HIGH(0x3F)
	MOV  R17,R30
	RCALL _getKeyIR_basic
	ANDI R30,LOW(0x3F)
	ANDI R31,HIGH(0x3F)
	MOV  R16,R30
	CP   R16,R17
	BRNE _0x14
	MOV  R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x18 ;PORTB
; 0000 001B #endasm
;#include <lcd.h>
;
;
;//#include "../include/myi2c.c"
;//#include "../include/eeprommyi2c.c"
;// I2C Bus functions
;#asm
   .equ __i2c_port=0x15 ;PORTC
   .equ __sda_bit=1
   .equ __scl_bit=0
; 0000 0026 #endasm
;#include <i2c.h>
;#include   "../include/eeprom.h"
;	add -> Y+4
;	*bAdd -> Y+2
;	addOLD -> R16,R17
;	add -> Y+0
;	add -> Y+0
;	add -> Y+0
_readByte:
;	add -> Y+0
	LD   R30,Y
	MOV  R4,R30
	CALL SUBOPT_0x0
_0x22:
	TST  R7
	BRNE _0x24
_0x25:
	CALL _i2c_start
	CPI  R30,0
	BREQ _0x25
	LDI  R30,LOW(160)
	ST   -Y,R30
	CALL _i2c_write
	MOV  R7,R30
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x22
_0x24:
	CALL SUBOPT_0x1
	CALL _i2c_start
	LDI  R30,LOW(161)
	ST   -Y,R30
	CALL _i2c_write
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _i2c_read
	MOV  R10,R30
	CLR  R11
	CALL _i2c_stop
	MOVW R30,R10
	JMP  _0x20C0004
_writeByte:
;	eB -> Y+2
;	add -> Y+0
	CALL _i2c_stop
	LDD  R4,Y+0
	CALL SUBOPT_0x0
	CALL _i2c_start
	LDI  R30,LOW(160)
	ST   -Y,R30
	CALL _i2c_write
	MOV  R7,R30
	CALL SUBOPT_0x1
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _i2c_write
	CALL _i2c_stop
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x2
	JMP  _0x20C0003
;
;
;
;
;#define ADC_VREF_TYPE 0x60
;
;unsigned int i;
;unsigned char j;
;unsigned char adc_val;
;unsigned char lcdPresent;
;unsigned int adc_volt;
;
;
;//_____________________________________________________________________________________
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 003A {
_read_adc:
; 0000 003B ADMUX=adc_input|ADC_VREF_TYPE;
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0x60)
	OUT  0x7,R30
; 0000 003C // Start the AD conversion
; 0000 003D ADCSRA|=0x40;
	SBI  0x6,6
; 0000 003E // Wait for the AD conversion to complete
; 0000 003F while ((ADCSRA & 0x10)==0);
_0x29:
	SBIS 0x6,4
	RJMP _0x29
; 0000 0040 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0041 return ADCH;
	IN   R30,0x5
	JMP  _0x20C0001
; 0000 0042 }
;
;//_______________________________________________________________________________________
;//# To display given number at given location on LCD
;void display_num(unsigned char nX,unsigned char nY,unsigned int nNum)
; 0000 0047 {
_display_num:
; 0000 0048 unsigned char *stnum="000000";
; 0000 0049 
; 0000 004A 	ltoa(nNum,stnum);
	ST   -Y,R17
	ST   -Y,R16
;	nX -> Y+5
;	nY -> Y+4
;	nNum -> Y+2
;	*stnum -> R16,R17
	__POINTWRMN 16,17,_0x2C,0
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x3
	ST   -Y,R17
	ST   -Y,R16
	CALL _ltoa
; 0000 004B 	lcd_gotoxy(nX,nY);
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R30,Y+5
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 004C 	lcd_puts(stnum);
	ST   -Y,R17
	ST   -Y,R16
	CALL _lcd_puts
; 0000 004D 
; 0000 004E  return;
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20C0006:
	ADIW R28,6
	RET
; 0000 004F }

	.DSEG
_0x2C:
	.BYTE 0x7
;
;//_____________________________________________________________________________________
;// Timer 1 overflow interrupt service routine
;//# This will flash LED on PORTB.7 at a rate of 1Hz.
;//  -Interrupt period 	= Timer Clk period * (65536 - TCNT1 )
;//	 						 	= (1/15625) * (65536 - 57723)
;//							 	= 64uS  * 7813
;//							 	= 500.032s => 0.5 sec
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0059 {

	.CSEG
_timer1_ovf_isr:
	ST   -Y,R30
	ST   -Y,R31
; 0000 005A 	TCNT1 = 57723;
	LDI  R30,LOW(57723)
	LDI  R31,HIGH(57723)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
; 0000 005B 
; 0000 005C 	// Place your code here
; 0000 005D 	PORTB.3 = !PORTB.3;
	SBIS 0x18,3
	RJMP _0x2D
	CBI  0x18,3
	RJMP _0x2E
_0x2D:
	SBI  0x18,3
_0x2E:
; 0000 005E 
; 0000 005F }
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;
;//_____________________________________________________________________________________
;void io_test()
; 0000 0064 {
; 0000 0065 unsigned char pa,pb,pc,pd;
; 0000 0066 unsigned char da,db,dc,dd;
; 0000 0067 
; 0000 0068 	//Save the port registers
; 0000 0069    pa = PORTA; pb = PORTB; pc = PORTC; pd = PORTD;
;	pa -> R17
;	pb -> R16
;	pc -> R19
;	pd -> R18
;	da -> R21
;	db -> R20
;	dc -> Y+7
;	dd -> Y+6
; 0000 006A    da = DDRA;	db = DDRB; 	dc = DDRC;	dd = DDRD;
; 0000 006B 
; 0000 006C 
; 0000 006D    DDRC.2 = 0;
; 0000 006E    PORTC.2 = 1;
; 0000 006F    while(PINC.2 == 1)
; 0000 0070    {
; 0000 0071 		//Set all ports to output
; 0000 0072 		PORTA = PORTB = PORTC = PORTD = 0;
; 0000 0073    	DDRA = DDRB = DDRC = DDRD = 0xFF;
; 0000 0074 
; 0000 0075       PORTA = PORTB = PORTC = PORTD = 0xFF;
; 0000 0076       delay_ms(500);
; 0000 0077    	PORTA = PORTB = PORTC = PORTD = 0;
; 0000 0078       delay_ms(500);
; 0000 0079 
; 0000 007A       //Set only PORTC.2 to input with pull up
; 0000 007B       PORTC.2 = 1;
; 0000 007C       DDRC.2 = 0;
; 0000 007D       delay_ms(10);
; 0000 007E 
; 0000 007F 	};
; 0000 0080 
; 0000 0081    //Restore PORT states
; 0000 0082 	PORTA = pa; PORTB = pb; PORTC = pc; PORTD =pd;
; 0000 0083    DDRA = da; DDRB = db; DDRC = dc;	DDRD = dd;
; 0000 0084 }
;
;
;//_____________________________________________________________________________________
;//I2C test routine, with output messages on LCD and UART.
;void i2c_test_withLCD()
; 0000 008A {
_i2c_test_withLCD:
; 0000 008B 	//I2C test
; 0000 008C    lcd_clear();
	CALL _lcd_clear
; 0000 008D 	lcd_putsf("Write:");
	__POINTW1FN _0x0,7
	CALL SUBOPT_0x4
; 0000 008E 	printf("\r\nWrite:");
	CALL SUBOPT_0x5
; 0000 008F 	for(i=0;i<5;i++)
_0x3B:
	CALL SUBOPT_0x6
	BRSH _0x3C
; 0000 0090 	{
; 0000 0091       #asm("cli");					//disable all interrupts
	cli
; 0000 0092 		writeByte(i+65,i);
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
; 0000 0093 		#asm("sei");         		//enable all interrupts
	sei
; 0000 0094 		lcd_putchar(i+65);
	CALL SUBOPT_0x9
	CALL _lcd_putchar
; 0000 0095 		putchar(i+65);
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
; 0000 0096 		delay_ms(300);
; 0000 0097 	}
	CALL SUBOPT_0xB
	RJMP _0x3B
_0x3C:
; 0000 0098 
; 0000 0099 	delay_ms(1000);
	CALL SUBOPT_0xC
; 0000 009A    lcd_clear();
	CALL _lcd_clear
; 0000 009B 	delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x2
; 0000 009C 	lcd_putsf("Read :");
	__POINTW1FN _0x0,23
	CALL SUBOPT_0x4
; 0000 009D 	printf("\r\nRead:");
	CALL SUBOPT_0xD
; 0000 009E 	for(i=0;i<5;i++)
_0x3E:
	CALL SUBOPT_0x6
	BRSH _0x3F
; 0000 009F 	{
; 0000 00A0       #asm("cli");					//disable all interrupts
	cli
; 0000 00A1 		j = readByte(i);
	CALL SUBOPT_0xE
; 0000 00A2 		#asm("sei");         		//enable all interrupts
	sei
; 0000 00A3 		lcd_putchar(j);
	ST   -Y,R6
	CALL _lcd_putchar
; 0000 00A4 		putchar(j);
	ST   -Y,R6
	CALL SUBOPT_0xA
; 0000 00A5 		delay_ms(300);
; 0000 00A6 	}
	CALL SUBOPT_0xB
	RJMP _0x3E
_0x3F:
; 0000 00A7 
; 0000 00A8 	delay_ms(3000);
	RJMP _0x20C0005
; 0000 00A9 
; 0000 00AA }
;
;//_____________________________________________________________________________________
;//I2C test routine. Output messages only on UART
;void i2c_test()
; 0000 00AF {
_i2c_test:
; 0000 00B0 
; 0000 00B1 	//I2C test
; 0000 00B2 	i2c_init();
	CALL _i2c_init
; 0000 00B3 	i2c_init();
	CALL _i2c_init
; 0000 00B4 	printf("\r\nWrite:");
	CALL SUBOPT_0x5
; 0000 00B5 	for(i=0;i<5;i++)
_0x41:
	CALL SUBOPT_0x6
	BRSH _0x42
; 0000 00B6 	{
; 0000 00B7 		writeByte(i+65,i);
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
; 0000 00B8 		putchar(i+65);
	CALL SUBOPT_0x9
	CALL SUBOPT_0xA
; 0000 00B9 		delay_ms(300);
; 0000 00BA 	}
	CALL SUBOPT_0xB
	RJMP _0x41
_0x42:
; 0000 00BB 
; 0000 00BC 	delay_ms(1000);
	CALL SUBOPT_0xC
; 0000 00BD 	printf("\r\nRead:");
	CALL SUBOPT_0xD
; 0000 00BE 	for(i=0;i<5;i++)
_0x44:
	CALL SUBOPT_0x6
	BRSH _0x45
; 0000 00BF 	{
; 0000 00C0 		j = readByte(i);
	CALL SUBOPT_0xE
; 0000 00C1 		putchar(j);
	ST   -Y,R6
	CALL SUBOPT_0xA
; 0000 00C2 		delay_ms(300);
; 0000 00C3 	}
	CALL SUBOPT_0xB
	RJMP _0x44
_0x45:
; 0000 00C4 
; 0000 00C5 	delay_ms(3000);
_0x20C0005:
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	CALL SUBOPT_0x2
; 0000 00C6 }
	RET
;
;//_____________________________________________________________________________________
;//L293D test routine. for L293D connected on PORTD.
;void l293d1_test()
; 0000 00CB {
_l293d1_test:
; 0000 00CC 	//#L293D test :
; 0000 00CD 	printf("\r\nL293D_1 Test ... ");
	__POINTW1FN _0x0,38
	CALL SUBOPT_0xF
	ADIW R28,2
; 0000 00CE 
; 0000 00CF 	PORTD.4=1;								//start motors..
	SBI  0x12,4
; 0000 00D0 	PORTD.6=0;
	CBI  0x12,6
; 0000 00D1 	PORTD.5=1;
	SBI  0x12,5
; 0000 00D2 	PORTD.7=0;
	CBI  0x12,7
; 0000 00D3 	delay_ms(3000);
	CALL SUBOPT_0x10
; 0000 00D4 
; 0000 00D5 	PORTD.4=0;								//reverse direction
	CBI  0x12,4
; 0000 00D6 	PORTD.6=1;
	SBI  0x12,6
; 0000 00D7 	PORTD.5=0;
	CBI  0x12,5
; 0000 00D8 	PORTD.7=1;
	SBI  0x12,7
; 0000 00D9 	delay_ms(3000);
	CALL SUBOPT_0x10
; 0000 00DA 
; 0000 00DB 	PORTD.4=0;								//stop motors
	CBI  0x12,4
; 0000 00DC 	PORTD.5=0;
	CBI  0x12,5
; 0000 00DD 	PORTD.6=0;
	CBI  0x12,6
; 0000 00DE 	PORTD.7=0;
	CBI  0x12,7
; 0000 00DF 
; 0000 00E0 	printf(" done");
	CALL SUBOPT_0x11
	JMP  _0x20C0004
; 0000 00E1 }
;
;//_____________________________________________________________________________________
;//L293D test routine.for L293D connected on PORTB.
;void l293d2_test()
; 0000 00E6 {
_l293d2_test:
; 0000 00E7 	//#L293D test :
; 0000 00E8 	printf("\r\nL293D_2 Test ... ");
	__POINTW1FN _0x0,64
	CALL SUBOPT_0xF
	ADIW R28,2
; 0000 00E9 
; 0000 00EA 	DDRB=0x0F;								//set lower nibble of PORTB as output
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 00EB 	PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00EC 
; 0000 00ED 	PORTB.0=1;                       //start motors in one direction
	SBI  0x18,0
; 0000 00EE 	PORTB.1=0;
	CBI  0x18,1
; 0000 00EF 	PORTB.2=1;
	SBI  0x18,2
; 0000 00F0 	PORTB.3=0;
	CBI  0x18,3
; 0000 00F1 	delay_ms(3000);
	CALL SUBOPT_0x10
; 0000 00F2 
; 0000 00F3 	PORTB.0=0;                       //reverse directions
	CBI  0x18,0
; 0000 00F4 	PORTB.1=1;
	SBI  0x18,1
; 0000 00F5 	PORTB.2=0;
	CBI  0x18,2
; 0000 00F6 	PORTB.3=1;
	SBI  0x18,3
; 0000 00F7 	delay_ms(3000);
	CALL SUBOPT_0x10
; 0000 00F8 
; 0000 00F9 	PORTB.0=0;                       //stop motors
	CBI  0x18,0
; 0000 00FA 	PORTB.1=0;
	CBI  0x18,1
; 0000 00FB 	PORTB.2=0;
	CBI  0x18,2
; 0000 00FC 	PORTB.3=0;
	CBI  0x18,3
; 0000 00FD 
; 0000 00FE 	printf(" done");
	CALL SUBOPT_0x11
	JMP  _0x20C0004
; 0000 00FF }
;
;
;//_____________________________________________________________________________________
;//LCD test routine
;void lcd_test()
; 0000 0105 {
_lcd_test:
; 0000 0106 unsigned char j,k;
; 0000 0107 unsigned char rows=2;
; 0000 0108 unsigned char cols=16;
; 0000 0109 
; 0000 010A 	//#LCD TEST		:
; 0000 010B 	printf("\r\nLCD_test");
	CALL __SAVELOCR4
;	j -> R17
;	k -> R16
;	rows -> R19
;	cols -> R18
	LDI  R19,2
	LDI  R18,16
	__POINTW1FN _0x0,84
	CALL SUBOPT_0xF
	ADIW R28,2
; 0000 010C 	lcd_init(cols);
	ST   -Y,R18
	CALL _lcd_init
; 0000 010D 	lcd_clear();
	CALL _lcd_clear
; 0000 010E 
; 0000 010F 	lcd_gotoxy((cols/2)-3,(rows/2)-1);
	MOV  R30,R18
	LSR  R30
	SUBI R30,LOW(3)
	ST   -Y,R30
	MOV  R30,R19
	LSR  R30
	SUBI R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0110 	lcd_putsf("MEGA16");
	__POINTW1FN _0x0,95
	CALL SUBOPT_0x4
; 0000 0111 	lcd_gotoxy((cols/2)-7,(rows/2));
	MOV  R30,R18
	LSR  R30
	SUBI R30,LOW(7)
	ST   -Y,R30
	MOV  R30,R19
	LSR  R30
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0112 	lcd_putsf("DEVELOPMENT BRD");
	__POINTW1FN _0x0,102
	CALL SUBOPT_0x4
; 0000 0113 	delay_ms(1000);
	CALL SUBOPT_0xC
; 0000 0114 
; 0000 0115 }
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;
;//_____________________________________________________________________________________
;//Test on board LEDs if LCD is not present
;void led_test()
; 0000 011A {
_led_test:
; 0000 011B 	//#LED TEST   :
; 0000 011C 	printf("\r\nLED Test ... ");
	__POINTW1FN _0x0,118
	CALL SUBOPT_0xF
	ADIW R28,2
; 0000 011D 	i = 1;
	CALL SUBOPT_0x12
; 0000 011E 	for(i=1;i<0x0100;)
	CALL SUBOPT_0x12
_0x77:
	CALL SUBOPT_0x13
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRSH _0x78
; 0000 011F 	{
; 0000 0120 		PORTB=(unsigned char)i;
	LDS  R30,_i
	OUT  0x18,R30
; 0000 0121 		delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CALL SUBOPT_0x2
; 0000 0122 		i = i<<1;
	CALL SUBOPT_0x7
	LSL  R30
	ROL  R31
	CALL SUBOPT_0x14
; 0000 0123 	}
	RJMP _0x77
_0x78:
; 0000 0124    PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0125 	printf(" done");
	CALL SUBOPT_0x11
	JMP  _0x20C0004
; 0000 0126 }
;
;//_____________________________________________________________________________________
;//Test the ADC.
;void adc_test()
; 0000 012B {
_adc_test:
; 0000 012C 	//#ADC test
; 0000 012D 	printf("\r\nADC Test ...");
	__POINTW1FN _0x0,134
	CALL SUBOPT_0xF
	ADIW R28,2
; 0000 012E 
; 0000 012F 	//this will read input voltage on each ADC port, 3 times, and will output it.
; 0000 0130 	for(j=0;j<3;j++)
	CLR  R6
_0x7A:
	LDI  R30,LOW(3)
	CP   R6,R30
	BRLO PC+3
	JMP _0x7B
; 0000 0131 	{
; 0000 0132 		for(i=0;i<6;i++)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x14
_0x7D:
	CALL SUBOPT_0x13
	SBIW R26,6
	BRSH _0x7E
; 0000 0133 		{
; 0000 0134 			adc_val = read_adc(i);
	LDS  R30,_i
	ST   -Y,R30
	RCALL _read_adc
	STS  _adc_val,R30
; 0000 0135 			adc_volt = (adc_val * 195.3)/10;
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2N 0x43434CCD
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41200000
	CALL __DIVF21
	LDI  R26,LOW(_adc_volt)
	LDI  R27,HIGH(_adc_volt)
	CALL __CFD1U
	ST   X+,R30
	ST   X,R31
; 0000 0136 			printf("\r\nCH %d: %03d => %04d mV",i,adc_val,adc_volt);
	__POINTW1FN _0x0,149
	CALL SUBOPT_0x15
	LDS  R30,_adc_val
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDS  R30,_adc_volt
	LDS  R31,_adc_volt+1
	CALL SUBOPT_0x3
	LDI  R24,12
	CALL _printf
	ADIW R28,14
; 0000 0137 		}
	CALL SUBOPT_0xB
	RJMP _0x7D
_0x7E:
; 0000 0138 		delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x2
; 0000 0139 		printf("\r\n");
	__POINTW1FN _0x0,174
	CALL SUBOPT_0xF
	ADIW R28,2
; 0000 013A 	}
	INC  R6
	RJMP _0x7A
_0x7B:
; 0000 013B 
; 0000 013C    printf("\r\n\n# DONE.");
	__POINTW1FN _0x0,177
	CALL SUBOPT_0xF
	JMP  _0x20C0004
; 0000 013D }
;
;
;//_____________________________________________________________________________________
;//Infrared remote test ..
;//This routine will call above functions based on a keyPress
;void ir_test()
; 0000 0144 {
_ir_test:
; 0000 0145 	printf("\r\n\n Now press keys on remote\r\n");
	__POINTW1FN _0x0,188
	CALL SUBOPT_0xF
	ADIW R28,2
; 0000 0146 	if(lcdPresent)
	LDS  R30,_lcdPresent
	CPI  R30,0
	BREQ _0x7F
; 0000 0147 	{
; 0000 0148 		lcd_clear();
	CALL _lcd_clear
; 0000 0149 		lcd_putsf("Press remote keys");
	__POINTW1FN _0x0,219
	CALL SUBOPT_0x4
; 0000 014A 	}
; 0000 014B 
; 0000 014C 	while(1)
_0x7F:
_0x80:
; 0000 014D 	{
; 0000 014E 		i = getKeyIR();
	RCALL _getKeyIR
	LDI  R31,0
	CALL SUBOPT_0x14
; 0000 014F 		printf("\r\n\nKey : %d ",i);
	__POINTW1FN _0x0,237
	CALL SUBOPT_0x15
	LDI  R24,4
	CALL _printf
	ADIW R28,6
; 0000 0150 		if(lcdPresent)
	LDS  R30,_lcdPresent
	CPI  R30,0
	BREQ _0x83
; 0000 0151 		{
; 0000 0152 			lcd_clear();
	CALL _lcd_clear
; 0000 0153 			display_num(0,0,i);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL SUBOPT_0x7
	ST   -Y,R31
	ST   -Y,R30
	RCALL _display_num
; 0000 0154 		}
; 0000 0155 
; 0000 0156 		//Process the keys ...
; 0000 0157 		switch(i)
_0x83:
	CALL SUBOPT_0x7
; 0000 0158 		{
; 0000 0159 			//Key 0: Execute LCD test
; 0000 015A 			case 0:
	SBIW R30,0
	BRNE _0x87
; 0000 015B 					lcd_test();
	RCALL _lcd_test
; 0000 015C 					break;
	RJMP _0x86
; 0000 015D 
; 0000 015E 			//Key 1: L293D 1 test
; 0000 015F 			case 1:
_0x87:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x88
; 0000 0160 					l293d1_test();
	RCALL _l293d1_test
; 0000 0161 					break;
	RJMP _0x86
; 0000 0162 
; 0000 0163 			//Key 2: L293D 2 test
; 0000 0164 			case 2:
_0x88:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x89
; 0000 0165 					l293d2_test();
	RCALL _l293d2_test
; 0000 0166 					break;
	RJMP _0x86
; 0000 0167 
; 0000 0168 			//Key 3: ADC Test
; 0000 0169 			case 3:
_0x89:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x8A
; 0000 016A 					adc_test();
	RCALL _adc_test
; 0000 016B 					break;
	RJMP _0x86
; 0000 016C 
; 0000 016D 			//Key 4 : LED test
; 0000 016E 			case 4:
_0x8A:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x8B
; 0000 016F 					led_test();
	RCALL _led_test
; 0000 0170 					break;
	RJMP _0x86
; 0000 0171 
; 0000 0172 			//Key 5: I2C test without LCD
; 0000 0173 			case 5:
_0x8B:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x8C
; 0000 0174 					i2c_test();
	RCALL _i2c_test
; 0000 0175 					break;
	RJMP _0x86
; 0000 0176 
; 0000 0177 			//Key 6: I2C test with LCD
; 0000 0178 			case 6:
_0x8C:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x8E
; 0000 0179 					i2c_test_withLCD();
	RCALL _i2c_test_withLCD
; 0000 017A 					break;
; 0000 017B 			default:
_0x8E:
; 0000 017C 					break;
; 0000 017D 		}
_0x86:
; 0000 017E 	};
	RJMP _0x80
; 0000 017F }
;
;
;//_____________________________________________________________________________________
;void main(void)
; 0000 0184 {
_main:
; 0000 0185 // Declare your local variables here
; 0000 0186 
; 0000 0187 
; 0000 0188 
; 0000 0189 //disable watchdog
; 0000 018A WDTCR = 0b00011000;
	LDI  R30,LOW(24)
	OUT  0x21,R30
; 0000 018B WDTCR = 0b00010000;
	LDI  R30,LOW(16)
	OUT  0x21,R30
; 0000 018C 
; 0000 018D 
; 0000 018E 
; 0000 018F 
; 0000 0190 // Input/Output Ports initialization
; 0000 0191 // Port A initialization
; 0000 0192 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0193 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0194 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0195 DDRA=0x00;
	OUT  0x1A,R30
; 0000 0196 
; 0000 0197 // Port B initialization
; 0000 0198 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0199 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0                                                                            PORTB=0x00;
; 0000 019A DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 019B 
; 0000 019C // Port C initialization
; 0000 019D // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 019E // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 019F PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 01A0 DDRC=0x00;
	OUT  0x14,R30
; 0000 01A1 
; 0000 01A2 // Port D initialization
; 0000 01A3 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In
; 0000 01A4 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=T State1=T State0=T
; 0000 01A5 PORTD=0x00;
	OUT  0x12,R30
; 0000 01A6 DDRD=0xFC;
	LDI  R30,LOW(252)
	OUT  0x11,R30
; 0000 01A7 
; 0000 01A8 // Timer/Counter 0 initialization
; 0000 01A9 // Clock source: System Clock
; 0000 01AA // Clock value: Timer 0 Stopped
; 0000 01AB // Mode: Normal top=FFh
; 0000 01AC // OC0 output: Disconnected
; 0000 01AD TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 01AE TCNT0=0x00;
	OUT  0x32,R30
; 0000 01AF OCR0=0x00;
	OUT  0x3C,R30
; 0000 01B0 
; 0000 01B1 
; 0000 01B2 // Timer/Counter 1 initialization
; 0000 01B3 // Clock source: System Clock
; 0000 01B4 // Clock value: 15.625 kHz
; 0000 01B5 // Mode: Normal top=FFFFh
; 0000 01B6 // OC1A output: Discon.
; 0000 01B7 // OC1B output: Discon.
; 0000 01B8 // Noise Canceler: Off
; 0000 01B9 // Input Capture on Falling Edge
; 0000 01BA // Timer 1 Overflow Interrupt: On
; 0000 01BB // Input Capture Interrupt: Off
; 0000 01BC // Compare A Match Interrupt: Off
; 0000 01BD // Compare B Match Interrupt: Off
; 0000 01BE TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 01BF TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 01C0 TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 01C1 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 01C2 ICR1H=0x00;
	OUT  0x27,R30
; 0000 01C3 ICR1L=0x00;
	OUT  0x26,R30
; 0000 01C4 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 01C5 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 01C6 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 01C7 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01C8 
; 0000 01C9 // Timer/Counter 2 initialization
; 0000 01CA // Clock source: System Clock
; 0000 01CB // Clock value: Timer 2 Stopped
; 0000 01CC // Mode: Normal top=FFh
; 0000 01CD // OC2 output: Disconnected
; 0000 01CE ASSR=0x00;
	OUT  0x22,R30
; 0000 01CF TCCR2=0x00;
	OUT  0x25,R30
; 0000 01D0 TCNT2=0x00;
	OUT  0x24,R30
; 0000 01D1 OCR2=0x00;
	OUT  0x23,R30
; 0000 01D2 
; 0000 01D3 // External Interrupt(s) initialization
; 0000 01D4 // INT0: Off
; 0000 01D5 // INT1: Off
; 0000 01D6 // INT2: Off
; 0000 01D7 MCUCR=0x00;
	OUT  0x35,R30
; 0000 01D8 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 01D9 
; 0000 01DA // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01DB TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 01DC 
; 0000 01DD // USART initialization
; 0000 01DE // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01DF // USART Receiver: On
; 0000 01E0 // USART Transmitter: On
; 0000 01E1 // USART Mode: Asynchronous
; 0000 01E2 // USART Baud rate: 56000
; 0000 01E3 UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 01E4 UCSRB=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 01E5 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 01E6 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 01E7 UBRRL=0x11;
	LDI  R30,LOW(17)
	OUT  0x9,R30
; 0000 01E8 
; 0000 01E9 
; 0000 01EA 
; 0000 01EB // Analog Comparator initialization
; 0000 01EC // Analog Comparator: Off
; 0000 01ED // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01EE ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01EF SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 01F0 
; 0000 01F1 // ADC initialization
; 0000 01F2 // ADC Clock frequency: 250.000 kHz
; 0000 01F3 // ADC Voltage Reference: AVCC pin
; 0000 01F4 // ADC Auto Trigger Source: None
; 0000 01F5 // Only the 8 most significant bits of
; 0000 01F6 // the AD conversion result are used
; 0000 01F7 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 01F8 ADCSRA=0x86;
	LDI  R30,LOW(134)
	OUT  0x6,R30
; 0000 01F9 
; 0000 01FA //Initialize I2C bus
; 0000 01FB i2c_init();
	CALL _i2c_init
; 0000 01FC 
; 0000 01FD // Global enable interrupts
; 0000 01FE #asm("sei")
	sei
; 0000 01FF 
; 0000 0200 
; 0000 0201 while (1)
; 0000 0202       {
; 0000 0203 
; 0000 0204 		//#MAX 232 TEST :
; 0000 0205 		printf("\r\n\n\nMega16 development board for project/product/robotics development");
	__POINTW1FN _0x0,250
	CALL SUBOPT_0xF
	ADIW R28,2
; 0000 0206 
; 0000 0207 
; 0000 0208 		//#Wait for SW0(PC.2) press for LCD detection. If user presses the SW0 within 3 seconds then
; 0000 0209 		//LCD is assumed to be present and LCD test routines will be run and visual feebback will
; 0000 020A 		//be displayed on LCD. If not, then LCD is assumed to be absent.
; 0000 020B 		i=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x14
; 0000 020C 		DDRC.2=0; 				//set 2nd bit of PC as input bit
	CBI  0x14,2
; 0000 020D 		PORTC.2=1;				//turn on internal pull-up for that bit
	SBI  0x15,2
; 0000 020E 		while(i<3000)
_0x96:
	CALL SUBOPT_0x13
	CPI  R26,LOW(0xBB8)
	LDI  R30,HIGH(0xBB8)
	CPC  R27,R30
	BRSH _0x98
; 0000 020F 		{
; 0000 0210 			if(PINC.2==0)
	SBIC 0x13,2
	RJMP _0x99
; 0000 0211 			{
; 0000 0212 				lcdPresent = 1;
	LDI  R30,LOW(1)
	STS  _lcdPresent,R30
; 0000 0213 				break;
	RJMP _0x98
; 0000 0214 			}
; 0000 0215 			else
_0x99:
; 0000 0216 				lcdPresent = 0;
	LDI  R30,LOW(0)
	STS  _lcdPresent,R30
; 0000 0217 
; 0000 0218 			i++;
	CALL SUBOPT_0xB
; 0000 0219 			delay_ms(1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x2
; 0000 021A 		};
	RJMP _0x96
_0x98:
; 0000 021B 
; 0000 021C       if(lcdPresent==1)
	LDS  R26,_lcdPresent
	CPI  R26,LOW(0x1)
	BRNE _0x9B
; 0000 021D 			printf("\n\rLCD is assumed to be present.");
	__POINTW1FN _0x0,320
	RJMP _0xB5
; 0000 021E 		else
_0x9B:
; 0000 021F 			printf("\n\rLCD is assumed to be absent.");
	__POINTW1FN _0x0,352
_0xB5:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 0220 
; 0000 0221 
; 0000 0222 		//# If LCD is present ... initialize the LCD and display message and execute test routines
; 0000 0223 		if(lcdPresent==1)
	LDS  R26,_lcdPresent
	CPI  R26,LOW(0x1)
	BRNE _0x9D
; 0000 0224 		{
; 0000 0225        	//Initialize and test LCD
; 0000 0226 			lcd_test();
	RCALL _lcd_test
; 0000 0227 
; 0000 0228 			//EEPROM test
; 0000 0229          while(PINC.2==0){delay_ms(100);};
_0x9E:
	SBIC 0x13,2
	RJMP _0xA0
	CALL SUBOPT_0x16
	RJMP _0x9E
_0xA0:
; 0000 022A          i2c_test_withLCD();
	RCALL _i2c_test_withLCD
; 0000 022B 
; 0000 022C          //Wait for SW0 press - Test the L293D
; 0000 022D          while(PINC.2==0){delay_ms(100);};
_0xA1:
	SBIC 0x13,2
	RJMP _0xA3
	CALL SUBOPT_0x16
	RJMP _0xA1
_0xA3:
; 0000 022E 			l293d1_test();
	RCALL _l293d1_test
; 0000 022F 
; 0000 0230 			//Test the ADC
; 0000 0231          while(PINC.2==0){delay_ms(100);};
_0xA4:
	SBIC 0x13,2
	RJMP _0xA6
	CALL SUBOPT_0x16
	RJMP _0xA4
_0xA6:
; 0000 0232 			adc_test();
	RJMP _0xB6
; 0000 0233 
; 0000 0234 			//Now wait for key press on IR remote. And execute test routines according to remote key press.
; 0000 0235 			ir_test();
; 0000 0236 		}
; 0000 0237 
; 0000 0238 		//# If LCD is absent we can also test 2nd L293D which is connected on PORTB.
; 0000 0239 		else
_0x9D:
; 0000 023A 		{
; 0000 023B        	//LED test
; 0000 023C          led_test();
	RCALL _led_test
; 0000 023D 
; 0000 023E 			//EEPROM test
; 0000 023F          while(PINC.2==0){delay_ms(100);};
_0xA8:
	SBIC 0x13,2
	RJMP _0xAA
	CALL SUBOPT_0x16
	RJMP _0xA8
_0xAA:
; 0000 0240          i2c_test();
	RCALL _i2c_test
; 0000 0241 
; 0000 0242          //Wait for SW0 press - Test the L293D
; 0000 0243          while(PINC.2==0){delay_ms(100);};
_0xAB:
	SBIC 0x13,2
	RJMP _0xAD
	CALL SUBOPT_0x16
	RJMP _0xAB
_0xAD:
; 0000 0244 			l293d1_test();
	RCALL _l293d1_test
; 0000 0245          l293d2_test();
	RCALL _l293d2_test
; 0000 0246 
; 0000 0247 			//Test the ADC
; 0000 0248          while(PINC.2==0){delay_ms(100);};
_0xAE:
	SBIC 0x13,2
	RJMP _0xB0
	CALL SUBOPT_0x16
	RJMP _0xAE
_0xB0:
; 0000 0249 			adc_test();
_0xB6:
	RCALL _adc_test
; 0000 024A 
; 0000 024B 			//Now wait for key press on IR remote. And execute test routines according to remote key press.
; 0000 024C 			ir_test();
	RCALL _ir_test
; 0000 024D 		}
; 0000 024E 
; 0000 024F 		while(1);
_0xB1:
	RJMP _0xB1
; 0000 0250 
; 0000 0251       };
; 0000 0252 }
_0xB4:
	RJMP _0xB4
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
     sbis usr,udre
     rjmp _putchar
     ld   r30,y
     out  udr,r30
	JMP  _0x20C0001
__put_G100:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	ST   X+,R30
	ST   X,R31
_0x2000012:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+6
	STD  Z+0,R26
_0x2000013:
	RJMP _0x2000014
_0x2000010:
	LDD  R30,Y+6
	ST   -Y,R30
	RCALL _putchar
_0x2000014:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
__print_G100:
	SBIW R28,11
	CALL __SAVELOCR6
	LDI  R17,0
_0x2000015:
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	ADIW R30,1
	STD  Y+23,R30
	STD  Y+23+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000017
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001B
	CPI  R18,37
	BRNE _0x200001C
	LDI  R17,LOW(1)
	RJMP _0x200001D
_0x200001C:
	CALL SUBOPT_0x17
_0x200001D:
	RJMP _0x200001A
_0x200001B:
	CPI  R30,LOW(0x1)
	BRNE _0x200001E
	CPI  R18,37
	BRNE _0x200001F
	CALL SUBOPT_0x17
	RJMP _0x20000C2
_0x200001F:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000020
	LDI  R16,LOW(1)
	RJMP _0x200001A
_0x2000020:
	CPI  R18,43
	BRNE _0x2000021
	LDI  R20,LOW(43)
	RJMP _0x200001A
_0x2000021:
	CPI  R18,32
	BRNE _0x2000022
	LDI  R20,LOW(32)
	RJMP _0x200001A
_0x2000022:
	RJMP _0x2000023
_0x200001E:
	CPI  R30,LOW(0x2)
	BRNE _0x2000024
_0x2000023:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000025
	ORI  R16,LOW(128)
	RJMP _0x200001A
_0x2000025:
	RJMP _0x2000026
_0x2000024:
	CPI  R30,LOW(0x3)
	BRNE _0x2000027
_0x2000026:
	CPI  R18,48
	BRLO _0x2000029
	CPI  R18,58
	BRLO _0x200002A
_0x2000029:
	RJMP _0x2000028
_0x200002A:
	MOV  R26,R21
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R21,R30
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001A
_0x2000028:
	CPI  R18,108
	BRNE _0x200002B
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x200001A
_0x200002B:
	RJMP _0x200002C
_0x2000027:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x200001A
_0x200002C:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000031
	CALL SUBOPT_0x18
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x19
	RJMP _0x2000032
_0x2000031:
	CPI  R30,LOW(0x73)
	BRNE _0x2000034
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000035
_0x2000034:
	CPI  R30,LOW(0x70)
	BRNE _0x2000037
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000035:
	ANDI R16,LOW(127)
	LDI  R30,LOW(0)
	STD  Y+16,R30
	LDI  R19,LOW(0)
	RJMP _0x2000038
_0x2000037:
	CPI  R30,LOW(0x64)
	BREQ _0x200003B
	CPI  R30,LOW(0x69)
	BRNE _0x200003C
_0x200003B:
	ORI  R16,LOW(4)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x75)
	BRNE _0x200003E
_0x200003D:
	LDI  R30,LOW(10)
	STD  Y+16,R30
	SBRS R16,1
	RJMP _0x200003F
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x1B
	LDI  R17,LOW(10)
	RJMP _0x2000040
_0x200003F:
	__GETD1N 0x2710
	CALL SUBOPT_0x1B
	LDI  R17,LOW(5)
	RJMP _0x2000040
_0x200003E:
	CPI  R30,LOW(0x58)
	BRNE _0x2000042
	ORI  R16,LOW(8)
	RJMP _0x2000043
_0x2000042:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2000076
_0x2000043:
	LDI  R30,LOW(16)
	STD  Y+16,R30
	SBRS R16,1
	RJMP _0x2000045
	__GETD1N 0x10000000
	CALL SUBOPT_0x1B
	LDI  R17,LOW(8)
	RJMP _0x2000040
_0x2000045:
	__GETD1N 0x1000
	CALL SUBOPT_0x1B
	LDI  R17,LOW(4)
_0x2000040:
	SBRS R16,1
	RJMP _0x2000046
	CALL SUBOPT_0x18
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x20000C3
_0x2000046:
	SBRS R16,2
	RJMP _0x2000048
	CALL SUBOPT_0x18
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	CALL __GETW1P
	CALL __CWD1
	RJMP _0x20000C3
_0x2000048:
	CALL SUBOPT_0x18
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	CALL __GETW1P
	CLR  R22
	CLR  R23
_0x20000C3:
	__PUTD1S 12
	SBRS R16,2
	RJMP _0x200004A
	LDD  R26,Y+15
	TST  R26
	BRPL _0x200004B
	__GETD1S 12
	CALL __ANEGD1
	__PUTD1S 12
	LDI  R20,LOW(45)
_0x200004B:
	CPI  R20,0
	BREQ _0x200004C
	SUBI R17,-LOW(1)
	RJMP _0x200004D
_0x200004C:
	ANDI R16,LOW(251)
_0x200004D:
_0x200004A:
_0x2000038:
	SBRC R16,0
	RJMP _0x200004E
_0x200004F:
	CP   R17,R21
	BRSH _0x2000051
	SBRS R16,7
	RJMP _0x2000052
	SBRS R16,2
	RJMP _0x2000053
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x2000054
_0x2000053:
	LDI  R18,LOW(48)
_0x2000054:
	RJMP _0x2000055
_0x2000052:
	LDI  R18,LOW(32)
_0x2000055:
	CALL SUBOPT_0x17
	SUBI R21,LOW(1)
	RJMP _0x200004F
_0x2000051:
_0x200004E:
	MOV  R19,R17
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0x2000056
_0x2000057:
	CPI  R19,0
	BREQ _0x2000059
	SBRS R16,3
	RJMP _0x200005A
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,1
	LPM  R30,Z
	RJMP _0x20000C4
_0x200005A:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x20000C4:
	ST   -Y,R30
	CALL SUBOPT_0x19
	CPI  R21,0
	BREQ _0x200005C
	SUBI R21,LOW(1)
_0x200005C:
	SUBI R19,LOW(1)
	RJMP _0x2000057
_0x2000059:
	RJMP _0x200005D
_0x2000056:
_0x200005F:
	CALL SUBOPT_0x1C
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x2000061
	SBRS R16,3
	RJMP _0x2000062
	SUBI R18,-LOW(55)
	RJMP _0x2000063
_0x2000062:
	SUBI R18,-LOW(87)
_0x2000063:
	RJMP _0x2000064
_0x2000061:
	SUBI R18,-LOW(48)
_0x2000064:
	SBRC R16,4
	RJMP _0x2000066
	CPI  R18,49
	BRSH _0x2000068
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	BRNE _0x2000067
_0x2000068:
	RJMP _0x200006A
_0x2000067:
	CP   R21,R19
	BRLO _0x200006C
	SBRS R16,0
	RJMP _0x200006D
_0x200006C:
	RJMP _0x200006B
_0x200006D:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x200006E
	LDI  R18,LOW(48)
_0x200006A:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006F
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x19
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
_0x2000070:
_0x200006F:
_0x200006E:
_0x2000066:
	CALL SUBOPT_0x17
	CPI  R21,0
	BREQ _0x2000071
	SUBI R21,LOW(1)
_0x2000071:
_0x200006B:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x1C
	CALL __MODD21U
	__PUTD1S 12
	LDD  R30,Y+16
	CALL SUBOPT_0x1D
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x1B
	__GETD1S 8
	CALL __CPD10
	BREQ _0x2000060
	RJMP _0x200005F
_0x2000060:
_0x200005D:
	SBRS R16,0
	RJMP _0x2000072
_0x2000073:
	CPI  R21,0
	BREQ _0x2000075
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x19
	RJMP _0x2000073
_0x2000075:
_0x2000072:
_0x2000076:
_0x2000032:
_0x20000C2:
	LDI  R17,LOW(0)
_0x200001A:
	RJMP _0x2000015
_0x2000017:
	CALL __LOADLOCR6
	ADIW R28,25
	RET
_printf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,2
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,0
	STD  Y+2,R30
	STD  Y+2+1,R30
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	POP  R15
	RET

	.CSEG
_ltoa:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	__GETD1N 0x3B9ACA00
	__PUTD1S 2
	LDI  R16,LOW(0)
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020003
	__GETD1S 8
	CALL __ANEGD1
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1F
	LDI  R30,LOW(45)
	ST   X,R30
_0x2020003:
_0x2020005:
	CALL SUBOPT_0x20
	CALL __DIVD21U
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x2020008
	CPI  R16,0
	BRNE _0x2020008
	__GETD2S 2
	CALL SUBOPT_0x1E
	BRNE _0x2020007
_0x2020008:
	CALL SUBOPT_0x1F
	MOV  R30,R17
	SUBI R30,-LOW(48)
	ST   X,R30
	LDI  R16,LOW(1)
_0x2020007:
	CALL SUBOPT_0x20
	CALL __MODD21U
	CALL SUBOPT_0x1B
	__GETD2S 2
	__GETD1N 0xA
	CALL __DIVD21U
	__PUTD1S 2
	CALL __CPD10
	BRNE _0x2020005
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,12
	RET

	.DSEG

	.CSEG
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G102:
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
__lcd_ready:
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G102
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G102
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G102
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G102
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G102:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G102
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G102
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G102
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G102
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x20C0001
__lcd_read_nibble_G102:
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G102
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G102
    andi  r30,0xf0
	RET
_lcd_read_byte0_G102:
	CALL __lcd_delay_G102
	RCALL __lcd_read_nibble_G102
    mov   r26,r30
	RCALL __lcd_read_nibble_G102
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G102)
	SBCI R31,HIGH(-__base_y_G102)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x20C0004:
	ADIW R28,2
	RET
_lcd_clear:
	CALL __lcd_ready
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R30,R26
	BRSH _0x2040004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	ST   -Y,R30
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2040004:
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x20C0001
_lcd_puts:
	ST   -Y,R17
_0x2040005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040007
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2040005
_0x2040007:
	RJMP _0x20C0002
_lcd_putsf:
	ST   -Y,R17
_0x2040008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x204000A
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2040008
_0x204000A:
_0x20C0002:
	LDD  R17,Y+0
_0x20C0003:
	ADIW R28,3
	RET
__long_delay_G102:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G102:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G102
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x20C0001
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G102,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G102,3
	CALL SUBOPT_0x21
	CALL SUBOPT_0x21
	CALL SUBOPT_0x21
	RCALL __long_delay_G102
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G102
	RCALL __long_delay_G102
	LDI  R30,LOW(40)
	CALL SUBOPT_0x22
	LDI  R30,LOW(4)
	CALL SUBOPT_0x22
	LDI  R30,LOW(133)
	CALL SUBOPT_0x22
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G102
	CPI  R30,LOW(0x5)
	BREQ _0x204000B
	LDI  R30,LOW(0)
	RJMP _0x20C0001
_0x204000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x20C0001:
	ADIW R28,1
	RET

	.CSEG

	.CSEG
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
    lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.CSEG

	.DSEG
_i:
	.BYTE 0x2
_adc_val:
	.BYTE 0x1
_lcdPresent:
	.BYTE 0x1
_adc_volt:
	.BYTE 0x2
__seed_G101:
	.BYTE 0x4
__base_y_G102:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
_p_S1040024:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LD   R30,Y
	LDD  R31,Y+1
	ANDI R30,LOW(0xFF00)
	MOVW R8,R30
	MOV  R8,R9
	CLR  R9
	MOV  R5,R8
	CLR  R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ST   -Y,R5
	CALL _i2c_write
	ST   -Y,R4
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	__POINTW1FN _0x0,14
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _i,R30
	STS  _i+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6:
	LDS  R26,_i
	LDS  R27,_i+1
	SBIW R26,5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x7:
	LDS  R30,_i
	LDS  R31,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	SUBI R30,LOW(-65)
	SBCI R31,HIGH(-65)
	ST   -Y,R30
	RCALL SUBOPT_0x7
	ST   -Y,R31
	ST   -Y,R30
	JMP  _writeByte

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-65)
	SBCI R31,HIGH(-65)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	CALL _putchar
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	__POINTW1FN _0x0,30
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _i,R30
	STS  _i+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	RCALL SUBOPT_0x7
	ST   -Y,R31
	ST   -Y,R30
	CALL _readByte
	MOV  R6,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0xF:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	JMP  _printf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	__POINTW1FN _0x0,58
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _i,R30
	STS  _i+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDS  R26,_i
	LDS  R27,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	STS  _i,R30
	STS  _i+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x7
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x17:
	ST   -Y,R18
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,20
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x18:
	LDD  R30,Y+21
	LDD  R31,Y+21+1
	SBIW R30,4
	STD  Y+21,R30
	STD  Y+21+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x19:
	LDD  R30,Y+20
	LDD  R31,Y+20+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,20
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1B:
	__PUTD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	__GETD1S 8
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	__CPD2N 0x1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	__GETD1S 2
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x21:
	CALL __long_delay_G102
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G102

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x22:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G102


	.CSEG
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2
_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,27
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,53
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	ld   r23,y+
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ld   r30,y+
	ldi  r23,8
__i2c_write0:
	lsl  r30
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	ret

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
