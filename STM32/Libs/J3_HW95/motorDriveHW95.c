/* Lib MotorDriveHW95 */
/* By: Nelson Lima - jnelsonlima3@gmail.com */

/* Vai usar o TIMER3 para o PWM */
#include "motorDriveHW95.h"

/* Definir os pinos A1, A2 and B1, B2  */
#define A1 GPIOB_ODR.B3
#define A2 GPIOA_ODR.B15
#define B1 GPIOA_ODR.B12
#define B2 GPIOA_ODR.B11
/* ----------------------------------- */

unsigned int pwm_ratio;

/* Normaliza o ratio do pwm para valores de 0 ate 100 */
unsigned int CalcDuty(unsigned int _duty){
  /* Regra de 3 pra calcular o valor do duty; */
  return (_duty * pwm_ratio / 100);
}

void HW95_Start(void){
  pwm_ratio = PWM_TIM3_Init(250000); // 100Hz Freq. do PWM
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
  A1 = 1;
  A2 = 0;
  PWM_TIM3_Set_Duty(CalcDuty(_pwm), _PWM_NON_INVERTED, _PWM_CHANNEL4);
}

void setA_Rear(unsigned  int _pwm){
  A1 = 0;
  A2 = 1;
  PWM_TIM3_Set_Duty(CalcDuty(_pwm), _PWM_NON_INVERTED, _PWM_CHANNEL4);
}

void SetB_Front(unsigned  int _pwm){
  B1 = 1;
  B2 = 0;
  PWM_TIM3_Set_Duty(CalcDuty(_pwm), _PWM_NON_INVERTED, _PWM_CHANNEL2);
}
void setB_Rear(unsigned int _pwm){
  B1 = 0;
  B2 = 1;
  PWM_TIM3_Set_Duty(CalcDuty(_pwm), _PWM_NON_INVERTED, _PWM_CHANNEL2);
}