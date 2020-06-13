#line 1 "C:/NelsonLima/Projetos/03_ESC_Brushed/STM32/ESC_Brushed.c"
#line 1 "c:/nelsonlima/projetos/03_esc_brushed/stm32/motordrivehw95.h"
#line 13 "c:/nelsonlima/projetos/03_esc_brushed/stm32/motordrivehw95.h"
void HW95_Start(void);

void setA_Enable(void);
void setB_Enable(void);
void setA_Disable(void);
void setB_Disable(void);

void SetA_Front(unsigned int _pwm);
void setA_Rear(unsigned int _pwm);
void SetB_Front(unsigned int _pwm);
void setB_Rear(unsigned int_pwm);
#line 10 "C:/NelsonLima/Projetos/03_ESC_Brushed/STM32/ESC_Brushed.c"
long double timer2_period_ms;

unsigned int ch1_val;
unsigned int contTempo;


void InitTimer2(){
 RCC_APB1ENR.TIM2EN = 1;
 TIM2_CR1.CEN = 0;
 TIM2_PSC = 0;
 TIM2_ARR = 79;
 NVIC_IntEnable(IVT_INT_TIM2);
 TIM2_DIER.UIE = 1;
 TIM2_CR1.CEN = 1;
}

void Timer2_interrupt() iv IVT_INT_TIM2 {
 TIM2_SR.UIF = 0;

}

void iniciaUART(){
 UART1_Init(9600);
 UART1_Enable();
}

void txtUART(char * UART_text){
 while(UART1_Tx_Idle() == 0);

 UART1_Write_Text(UART_text);

}

void intUART(int _data){
 char txt[7];
 while(UART1_Tx_Idle() == 0);
 IntToStr(_data,txt);
 UART1_Write_Text(Ltrim(txt));
}


void main() {
 int i;
 unsigned int potA = 0;

 GPIO_Digital_Output(&GPIOB_BASE, _GPIO_PINMASK_3);
 GPIO_Digital_Output(&GPIOA_BASE, _GPIO_PINMASK_15);
 GPIO_Digital_Output(&GPIOA_BASE, _GPIO_PINMASK_12 | _GPIO_PINMASK_11);

 GPIO_Digital_Output(&GPIOC_BASE, _GPIO_PINMASK_13);

 HW95_Start(void);

 setA_Enable();
 setB_Enable();

 init_input_capture();


 iniciaUART();

 while(1){
  GPIOC_ODR.B13  = 0;
 Delay_1sec();
  GPIOC_ODR.B13  = 1;
 Delay_1sec();
  GPIOC_ODR.B13  = 0;
 intUART(ch1_val);
#line 117 "C:/NelsonLima/Projetos/03_ESC_Brushed/STM32/ESC_Brushed.c"
 }


}
