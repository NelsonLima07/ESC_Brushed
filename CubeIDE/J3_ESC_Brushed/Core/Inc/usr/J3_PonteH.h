/*
 * J3_PonteH.h
 *
 *  Created on: Apr 02, 2022
 *      Author: Nelson Lima
 */

#ifndef INC_J3_PonteH_H_
#define INC_J3_PonteH_H_

#define RESOLUCAO_PWM 0xFFFF // Cada "F" 4 bits; Em Hex pra facilitar

struct TPonteH
{
  GPIO_TypeDef *GPIOx;
  uint16_t pinAEnable;
  uint16_t pinA1;
  uint16_t pinA2;
};

typedef struct TPonteH TPonteH;

TPonteH* J3_PonteH_new(GPIO_TypeDef *_GPIOx, uint16_t _enable, _a1, _a2);

void J3_PonteH_SetVal(TPonteH* _ponteH, uint16_t _val); /* Seta o valor de acordo com a resolucao */
void J3_PonteH_SetPot(TPonteH* _ponteH, uint8_t _val); /* Seta a potencia 0% a 100%  */
void J3_PonteH_Para(TPonteH* _ponteH); /* Desliga a ponte  */
void J3_PonteH_Frente(TPonteH* _ponteH); /* Sentido Frente   */
void J3_PonteH_Reverse(TPonteH* _ponteH); /* Sentido Re  */
void J3_PonteH_Inverte(TPonteH* _ponteH); /* Inverte o sentido  */

#endif /* INC_J3_PonteH_H_ */
