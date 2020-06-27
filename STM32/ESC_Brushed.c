#include "Libs/J3_HW95/motorDriveHW95.h"
#include "Libs/J3_RC_Reciver/libJ3_RC_Reciver.h"

#define LED GPIOC_ODR.B13

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
  unsigned int potA = 0;

  GPIO_Digital_Output(&GPIOB_BASE, _GPIO_PINMASK_3); //   A1 - HW95
  GPIO_Digital_Output(&GPIOA_BASE, _GPIO_PINMASK_15); //  A2 - HW95
  GPIO_Digital_Output(&GPIOA_BASE, _GPIO_PINMASK_12 | _GPIO_PINMASK_11); //  B1 and B2 = HW95

  GPIO_Digital_Output(&GPIOC_BASE, _GPIO_PINMASK_13); // // LED
 
  HW95_Start();
  setA_Enable();
 //setB_Enable();
 
  iniciaUART();
 
  LED = 1;

  RC_Reciver_Start();

  while(1){
    Delay_ms(25);
    potA = GetCh1();
    potA = (potA - 100);
    SetA_Front(potA);
  }
}