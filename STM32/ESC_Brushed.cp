#line 1 "C:/NelsonLima/Projetos/03_ESC_Brushed/ESC_Brushed.git/trunk/STM32/ESC_Brushed.c"
#line 1 "c:/nelsonlima/projetos/03_esc_brushed/esc_brushed.git/trunk/stm32/libs/j3_hw95/motordrivehw95.h"









void HW95_Start(void);

void setA_Enable(void);
void setB_Enable(void);
void setA_Disable(void);
void setB_Disable(void);

void SetA_Front(unsigned int _pwm);
void setA_Rear(unsigned int _pwm);
void SetB_Front(unsigned int _pwm);
void setB_Rear(unsigned int_pwm);
#line 1 "c:/nelsonlima/projetos/03_esc_brushed/esc_brushed.git/trunk/stm32/libs/j3_rc_reciver/libj3_rc_reciver.h"
#line 16 "c:/nelsonlima/projetos/03_esc_brushed/esc_brushed.git/trunk/stm32/libs/j3_rc_reciver/libj3_rc_reciver.h"
void RC_Reciver_Start(void);
unsigned int GetCh1(void);
unsigned int GetCh2(void);
unsigned int GetCh3(void);
unsigned int GetCh4(void);
unsigned int GetCh5(void);
unsigned int GetCh6(void);
#line 1 "c:/nelsonlima/projetos/03_esc_brushed/esc_brushed.git/trunk/stm32/libs/j3_dshot_esc/j3_dshot_esc.h"







void J3_DShotESC_Init();
void J3_DShotESC_setValue(unsigned int _val);
#line 10 "C:/NelsonLima/Projetos/03_ESC_Brushed/ESC_Brushed.git/trunk/STM32/ESC_Brushed.c"
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



unsigned int normalize(unsigned int _min, unsigned int _max, unsigned int _valor,unsigned int _minOut, unsigned int _maxOut){

}

unsigned int normalizeInvert(unsigned int _min, unsigned int _max, unsigned int _valor,unsigned int _minOut, unsigned int _maxOut){

}


void main() {
 unsigned int i;
 unsigned int potA = 0;
 unsigned long statusMem;
 unsigned int* memPotA;
 memPotA = (unsigned int*)0x08008000;

 GPIO_Digital_Output(&GPIOB_BASE, _GPIO_PINMASK_12
 | _GPIO_PINMASK_13
 | _GPIO_PINMASK_14
 | _GPIO_PINMASK_15);

 GPIO_Digital_Output(&GPIOC_BASE, _GPIO_PINMASK_13);


 GPIO_Config(&GPIOB_BASE, _GPIO_PINMASK_8, _GPIO_CFG_MODE_OUTPUT | _GPIO_CFG_SPEED_MAX);

 HW95_Start();
 setA_Enable();
 setB_Enable();

 iniciaUART();

  GPIOC_ODR.B13  = 1;

 RC_Reciver_Start();

 statusMem = FLASH_Write_HalfWord(0x08008000, 0x0096);


 J3_DShotESC_Init();
 while(1){
  GPIOC_ODR.B13  = ~ GPIOC_ODR.B13 ;
 Delay_ms(150);
 potA = GetCh1();
 potA = (potA - 100) * 20;
 if (potA < 48)
 potA = 48;
 if (potA > 2047)
 potA = 2047;
 J3_DShotESC_setValue(potA);
 }
}
