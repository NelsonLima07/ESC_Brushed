#include "motorDriveHW95.h"

#define LED GPIOC_ODR.B13

long double timer2_period_ms;

unsigned int ch1_val;
unsigned int contTempo; //


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
  //Enter your code here
}

/* UART Function */
void iniciaUART(){
  UART1_Init(9600);
  UART1_Enable();
}

void txtUART(char * UART_text){
 while(UART1_Tx_Idle() == 0);
// if (UART1_Tx_Idle() == 1) {
   UART1_Write_Text(UART_text);
// }
}

void intUART(int _data){
 char txt[7];
 while(UART1_Tx_Idle() == 0);
 IntToStr(_data,txt);
 UART1_Write_Text(Ltrim(txt));
}
/* FIM UART Functions */

void main() {
 int i;
 unsigned int potA = 0;
 
 GPIO_Digital_Output(&GPIOB_BASE, _GPIO_PINMASK_3); //   A1 - HW95
 GPIO_Digital_Output(&GPIOA_BASE, _GPIO_PINMASK_15); //  A2 - HW95
 GPIO_Digital_Output(&GPIOA_BASE, _GPIO_PINMASK_12 | _GPIO_PINMASK_11); //  B1 and B2 = HW95

 GPIO_Digital_Output(&GPIOC_BASE, _GPIO_PINMASK_13); // // LED
 
 HW95_Start(void);
 
 setA_Enable();
 setB_Enable();
 
 init_input_capture();


  iniciaUART();
 
 while(1){
   LED = 0;
   Delay_1sec();
   LED = 1;
   Delay_1sec();
   LED = 0;
   intUART(ch1_val);
 }
}