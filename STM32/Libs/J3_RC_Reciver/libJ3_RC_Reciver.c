#include "libJ3_RC_Reciver.h"

char ch1_flag = 0;
unsigned int ch1_val = 0;
unsigned int ch1_val_final = 0;
unsigned int ch1_val_min = 100;
unsigned int ch1_val_max = 200;

char ch2_flag = 0;
unsigned int ch2_val = 0;
unsigned int ch2_val_final = 0;
unsigned int ch2_val_min = 100;
unsigned int ch2_val_max = 200;

char ch3_flag = 0;
unsigned int ch3_val = 0;
unsigned int ch3_val_final = 0;
unsigned int ch3_val_min = 100;
unsigned int ch3_val_max = 200;

char ch4_flag = 0;
unsigned int ch4_val = 0;
unsigned int ch4_val_final = 0;
unsigned int ch4_val_min = 100;
unsigned int ch4_val_max = 200;

char ch5_flag = 0;
unsigned int ch5_val = 0;
unsigned int ch5_val_final = 0;
unsigned int ch5_val_min = 100;
unsigned int ch5_val_max = 200;

char ch6_flag = 0;
unsigned int ch6_val = 0;
unsigned int ch6_val_final = 0;
unsigned int ch6_val_min = 100;
unsigned int ch6_val_max = 200;

void InitTimer2(void);

char TimerEmUso(void){
  return (ch1_flag == 0) || (ch2_flag == 0)
    || (ch3_flag == 0) || (ch4_flag == 0)
    || (ch5_flag == 0) || (ch6_flag == 0);
}

void RC_Reciver_Start(void){

  // IN - PA_0 CH1
  GPIO_Config(&GPIOA_BASE, _GPIO_PINMASK_0, _GPIO_CFG_MODE_INPUT | _GPIO_CFG_PULL_DOWN);
  // IN - PA_1 CH2
  GPIO_Config(&GPIOA_BASE, _GPIO_PINMASK_1, _GPIO_CFG_MODE_INPUT | _GPIO_CFG_PULL_DOWN);
  // IN - PA_2 CH3
  GPIO_Config(&GPIOA_BASE, _GPIO_PINMASK_2, _GPIO_CFG_MODE_INPUT | _GPIO_CFG_PULL_DOWN);
  // IN - PA_3 CH4
  GPIO_Config(&GPIOA_BASE, _GPIO_PINMASK_3, _GPIO_CFG_MODE_INPUT | _GPIO_CFG_PULL_DOWN);
  // IN - PA_4 CH5
  GPIO_Config(&GPIOA_BASE, _GPIO_PINMASK_4, _GPIO_CFG_MODE_INPUT | _GPIO_CFG_PULL_DOWN);
  // IN - PA_5 CH6
  GPIO_Config(&GPIOA_BASE, _GPIO_PINMASK_5, _GPIO_CFG_MODE_INPUT | _GPIO_CFG_PULL_DOWN);

  InitTimer2(); /* Configura o Timer2 para 10us = 80MHz */
  
  ch1_flag = 1;  /* 1 ch não esta contado sinal esta em down */
  ch2_flag = 1;
  ch3_flag = 1;
  ch4_flag = 1;
  ch5_flag = 1;
  ch6_flag = 1;
  EXTI_RTSR |= 0x00000007;  // Set com 1
  EXTI_FTSR &= 0xFFFFFFF8;  // Set com 0
  EXTI_IMR  |= 0x00000007;  // Set com 1
  
  /* enable NVIC interface  */
  NVIC_IntEnable(IVT_INT_EXTI0);    // ch1
  NVIC_IntEnable(IVT_INT_EXTI1);    // ch2
  NVIC_IntEnable(IVT_INT_EXTI2);    // ch3
//  NVIC_IntEnable(IVT_INT_EXTI3);    // enable NVIC interface
//  NVIC_IntEnable(IVT_INT_EXTI4);    // enable NVIC interface
//  NVIC_IntEnable(IVT_INT_EXTI9_5);  // enable NVIC interface


}

unsigned int GetCh1(void){
  unsigned int ch1 = ch1_val_final;
  if (ch1 < ch1_val_min)
    ch1 = ch1_val_min;
  if (ch1 > ch1_val_max)
    ch1 = ch1_val_max;
  return ch1;
}

unsigned int GetCh2(void){
  if (ch2_val_final < ch2_val_min)
    ch2_val_final = ch2_val_min;
  if (ch2_val_final > ch2_val_max)
    ch2_val_final = ch2_val_max;
  return ch2_val_final;
}

