/* Lib MotorDriveHW95 */
/* By: Nelson Lima - jnelsonlima3@gmail.com */

/* Construida pensando em facilitar o uso do Drive HW95 */
/* Valores para setar no PWM de 0 ate 100 */




void HW95_Start(void);

void setA_Enable(void);
void setB_Enable(void);
void setA_Disable(void);
void setB_Disable(void);

void SetA_Front(unsigned int _pwm);
void setA_Rear(unsigned int _pwm);
void SetB_Front(unsigned int _pwm);
void setB_Rear(unsigned int_pwm);