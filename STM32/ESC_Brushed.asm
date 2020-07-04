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
;ESC_Brushed.c,47 :: 		unsigned int potA = 0;
;ESC_Brushed.c,55 :: 		| _GPIO_PINMASK_15);                             // B2 - HW95
MOVW	R1, #61440
;ESC_Brushed.c,52 :: 		GPIO_Digital_Output(&GPIOB_BASE, _GPIO_PINMASK_12  // A1 -  HW95
MOVW	R0, #lo_addr(GPIOB_BASE+0)
MOVT	R0, #hi_addr(GPIOB_BASE+0)
;ESC_Brushed.c,55 :: 		| _GPIO_PINMASK_15);                             // B2 - HW95
BL	_GPIO_Digital_Output+0
;ESC_Brushed.c,57 :: 		GPIO_Digital_Output(&GPIOC_BASE, _GPIO_PINMASK_13); // // LED
MOVW	R1, #8192
MOVW	R0, #lo_addr(GPIOC_BASE+0)
MOVT	R0, #hi_addr(GPIOC_BASE+0)
BL	_GPIO_Digital_Output+0
;ESC_Brushed.c,59 :: 		HW95_Start();
BL	_HW95_Start+0
;ESC_Brushed.c,60 :: 		setA_Enable();
BL	_setA_Enable+0
;ESC_Brushed.c,61 :: 		setB_Enable();
BL	_setB_Enable+0
;ESC_Brushed.c,63 :: 		iniciaUART();
BL	_iniciaUART+0
;ESC_Brushed.c,65 :: 		LED = 1;
MOVS	R1, #1
SXTB	R1, R1
MOVW	R0, #lo_addr(GPIOC_ODR+0)
MOVT	R0, #hi_addr(GPIOC_ODR+0)
_SX	[R0, ByteOffset(GPIOC_ODR+0)]
;ESC_Brushed.c,67 :: 		RC_Reciver_Start();
BL	_RC_Reciver_Start+0
;ESC_Brushed.c,69 :: 		statusMem = FLASH_Write_HalfWord(0x08008000, 0x0096);
MOVS	R1, #150
MOVW	R0, #32768
MOVT	R0, #2048
BL	_FLASH_Write_HalfWord+0
;ESC_Brushed.c,72 :: 		while(1){
L_main6:
;ESC_Brushed.c,73 :: 		LED = 0;
MOVS	R1, #0
SXTB	R1, R1
MOVW	R0, #lo_addr(GPIOC_ODR+0)
MOVT	R0, #hi_addr(GPIOC_ODR+0)
_SX	[R0, ByteOffset(GPIOC_ODR+0)]
;ESC_Brushed.c,74 :: 		Delay_ms(25);
MOVW	R7, #5653
MOVT	R7, #5
NOP
NOP
L_main8:
SUBS	R7, R7, #1
BNE	L_main8
NOP
NOP
;ESC_Brushed.c,75 :: 		potA = GetCh1();
BL	_GetCh1+0
;ESC_Brushed.c,76 :: 		setA_Rear(potA-100);
SUBS	R0, #100
BL	_setA_Rear+0
;ESC_Brushed.c,77 :: 		Delay_ms(2000);
MOVW	R7, #59050
MOVT	R7, #406
NOP
NOP
L_main10:
SUBS	R7, R7, #1
BNE	L_main10
NOP
NOP
NOP
NOP
;ESC_Brushed.c,80 :: 		Delay_ms(2000);
MOVW	R7, #59050
MOVT	R7, #406
NOP
NOP
L_main12:
SUBS	R7, R7, #1
BNE	L_main12
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