unsigned int GetCh3(void){
  if (ch3_val_final < ch3_val_min)
    ch3_val_final = ch3_val_min;
  if (ch3_val_final > ch3_val_max)
    ch3_val_final = ch3_val_max;
  return ch3_val_final;
}

unsigned int GetCh4(void){
  if (ch4_val_final < ch4_val_min)
    ch4_val_final = ch4_val_min;
  if (ch4_val_final > ch4_val_max)
    ch4_val_final = ch4_val_max;
  return ch4_val_final;
}

unsigned int GetCh5(void){
  if (ch5_val_final < ch5_val_min)
    ch5_val_final = ch5_val_min;
  if (ch5_val_final > ch5_val_max)
    ch5_val_final = ch5_val_max;
  return ch5_val_final;
}

unsigned int GetCh6(void){
  if (ch6_val_final < ch6_val_min)
    ch6_val_final = ch6_val_min;
  if (ch6_val_final > ch6_val_max)
    ch6_val_final = ch6_val_max;
  return ch6_val_final;
}


/* Config Timer2 para 10us  */
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
  if (ch1_flag == 0)
    ch1_val++;

  if (ch2_flag == 0)
   ch2_val++;

  if (ch3_flag == 0)
   ch3_val++;

  if (ch4_flag == 0)
    ch4_val++;

  if (ch5_flag == 0)
    ch5_val++;

  if (ch6_flag == 0)
    ch6_val++;
}

void external_interrupt_PA0() iv IVT_INT_EXTI0 ics ICS_AUTO
{
    if((EXTI_PR & 0x00000001) != 0) {   // Interrupcao em PA0
         if(ch1_flag == 1){                       // se o sinal foi de subida
           ch1_flag = 0;                          // flag = 0  vai detectar borda de descida
           EXTI_RTSR = EXTI_RTSR & 0xFFFFFFFE;    // Não detectar borda de subida set 0 zero
           EXTI_FTSR = EXTI_FTSR | 0x00000001;    // 1 Liga detectar a bora de subida
           ch1_val = 0;                           // Zera contador
           NVIC_IntEnable(IVT_INT_TIM2);          // Habilita o timer da contagem
         }
         else{
           ch1_flag = 1;
           EXTI_RTSR = EXTI_RTSR | 0x00000001;   // Detectar borda de subida
           EXTI_FTSR = EXTI_FTSR & 0xFFFFFFFE;   // Não detectar borada de decida
           if(!TimerEmUso())                     // Se nao tiver em uso
             NVIC_IntDisable(IVT_INT_TIM2);      // Desabilita o timer da contagem
           ch1_val_final = ch1_val;              // Salva o contador na variavel principal
         }
        EXTI_PR  |= 0x00000001;          // set pending register
    }
}

void external_interrupt_PA1() iv IVT_INT_EXTI1 ics ICS_AUTO
{
    if((EXTI_PR & 0x00000002) != 0) {   // PA1 (pending register PA1 set)
         if(ch2_flag == 1){
           ch2_flag = 0;
           EXTI_RTSR = EXTI_RTSR & 0xFFFFFFFD;       // rising edge: 4800 = 0100 1000 0000 0000 (line 14 + 11)
           EXTI_FTSR = EXTI_FTSR | 0x00000002;
           ch2_val = 0;
           NVIC_IntEnable(IVT_INT_TIM2);
         }
         else{
           ch2_flag = 1;
           EXTI_RTSR = EXTI_RTSR | 0x00000002;       // rising edge: 4800 = 0100 1000 0000 0000 (line 14 + 11)
           EXTI_FTSR = EXTI_FTSR & 0xFFFFFFFD;
           NVIC_IntDisable(IVT_INT_TIM2);
           ch2_val_final = ch2_val;
         }
        EXTI_PR  |= 0x00000002;          // reset pending register PR11
    }
}

void external_interrupt_PA2() iv IVT_INT_EXTI2 ics ICS_AUTO
{
    if((EXTI_PR & 0x00000004) != 0) {
         if(ch3_flag == 1){
           ch3_flag = 0;
           EXTI_RTSR = EXTI_RTSR & 0xFFFFFFFB;
           EXTI_FTSR = EXTI_FTSR | 0x00000004;
           ch3_val = 0;
           NVIC_IntEnable(IVT_INT_TIM2);
         }
         else{
           ch3_flag = 1;
           EXTI_RTSR = EXTI_RTSR | 0x00000004;
           EXTI_FTSR = EXTI_FTSR & 0xFFFFFFFB;   // 1011b = 0xB
           NVIC_IntDisable(IVT_INT_TIM2);
           ch3_val_final = ch3_val;
         }
        EXTI_PR  |= 0x00000004;          // 0100b = 0x4
    }
}