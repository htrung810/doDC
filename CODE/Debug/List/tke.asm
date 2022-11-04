
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32L
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32L
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

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
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
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
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
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

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
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

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
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

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
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
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
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

	.MACRO __PUTBSR
	STD  Y+@1,R@0
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
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
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
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
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
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
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
	.DEF _adc=R4
	.DEF _adc_msb=R5
	.DEF _N=R6
	.DEF _N_msb=R7
	.DEF _tx_wr_index=R9
	.DEF _tx_rd_index=R8
	.DEF _tx_counter=R11
	.DEF __lcd_x=R10
	.DEF __lcd_y=R13
	.DEF __lcd_maxx=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0

_0x0:
	.DB  0x4F,0x4E,0x20,0x44,0x49,0x4E,0x48,0x0
	.DB  0x31,0x30,0x30,0x25,0x0,0x39,0x30,0x25
	.DB  0x0,0x38,0x30,0x25,0x0,0x37,0x30,0x25
	.DB  0x0,0x36,0x30,0x25,0x0,0x35,0x30,0x25
	.DB  0x0,0x34,0x30,0x25,0x0,0x43,0x41,0x4E
	.DB  0x48,0x20,0x42,0x41,0x4F,0x0,0x33,0x30
	.DB  0x25,0x0,0x32,0x30,0x25,0x0,0x4E,0x47
	.DB  0x55,0x59,0x20,0x48,0x49,0x45,0x4D,0x0
	.DB  0x31,0x30,0x25,0x0,0x47,0x69,0x61,0x20
	.DB  0x54,0x72,0x69,0x3A,0x20,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x08
	.DW  __REG_VARS*2

	.DW  0x08
	.DW  _0x7
	.DW  _0x0*2

	.DW  0x05
	.DW  _0x7+8
	.DW  _0x0*2+8

	.DW  0x04
	.DW  _0x7+13
	.DW  _0x0*2+13

	.DW  0x04
	.DW  _0x7+17
	.DW  _0x0*2+17

	.DW  0x04
	.DW  _0x7+21
	.DW  _0x0*2+21

	.DW  0x04
	.DW  _0x7+25
	.DW  _0x0*2+25

	.DW  0x04
	.DW  _0x7+29
	.DW  _0x0*2+29

	.DW  0x04
	.DW  _0x7+33
	.DW  _0x0*2+33

	.DW  0x09
	.DW  _0x7+37
	.DW  _0x0*2+37

	.DW  0x04
	.DW  _0x7+46
	.DW  _0x0*2+46

	.DW  0x04
	.DW  _0x7+50
	.DW  _0x0*2+50

	.DW  0x0A
	.DW  _0x7+54
	.DW  _0x0*2+54

	.DW  0x04
	.DW  _0x7+64
	.DW  _0x0*2+64

	.DW  0x03
	.DW  _0x7+68
	.DW  _0x0*2+10

	.DW  0x0A
	.DW  _0x23
	.DW  _0x0*2+68

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

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

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
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

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 10/13/2022
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega32L
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*******************************************************/
;
;#include <main.h>
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
;#include <main.h>
;#include <adc.h>
;
;unsigned int adc;
;// Declare your global variables here
;#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0018 {

	.CSEG
_read_adc:
; .FSTART _read_adc
;    ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
;// Delay needed for the stabilization of the ADC input voltage
;    delay_us(10);
	__DELAY_USB 27
;// Start the AD conversion
;    ADCSRA|=(1<<ADSC);
	SBI  0x6,6
