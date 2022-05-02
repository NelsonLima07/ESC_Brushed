_iniciaUART:
;ESC_Brushed.c,10 :: 		void iniciaUART(){
SUB	SP, SP, #4
STR	LR, [SP, #0]
;ESC_Brushed.c,11 :: 		UART1_Init(9600);
MOVW	R0, #9600
BL	_UART1_Init+0
;ESC_Brushed.c,12 :: 		UART1_Enable();
BL	_UART1_Enable+0
;ESC_Brushed.c,13 :: 		}
L_end_iniciaUART:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _iniciaUART
_txtUART:
;ESC_Brushed.c,15 :: 		void txtUART(char * UART_text){
; UART_text start address is: 0 (R0)
SUB	SP, SP, #4
STR	LR, [SP, #0]
; UART_text end address is: 0 (R0)
; UART_text start address is: 0 (R0)
MOV	R2, R0
; UART_text end address is: 0 (R0)
;ESC_Brushed.c,16 :: 		while(UART1_Tx_Idle() == 0);
L_txtUART0:
; UART_text start address is: 8 (R2)
BL	_UART1_Tx_Idle+0
CMP	R0, #0
IT	NE
BNE	L_txtUART1
IT	AL
BAL	L_txtUART0
L_txtUART1:
;ESC_Brushed.c,18 :: 		UART1_Write_Text(UART_text);
MOV	R0, R2
; UART_text end address is: 8 (R2)
BL	_UART1_Write_Text+0
;ESC_Brushed.c,20 :: 		}
L_end_txtUART:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _txtUART
_intUART:
;ESC_Brushed.c,22 :: 		void intUART(int _data){
; _data start address is: 0 (R0)
SUB	SP, SP, #12
STR	LR, [SP, #0]
; _data end address is: 0 (R0)
; _data start address is: 0 (R0)
SXTH	R2, R0
; _data end address is: 0 (R0)
;ESC_Brushed.c,24 :: 		while(UART1_Tx_Idle() == 0);
L_intUART2:
; _data start address is: 8 (R2)
BL	_UART1_Tx_Idle+0
CMP	R0, #0
IT	NE
BNE	L_intUART3
IT	AL
BAL	L_intUART2
L_intUART3:
;ESC_Brushed.c,25 :: 		IntToStr(_data,txt);
ADD	R1, SP, #4
SXTH	R0, R2
; _data end address is: 8 (R2)
BL	_IntToStr+0
;ESC_Brushed.c,26 :: 		UART1_Write_Text(Ltrim(txt));
ADD	R1, SP, #4
MOV	R0, R1
BL	_Ltrim+0
BL	_UART1_Write_Text+0
;ESC_Brushed.c,27 :: 		}
L_end_intUART:
LDR	LR, [SP, #0]
ADD	SP, SP, #12
BX	LR
; end of _intUART
_longUART:
;ESC_Brushed.c,29 :: 		void longUART(long _data){
; _data start address is: 0 (R0)
SUB	SP, SP, #16
STR	LR, [SP, #0]
; _data end address is: 0 (R0)
; _data start address is: 0 (R0)
MOV	R2, R0
; _data end address is: 0 (R0)
;ESC_Brushed.c,31 :: 		while(UART1_Tx_Idle() == 0);
L_longUART4:
; _data start address is: 8 (R2)
BL	_UART1_Tx_Idle+0
CMP	R0, #0
IT	NE
BNE	L_longUART5
IT	AL
BAL	L_longUART4
L_longUART5:
;ESC_Brushed.c,32 :: 		LongToStr(_data,txt);
ADD	R1, SP, #4
MOV	R0, R2
; _data end address is: 8 (R2)
BL	_LongToStr+0
;ESC_Brushed.c,33 :: 		UART1_Write_Text(Ltrim(txt));
ADD	R1, SP, #4
MOV	R0, R1
BL	_Ltrim+0
BL	_UART1_Write_Text+0
;ESC_Brushed.c,34 :: 		}
L_end_longUART:
LDR	LR, [SP, #0]
ADD	SP, SP, #16
BX	LR
; end of _longUART
_normalize:
;ESC_Brushed.c,38 :: 		unsigned int normalize(unsigned int _min, unsigned int _max, unsigned int _valor,unsigned int _minOut, unsigned int _maxOut){
;ESC_Brushed.c,40 :: 		}
L_end_normalize:
BX	LR
; end of _normalize
_normalizeInvert:
;ESC_Brushed.c,42 :: 		unsigned int normalizeInvert(unsigned int _min, unsigned int _max, unsigned int _valor,unsigned int _minOut, unsigned int _maxOut){
;ESC_Brushed.c,44 :: 		}
L_end_normalizeInvert:
BX	LR
; end of _normalizeInvert
_main:
;ESC_Brushed.c,47 :: 		void main() {
;ESC_Brushed.c,49 :: 		unsigned int potA = 0;
;ESC_Brushed.c,57 :: 		| _GPIO_PINMASK_15);                             // B2 - HW95
MOVW	R1, #61440
;ESC_Brushed.c,54 :: 		GPIO_Digital_Output(&GPIOB_BASE, _GPIO_PINMASK_12  // A1 -  HW95
MOVW	R0, #lo_addr(GPIOB_BASE+0)
MOVT	R0, #hi_addr(GPIOB_BASE+0)
;ESC_Brushed.c,57 :: 		| _GPIO_PINMASK_15);                             // B2 - HW95
BL	_GPIO_Digital_Output+0
;ESC_Brushed.c,59 :: 		GPIO_Digital_Output(&GPIOC_BASE, _GPIO_PINMASK_13); // // LED
MOVW	R1, #8192
MOVW	R0, #lo_addr(GPIOC_BASE+0)
MOVT	R0, #hi_addr(GPIOC_BASE+0)
BL	_GPIO_Digital_Output+0
;ESC_Brushed.c,62 :: 		GPIO_Config(&GPIOB_BASE, _GPIO_PINMASK_8, _GPIO_CFG_MODE_OUTPUT | _GPIO_CFG_SPEED_MAX);
MOVW	R2, #4
MOVT	R2, #8
MOVW	R1, #256
MOVW	R0, #lo_addr(GPIOB_BASE+0)
MOVT	R0, #hi_addr(GPIOB_BASE+0)
BL	_GPIO_Config+0
;ESC_Brushed.c,64 :: 		HW95_Start();
BL	_HW95_Start+0
;ESC_Brushed.c,65 :: 		setA_Enable();
BL	_setA_Enable+0
;ESC_Brushed.c,66 :: 		setB_Enable();
BL	_setB_Enable+0
;ESC_Brushed.c,68 :: 		iniciaUART();
BL	_iniciaUART+0
;ESC_Brushed.c,70 :: 		LED = 1;
MOVS	R1, #1
SXTB	R1, R1
MOVW	R0, #lo_addr(GPIOC_ODR+0)
MOVT	R0, #hi_addr(GPIOC_ODR+0)
_SX	[R0, ByteOffset(GPIOC_ODR+0)]
;ESC_Brushed.c,72 :: 		RC_Reciver_Start();
BL	_RC_Reciver_Start+0
;ESC_Brushed.c,74 :: 		statusMem = FLASH_Write_HalfWord(0x08008000, 0x0096);
MOVS	R1, #150
MOVW	R0, #32768
MOVT	R0, #2048
BL	_FLASH_Write_HalfWord+0
;ESC_Brushed.c,77 :: 		J3_DShotESC_Init();
BL	_J3_DShotESC_Init+0
;ESC_Brushed.c,78 :: 		while(1){
L_main6:
;ESC_Brushed.c,79 :: 		LED = ~LED;
MOVW	R0, #lo_addr(GPIOC_ODR+0)
MOVT	R0, #hi_addr(GPIOC_ODR+0)
_LX	[R0, ByteOffset(GPIOC_ODR+0)]
EOR	R1, R0, #1
UXTB	R1, R1
MOVW	R0, #lo_addr(GPIOC_ODR+0)
MOVT	R0, #hi_addr(GPIOC_ODR+0)
_SX	[R0, ByteOffset(GPIOC_ODR+0)]
;ESC_Brushed.c,80 :: 		Delay_ms(150);
MOVW	R7, #33919
MOVT	R7, #30
NOP
NOP
L_main8:
SUBS	R7, R7, #1
BNE	L_main8
NOP
NOP
NOP
;ESC_Brushed.c,81 :: 		potA = GetCh1();
BL	_GetCh1+0
;ESC_Brushed.c,82 :: 		potA = (potA - 100) * 20;
SUBW	R1, R0, #100
UXTH	R1, R1
MOVS	R0, #20
MULS	R0, R1, R0
UXTH	R0, R0
; potA start address is: 4 (R1)
UXTH	R1, R0
;ESC_Brushed.c,83 :: 		if (potA < 48)
CMP	R0, #48
IT	CS
BCS	L__main12
;ESC_Brushed.c,84 :: 		potA = 48;
MOVS	R1, #48
; potA end address is: 4 (R1)
IT	AL
BAL	L_main10
L__main12:
;ESC_Brushed.c,83 :: 		if (potA < 48)
;ESC_Brushed.c,84 :: 		potA = 48;
L_main10:
;ESC_Brushed.c,85 :: 		if (potA > 2047)
; potA start address is: 4 (R1)
MOVW	R0, #2047
CMP	R1, R0
IT	LS
BLS	L__main13
; potA end address is: 4 (R1)
;ESC_Brushed.c,86 :: 		potA = 2047;
; potA start address is: 0 (R0)
MOVW	R0, #2047
; potA end address is: 0 (R0)
IT	AL
BAL	L_main11
L__main13:
;ESC_Brushed.c,85 :: 		if (potA > 2047)
UXTH	R0, R1
;ESC_Brushed.c,86 :: 		potA = 2047;
L_main11:
;ESC_Brushed.c,87 :: 		J3_DShotESC_setValue(potA);
; potA start address is: 0 (R0)
; potA end address is: 0 (R0)
BL	_J3_DShotESC_setValue+0
;ESC_Brushed.c,88 :: 		}
IT	AL
BAL	L_main6
;ESC_Brushed.c,89 :: 		}
L_end_main:
L__main_end_loop:
B	L__main_end_loop
; end of _main
