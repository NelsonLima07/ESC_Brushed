#line 1 "C:/NelsonLima/Projetos/03_ESC_Brushed/ESC_Brushed.git/trunk/STM32/motorDriveHW95.c"
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
#line 14 "C:/NelsonLima/Projetos/03_ESC_Brushed/ESC_Brushed.git/trunk/STM32/motorDriveHW95.c"
unsigned int pwm_ratio;


unsigned int CalcDuty(unsigned int _duty){

 return (_duty * pwm_ratio / 100);
}

void HW95_Start(void){
 pwm_ratio = PWM_TIM3_Init(250000);
 PWM_TIM3_Set_Duty(0, _PWM_NON_INVERTED, _PWM_CHANNEL4);
 PWM_TIM3_Set_Duty(0, _PWM_NON_INVERTED, _PWM_CHANNEL2);
}

void setA_Enable(void){
 PWM_TIM3_Start(_PWM_CHANNEL4, &_GPIO_MODULE_TIM3_CH4_PB1);
}

void setB_Enable(void){
 PWM_TIM3_Start(_PWM_CHANNEL2, &_GPIO_MODULE_TIM3_CH2_PB5);
}

void setA_Disable(void){
 PWM_TIM3_Stop(_PWM_CHANNEL4);
}

void setB_Disable(void){
 PWM_TIM3_Stop(_PWM_CHANNEL2);
}

void SetA_Front(unsigned int _pwm){
  GPIOB_ODR.B3  = 1;
  GPIOA_ODR.B15  = 0;
 PWM_TIM3_Set_Duty(CalcDuty(_pwm), _PWM_NON_INVERTED, _PWM_CHANNEL4);
}

void setA_Rear(unsigned int _pwm){
  GPIOB_ODR.B3  = 0;
  GPIOA_ODR.B15  = 1;
 PWM_TIM3_Set_Duty(CalcDuty(_pwm), _PWM_NON_INVERTED, _PWM_CHANNEL4);
}

void SetB_Front(unsigned int _pwm){
  GPIOA_ODR.B12  = 1;
  GPIOA_ODR.B11  = 0;
 PWM_TIM3_Set_Duty(CalcDuty(_pwm), _PWM_NON_INVERTED, _PWM_CHANNEL2);
}
void setB_Rear(unsigned int _pwm){
  GPIOA_ODR.B12  = 0;
  GPIOA_ODR.B11  = 1;
 PWM_TIM3_Set_Duty(CalcDuty(_pwm), _PWM_NON_INVERTED, _PWM_CHANNEL2);
}
