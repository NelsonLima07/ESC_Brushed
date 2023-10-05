/*
 * main_ESC_Brushed.h
 *
 *  Created on: Jun 2, 2022
 *      Author: Nelson Lima
 */

#ifndef INC_USR_MAIN_ESC_BRUSHED_H_
#define INC_USR_MAIN_ESC_BRUSHED_H_

#include "main.h"
#include "stdbool.h"

typedef enum {A, B} tcanalMotor;
typedef enum {S1, S2} tcanalServo;

/* chA pins -> PonteH_A1, PonteH_A2 */
/* chB pins -> PonteH_B1, PonteH_B2 */

#define RX_VAL_MAX 2000   /* Armazena o maior sinal que vem do RX */
#define RX_VAL_MIN 1000   /* Armazena o menor sinal que vem do RX */
#define RX_REVERSE true   /* Se vai considerar o motor com os 2 sentidos de rotacao */
#define REVERSE_OFFSET 50 /* Offset de valores q sera considerador neutro se tiver RX_REVERSE = TRUE */


/* Config FailOver */
/* Se passar um determinado tempo sem receber dados de Rx Desabilita tudo   */
#define FAIL_OVER_ATIVO true
#define FAIL_OVER_TEMPO 5  /* Tempo em segundos */


int main_ESC_Brushed(void);

uint16_t J3_ESC_ValidVal(uint16_t _val); /* Ajusta o valor do sinal */

void J3_ESC_Servo(uint16_t _val, tcanalServo _ch); /*  */
void J3_ESC_Motor(uint16_t _val, tcanalMotor _ch); /*  */

void J3_PonteH_SetVal(uint16_t _val, tcanalMotor _ch); /* Seta o valor de acordo com a resolucao */
void J3_PonteH_Para(tcanalMotor _ch); /* Desliga a ponte  */
void J3_PonteH_Frente(tcanalMotor _ch); /* Sentido Frente   */
void J3_PonteH_Reverse(tcanalMotor _ch); /* Sentido Re  */
void J3_PonteH_Inverte(tcanalMotor _ch); /* Inverte o sentido  */

void J3_Servo_SetVal(uint16_t _val, tcanalServo _ch); /* Set PWM Servo */



#endif /* INC_USR_MAIN_ESC_BRUSHED_H_ */
