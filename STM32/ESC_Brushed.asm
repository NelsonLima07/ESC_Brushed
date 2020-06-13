_init_input_capture:
;ESC_Brushed.c,15 :: 		void init_input_capture() {
SUB	SP, SP, #4
STR	LR, [SP, #0]
;ESC_Brushed.c,18 :: 		RCC_APB1ENR.TIM2EN = 1;        // Enable clock gating for timer module 2
MOVS	R1, #1
SXTB	R1, R1
MOVW	R0, #lo_addr(RCC_APB1ENR+0)
MOVT	R0, #hi_addr(RCC_APB1ENR+0)
_SX	[R0, ByteOffset(RCC_APB1ENR+0)]
;ESC_Brushed.c,19 :: 		TIM2_CR1.CEN = 0;              // Disable timer/counter
MOVS	R1, #0
SXTB	R1, R1
MOVW	R0, #lo_addr(TIM2_CR1+0)
MOVT	R0, #hi_addr(TIM2_CR1+0)
_SX	[R0, ByteOffset(TIM2_CR1+0)]
;ESC_Brushed.c,20 :: 		TIM2_CR2.TI1S = 0;             // TIM2_CH1 connected to TI1 Input (1 would be Ch1, 2, 3 XOR to TI1)
MOVW	R0, #lo_addr(TIM2_CR2+0)
MOVT	R0, #hi_addr(TIM2_CR2+0)
_SX	[R0, ByteOffset(TIM2_CR2+0)]
;ESC_Brushed.c,21 :: 		TIM2_PSC = ENCODER_TIM_PSC;    // Set timer 2 prescaler
MOVS	R1, #0
MOVW	R0, #lo_addr(TIM2_PSC+0)
MOVT	R0, #hi_addr(TIM2_PSC+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,22 :: 		TIM2_ARR = ENCODER_TIM_RELOAD; // Set timer 2 Auto Reload value
MOVS	R1, #79
MOVW	R0, #lo_addr(TIM2_ARR+0)
MOVT	R0, #hi_addr(TIM2_ARR+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,26 :: 		GPIO_Alternate_Function_Enable(&_GPIO_MODULE_TIM2_CH1_PA0);             // Configure alternate function for A0 as Timer 2 Channel 1
MOVW	R0, #lo_addr(__GPIO_MODULE_TIM2_CH1_PA0+0)
MOVT	R0, #hi_addr(__GPIO_MODULE_TIM2_CH1_PA0+0)
BL	_GPIO_Alternate_Function_Enable+0
;ESC_Brushed.c,27 :: 		TIM2_CCMR1_Input |= 0x01; // Set capture channel 1 as input on TI1 (CC1S = 01)
MOVW	R0, #lo_addr(TIM2_CCMR1_Input+0)
MOVT	R0, #hi_addr(TIM2_CCMR1_Input+0)
LDR	R0, [R0, #0]
ORR	R1, R0, #1
MOVW	R0, #lo_addr(TIM2_CCMR1_Input+0)
MOVT	R0, #hi_addr(TIM2_CCMR1_Input+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,28 :: 		TIM2_CCER.CC1P = 0;      // Set capture on rising edge event
MOVS	R1, #0
SXTB	R1, R1
MOVW	R0, #lo_addr(TIM2_CCER+0)
MOVT	R0, #hi_addr(TIM2_CCER+0)
_SX	[R0, ByteOffset(TIM2_CCER+0)]
;ESC_Brushed.c,29 :: 		TIM2_CCER.CC1NP = 0;
MOVW	R0, #lo_addr(TIM2_CCER+0)
MOVT	R0, #hi_addr(TIM2_CCER+0)
_SX	[R0, ByteOffset(TIM2_CCER+0)]
;ESC_Brushed.c,30 :: 		TIM2_CCER.CC1E = 1;     // Enable capture on channel 1
MOVS	R1, #1
SXTB	R1, R1
MOVW	R0, #lo_addr(TIM2_CCER+0)
MOVT	R0, #hi_addr(TIM2_CCER+0)
_SX	[R0, ByteOffset(TIM2_CCER+0)]
;ESC_Brushed.c,31 :: 		TIM2_DIER.CC1IE = 1;    // Enable interrupt on capture channel 1
MOVW	R0, #lo_addr(TIM2_DIER+0)
MOVT	R0, #hi_addr(TIM2_DIER+0)
_SX	[R0, ByteOffset(TIM2_DIER+0)]
;ESC_Brushed.c,34 :: 		TIM2_DIER.UIE = 1;             // Enable overflow interrupt
MOVW	R0, #lo_addr(TIM2_DIER+0)
MOVT	R0, #hi_addr(TIM2_DIER+0)
_SX	[R0, ByteOffset(TIM2_DIER+0)]
;ESC_Brushed.c,35 :: 		NVIC_IntEnable(IVT_INT_TIM2);  // Enable timer 2 interrupt
MOVW	R0, #44
BL	_NVIC_IntEnable+0
;ESC_Brushed.c,36 :: 		TIM2_CR1.CEN = 1;             // Enable timer/counter
MOVS	R1, #1
SXTB	R1, R1
MOVW	R0, #lo_addr(TIM2_CR1+0)
MOVT	R0, #hi_addr(TIM2_CR1+0)
_SX	[R0, ByteOffset(TIM2_CR1+0)]
;ESC_Brushed.c,39 :: 		timer2_period_ms = (long double) 1000.0 / (MCU_FREQUENCY / (ENCODER_TIM_PSC + 1));
MOVW	R1, #43516
MOVT	R1, #54001
MOVW	R2, #25165
MOVT	R2, #16160
MOVW	R0, #lo_addr(_timer2_period_ms+0)
MOVT	R0, #hi_addr(_timer2_period_ms+0)
STRD	R1, R2, [R0, #0]
;ESC_Brushed.c,41 :: 		}
L_end_init_input_capture:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _init_input_capture
_timer2_ISR:
;ESC_Brushed.c,43 :: 		void timer2_ISR() iv IVT_INT_TIM2 {
;ESC_Brushed.c,45 :: 		if(TIM2_SR.UIF == 1) {
MOVW	R0, #lo_addr(TIM2_SR+0)
MOVT	R0, #hi_addr(TIM2_SR+0)
_LX	[R0, ByteOffset(TIM2_SR+0)]
CMP	R0, #0
IT	EQ
BEQ	L_timer2_ISR0
;ESC_Brushed.c,46 :: 		TIM2_SR.UIF = 0;               // Clear timer 2 interrupt bit
MOVS	R1, #0
SXTB	R1, R1
MOVW	R0, #lo_addr(TIM2_SR+0)
MOVT	R0, #hi_addr(TIM2_SR+0)
_SX	[R0, ByteOffset(TIM2_SR+0)]
;ESC_Brushed.c,48 :: 		}
L_timer2_ISR0:
;ESC_Brushed.c,50 :: 		if (TIM2_SR.CC1IF == 1) {
MOVW	R0, #lo_addr(TIM2_SR+0)
MOVT	R0, #hi_addr(TIM2_SR+0)
_LX	[R0, ByteOffset(TIM2_SR+0)]
CMP	R0, #0
IT	EQ
BEQ	L_timer2_ISR1
;ESC_Brushed.c,51 :: 		if (TIM2_CCER.CC1P == 0) // Se for borda de subida é o inicial do sinal
MOVW	R0, #lo_addr(TIM2_CCER+0)
MOVT	R0, #hi_addr(TIM2_CCER+0)
_LX	[R0, ByteOffset(TIM2_CCER+0)]
CMP	R0, #0
IT	NE
BNE	L_timer2_ISR2
;ESC_Brushed.c,54 :: 		TIM2_CCER.CC1P = 1; // Agora vai captura a descida
MOVS	R1, #1
SXTB	R1, R1
MOVW	R0, #lo_addr(TIM2_CCER+0)
MOVT	R0, #hi_addr(TIM2_CCER+0)
_SX	[R0, ByteOffset(TIM2_CCER+0)]
;ESC_Brushed.c,55 :: 		}
IT	AL
BAL	L_timer2_ISR3
L_timer2_ISR2:
;ESC_Brushed.c,58 :: 		ch1_val = TIM2_CCR1; // Armazena o valor
MOVW	R0, #lo_addr(TIM2_CCR1+0)
MOVT	R0, #hi_addr(TIM2_CCR1+0)
LDR	R1, [R0, #0]
MOVW	R0, #lo_addr(_ch1_val+0)
MOVT	R0, #hi_addr(_ch1_val+0)
STRH	R1, [R0, #0]
;ESC_Brushed.c,59 :: 		TIM2_CCER.CC1P = 0; // Vai capturar a subida qdo o sinal iniciar
MOVS	R1, #0
SXTB	R1, R1
MOVW	R0, #lo_addr(TIM2_CCER+0)
MOVT	R0, #hi_addr(TIM2_CCER+0)
_SX	[R0, ByteOffset(TIM2_CCER+0)]
;ESC_Brushed.c,60 :: 		}
L_timer2_ISR3:
;ESC_Brushed.c,61 :: 		TIM2_CCR1 = 0;
MOVS	R1, #0
MOVW	R0, #lo_addr(TIM2_CCR1+0)
MOVT	R0, #hi_addr(TIM2_CCR1+0)
STR	R1, [R0, #0]
;ESC_Brushed.c,62 :: 		TIM2_SR.CC1IF = 0;
MOVS	R1, #0
SXTB	R1, R1
MOVW	R0, #lo_addr(TIM2_SR+0)
MOVT	R0, #hi_addr(TIM2_SR+0)
_SX	[R0, ByteOffset(TIM2_SR+0)]
;ESC_Brushed.c,63 :: 		}
L_timer2_ISR1:
;ESC_Brushed.c,64 :: 		}
L_end_timer2_ISR:
BX	LR
; end of _timer2_ISR
_iniciaUART:
;ESC_Brushed.c,66 :: 		void iniciaUART(){
SUB	SP, SP, #4
STR	LR, [SP, #0]
;ESC_Brushed.c,67 :: 		UART1_Init(9600);
MOVW	R0, #9600
BL	_UART1_Init+0
;ESC_Brushed.c,68 :: 		UART1_Enable();
BL	_UART1_Enable+0
;ESC_Brushed.c,69 :: 		}
L_end_iniciaUART:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _iniciaUART
_txtUART:
;ESC_Brushed.c,71 :: 		void txtUART(char * UART_text){
; UART_text start address is: 0 (R0)
SUB	SP, SP, #4
STR	LR, [SP, #0]
; UART_text end address is: 0 (R0)
; UART_text start address is: 0 (R0)
MOV	R2, R0
; UART_text end address is: 0 (R0)
;ESC_Brushed.c,72 :: 		while(UART1_Tx_Idle() == 0);
L_txtUART4:
; UART_text start address is: 8 (R2)
BL	_UART1_Tx_Idle+0
CMP	R0, #0
IT	NE
BNE	L_txtUART5
IT	AL
BAL	L_txtUART4
L_txtUART5:
;ESC_Brushed.c,74 :: 		UART1_Write_Text(UART_text);
MOV	R0, R2
; UART_text end address is: 8 (R2)
BL	_UART1_Write_Text+0
;ESC_Brushed.c,76 :: 		}
L_end_txtUART:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _txtUART
_intUART:
;ESC_Brushed.c,78 :: 		void intUART(int _data){
; _data start address is: 0 (R0)
SUB	SP, SP, #12
STR	LR, [SP, #0]
; _data end address is: 0 (R0)
; _data start address is: 0 (R0)
SXTH	R2, R0
; _data end address is: 0 (R0)
;ESC_Brushed.c,80 :: 		while(UART1_Tx_Idle() == 0);
L_intUART6:
; _data start address is: 8 (R2)
BL	_UART1_Tx_Idle+0
CMP	R0, #0
IT	NE
BNE	L_intUART7
IT	AL
BAL	L_intUART6
L_intUART7:
;ESC_Brushed.c,81 :: 		IntToStr(_data,txt);
ADD	R1, SP, #4
SXTH	R0, R2
; _data end address is: 8 (R2)
BL	_IntToStr+0
;ESC_Brushed.c,82 :: 		UART1_Write_Text(Ltrim(txt));
ADD	R1, SP, #4
MOV	R0, R1
BL	_Ltrim+0
BL	_UART1_Write_Text+0
;ESC_Brushed.c,83 :: 		}
L_end_intUART:
LDR	LR, [SP, #0]
ADD	SP, SP, #12
BX	LR
; end of _intUART
_main:
;ESC_Brushed.c,86 :: 		void main() {
;ESC_Brushed.c,88 :: 		unsigned int potA = 0;
;ESC_Brushed.c,90 :: 		GPIO_Digital_Output(&GPIOB_BASE, _GPIO_PINMASK_3); //
MOVW	R1, #8
MOVW	R0, #lo_addr(GPIOB_BASE+0)
MOVT	R0, #hi_addr(GPIOB_BASE+0)
BL	_GPIO_Digital_Output+0
;ESC_Brushed.c,91 :: 		GPIO_Digital_Output(&GPIOA_BASE, _GPIO_PINMASK_15); //
MOVW	R1, #32768
MOVW	R0, #lo_addr(GPIOA_BASE+0)
MOVT	R0, #hi_addr(GPIOA_BASE+0)
BL	_GPIO_Digital_Output+0
;ESC_Brushed.c,92 :: 		GPIO_Digital_Output(&GPIOA_BASE, _GPIO_PINMASK_12 | _GPIO_PINMASK_11); //
MOVW	R1, #6144
MOVW	R0, #lo_addr(GPIOA_BASE+0)
MOVT	R0, #hi_addr(GPIOA_BASE+0)
BL	_GPIO_Digital_Output+0
;ESC_Brushed.c,94 :: 		GPIO_Digital_Output(&GPIOC_BASE, _GPIO_PINMASK_13); // // LED
MOVW	R1, #8192
MOVW	R0, #lo_addr(GPIOC_BASE+0)
MOVT	R0, #hi_addr(GPIOC_BASE+0)
BL	_GPIO_Digital_Output+0
;ESC_Brushed.c,96 :: 		HW95_Start(void);
BL	_HW95_Start+0
;ESC_Brushed.c,98 :: 		setA_Enable();
BL	_setA_Enable+0
;ESC_Brushed.c,99 :: 		setB_Enable();
BL	_setB_Enable+0
;ESC_Brushed.c,101 :: 		init_input_capture();
BL	_init_input_capture+0
;ESC_Brushed.c,104 :: 		iniciaUART();
BL	_iniciaUART+0
;ESC_Brushed.c,106 :: 		while(1){
L_main8:
;ESC_Brushed.c,107 :: 		LED = 0;
MOVS	R1, #0
SXTB	R1, R1
MOVW	R0, #lo_addr(GPIOC_ODR+0)
MOVT	R0, #hi_addr(GPIOC_ODR+0)
_SX	[R0, ByteOffset(GPIOC_ODR+0)]
;ESC_Brushed.c,108 :: 		Delay_1sec();
BL	_Delay_1sec+0
;ESC_Brushed.c,109 :: 		LED = 1;
MOVS	R1, #1
SXTB	R1, R1
MOVW	R0, #lo_addr(GPIOC_ODR+0)
MOVT	R0, #hi_addr(GPIOC_ODR+0)
_SX	[R0, ByteOffset(GPIOC_ODR+0)]
;ESC_Brushed.c,110 :: 		Delay_1sec();
BL	_Delay_1sec+0
;ESC_Brushed.c,111 :: 		LED = 0;
MOVS	R1, #0
SXTB	R1, R1
MOVW	R0, #lo_addr(GPIOC_ODR+0)
MOVT	R0, #hi_addr(GPIOC_ODR+0)
_SX	[R0, ByteOffset(GPIOC_ODR+0)]
;ESC_Brushed.c,112 :: 		intUART(ch1_val);
MOVW	R0, #lo_addr(_ch1_val+0)
MOVT	R0, #hi_addr(_ch1_val+0)
LDRH	R0, [R0, #0]
BL	_intUART+0
;ESC_Brushed.c,152 :: 		}
IT	AL
BAL	L_main8
;ESC_Brushed.c,155 :: 		}
L_end_main:
L__main_end_loop:
B	L__main_end_loop
; end of _main
