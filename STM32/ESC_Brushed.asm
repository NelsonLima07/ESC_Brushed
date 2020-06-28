_iniciaUART:
;ESC_Brushed.c,9 :: 		void iniciaUART(){
SUB	SP, SP, #4
STR	LR, [SP, #0]
;ESC_Brushed.c,10 :: 		UART1_Init(9600);
MOVW	R0, #9600
BL	_UART1_Init+0
;ESC_Brushed.c,11 :: 		UART1_Enable();
BL	_UART1_Enable+0
;ESC_Brushed.c,12 :: 		}
L_end_iniciaUART:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _iniciaUART
_txtUART:
;ESC_Brushed.c,14 :: 		void txtUART(char * UART_text){
; UART_text start address is: 0 (R0)
SUB	SP, SP, #4
STR	LR, [SP, #0]
; UART_text end address is: 0 (R0)
; UART_text start address is: 0 (R0)
MOV	R2, R0
; UART_text end address is: 0 (R0)
;ESC_Brushed.c,15 :: 		while(UART1_Tx_Idle() == 0);
L_txtUART0:
; UART_text start address is: 8 (R2)
BL	_UART1_Tx_Idle+0
CMP	R0, #0
IT	NE
BNE	L_txtUART1
IT	AL
BAL	L_txtUART0
L_txtUART1:
;ESC_Brushed.c,17 :: 		UART1_Write_Text(UART_text);
MOV	R0, R2
; UART_text end address is: 8 (R2)
BL	_UART1_Write_Text+0
;ESC_Brushed.c,19 :: 		}
L_end_txtUART:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _txtUART
_intUART:
;ESC_Brushed.c,21 :: 		void intUART(int _data){
; _data start address is: 0 (R0)
SUB	SP, SP, #12
STR	LR, [SP, #0]
; _data end address is: 0 (R0)
; _data start address is: 0 (R0)
SXTH	R2, R0
; _data end address is: 0 (R0)
;ESC_Brushed.c,23 :: 		while(UART1_Tx_Idle() == 0);
L_intUART2:
; _data start address is: 8 (R2)
BL	_UART1_Tx_Idle+0
CMP	R0, #0
IT	NE
BNE	L_intUART3
IT	AL
BAL	L_intUART2
L_intUART3:
;ESC_Brushed.c,24 :: 		IntToStr(_data,txt);
ADD	R1, SP, #4
SXTH	R0, R2
; _data end address is: 8 (R2)
BL	_IntToStr+0
;ESC_Brushed.c,25 :: 		UART1_Write_Text(Ltrim(txt));
ADD	R1, SP, #4
MOV	R0, R1
BL	_Ltrim+0
BL	_UART1_Write_Text+0
;ESC_Brushed.c,26 :: 		}
L_end_intUART:
LDR	LR, [SP, #0]
ADD	SP, SP, #12
BX	LR
; end of _intUART
_longUART:
;ESC_Brushed.c,28 :: 		void longUART(long _data){
; _data start address is: 0 (R0)
SUB	SP, SP, #16
STR	LR, [SP, #0]
; _data end address is: 0 (R0)
; _data start address is: 0 (R0)
MOV	R2, R0
; _data end address is: 0 (R0)
;ESC_Brushed.c,30 :: 		while(UART1_Tx_Idle() == 0);
L_longUART4:
; _data start address is: 8 (R2)
BL	_UART1_Tx_Idle+0
CMP	R0, #0
IT	NE
BNE	L_longUART5
IT	AL
BAL	L_longUART4
L_longUART5:
;ESC_Brushed.c,31 :: 		LongToStr(_data,txt);
ADD	R1, SP, #4
MOV	R0, R2
; _data end address is: 8 (R2)
BL	_LongToStr+0
;ESC_Brushed.c,32 :: 		UART1_Write_Text(Ltrim(txt));
ADD	R1, SP, #4
MOV	R0, R1
BL	_Ltrim+0
BL	_UART1_Write_Text+0
;ESC_Brushed.c,33 :: 		}
L_end_longUART:
LDR	LR, [SP, #0]
ADD	SP, SP, #16
BX	LR
; end of _longUART
_normalize:
;ESC_Brushed.c,37 :: 		unsigned int normalize(unsigned int _min, unsigned int _max, unsigned int _valor,unsigned int _minOut, unsigned int _maxOut){
;ESC_Brushed.c,39 :: 		}
L_end_normalize:
BX	LR
; end of _normalize
_normalizeInvert:
;ESC_Brushed.c,41 :: 		unsigned int normalizeInvert(unsigned int _min, unsigned int _max, unsigned int _valor,unsigned int _minOut, unsigned int _maxOut){
;ESC_Brushed.c,43 :: 		}
L_end_normalizeInvert:
BX	LR
; end of _normalizeInvert
_main:
;ESC_Brushed.c,46 :: 		void main() {
SUB	SP, SP, #4
;ESC_Brushed.c,47 :: 		unsigned int potA = 0;
;ESC_Brushed.c,52 :: 		| _GPIO_PINMASK_15);                             // B2 - HW95
MOVW	R1, #61440
;ESC_Brushed.c,49 :: 		GPIO_Digital_Output(&GPIOB_BASE, _GPIO_PINMASK_12  // A1 -  HW95
MOVW	R0, #lo_addr(GPIOB_BASE+0)
MOVT	R0, #hi_addr(GPIOB_BASE+0)
;ESC_Brushed.c,52 :: 		| _GPIO_PINMASK_15);                             // B2 - HW95
BL	_GPIO_Digital_Output+0
;ESC_Brushed.c,54 :: 		GPIO_Digital_Output(&GPIOC_BASE, _GPIO_PINMASK_13); // // LED
MOVW	R1, #8192
MOVW	R0, #lo_addr(GPIOC_BASE+0)
MOVT	R0, #hi_addr(GPIOC_BASE+0)
BL	_GPIO_Digital_Output+0
;ESC_Brushed.c,56 :: 		HW95_Start();
BL	_HW95_Start+0
;ESC_Brushed.c,57 :: 		setA_Enable();
BL	_setA_Enable+0
;ESC_Brushed.c,58 :: 		setB_Enable();
BL	_setB_Enable+0
;ESC_Brushed.c,60 :: 		iniciaUART();
BL	_iniciaUART+0
;ESC_Brushed.c,62 :: 		LED = 1;
MOVS	R1, #1
SXTB	R1, R1
MOVW	R0, #lo_addr(GPIOC_ODR+0)
MOVT	R0, #hi_addr(GPIOC_ODR+0)
_SX	[R0, ByteOffset(GPIOC_ODR+0)]
;ESC_Brushed.c,64 :: 		RC_Reciver_Start();
BL	_RC_Reciver_Start+0
;ESC_Brushed.c,68 :: 		while(1){
L_main6:
;ESC_Brushed.c,69 :: 		LED = 0;
MOVS	R1, #0
SXTB	R1, R1
MOVW	R0, #lo_addr(GPIOC_ODR+0)
MOVT	R0, #hi_addr(GPIOC_ODR+0)
_SX	[R0, ByteOffset(GPIOC_ODR+0)]
;ESC_Brushed.c,70 :: 		Delay_ms(25);
MOVW	R7, #5653
MOVT	R7, #5
NOP
NOP
L_main8:
SUBS	R7, R7, #1
BNE	L_main8
NOP
NOP
;ESC_Brushed.c,71 :: 		potA = GetCh1();
BL	_GetCh1+0
; potA start address is: 4 (R1)
UXTH	R1, R0
;ESC_Brushed.c,72 :: 		if(potA > 155){
CMP	R0, #155
IT	LS
BLS	L_main10
;ESC_Brushed.c,73 :: 		potA = (potA - 100);
SUBW	R0, R1, #100
UXTH	R1, R0
;ESC_Brushed.c,74 :: 		SetA_Front(potA);
STRH	R1, [SP, #0]
BL	_SetA_Front+0
LDRH	R1, [SP, #0]
;ESC_Brushed.c,75 :: 		}else if (potA < 145){
UXTH	R0, R1
IT	AL
BAL	L_main11
L_main10:
CMP	R1, #145
IT	CS
BCS	L_main12
;ESC_Brushed.c,76 :: 		}
L_main12:
UXTH	R0, R1
L_main11:
; potA end address is: 4 (R1)
;ESC_Brushed.c,77 :: 		setA_Rear(potA);
; potA start address is: 0 (R0)
STRH	R0, [SP, #0]
BL	_setA_Rear+0
LDRH	R0, [SP, #0]
;ESC_Brushed.c,78 :: 		Delay_ms(2000);
MOVW	R7, #59050
MOVT	R7, #406
NOP
NOP
L_main13:
SUBS	R7, R7, #1
BNE	L_main13
NOP
NOP
NOP
NOP
;ESC_Brushed.c,79 :: 		SetA_Front(potA);
; potA end address is: 0 (R0)
BL	_SetA_Front+0
;ESC_Brushed.c,80 :: 		Delay_ms(2000);
MOVW	R7, #59050
MOVT	R7, #406
NOP
NOP
L_main15:
SUBS	R7, R7, #1
BNE	L_main15
NOP
NOP
NOP
NOP
;ESC_Brushed.c,81 :: 		}
IT	AL
BAL	L_main6
;ESC_Brushed.c,82 :: 		}
L_end_main:
L__main_end_loop:
B	L__main_end_loop
; end of _main
