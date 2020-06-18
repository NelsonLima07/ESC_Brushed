#include "motorDriveHW95.h"
#include "libJ3_RC_Reciver.h"

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







void main() {
  int i;
  unsigned int potA = 0;

  // IN - PA_0
  GPIO_Config(&GPIOA_BASE, _GPIO_PINMASK_0, _GPIO_CFG_MODE_INPUT | _GPIO_CFG_PULL_DOWN);
  // IN - PA_1
  GPIO_Config(&GPIOA_BASE, _GPIO_PINMASK_1, _GPIO_CFG_MODE_INPUT | _GPIO_CFG_PULL_DOWN);

 
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


 
  InitTimer2();

  while(1){
   //Delay_ms(3000);
   //NVIC_IntDisable(IVT_INT_TIM2);
    Delay_ms(200);
    //LED = 0;
    //longUART(ch1_val_final);
   
    potA = (ch2_val_final - 89) * 0.813;
    SetA_Front(potA);
    // NVIC_IntEnable(IVT_INT_TIM2);
  }
}