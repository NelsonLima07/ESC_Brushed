#line 1 "C:/NelsonLima/Projetos/03_ESC_Brushed/ESC_Brushed.git/trunk/STM32/ESC_Brushed.c"
#line 1 "c:/nelsonlima/projetos/03_esc_brushed/esc_brushed.git/trunk/stm32/motordrivehw95.h"









void HW95_Start(void);

void setA_Enable(void);
void setB_Enable(void);
void setA_Disable(void);
void setB_Disable(void);

void SetA_Front(unsigned int _pwm);
void setA_Rear(unsigned int _pwm);
void SetB_Front(unsigned int _pwm);
void setB_Rear(unsigned int_pwm);
#line 1 "c:/nelsonlima/projetos/03_esc_brushed/esc_brushed.git/trunk/stm32/libj3_rc_reciver.h"
#line 6 "C:/NelsonLima/Projetos/03_ESC_Brushed/ESC_Brushed.git/trunk/STM32/ESC_Brushed.c"
long double timer2_period_ms;

unsigned long ch1_val = 0;
unsigned long ch1_val_final = 0;




unsigned int potA = 0;
unsigned int contTempo = 0;

unsigned long cont_Timer2 = 0;


void InitTimer2(){
 RCC_APB1ENR.TIM2EN = 1;
 TIM2_CR1.CEN = 0;
 TIM2_PSC = 0;
 TIM2_ARR = 199;

 TIM2_DIER.UIE = 1;
 TIM2_CR1.CEN = 1;
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

void longUART(long _data){
 char txt[12];
 while(UART1_Tx_Idle() == 0);
 LongToStr(_data,txt);
 UART1_Write_Text(Ltrim(txt));
}








void main() {
 int i;
 unsigned int potA = 0;


 GPIO_Config(&GPIOA_BASE, _GPIO_PINMASK_0, _GPIO_CFG_MODE_INPUT | _GPIO_CFG_PULL_DOWN);

 GPIO_Config(&GPIOA_BASE, _GPIO_PINMASK_1, _GPIO_CFG_MODE_INPUT | _GPIO_CFG_PULL_DOWN);


 GPIO_Digital_Output(&GPIOB_BASE, _GPIO_PINMASK_3);
 GPIO_Digital_Output(&GPIOA_BASE, _GPIO_PINMASK_15);
 GPIO_Digital_Output(&GPIOA_BASE, _GPIO_PINMASK_12 | _GPIO_PINMASK_11);

 GPIO_Digital_Output(&GPIOC_BASE, _GPIO_PINMASK_13);

 HW95_Start(void);

 setA_Enable();



 iniciaUART();

  GPIOC_ODR.B13  = 1;



 InitTimer2();

 while(1){


 Delay_ms(200);



 potA = (ch2_val_final - 89) * 0.813;
 SetA_Front(potA);

 }
}
