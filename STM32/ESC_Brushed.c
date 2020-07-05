#include "Libs/J3_HW95/motorDriveHW95.h"
#include "Libs/J3_RC_Reciver/libJ3_RC_Reciver.h"
#include "Libs/J3_DShot_ESC/J3_DShot_ESC.h"

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


unsigned int normalize(unsigned int _min, unsigned int _max, unsigned int _valor,unsigned int _minOut, unsigned int _maxOut){

}

unsigned int normalizeInvert(unsigned int _min, unsigned int _max, unsigned int _valor,unsigned int _minOut, unsigned int _maxOut){

}


void main() {
  unsigned int i;
  unsigned int potA = 0;
  unsigned long statusMem;
  unsigned int* memPotA;
  memPotA = (unsigned int*)0x08008000;    //

  GPIO_Digital_Output(&GPIOB_BASE, _GPIO_PINMASK_12  // A1 -  HW95
    | _GPIO_PINMASK_13                               // A2 -  HW95
    | _GPIO_PINMASK_14                               // B1 -  HW95
    | _GPIO_PINMASK_15);                             // B2 - HW95

  GPIO_Digital_Output(&GPIOC_BASE, _GPIO_PINMASK_13); // // LED
  
  //GPIO_Digital_Output(&GPIOA_ODR, _GPIO_CFG_SPEED_MAX | _GPIO_PINMASK_8); // ESC
  GPIO_Config(&GPIOB_BASE, _GPIO_PINMASK_8, _GPIO_CFG_MODE_OUTPUT | _GPIO_CFG_SPEED_MAX);
 
  HW95_Start();
  setA_Enable();
  setB_Enable();
 
  iniciaUART();
 
  LED = 1;

  RC_Reciver_Start();
  
  statusMem = FLASH_Write_HalfWord(0x08008000, 0x0096);
  //FLASH_Lock();

  for(i=0;i<1500;i++){
    DShotESC_setValue(0);
    Delay_us(1500);
  }
  for(i=0;i<1500;i++){
    DShotESC_setValue(100);
    Delay_us(1500);
  }
  for(i=0;i<1500;i++){
    DShotESC_setValue(200);
    Delay_us(1500);
  }

  
  while(1){
    LED = ~LED;
    Delay_ms(1500);
    potA = GetCh1();
    potA = (potA - 100) * 20;
    if (potA < 48)
      potA = 48;
    if (potA > 2047)
      potA = 2047;
    DShotESC_setValue(potA);
  }
}