;// Wait for the AD conversion to complete
;    while ((ADCSRA & (1<<ADIF))==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
;    ADCSRA|=(1<<ADIF);
	SBI  0x6,4
;    return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x2080001
;}
; .FEND
;
;unsigned int N;
;float gtri_bcd()
;{
_gtri_bcd:
; .FSTART _gtri_bcd
;    float giatri,temp,temp2;
;    N = read_adc(0);
	SBIW R28,12
;	giatri -> Y+8
;	temp -> Y+4
;	temp2 -> Y+0
	LDI  R26,LOW(0)
	RCALL _read_adc
	MOVW R6,R30
;    temp = ((float)N * 5) / 1023;
	CALL SUBOPT_0x0
	__PUTD1S 4
;    temp2 = temp * 5.67 * 100;
	__GETD2S 4
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
;    giatri = temp2 / 100 ;
	CALL SUBOPT_0x3
	__PUTD1S 8
;
;
;
;    return giatri;
	ADIW R28,12
	RET
;}
; .FEND
;
;void lcd_putnum(unsigned int N)
;{
_lcd_putnum:
; .FSTART _lcd_putnum
;     float temp, temp2, giatri;
;     unsigned int Nghin, Tram, Chuc, Dv, temp3;
;     temp = ((float)N * 5) / 1023;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,16
	CALL __SAVELOCR6
;	N -> Y+22
;	temp -> Y+18
;	temp2 -> Y+14
;	giatri -> Y+10
;	Nghin -> R16,R17
;	Tram -> R18,R19
;	Chuc -> R20,R21
;	Dv -> Y+8
;	temp3 -> Y+6
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	CALL SUBOPT_0x0
	__PUTD1S 18
;     temp2 = temp * 5.67 * 100;
	__GETD2S 18
	CALL SUBOPT_0x1
	__PUTD1S 14
;     temp3 = (int)temp2;
	CALL __CFD1
	STD  Y+6,R30
	STD  Y+6+1,R31
;     Nghin = temp3/1000;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21U
	MOVW R16,R30
;     Tram = (temp3%1000) /100;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __MODW21U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOVW R18,R30
;     Chuc = (temp3%100) /10;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOVW R20,R30
;     Dv = temp3 % 10;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	STD  Y+8,R30
	STD  Y+8+1,R31
;     lcd_putchar(Nghin + 48);
	MOV  R26,R16
	SUBI R26,-LOW(48)
	CALL _lcd_putchar
;     lcd_putchar(Tram + 48);
	MOV  R26,R18
	SUBI R26,-LOW(48)
	CALL _lcd_putchar
;     lcd_putchar(',');
	LDI  R26,LOW(44)
	CALL _lcd_putchar
;     lcd_putchar(Chuc + 48);
	MOV  R26,R20
	SUBI R26,-LOW(48)
	CALL _lcd_putchar
;     lcd_putchar(Dv + 48);
	LDD  R26,Y+8
	SUBI R26,-LOW(48)
	CALL _lcd_putchar
;     lcd_putchar('V');
	LDI  R26,LOW(86)
	CALL _lcd_putchar
;     giatri = temp2 / 100;
	__GETD2S 14
	CALL SUBOPT_0x3
	__PUTD1S 10
;     if (giatri > 11.9)
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	BREQ PC+2
	BRCC PC+2
	RJMP _0x6
;     {
;        lcd_gotoxy(1,1);
	CALL SUBOPT_0x6
;        lcd_puts("ON DINH");
	__POINTW2MN _0x7,0
	CALL _lcd_puts
;        delay_ms(1000);
	CALL SUBOPT_0x7
;        if(giatri>=12.7)
	CALL SUBOPT_0x4
	CALL SUBOPT_0x8
	BRLO _0x8
;        {
;            lcd_clear();
	CALL _lcd_clear
;            lcd_puts("100%");
	__POINTW2MN _0x7,8
	RJMP _0x46
;        }
;        else if (giatri >= 12.5)
_0x8:
	CALL SUBOPT_0x4
	CALL SUBOPT_0x9
	BRLO _0xA
;        {
;            lcd_clear();
	CALL _lcd_clear
;            lcd_puts("90%");
	__POINTW2MN _0x7,13
	RJMP _0x46
;        }
;        else if (giatri >= 12.42)
_0xA:
	CALL SUBOPT_0x4
	CALL SUBOPT_0xA
	BRLO _0xC
;        {
;            lcd_clear();
	CALL _lcd_clear
;            lcd_puts("80%");
	__POINTW2MN _0x7,17
	RJMP _0x46
;        }
;        else if (giatri >= 12.32)
_0xC:
	CALL SUBOPT_0x4
	CALL SUBOPT_0xB
	BRLO _0xE
;        {
;            lcd_clear();
	CALL _lcd_clear
;            lcd_puts("70%");
	__POINTW2MN _0x7,21
	RJMP _0x46
;        }
;        else if (giatri >= 12.20)
_0xE:
	CALL SUBOPT_0x4
	CALL SUBOPT_0xC
	BRLO _0x10
;        {
;            lcd_clear();
	CALL _lcd_clear
;            lcd_puts("60%");
	__POINTW2MN _0x7,25
	RJMP _0x46
;        }
;        else if (giatri >= 12.06)
_0x10:
	CALL SUBOPT_0x4
	CALL SUBOPT_0xD
	BRLO _0x12
;        {
;            lcd_clear();
	CALL _lcd_clear
;            lcd_puts("50%");
	__POINTW2MN _0x7,29
	RJMP _0x46
;        }
;        else if (giatri >= 11.9)
_0x12:
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	BRLO _0x14
;        {
;            lcd_clear();
	CALL _lcd_clear
;            lcd_puts("40%");
	__POINTW2MN _0x7,33
_0x46:
	CALL _lcd_puts
;        } }
_0x14:
;
;
;     else if (giatri >= 11.58)
	RJMP _0x15
_0x6:
	CALL SUBOPT_0xE
	BRLO _0x16
;     {
;        lcd_gotoxy(1,1);
	CALL SUBOPT_0x6
;        lcd_puts("CANH BAO");
	__POINTW2MN _0x7,37
	CALL _lcd_puts
;        PORTD.7 = 1;
	SBI  0x12,7
;        delay_ms(1000);
	CALL SUBOPT_0x7
;        PORTD.7 = 0;
	CBI  0x12,7
;        if(giatri >= 11.75)
	CALL SUBOPT_0x4
	CALL SUBOPT_0xF
	BRLO _0x1B
;        {
;            lcd_clear();
	CALL _lcd_clear
;            lcd_puts("30%");
	__POINTW2MN _0x7,46
	RJMP _0x47
;        }
;         else if (giatri >= 11.58)
_0x1B:
	CALL SUBOPT_0xE
	BRLO _0x1D
;        {
;            lcd_clear();
	CALL _lcd_clear
;            lcd_puts("20%");
	__POINTW2MN _0x7,50
_0x47:
	CALL _lcd_puts
;        }
;
;     }
_0x1D:
;     else
	RJMP _0x1E
_0x16:
;     {
;        lcd_gotoxy(1,1);
	CALL SUBOPT_0x6
;        lcd_puts("NGUY HIEM");
	__POINTW2MN _0x7,54
	CALL _lcd_puts
;        PORTD.7 = 1;
	SBI  0x12,7
;        delay_ms(1000);
	CALL SUBOPT_0x7
;         if (giatri >= 11.31)
	CALL SUBOPT_0x4
	CALL SUBOPT_0x10
	BRLO _0x21
;        {
;            lcd_clear();
	CALL _lcd_clear
;            lcd_puts("10%");
	__POINTW2MN _0x7,64
	RJMP _0x48
;        }
;        else
_0x21:
;        {
;            lcd_clear();
	CALL _lcd_clear
;            lcd_puts("0%");
	__POINTW2MN _0x7,68
_0x48:
	CALL _lcd_puts
;     }  }
_0x1E:
_0x15:
;}
	CALL __LOADLOCR6
	ADIW R28,24
	RET
