#include "libJ3_RC_Reciver.h"



/* Vai usar o TIMER3 para o PWM */
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

void RC_Reciver_Start(void){
  ch1_flag = 1;
  ch2_flag = 1;
  ch3_flag = 1;
  ch4_flag = 1;
  ch5_flag = 1;
  ch6_flag = 1;
  EXTI_RTSR |= 0x00000003;  // Set com 1
  EXTI_FTSR &= 0xFFFFFFFC;  // Set com 0
  EXTI_IMR  |= 0x00000003;  // Set com 1
  NVIC_IntEnable(IVT_INT_EXTI0);    // enable NVIC interface
  NVIC_IntEnable(IVT_INT_EXTI1);    // enable NVIC interface
  NVIC_IntEnable(IVT_INT_EXTI2);    // enable NVIC interface
  NVIC_IntEnable(IVT_INT_EXTI3);    // enable NVIC interface
  NVIC_IntEnable(IVT_INT_EXTI4);    // enable NVIC interface
  NVIC_IntEnable(IVT_INT_EXTI9_5);  // enable NVIC interface
}

unsigned int GetCh1(void){

}

unsigned int GetCh2(void){
}

unsigned int GetCh3(void){
}

unsigned int GetCh4(void){
}

unsigned int GetCh5(void){
}

unsigned int GetCh6(void){
}


void Timer2_interrupt() iv IVT_INT_TIM2 {
  TIM2_SR.UIF = 0;
  /* Codigo do timer2 aqui  */


  ch1_val++;
  ch2_val++;
  ch3_val++;
  ch4_val++;
  ch5_val++;
  ch6_val++;
}

void external_interrupt_PA0() iv IVT_INT_EXTI0 ics ICS_AUTO
{
    if((EXTI_PR & 0x00000001) != 0) {   // PA0 (pending register PA0 set)
         if(ch1_flag == 1){
           ch1_flag = 0;
           EXTI_RTSR = EXTI_RTSR & 0xFFFFFFFE;       // rising edge: 4800 = 0100 1000 0000 0000 (line 14 + 11)
           EXTI_FTSR = EXTI_FTSR | 0x00000001;
           ch1_val = 0;
           NVIC_IntEnable(IVT_INT_TIM2);
         }
         else{
           ch1_flag = 1;
           EXTI_RTSR = EXTI_RTSR | 0x00000001;       // rising edge: 4800 = 0100 1000 0000 0000 (line 14 + 11)
           EXTI_FTSR = EXTI_FTSR & 0xFFFFFFFE;
           NVIC_IntDisable(IVT_INT_TIM2);
           ch1_val_final = ch1_val;
         }
        EXTI_PR  |= 0x00000001;          // reset pending register PR11
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
        // my code
        EXTI_PR  |= 0x00000002;          // reset pending register PR11
    }
}