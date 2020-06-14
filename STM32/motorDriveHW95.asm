_CalcDuty:
;motorDriveHW95.c,17 :: 		unsigned int CalcDuty(unsigned int _duty){
; _duty start address is: 0 (R0)
; _duty end address is: 0 (R0)
; _duty start address is: 0 (R0)
;motorDriveHW95.c,19 :: 		return (_duty * pwm_ratio / 100);
MOVW	R1, #lo_addr(_pwm_ratio+0)
MOVT	R1, #hi_addr(_pwm_ratio+0)
LDRH	R1, [R1, #0]
MUL	R2, R0, R1
UXTH	R2, R2
; _duty end address is: 0 (R0)
MOVS	R1, #100
UDIV	R1, R2, R1
UXTH	R0, R1
;motorDriveHW95.c,20 :: 		}
L_end_CalcDuty:
BX	LR
; end of _CalcDuty
_HW95_Start:
;motorDriveHW95.c,22 :: 		void HW95_Start(void){
SUB	SP, SP, #4
STR	LR, [SP, #0]
;motorDriveHW95.c,23 :: 		pwm_ratio = PWM_TIM3_Init(250000); // 100Hz Freq. do PWM
MOVW	R0, #53392
MOVT	R0, #3
BL	_PWM_TIM3_Init+0
MOVW	R1, #lo_addr(_pwm_ratio+0)
MOVT	R1, #hi_addr(_pwm_ratio+0)
STRH	R0, [R1, #0]
;motorDriveHW95.c,24 :: 		PWM_TIM3_Set_Duty(0, _PWM_NON_INVERTED, _PWM_CHANNEL4);
MOVS	R2, #3
MOVS	R1, #0
MOVS	R0, #0
BL	_PWM_TIM3_Set_Duty+0
;motorDriveHW95.c,25 :: 		PWM_TIM3_Set_Duty(0, _PWM_NON_INVERTED, _PWM_CHANNEL2);
MOVS	R2, #1
MOVS	R1, #0
MOVS	R0, #0
BL	_PWM_TIM3_Set_Duty+0
;motorDriveHW95.c,26 :: 		}
L_end_HW95_Start:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _HW95_Start
_setA_Enable:
;motorDriveHW95.c,28 :: 		void setA_Enable(void){
SUB	SP, SP, #4
STR	LR, [SP, #0]
;motorDriveHW95.c,29 :: 		PWM_TIM3_Start(_PWM_CHANNEL4, &_GPIO_MODULE_TIM3_CH4_PB1);
MOVW	R1, #lo_addr(__GPIO_MODULE_TIM3_CH4_PB1+0)
MOVT	R1, #hi_addr(__GPIO_MODULE_TIM3_CH4_PB1+0)
MOVS	R0, #3
BL	_PWM_TIM3_Start+0
;motorDriveHW95.c,30 :: 		}
L_end_setA_Enable:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _setA_Enable
_setB_Enable:
;motorDriveHW95.c,32 :: 		void setB_Enable(void){
SUB	SP, SP, #4
STR	LR, [SP, #0]
;motorDriveHW95.c,33 :: 		PWM_TIM3_Start(_PWM_CHANNEL2, &_GPIO_MODULE_TIM3_CH2_PB5);
MOVW	R1, #lo_addr(__GPIO_MODULE_TIM3_CH2_PB5+0)
MOVT	R1, #hi_addr(__GPIO_MODULE_TIM3_CH2_PB5+0)
MOVS	R0, #1
BL	_PWM_TIM3_Start+0
;motorDriveHW95.c,34 :: 		}
L_end_setB_Enable:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _setB_Enable
_setA_Disable:
;motorDriveHW95.c,36 :: 		void setA_Disable(void){
SUB	SP, SP, #4
STR	LR, [SP, #0]
;motorDriveHW95.c,37 :: 		PWM_TIM3_Stop(_PWM_CHANNEL4);
MOVS	R0, #3
BL	_PWM_TIM3_Stop+0
;motorDriveHW95.c,38 :: 		}
L_end_setA_Disable:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _setA_Disable
_setB_Disable:
;motorDriveHW95.c,40 :: 		void setB_Disable(void){
SUB	SP, SP, #4
STR	LR, [SP, #0]
;motorDriveHW95.c,41 :: 		PWM_TIM3_Stop(_PWM_CHANNEL2);
MOVS	R0, #1
BL	_PWM_TIM3_Stop+0
;motorDriveHW95.c,42 :: 		}
L_end_setB_Disable:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _setB_Disable
_SetA_Front:
;motorDriveHW95.c,44 :: 		void SetA_Front(unsigned int _pwm){
; _pwm start address is: 0 (R0)
SUB	SP, SP, #4
STR	LR, [SP, #0]
; _pwm end address is: 0 (R0)
; _pwm start address is: 0 (R0)
;motorDriveHW95.c,45 :: 		A1 = 1;
MOVS	R2, #1
SXTB	R2, R2
MOVW	R1, #lo_addr(GPIOB_ODR+0)
MOVT	R1, #hi_addr(GPIOB_ODR+0)
_SX	[R1, ByteOffset(GPIOB_ODR+0)]
;motorDriveHW95.c,46 :: 		A2 = 0;
MOVS	R2, #0
SXTB	R2, R2
MOVW	R1, #lo_addr(GPIOA_ODR+0)
MOVT	R1, #hi_addr(GPIOA_ODR+0)
_SX	[R1, ByteOffset(GPIOA_ODR+0)]
;motorDriveHW95.c,47 :: 		PWM_TIM3_Set_Duty(CalcDuty(_pwm), _PWM_NON_INVERTED, _PWM_CHANNEL4);
; _pwm end address is: 0 (R0)
BL	_CalcDuty+0
MOVS	R2, #3
MOVS	R1, #0
BL	_PWM_TIM3_Set_Duty+0
;motorDriveHW95.c,48 :: 		}
L_end_SetA_Front:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _SetA_Front
_setA_Rear:
;motorDriveHW95.c,50 :: 		void setA_Rear(unsigned  int _pwm){
; _pwm start address is: 0 (R0)
SUB	SP, SP, #4
STR	LR, [SP, #0]
; _pwm end address is: 0 (R0)
; _pwm start address is: 0 (R0)
;motorDriveHW95.c,51 :: 		A1 = 0;
MOVS	R2, #0
SXTB	R2, R2
MOVW	R1, #lo_addr(GPIOB_ODR+0)
MOVT	R1, #hi_addr(GPIOB_ODR+0)
_SX	[R1, ByteOffset(GPIOB_ODR+0)]
;motorDriveHW95.c,52 :: 		A2 = 1;
MOVS	R2, #1
SXTB	R2, R2
MOVW	R1, #lo_addr(GPIOA_ODR+0)
MOVT	R1, #hi_addr(GPIOA_ODR+0)
_SX	[R1, ByteOffset(GPIOA_ODR+0)]
;motorDriveHW95.c,53 :: 		PWM_TIM3_Set_Duty(CalcDuty(_pwm), _PWM_NON_INVERTED, _PWM_CHANNEL4);
; _pwm end address is: 0 (R0)
BL	_CalcDuty+0
MOVS	R2, #3
MOVS	R1, #0
BL	_PWM_TIM3_Set_Duty+0
;motorDriveHW95.c,54 :: 		}
L_end_setA_Rear:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _setA_Rear
_SetB_Front:
;motorDriveHW95.c,56 :: 		void SetB_Front(unsigned  int _pwm){
; _pwm start address is: 0 (R0)
SUB	SP, SP, #4
STR	LR, [SP, #0]
; _pwm end address is: 0 (R0)
; _pwm start address is: 0 (R0)
;motorDriveHW95.c,57 :: 		B1 = 1;
MOVS	R2, #1
SXTB	R2, R2
MOVW	R1, #lo_addr(GPIOA_ODR+0)
MOVT	R1, #hi_addr(GPIOA_ODR+0)
_SX	[R1, ByteOffset(GPIOA_ODR+0)]
;motorDriveHW95.c,58 :: 		B2 = 0;
MOVS	R2, #0
SXTB	R2, R2
MOVW	R1, #lo_addr(GPIOA_ODR+0)
MOVT	R1, #hi_addr(GPIOA_ODR+0)
_SX	[R1, ByteOffset(GPIOA_ODR+0)]
;motorDriveHW95.c,59 :: 		PWM_TIM3_Set_Duty(CalcDuty(_pwm), _PWM_NON_INVERTED, _PWM_CHANNEL2);
; _pwm end address is: 0 (R0)
BL	_CalcDuty+0
MOVS	R2, #1
MOVS	R1, #0
BL	_PWM_TIM3_Set_Duty+0
;motorDriveHW95.c,60 :: 		}
L_end_SetB_Front:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _SetB_Front
_setB_Rear:
;motorDriveHW95.c,61 :: 		void setB_Rear(unsigned int _pwm){
; _pwm start address is: 0 (R0)
SUB	SP, SP, #4
STR	LR, [SP, #0]
; _pwm end address is: 0 (R0)
; _pwm start address is: 0 (R0)
;motorDriveHW95.c,62 :: 		B1 = 0;
MOVS	R2, #0
SXTB	R2, R2
MOVW	R1, #lo_addr(GPIOA_ODR+0)
MOVT	R1, #hi_addr(GPIOA_ODR+0)
_SX	[R1, ByteOffset(GPIOA_ODR+0)]
;motorDriveHW95.c,63 :: 		B2 = 1;
MOVS	R2, #1
SXTB	R2, R2
MOVW	R1, #lo_addr(GPIOA_ODR+0)
MOVT	R1, #hi_addr(GPIOA_ODR+0)
_SX	[R1, ByteOffset(GPIOA_ODR+0)]
;motorDriveHW95.c,64 :: 		PWM_TIM3_Set_Duty(CalcDuty(_pwm), _PWM_NON_INVERTED, _PWM_CHANNEL2);
; _pwm end address is: 0 (R0)
BL	_CalcDuty+0
MOVS	R2, #1
MOVS	R1, #0
BL	_PWM_TIM3_Set_Duty+0
;motorDriveHW95.c,65 :: 		}
L_end_setB_Rear:
LDR	LR, [SP, #0]
ADD	SP, SP, #4
BX	LR
; end of _setB_Rear