; .FEND

	.DSEG
_0x7:
	.BYTE 0x47
;
;void lcd_hienthi()
;{

	.CSEG
_lcd_hienthi:
; .FSTART _lcd_hienthi
;    adc = read_adc(0);
	LDI  R26,LOW(0)
	RCALL _read_adc
	MOVW R4,R30
;    lcd_puts("Gia Tri: ");
	__POINTW2MN _0x23,0
	CALL _lcd_puts
;    lcd_putnum(adc);
	MOVW R26,R4
	RCALL _lcd_putnum
;    delay_ms(1000);
	CALL SUBOPT_0x7
;    lcd_clear();
	CALL _lcd_clear
;}
	RET
; .FEND

	.DSEG
_0x23:
	.BYTE 0xA
;#include <mega32.h>
;
;
;// Declare your global variables here
;
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 8
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE <= 256
;unsigned char tx_wr_index=0,tx_rd_index=0;
;#else
;unsigned int tx_wr_index=0,tx_rd_index=0;
;#endif
;
;#if TX_BUFFER_SIZE < 256
;unsigned char tx_counter=0;
;#else
;unsigned int tx_counter=0;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 0036 {

	.CSEG
_usart_tx_isr:
; .FSTART _usart_tx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0037 if (tx_counter)
	TST  R11
	BREQ _0x24
; 0000 0038    {
; 0000 0039    --tx_counter;
	DEC  R11
; 0000 003A    UDR=tx_buffer[tx_rd_index++];
	MOV  R30,R8
	INC  R8
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 003B #if TX_BUFFER_SIZE != 256
; 0000 003C    if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDI  R30,LOW(8)
	CP   R30,R8
	BRNE _0x25
	CLR  R8
; 0000 003D #endif
; 0000 003E    }
_0x25:
; 0000 003F }
_0x24:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 0046 {
_putchar:
; .FSTART _putchar
; 0000 0047 while (tx_counter == TX_BUFFER_SIZE);
	ST   -Y,R26
;	c -> Y+0
_0x26:
	LDI  R30,LOW(8)
	CP   R30,R11
	BREQ _0x26
; 0000 0048 #asm("cli")
	cli
; 0000 0049 if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	TST  R11
	BRNE _0x2A
	SBIC 0xB,5
	RJMP _0x29
_0x2A:
; 0000 004A    {
; 0000 004B    tx_buffer[tx_wr_index++]=c;
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0000 004C #if TX_BUFFER_SIZE != 256
; 0000 004D    if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0x2C
	CLR  R9
; 0000 004E #endif
; 0000 004F    ++tx_counter;
_0x2C:
	INC  R11
; 0000 0050    }
; 0000 0051 else
	RJMP _0x2D
_0x29:
; 0000 0052    UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 0053 #asm("sei")
_0x2D:
	sei
; 0000 0054 }
	JMP  _0x2080001
