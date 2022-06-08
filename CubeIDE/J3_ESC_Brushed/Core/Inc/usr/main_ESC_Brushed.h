/*
 * main_ESC_Brushed.h
 *
 *  Created on: Jun 2, 2022
 *      Author: Nelson Lima
 */

#ifndef INC_USR_MAIN_ESC_BRUSHED_H_
#define INC_USR_MAIN_ESC_BRUSHED_H_

#include "main.h"

typedef enum {A, B} tcanal;

int main_ESC_Brushed(void);

void J3_PonteH_SetVal(uint16_t _val, tcanal _ch); /* Seta o valor de acordo com a resolucao */
void J3_PonteH_SetPot(uint8_t _val, tcanal _ch); /* Seta a potencia 0% a 100%  */
void J3_PonteH_Para(tcanal _ch); /* Desliga a ponte  */
void J3_PonteH_Frente(tcanal _ch); /* Sentido Frente   */
void J3_PonteH_Reverse(tcanal _ch); /* Sentido Re  */
void J3_PonteH_Inverte(tcanal _ch); /* Inverte o sentido  */

void J3_Servo_SetVal(uint16_t _val, tcanal _ch); /* Set PWM Servo */



#endif /* INC_USR_MAIN_ESC_BRUSHED_H_ */
