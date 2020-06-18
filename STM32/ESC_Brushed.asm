_InitTimer2:
;ESC_Brushed.c,21 :: 		void InitTimer2(){
;ESC_Brushed.c,22 :: 		RCC_APB1ENR.TIM2EN = 1;
MOVS	R2, #1
SXTB	R2, R2
MOVW	R0, #lo_addr(RCC_APB1ENR+0)
MOVT	R0, #hi_addr(RCC_APB1ENR+0)
_SX	[R0, ByteOffset(RCC_APB1ENR+0)]
;ESC_Brushed.c,23 :: 		TIM2_CR1.CEN = 0;
MOVS	R1, #0
SXTB	R1, R1
MOVW	R0, #lo_addr(TIM2_CR1+0)
MOVT	R0, #hi_addr(TIM2_CR1+0)
_SX	[R0, ByteOffset(TIM2_CR1+0)]
;ESC_Brushed.c,24 :: 		TIM2_PSC = 0;
MOVS	R1, #0
MOVW	R0, #lo_addr(TIM2_PSC+0)
MOVT	R0, #hi_addr(TIM2_PSC+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,25 :: 		TIM2_ARR = 199;
MOVS	R1, #199
MOVW	R0, #lo_addr(TIM2_ARR+0)
MOVT	R0, #hi_addr(TIM2_ARR+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,27 :: 		TIM2_DIER.UIE = 1;
MOVW	R0, #lo_addr(TIM2_DIER+0)
MOVT	R0, #hi_addr(TIM2_DIER+0)
_SX	[R0, ByteOffset(TIM2_DIER+0)]
;ESC_Brushed.c,28 :: 		TIM2_CR1.CEN = 1;
MOVW	R0, #lo_addr(TIM2_CR1+0)
MOVT	R0, #hi_addr(TIM2_CR1+0)
_SX	[R0, ByteOffset(TIM2_CR1+0)]
;ESC_Brushed.c,29 :: 		}
L_end_InitTimer2:
BX	LR
; end of _InitTimer2
_Timer2_interrupt:
;ESC_Brushed.c,31 :: 		void Timer2_interrupt() iv IVT_INT_TIM2 {
;ESC_Brushed.c,32 :: 		TIM2_SR.UIF = 0;
MOVS	R1, #0
SXTB	R1, R1
MOVW	R0, #lo_addr(TIM2_SR+0)
MOVT	R0, #hi_addr(TIM2_SR+0)
_SX	[R0, ByteOffset(TIM2_SR+0)]
;ESC_Brushed.c,34 :: 		cont_Timer2++;
MOVW	R1, #lo_addr(_cont_Timer2+0)
MOVT	R1, #hi_addr(_cont_Timer2+0)
LDR	R0, [R1, #0]
ADDS	R2, R0, #1
STR	R2, [R1, #0]
;ESC_Brushed.c,35 :: 		ch1_val++;
MOVW	R1, #lo_addr(_ch1_val+0)
MOVT	R1, #hi_addr(_ch1_val+0)
LDR	R0, [R1, #0]
ADDS	R0, R0, #1
STR	R0, [R1, #0]
;ESC_Brushed.c,36 :: 		ch2_val++;
MOVW	R1, #lo_addr(_ch2_val+0)
MOVT	R1, #hi_addr(_ch2_val+0)
LDR	R0, [R1, #0]
ADDS	R0, R0, #1
STR	R0, [R1, #0]
;ESC_Brushed.c,37 :: 		if(cont_Timer2 >= 15000) /* 1,5ms ou 150000us */
MOVW	R0, #15000
CMP	R2, R0
IT	CC
BCC	L_Timer2_interrupt0
;ESC_Brushed.c,40 :: 		cont_Timer2 = 0;
MOVS	R1, #0
MOVW	R0, #lo_addr(_cont_Timer2+0)
MOVT	R0, #hi_addr(_cont_Timer2+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,41 :: 		}
L_Timer2_interrupt0:
;ESC_Brushed.c,42 :: 		}
L_end_Timer2_interrupt:
BX	LR
; end of _Timer2_interrupt
_iniciaUART:
;ESC_Brushed.c,45 :: 		void iniciaUART(){
SUB	SP, SP, #4
STR	LR, [SP, #0]
;ESC_Brushed.c,46 :: 		UART1_Init(9600);
MOVW	R0, #9600
BL	_UART1_Init+0
;ESC_Brushed.c,47 :: 		UART1_Enable();
BL	_UART1_Enable+0
;ESC_Brushed.c,48 :: 		}
L_end_iniciaUART:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _iniciaUART
_txtUART:
;ESC_Brushed.c,50 :: 		void txtUART(char * UART_text){
; UART_text start address is: 0 (R0)
SUB	SP, SP, #4
STR	LR, [SP, #0]
; UART_text end address is: 0 (R0)
; UART_text start address is: 0 (R0)
MOV	R2, R0
; UART_text end address is: 0 (R0)
;ESC_Brushed.c,51 :: 		while(UART1_Tx_Idle() == 0);
L_txtUART1:
; UART_text start address is: 8 (R2)
BL	_UART1_Tx_Idle+0
CMP	R0, #0
IT	NE
BNE	L_txtUART2
IT	AL
BAL	L_txtUART1
L_txtUART2:
;ESC_Brushed.c,53 :: 		UART1_Write_Text(UART_text);
MOV	R0, R2
; UART_text end address is: 8 (R2)
BL	_UART1_Write_Text+0
;ESC_Brushed.c,55 :: 		}
L_end_txtUART:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _txtUART
_intUART:
;ESC_Brushed.c,57 :: 		void intUART(int _data){
; _data start address is: 0 (R0)
SUB	SP, SP, #12
STR	LR, [SP, #0]
; _data end address is: 0 (R0)
; _data start address is: 0 (R0)
SXTH	R2, R0
; _data end address is: 0 (R0)
;ESC_Brushed.c,59 :: 		while(UART1_Tx_Idle() == 0);
L_intUART3:
; _data start address is: 8 (R2)
BL	_UART1_Tx_Idle+0
CMP	R0, #0
IT	NE
BNE	L_intUART4
IT	AL
BAL	L_intUART3
L_intUART4:
;ESC_Brushed.c,60 :: 		IntToStr(_data,txt);
ADD	R1, SP, #4
SXTH	R0, R2
; _data end address is: 8 (R2)
BL	_IntToStr+0
;ESC_Brushed.c,61 :: 		UART1_Write_Text(Ltrim(txt));
ADD	R1, SP, #4
MOV	R0, R1
BL	_Ltrim+0
BL	_UART1_Write_Text+0
;ESC_Brushed.c,62 :: 		}
L_end_intUART:
LDR	LR, [SP, #0]
ADD	SP, SP, #12
BX	LR
; end of _intUART
_longUART:
;ESC_Brushed.c,64 :: 		void longUART(long _data){
; _data start address is: 0 (R0)
SUB	SP, SP, #16
STR	LR, [SP, #0]
; _data end address is: 0 (R0)
; _data start address is: 0 (R0)
MOV	R2, R0
; _data end address is: 0 (R0)
;ESC_Brushed.c,66 :: 		while(UART1_Tx_Idle() == 0);
L_longUART5:
; _data start address is: 8 (R2)
BL	_UART1_Tx_Idle+0
CMP	R0, #0
IT	NE
BNE	L_longUART6
IT	AL
BAL	L_longUART5
L_longUART6:
;ESC_Brushed.c,67 :: 		LongToStr(_data,txt);
ADD	R1, SP, #4
MOV	R0, R2
; _data end address is: 8 (R2)
BL	_LongToStr+0
;ESC_Brushed.c,68 :: 		UART1_Write_Text(Ltrim(txt));
ADD	R1, SP, #4
MOV	R0, R1
BL	_Ltrim+0
BL	_UART1_Write_Text+0
;ESC_Brushed.c,69 :: 		}
L_end_longUART:
LDR	LR, [SP, #0]
ADD	SP, SP, #16
BX	LR
; end of _longUART
_external_interrupt_PA0:
;ESC_Brushed.c,72 :: 		void external_interrupt_PA0() iv IVT_INT_EXTI0 ics ICS_AUTO
SUB	SP, SP, #4
STR	LR, [SP, #0]
;ESC_Brushed.c,74 :: 		if((EXTI_PR & 0x00000001) != 0) {   // PA0 (pending register PA0 set)
MOVW	R0, #lo_addr(EXTI_PR+0)
MOVT	R0, #hi_addr(EXTI_PR+0)
LDR	R0, [R0, #0]
AND	R0, R0, #1
CMP	R0, #0
IT	EQ
BEQ	L_external_interrupt_PA07
;ESC_Brushed.c,75 :: 		if(LED == 1){
MOVW	R0, #lo_addr(GPIOC_ODR+0)
MOVT	R0, #hi_addr(GPIOC_ODR+0)
_LX	[R0, ByteOffset(GPIOC_ODR+0)]
CMP	R0, #0
IT	EQ
BEQ	L_external_interrupt_PA08
;ESC_Brushed.c,76 :: 		LED = 0;
MOVS	R1, #0
SXTB	R1, R1
MOVW	R0, #lo_addr(GPIOC_ODR+0)
MOVT	R0, #hi_addr(GPIOC_ODR+0)
_SX	[R0, ByteOffset(GPIOC_ODR+0)]
;ESC_Brushed.c,79 :: 		EXTI_RTSR = EXTI_RTSR & 0xFFFFFFFE;       // rising edge: 4800 = 0100 1000 0000 0000 (line 14 + 11)
MOVW	R0, #lo_addr(EXTI_RTSR+0)
MOVT	R0, #hi_addr(EXTI_RTSR+0)
LDR	R1, [R0, #0]
MVN	R0, #1
ANDS	R1, R0
MOVW	R0, #lo_addr(EXTI_RTSR+0)
MOVT	R0, #hi_addr(EXTI_RTSR+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,80 :: 		EXTI_FTSR = EXTI_FTSR | 0x00000001;
MOVW	R0, #lo_addr(EXTI_FTSR+0)
MOVT	R0, #hi_addr(EXTI_FTSR+0)
LDR	R0, [R0, #0]
ORR	R1, R0, #1
MOVW	R0, #lo_addr(EXTI_FTSR+0)
MOVT	R0, #hi_addr(EXTI_FTSR+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,81 :: 		ch1_val = 0;
MOVS	R1, #0
MOVW	R0, #lo_addr(_ch1_val+0)
MOVT	R0, #hi_addr(_ch1_val+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,82 :: 		NVIC_IntEnable(IVT_INT_TIM2);
MOVW	R0, #44
BL	_NVIC_IntEnable+0
;ESC_Brushed.c,83 :: 		}
IT	AL
BAL	L_external_interrupt_PA09
L_external_interrupt_PA08:
;ESC_Brushed.c,85 :: 		LED = 1;
MOVS	R1, #1
SXTB	R1, R1
MOVW	R0, #lo_addr(GPIOC_ODR+0)
MOVT	R0, #hi_addr(GPIOC_ODR+0)
_SX	[R0, ByteOffset(GPIOC_ODR+0)]
;ESC_Brushed.c,88 :: 		EXTI_RTSR = EXTI_RTSR | 0x00000001;       // rising edge: 4800 = 0100 1000 0000 0000 (line 14 + 11)
MOVW	R0, #lo_addr(EXTI_RTSR+0)
MOVT	R0, #hi_addr(EXTI_RTSR+0)
LDR	R0, [R0, #0]
ORR	R1, R0, #1
MOVW	R0, #lo_addr(EXTI_RTSR+0)
MOVT	R0, #hi_addr(EXTI_RTSR+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,89 :: 		EXTI_FTSR = EXTI_FTSR & 0xFFFFFFFE;
MOVW	R0, #lo_addr(EXTI_FTSR+0)
MOVT	R0, #hi_addr(EXTI_FTSR+0)
LDR	R1, [R0, #0]
MVN	R0, #1
ANDS	R1, R0
MOVW	R0, #lo_addr(EXTI_FTSR+0)
MOVT	R0, #hi_addr(EXTI_FTSR+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,90 :: 		NVIC_IntDisable(IVT_INT_TIM2);
MOVW	R0, #44
BL	_NVIC_IntDisable+0
;ESC_Brushed.c,91 :: 		ch1_val_final = ch1_val;
MOVW	R0, #lo_addr(_ch1_val+0)
MOVT	R0, #hi_addr(_ch1_val+0)
LDR	R1, [R0, #0]
MOVW	R0, #lo_addr(_ch1_val_final+0)
MOVT	R0, #hi_addr(_ch1_val_final+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,92 :: 		}
L_external_interrupt_PA09:
;ESC_Brushed.c,94 :: 		EXTI_PR  |= 0x00000001;          // reset pending register PR11
MOVW	R0, #lo_addr(EXTI_PR+0)
MOVT	R0, #hi_addr(EXTI_PR+0)
LDR	R0, [R0, #0]
ORR	R1, R0, #1
MOVW	R0, #lo_addr(EXTI_PR+0)
MOVT	R0, #hi_addr(EXTI_PR+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,95 :: 		}
L_external_interrupt_PA07:
;ESC_Brushed.c,96 :: 		}
L_end_external_interrupt_PA0:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _external_interrupt_PA0
_external_interrupt_PA1:
;ESC_Brushed.c,98 :: 		void external_interrupt_PA1() iv IVT_INT_EXTI1 ics ICS_AUTO
SUB	SP, SP, #4
STR	LR, [SP, #0]
;ESC_Brushed.c,100 :: 		if((EXTI_PR & 0x00000002) != 0) {   // PA1 (pending register PA1 set)
MOVW	R0, #lo_addr(EXTI_PR+0)
MOVT	R0, #hi_addr(EXTI_PR+0)
LDR	R0, [R0, #0]
AND	R0, R0, #2
CMP	R0, #0
IT	EQ
BEQ	L_external_interrupt_PA110
;ESC_Brushed.c,101 :: 		if(ch2_flag == 1){
MOVW	R0, #lo_addr(_ch2_flag+0)
MOVT	R0, #hi_addr(_ch2_flag+0)
LDRB	R0, [R0, #0]
CMP	R0, #1
IT	NE
BNE	L_external_interrupt_PA111
;ESC_Brushed.c,102 :: 		ch2_flag = 0;
MOVS	R1, #0
MOVW	R0, #lo_addr(_ch2_flag+0)
MOVT	R0, #hi_addr(_ch2_flag+0)
STRB	R1, [R0, #0]
;ESC_Brushed.c,103 :: 		EXTI_RTSR = EXTI_RTSR & 0xFFFFFFFD;       // rising edge: 4800 = 0100 1000 0000 0000 (line 14 + 11)
MOVW	R0, #lo_addr(EXTI_RTSR+0)
MOVT	R0, #hi_addr(EXTI_RTSR+0)
LDR	R1, [R0, #0]
MVN	R0, #2
ANDS	R1, R0
MOVW	R0, #lo_addr(EXTI_RTSR+0)
MOVT	R0, #hi_addr(EXTI_RTSR+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,104 :: 		EXTI_FTSR = EXTI_FTSR | 0x00000002;
MOVW	R0, #lo_addr(EXTI_FTSR+0)
MOVT	R0, #hi_addr(EXTI_FTSR+0)
LDR	R0, [R0, #0]
ORR	R1, R0, #2
MOVW	R0, #lo_addr(EXTI_FTSR+0)
MOVT	R0, #hi_addr(EXTI_FTSR+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,105 :: 		ch2_val = 0;
MOVS	R1, #0
MOVW	R0, #lo_addr(_ch2_val+0)
MOVT	R0, #hi_addr(_ch2_val+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,106 :: 		NVIC_IntEnable(IVT_INT_TIM2);
MOVW	R0, #44
BL	_NVIC_IntEnable+0
;ESC_Brushed.c,107 :: 		}
IT	AL
BAL	L_external_interrupt_PA112
L_external_interrupt_PA111:
;ESC_Brushed.c,109 :: 		ch2_flag = 1;
MOVS	R1, #1
MOVW	R0, #lo_addr(_ch2_flag+0)
MOVT	R0, #hi_addr(_ch2_flag+0)
STRB	R1, [R0, #0]
;ESC_Brushed.c,110 :: 		EXTI_RTSR = EXTI_RTSR | 0x00000002;       // rising edge: 4800 = 0100 1000 0000 0000 (line 14 + 11)
MOVW	R0, #lo_addr(EXTI_RTSR+0)
MOVT	R0, #hi_addr(EXTI_RTSR+0)
LDR	R0, [R0, #0]
ORR	R1, R0, #2
MOVW	R0, #lo_addr(EXTI_RTSR+0)
MOVT	R0, #hi_addr(EXTI_RTSR+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,111 :: 		EXTI_FTSR = EXTI_FTSR & 0xFFFFFFFD;
MOVW	R0, #lo_addr(EXTI_FTSR+0)
MOVT	R0, #hi_addr(EXTI_FTSR+0)
LDR	R1, [R0, #0]
MVN	R0, #2
ANDS	R1, R0
MOVW	R0, #lo_addr(EXTI_FTSR+0)
MOVT	R0, #hi_addr(EXTI_FTSR+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,112 :: 		NVIC_IntDisable(IVT_INT_TIM2);
MOVW	R0, #44
BL	_NVIC_IntDisable+0
;ESC_Brushed.c,113 :: 		ch2_val_final = ch2_val;
MOVW	R0, #lo_addr(_ch2_val+0)
MOVT	R0, #hi_addr(_ch2_val+0)
LDR	R1, [R0, #0]
MOVW	R0, #lo_addr(_ch2_val_final+0)
MOVT	R0, #hi_addr(_ch2_val_final+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,114 :: 		}
L_external_interrupt_PA112:
;ESC_Brushed.c,116 :: 		EXTI_PR  |= 0x00000002;          // reset pending register PR11
MOVW	R0, #lo_addr(EXTI_PR+0)
MOVT	R0, #hi_addr(EXTI_PR+0)
LDR	R0, [R0, #0]
ORR	R1, R0, #2
MOVW	R0, #lo_addr(EXTI_PR+0)
MOVT	R0, #hi_addr(EXTI_PR+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,117 :: 		}
L_external_interrupt_PA110:
;ESC_Brushed.c,118 :: 		}
L_end_external_interrupt_PA1:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _external_interrupt_PA1
_main:
;ESC_Brushed.c,122 :: 		void main() {
;ESC_Brushed.c,124 :: 		unsigned int potA = 0;
;ESC_Brushed.c,127 :: 		GPIO_Config(&GPIOA_BASE, _GPIO_PINMASK_0, _GPIO_CFG_MODE_INPUT | _GPIO_CFG_PULL_DOWN);
MOV	R2, #258
MOVW	R1, #1
MOVW	R0, #lo_addr(GPIOA_BASE+0)
MOVT	R0, #hi_addr(GPIOA_BASE+0)
BL	_GPIO_Config+0
;ESC_Brushed.c,129 :: 		GPIO_Config(&GPIOA_BASE, _GPIO_PINMASK_1, _GPIO_CFG_MODE_INPUT | _GPIO_CFG_PULL_DOWN);
MOV	R2, #258
MOVW	R1, #2
MOVW	R0, #lo_addr(GPIOA_BASE+0)
MOVT	R0, #hi_addr(GPIOA_BASE+0)
BL	_GPIO_Config+0
;ESC_Brushed.c,132 :: 		GPIO_Digital_Output(&GPIOB_BASE, _GPIO_PINMASK_3); //   A1 - HW95
MOVW	R1, #8
MOVW	R0, #lo_addr(GPIOB_BASE+0)
MOVT	R0, #hi_addr(GPIOB_BASE+0)
BL	_GPIO_Digital_Output+0
;ESC_Brushed.c,133 :: 		GPIO_Digital_Output(&GPIOA_BASE, _GPIO_PINMASK_15); //  A2 - HW95
MOVW	R1, #32768
MOVW	R0, #lo_addr(GPIOA_BASE+0)
MOVT	R0, #hi_addr(GPIOA_BASE+0)
BL	_GPIO_Digital_Output+0
;ESC_Brushed.c,134 :: 		GPIO_Digital_Output(&GPIOA_BASE, _GPIO_PINMASK_12 | _GPIO_PINMASK_11); //  B1 and B2 = HW95
MOVW	R1, #6144
MOVW	R0, #lo_addr(GPIOA_BASE+0)
MOVT	R0, #hi_addr(GPIOA_BASE+0)
BL	_GPIO_Digital_Output+0
;ESC_Brushed.c,136 :: 		GPIO_Digital_Output(&GPIOC_BASE, _GPIO_PINMASK_13); // // LED
MOVW	R1, #8192
MOVW	R0, #lo_addr(GPIOC_BASE+0)
MOVT	R0, #hi_addr(GPIOC_BASE+0)
BL	_GPIO_Digital_Output+0
;ESC_Brushed.c,138 :: 		HW95_Start(void);
BL	_HW95_Start+0
;ESC_Brushed.c,140 :: 		setA_Enable();
BL	_setA_Enable+0
;ESC_Brushed.c,144 :: 		iniciaUART();
BL	_iniciaUART+0
;ESC_Brushed.c,146 :: 		LED = 1;
MOVS	R1, #1
SXTB	R1, R1
MOVW	R0, #lo_addr(GPIOC_ODR+0)
MOVT	R0, #hi_addr(GPIOC_ODR+0)
_SX	[R0, ByteOffset(GPIOC_ODR+0)]
;ESC_Brushed.c,147 :: 		ch2_flag = 1;
MOVS	R1, #1
MOVW	R0, #lo_addr(_ch2_flag+0)
MOVT	R0, #hi_addr(_ch2_flag+0)
STRB	R1, [R0, #0]
;ESC_Brushed.c,148 :: 		EXTI_RTSR |= 0x00000003;  // Set com 1
MOVW	R0, #lo_addr(EXTI_RTSR+0)
MOVT	R0, #hi_addr(EXTI_RTSR+0)
LDR	R0, [R0, #0]
ORR	R1, R0, #3
MOVW	R0, #lo_addr(EXTI_RTSR+0)
MOVT	R0, #hi_addr(EXTI_RTSR+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,149 :: 		EXTI_FTSR &= 0xFFFFFFFC;  // Set com 0
MOVW	R0, #lo_addr(EXTI_FTSR+0)
MOVT	R0, #hi_addr(EXTI_FTSR+0)
LDR	R1, [R0, #0]
MVN	R0, #3
ANDS	R1, R0
MOVW	R0, #lo_addr(EXTI_FTSR+0)
MOVT	R0, #hi_addr(EXTI_FTSR+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,150 :: 		EXTI_IMR  |= 0x00000003;  // Set com 1
MOVW	R0, #lo_addr(EXTI_IMR+0)
MOVT	R0, #hi_addr(EXTI_IMR+0)
LDR	R0, [R0, #0]
ORR	R1, R0, #3
MOVW	R0, #lo_addr(EXTI_IMR+0)
MOVT	R0, #hi_addr(EXTI_IMR+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,151 :: 		NVIC_IntEnable(IVT_INT_EXTI0);  // enable NVIC interface
MOVW	R0, #22
BL	_NVIC_IntEnable+0
;ESC_Brushed.c,152 :: 		NVIC_IntEnable(IVT_INT_EXTI1);  // enable NVIC interface
MOVW	R0, #23
BL	_NVIC_IntEnable+0
;ESC_Brushed.c,155 :: 		InitTimer2();
BL	_InitTimer2+0
;ESC_Brushed.c,157 :: 		while(1){
L_main13:
;ESC_Brushed.c,160 :: 		Delay_ms(200);
MOVW	R7, #45226
MOVT	R7, #40
NOP
NOP
L_main15:
SUBS	R7, R7, #1
BNE	L_main15
NOP
NOP
NOP
NOP
;ESC_Brushed.c,164 :: 		potA = (ch2_val_final - 89) * 0.813;
MOVW	R0, #lo_addr(_ch2_val_final+0)
MOVT	R0, #hi_addr(_ch2_val_final+0)
LDR	R0, [R0, #0]
SUBS	R0, #89
BL	__UnsignedIntegralToFloat+0
MOVW	R2, #8389
MOVT	R2, #16208
BL	__Mul_FP+0
BL	__FloatToUnsignedIntegral+0
UXTH	R0, R0
;ESC_Brushed.c,165 :: 		SetA_Front(potA);
BL	_SetA_Front+0
;ESC_Brushed.c,167 :: 		}
IT	AL
BAL	L_main13
;ESC_Brushed.c,168 :: 		}
L_end_main:
L__main_end_loop:
B	L__main_end_loop
; end of _main