; .FEND
;#pragma used-
;#endif
;
;// Alphanumeric LCD functions
;
;
;// Declare your global variables here
;
;// Standard Input/Output functions
;
;
;// Voltage Reference: AVCC pin
;
;// Read the AD conversion result
;
;void main(void)
; 0000 0065 {
_main:
; .FSTART _main
; 0000 0066 
; 0000 0067 // Declare your local variables here
; 0000 0068     float so;
; 0000 0069 // Input/Output Ports initialization
; 0000 006A // Port A initialization
; 0000 006B // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 006C DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	SBIW R28,4
;	so -> Y+0
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 006D // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 006E PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 006F 
; 0000 0070 // Port B initialization
; 0000 0071 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0072 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0073 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=P
; 0000 0074 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (1<<PORTB0);
	LDI  R30,LOW(1)
	OUT  0x18,R30
; 0000 0075 
; 0000 0076 // Port C initialization
; 0000 0077 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0078 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 0079 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 007A PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 007B 
; 0000 007C // Port D initialization
; 0000 007D // Function: Bit7=Out Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 007E DDRD=(1<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(128)
	OUT  0x11,R30
; 0000 007F // State: Bit7=0 Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0080 PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0081 
; 0000 0082 // Timer/Counter 0 initialization
; 0000 0083 // Clock source: System Clock
; 0000 0084 // Clock value: Timer 0 Stopped
; 0000 0085 // Mode: Normal top=0xFF
; 0000 0086 // OC0 output: Disconnected
; 0000 0087 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 0088 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0089 OCR0=0x00;
	OUT  0x3C,R30
; 0000 008A 
; 0000 008B // Timer/Counter 1 initialization
; 0000 008C // Clock source: System Clock
; 0000 008D // Clock value: Timer1 Stopped
; 0000 008E // Mode: Normal top=0xFFFF
; 0000 008F // OC1A output: Disconnected
; 0000 0090 // OC1B output: Disconnected
; 0000 0091 // Noise Canceler: Off
; 0000 0092 // Input Capture on Falling Edge
; 0000 0093 // Timer1 Overflow Interrupt: Off
; 0000 0094 // Input Capture Interrupt: Off
; 0000 0095 // Compare A Match Interrupt: Off
; 0000 0096 // Compare B Match Interrupt: Off
; 0000 0097 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0098 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0099 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 009A TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 009B ICR1H=0x00;
	OUT  0x27,R30
; 0000 009C ICR1L=0x00;
	OUT  0x26,R30
; 0000 009D OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 009E OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 009F OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00A0 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00A1 
; 0000 00A2 // Timer/Counter 2 initialization
; 0000 00A3 // Clock source: System Clock
; 0000 00A4 // Clock value: Timer2 Stopped
; 0000 00A5 // Mode: Normal top=0xFF
; 0000 00A6 // OC2 output: Disconnected
; 0000 00A7 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 00A8 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 00A9 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00AA OCR2=0x00;
	OUT  0x23,R30
; 0000 00AB 
; 0000 00AC // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00AD TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 00AE 
; 0000 00AF // External Interrupt(s) initialization
; 0000 00B0 // INT0: Off
; 0000 00B1 // INT1: Off
; 0000 00B2 // INT2: Off
; 0000 00B3 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 00B4 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 00B5 
; 0000 00B6 // USART initialization
; 0000 00B7 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00B8 // USART Receiver: Off
; 0000 00B9 // USART Transmitter: On
; 0000 00BA // USART Mode: Asynchronous
; 0000 00BB // USART Baud Rate: 9600
; 0000 00BC UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 00BD UCSRB=(1<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 00BE UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 00BF UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00C0 UBRRL=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 00C1 
; 0000 00C2 // Analog Comparator initialization
; 0000 00C3 // Analog Comparator: Off
; 0000 00C4 // The Analog Comparator's positive input is
; 0000 00C5 // connected to the AIN0 pin
; 0000 00C6 // The Analog Comparator's negative input is
; 0000 00C7 // connected to the AIN1 pin
; 0000 00C8 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00C9 
; 0000 00CA // ADC initialization
; 0000 00CB // ADC Clock frequency: 1000.000 kHz
; 0000 00CC // ADC Voltage Reference: AVCC pin
; 0000 00CD // ADC Auto Trigger Source: ADC Stopped
; 0000 00CE ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 00CF ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(131)
	OUT  0x6,R30
; 0000 00D0 SFIOR=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00D1 
; 0000 00D2 // SPI initialization
; 0000 00D3 // SPI disabled
; 0000 00D4 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 00D5 
; 0000 00D6 // TWI initialization
; 0000 00D7 // TWI disabled
; 0000 00D8 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00D9 
; 0000 00DA // Alphanumeric LCD initialization
; 0000 00DB // Connections are specified in the
; 0000 00DC // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00DD // RS - PORTC Bit 4
; 0000 00DE // RD - PORTC Bit 5
; 0000 00DF // EN - PORTC Bit 6
; 0000 00E0 // D4 - PORTC Bit 3
; 0000 00E1 // D5 - PORTC Bit 2
; 0000 00E2 // D6 - PORTC Bit 1
; 0000 00E3 // D7 - PORTC Bit 0
; 0000 00E4 // Characters/line: 16
; 0000 00E5 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 00E6 
; 0000 00E7 while (1)
_0x2E:
; 0000 00E8       {
; 0000 00E9 
; 0000 00EA             so = gtri_bcd();
	RCALL _gtri_bcd
	CALL SUBOPT_0x2
; 0000 00EB              if (so >= 12.7)
	CALL SUBOPT_0x8
	BRLO _0x31
; 0000 00EC              {
; 0000 00ED              putchar('A');
	LDI  R26,LOW(65)
	RJMP _0x49
; 0000 00EE              }
; 0000 00EF              else if (so >= 12.5)
_0x31:
	CALL SUBOPT_0x11
	CALL SUBOPT_0x9
	BRLO _0x33
; 0000 00F0              {
; 0000 00F1              putchar('B');
	LDI  R26,LOW(66)
	RJMP _0x49
; 0000 00F2              }
; 0000 00F3              else if (so >= 12.42)
_0x33:
	CALL SUBOPT_0x11
	CALL SUBOPT_0xA
	BRLO _0x35
; 0000 00F4              {
; 0000 00F5              putchar('C');
	LDI  R26,LOW(67)
	RJMP _0x49
; 0000 00F6              }
; 0000 00F7             else if(so >= 12.32)
_0x35:
	CALL SUBOPT_0x11
	CALL SUBOPT_0xB
	BRLO _0x37
; 0000 00F8             {
; 0000 00F9             putchar('D');
	LDI  R26,LOW(68)
	RJMP _0x49
; 0000 00FA             }
; 0000 00FB             else if (so >= 12.20)
_0x37:
	CALL SUBOPT_0x11
	CALL SUBOPT_0xC
	BRLO _0x39
; 0000 00FC              {
; 0000 00FD              putchar('E');
	LDI  R26,LOW(69)
	RJMP _0x49
; 0000 00FE              }
; 0000 00FF              else if (so >= 12.06)
_0x39:
	CALL SUBOPT_0x11
	CALL SUBOPT_0xD
	BRLO _0x3B
; 0000 0100              {
; 0000 0101              putchar('F');
	LDI  R26,LOW(70)
	RJMP _0x49
; 0000 0102              }
; 0000 0103              else if (so >= 11.9)
_0x3B:
	CALL SUBOPT_0x11
	CALL SUBOPT_0x5
	BRLO _0x3D
; 0000 0104              {
; 0000 0105              putchar('G');
	LDI  R26,LOW(71)
	RJMP _0x49
; 0000 0106              }
; 0000 0107              else if (so >= 11.75)
_0x3D:
	CALL SUBOPT_0x11
	CALL SUBOPT_0xF
	BRLO _0x3F
; 0000 0108              {
; 0000 0109              putchar('H');
	LDI  R26,LOW(72)
	RJMP _0x49
; 0000 010A              }
; 0000 010B             else if (so >= 11.58)
_0x3F:
	CALL SUBOPT_0x11
	__GETD1N 0x413947AE
	CALL __CMPF12
	BRLO _0x41
; 0000 010C              {
; 0000 010D              putchar('I');
	LDI  R26,LOW(73)
	RJMP _0x49
; 0000 010E              }
; 0000 010F              else if (so >= 11.31)
_0x41:
	CALL SUBOPT_0x11
	CALL SUBOPT_0x10
	BRLO _0x43
; 0000 0110              {
; 0000 0111              putchar('K');
	LDI  R26,LOW(75)
	RJMP _0x49
; 0000 0112              }
; 0000 0113             else
_0x43:
; 0000 0114             {
; 0000 0115             putchar('L');
	LDI  R26,LOW(76)
_0x49:
	RCALL _putchar
; 0000 0116             }
; 0000 0117 
; 0000 0118             lcd_hienthi();
	RCALL _lcd_hienthi
; 0000 0119       }
	RJMP _0x2E
; 0000 011A }
_0x45:
	RJMP _0x45
; .FEND
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

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
; .FSTART __lcd_write_nibble_G101
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2020004
	SBI  0x15,3
	RJMP _0x2020005
_0x2020004:
	CBI  0x15,3
_0x2020005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2020006
	SBI  0x15,2
	RJMP _0x2020007
_0x2020006:
	CBI  0x15,2
_0x2020007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2020008
	SBI  0x15,1
	RJMP _0x2020009
_0x2020008:
	CBI  0x15,1
_0x2020009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x202000A
	SBI  0x15,0
	RJMP _0x202000B
_0x202000A:
	CBI  0x15,0
_0x202000B:
	__DELAY_USB 13
	SBI  0x15,6
	__DELAY_USB 13
	CBI  0x15,6
	__DELAY_USB 13
	RJMP _0x2080001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 133
	RJMP _0x2080001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R10,Y+1
	LDD  R13,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x12
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x12
	LDI  R30,LOW(0)
	MOV  R13,R30
	MOV  R10,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020011
	CP   R10,R12
	BRLO _0x2020010
_0x2020011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R13
	MOV  R26,R13
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020013
	RJMP _0x2080001
_0x2020013:
_0x2020010:
	INC  R10
	SBI  0x15,4
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,4
	RJMP _0x2080001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020014
_0x2020016:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x14,3
	SBI  0x14,2
	SBI  0x14,1
	SBI  0x14,0
	SBI  0x14,6
	SBI  0x14,4
	SBI  0x14,5
	CBI  0x15,6
	CBI  0x15,4
	CBI  0x15,5
	LDD  R12,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x13
	CALL SUBOPT_0x13
	CALL SUBOPT_0x13
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG
_tx_buffer:
	.BYTE 0x8
__base_y_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x0:
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2N 0x40A00000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x447FC000
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	__GETD1N 0x40B570A4
	CALL __MULF12
	__GETD2N 0x42C80000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	CALL __PUTD1S0
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	__GETD1N 0x42C80000
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x4:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	__GETD1N 0x413E6666
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	__GETD1N 0x414B3333
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	__GETD1N 0x41480000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	__GETD1N 0x4146B852
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	__GETD1N 0x41451EB8
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	__GETD1N 0x41433333
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	__GETD1N 0x4140F5C3
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	RCALL SUBOPT_0x4
	__GETD1N 0x413947AE
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	__GETD1N 0x413C0000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	__GETD1N 0x4134F5C3
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x11:
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G101
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

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

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
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
