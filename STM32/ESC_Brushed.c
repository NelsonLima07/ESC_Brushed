#include "motorDriveHW95.h"

#define LED GPIOC_ODR.B13

long double timer2_period_ms;

unsigned long ch1_val = 0;
unsigned long ch1_val_final = 0;
unsigned int potA = 0;
unsigned int contTempo = 0; //

unsigned long cont_Timer2 = 0; /* Conta na base de dados do Timer2 10us */

/* Timer2 para 10us  */
void InitTimer2(){
  RCC_APB1ENR.TIM2EN = 1;
  TIM2_CR1.CEN = 0;
  TIM2_PSC = 0;
  TIM2_ARR = 199;
  //NVIC_IntEnable(IVT_INT_TIM2);
  TIM2_DIER.UIE = 1;
  TIM2_CR1.CEN = 1;
}

void Timer2_interrupt() iv IVT_INT_TIM2 {
  TIM2_SR.UIF = 0;
  /* Codigo do timer2 aqui  */
  cont_Timer2++;
  ch1_val++;
  if(cont_Timer2 >= 15000) /* 1,5ms ou 150000us */
  {
    //LED = ~LED;
    cont_Timer2 = 0;
  }
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

void longUART(long _data){
 char txt[12];
 while(UART1_Tx_Idle() == 0);
 LongToStr(_data,txt);
 UART1_Write_Text(Ltrim(txt));
}
/* FIM UART Functions */

void external_interrupt_PA0() iv IVT_INT_EXTI0 ics ICS_AUTO
{
    if((EXTI_PR & 0x00000001) != 0) {   // PA0 (pending register PA0 set)
         if(LED == 1){
           LED = 0;
//           EXTI_RTSR = 0x00000000;       // rising edge: 4800 = 0100 1000 0000 0000 (line 14 + 11)
//           EXTI_FTSR = 0x00000001;
           EXTI_RTSR = EXTI_RTSR & 0xFFFFFFFE;       // rising edge: 4800 = 0100 1000 0000 0000 (line 14 + 11)
           EXTI_FTSR = EXTI_FTSR | 0x00000001;
           ch1_val = 0;
           NVIC_IntEnable(IVT_INT_TIM2);
         }
         else{
           LED = 1;
//           EXTI_RTSR = 0x00000001;       // rising edge: 4800 = 0100 1000 0000 0000 (line 14 + 11)
//           EXTI_FTSR = 0x00000000;
           EXTI_RTSR = EXTI_RTSR | 0x00000001;       // rising edge: 4800 = 0100 1000 0000 0000 (line 14 + 11)
           EXTI_FTSR = EXTI_FTSR & 0xFFFFFFFE;
           NVIC_IntDisable(IVT_INT_TIM2);
           ch1_val_final = ch1_val;
         }
        // my code
        EXTI_PR  |= 0x00000001;          // reset pending register PR11
    }
}
/*
void external_interrupt_PA1() iv IVT_INT_EXTI1 ics ICS_AUTO
{
    if((EXTI_PR & 0x00000001) != 0) {   // PA0 (pending register PA0 set)
         if(LED == 1){
           LED = 0;
           EXTI_RTSR = EXTI_RTSR & 0xFFFFFFFE;       // rising edge: 4800 = 0100 1000 0000 0000 (line 14 + 11)
           EXTI_FTSR = EXTI_FTSR | 0x00000001;
           ch1_val = 0;
           NVIC_IntEnable(IVT_INT_TIM2);
         }
         else{
           LED = 1;
           EXTI_RTSR = EXTI_RTSR | 0x00000001;       // rising edge: 4800 = 0100 1000 0000 0000 (line 14 + 11)
           EXTI_FTSR = EXTI_FTSR & 0xFFFFFFFE;
           NVIC_IntDisable(IVT_INT_TIM2);
           ch1_val_final = ch1_val;
         }
        // my code
        EXTI_PR  |= 0x00000001;          // reset pending register PR11
    }
}
  */


void main() {
  int i;
  unsigned int potA = 0;

  // IN - PA_0
  GPIO_Config(&GPIOA_BASE, _GPIO_PINMASK_0, _GPIO_CFG_MODE_INPUT | _GPIO_CFG_PULL_DOWN);
 
  GPIO_Digital_Output(&GPIOB_BASE, _GPIO_PINMASK_3); //   A1 - HW95
  GPIO_Digital_Output(&GPIOA_BASE, _GPIO_PINMASK_15); //  A2 - HW95
  GPIO_Digital_Output(&GPIOA_BASE, _GPIO_PINMASK_12 | _GPIO_PINMASK_11); //  B1 and B2 = HW95

  GPIO_Digital_Output(&GPIOC_BASE, _GPIO_PINMASK_13); // // LED
 
  HW95_Start(void);
 
  setA_Enable();
 //setB_Enable();
 
 // init_input_capture();
  iniciaUART();
 
  LED = 1;
  
  EXTI_RTSR = 0x00000001;       // rising edge: 4800 = 0100 1000 0000 0000 (line 14 + 11)
  EXTI_FTSR = 0x00000000;
  EXTI_IMR = 0x00000001;
  NVIC_IntEnable(IVT_INT_EXTI0);      // enable NVIC interface

 
  InitTimer2();

  while(1){
   //Delay_ms(3000);
   //NVIC_IntDisable(IVT_INT_TIM2);
    Delay_ms(200);
    //LED = 0;
    //longUART(ch1_val_final);
   
    potA = (ch1_val_final - 89) * 0.813;
    SetA_Front(potA);
    // NVIC_IntEnable(IVT_INT_TIM2);
  }
}