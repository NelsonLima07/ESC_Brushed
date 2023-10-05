/*
 * main_ESC_Brushed.c
 *
 *  Created on: Jun 2, 2022
 *      Author: Nelson Lima
 */


#include "usr\main_ESC_Brushed.h"
#include "tim.h"
#include "usr\J3_IBUS_FLYSKY.h"

#include "stdbool.h"

/* Definicao dos canais */
#define CH_MOTOR_A 3   /* Define o canal de leitura para o Motor A */
#define CH_MOTOR_B 3   /* Define o canal de leitura para o Motor B */
#define CH_SERVO_A 1   /* Define o canal de leitura para o Servo A */
#define CH_SERVO_B 2   /* Define o canal de leitura para o Servo B */

  /* flags */
  bool flag_UART1_iBus = false; // Flag que sinaliza a atualização dos dados
  /* ----------------------- */
  uint16_t failOver_cont = 0;

int main_ESC_Brushed(void)
{
  /* */
  uint32_t cont_LED; // Contar a o tempo para piscar o LED;

  TRxIBus *RxIBus;

  RxIBus = J3_IBUS_new(&huart1, 14);
  HAL_UART_Receive_DMA(&huart1, RxIBus->buffer, 64);


  /* Timer2 -> Servos          */
  /* Timer2 20ms ou seja 50Hz  */

  /* Timer3 -> PWM Ponte H */

  TIM2->CCR1 = 0; // Usado para os servos
  TIM2->CCR2 = 0; // Usado para os servos
  TIM2->CCR3 = 0; // Usado para os servos S1
  TIM2->CCR4 = 0; // Usado para os servos S2

  TIM3->CCR1 = 0; // PWM da Ponte A
  TIM3->CCR2 = 0; // PWM da Ponte B


  HAL_GPIO_WritePin(PonteH_A1_GPIO_Port, PonteH_A1_Pin, GPIO_PIN_RESET);
  HAL_GPIO_WritePin(PonteH_A2_GPIO_Port, PonteH_A2_Pin, GPIO_PIN_RESET);
  HAL_GPIO_WritePin(PonteH_B1_GPIO_Port, PonteH_B1_Pin, GPIO_PIN_RESET);
  HAL_GPIO_WritePin(PonteH_B2_GPIO_Port, PonteH_B2_Pin, GPIO_PIN_RESET);

  HAL_TIM_PWM_Start(&htim2, TIM_CHANNEL_1);
  HAL_TIM_PWM_Start(&htim2, TIM_CHANNEL_2);
  HAL_TIM_PWM_Start(&htim2, TIM_CHANNEL_3);
  HAL_TIM_PWM_Start(&htim2, TIM_CHANNEL_4);

  HAL_TIM_PWM_Start(&htim3, TIM_CHANNEL_1);
  HAL_TIM_PWM_Start(&htim3, TIM_CHANNEL_2);

  cont_LED = HAL_GetTick();
  while(1)
  {
	  /* Processar as entradas da UART1 receptor */
	  if(flag_UART1_iBus){
		J3_IBUS_ProcessBuffer(RxIBus);
	    HAL_UART_Receive_DMA(&huart1, RxIBus->buffer, 64);

	    flag_UART1_iBus = false;
	    failOver_cont = 0;

		J3_ESC_Servo(J3_IBUS_GetCh(RxIBus, CH_SERVO_A), A);
		J3_ESC_Servo(J3_IBUS_GetCh(RxIBus, CH_SERVO_B), B);
		J3_ESC_Motor(J3_IBUS_GetCh(RxIBus, CH_MOTOR_A), A);
		J3_ESC_Motor(J3_IBUS_GetCh(RxIBus, CH_MOTOR_B), B);
	  }
	  /* --------------------------------------- */


	  if((HAL_GetTick() - cont_LED) > 1000)
	  {
		  cont_LED = HAL_GetTick();
		  HAL_GPIO_TogglePin(PLACA_LED_GPIO_Port, PLACA_LED_Pin);
		  failOver_cont++;
	  }

	  if(FAIL_OVER_ATIVO && (failOver_cont >= FAIL_OVER_TEMPO))
	  {
		  J3_PonteH_Para(A);
		  J3_PonteH_Para(B);
		  J3_ESC_Servo(1500, S1);
		  J3_ESC_Servo(1500, S2);
	  }




  }/* end while loop */

}/* end main */


uint16_t J3_ESC_ValidVal(uint16_t _val)
{
  if (_val > RX_VAL_MAX)
    {  _val = RX_VAL_MAX; }
  else if (_val < RX_VAL_MIN)
	{  _val = RX_VAL_MIN; }

  return _val;
}


void J3_ESC_Servo(uint16_t _val, tcanalServo _ch)
{
  uint16_t auxVal = 0;

  auxVal = J3_ESC_ValidVal(_val);

  J3_Servo_SetVal(auxVal, _ch);
}

void J3_ESC_Motor(uint16_t _val, tcanalMotor _ch)
{
  uint16_t auxVal = 0;

  auxVal = J3_ESC_ValidVal(_val);

  if(RX_REVERSE){
    if(auxVal < (1500 - REVERSE_OFFSET)) /* Reverse ativado */
    {
      //auxVal = (1500 - REVERSE_OFFSET - auxVal) * 41; // 41 ~= (20000 / 480);
      auxVal = (1500 - REVERSE_OFFSET - auxVal) * 2.22; // 2.22 ~= (1000 / 450);
      J3_PonteH_SetVal(auxVal, _ch);
	  J3_PonteH_Reverse(_ch);
    }
    else if (auxVal > (1500 + REVERSE_OFFSET))
    {
      //auxVal = (auxVal - 1500 + REVERSE_OFFSET) * 41; // (20000 / 480);
      auxVal = (auxVal - 1500 - REVERSE_OFFSET) * 2.22; //2.22 ~= (10000 / 450);
      J3_PonteH_SetVal(auxVal, _ch);
  	  J3_PonteH_Frente(_ch);
    }
    else
    {
      J3_PonteH_Para(_ch);
    }
  }
  else // Não tem reverse(ré)
  {
    auxVal = (auxVal - 1000);
    J3_PonteH_SetVal(auxVal, _ch);
    J3_PonteH_Frente(_ch);
  }
}


void J3_PonteH_SetVal(uint16_t _val, tcanalMotor _ch)
{
  switch(_ch)
  {
	case A:
	{
	  //TIM2->CCR1 = _val; // Usado para os ponteH1)
	  TIM3->CCR1 = _val; // Usado para os ponteH1) // Pin PA6
	  break;
	}

	case B:
	{
	  //TIM2->CCR2 = _val; // Usado para os ponteH2)
	  TIM3->CCR2 = _val; // Usado para os ponteH2) // Pin PA7
	  break;
	}
  }/* end switch */

}

void J3_PonteH_Para(tcanalMotor _ch)
{
  if (_ch == A)
  {
	HAL_GPIO_WritePin(PonteH_A1_GPIO_Port, PonteH_A1_Pin, GPIO_PIN_RESET);
	HAL_GPIO_WritePin(PonteH_A2_GPIO_Port, PonteH_A2_Pin, GPIO_PIN_RESET);
  }
  else if(_ch == B)
  {
	HAL_GPIO_WritePin(PonteH_B1_GPIO_Port, PonteH_B1_Pin, GPIO_PIN_RESET);
	HAL_GPIO_WritePin(PonteH_B2_GPIO_Port, PonteH_B2_Pin, GPIO_PIN_RESET);
  }
}

void J3_PonteH_Frente(tcanalMotor _ch)
{
  if (_ch == A)
  {
	HAL_GPIO_WritePin(PonteH_A1_GPIO_Port, PonteH_A1_Pin, GPIO_PIN_SET);
	HAL_GPIO_WritePin(PonteH_A2_GPIO_Port, PonteH_A2_Pin, GPIO_PIN_RESET);
  }
  else if(_ch == B)
  {
	HAL_GPIO_WritePin(PonteH_B1_GPIO_Port, PonteH_B1_Pin, GPIO_PIN_SET);
	HAL_GPIO_WritePin(PonteH_B2_GPIO_Port, PonteH_B2_Pin, GPIO_PIN_RESET);
  }
}

/* Sentido Re  */
void J3_PonteH_Reverse(tcanalMotor _ch)
{
  if (_ch == A)
  {
	HAL_GPIO_WritePin(PonteH_A1_GPIO_Port, PonteH_A1_Pin, GPIO_PIN_RESET);
	HAL_GPIO_WritePin(PonteH_A2_GPIO_Port, PonteH_A2_Pin, GPIO_PIN_SET);
  }
  else if(_ch == B)
  {
	HAL_GPIO_WritePin(PonteH_B1_GPIO_Port, PonteH_B1_Pin, GPIO_PIN_RESET);
	HAL_GPIO_WritePin(PonteH_B2_GPIO_Port, PonteH_B2_Pin, GPIO_PIN_SET);
  }
}

/* Inverte o sentido  */
void J3_PonteH_Inverte(tcanalMotor _ch)
{
  if (_ch == A)
  {
	HAL_GPIO_TogglePin(PonteH_A1_GPIO_Port, PonteH_A1_Pin);
	HAL_GPIO_TogglePin(PonteH_A2_GPIO_Port, PonteH_A2_Pin);
  }
  else if(_ch == B)
  {
	HAL_GPIO_TogglePin(PonteH_B1_GPIO_Port, PonteH_B1_Pin);
	HAL_GPIO_TogglePin(PonteH_B2_GPIO_Port, PonteH_B2_Pin);
  }
}

void J3_Servo_SetVal(uint16_t _val, tcanalServo _ch)
{
  switch(_ch)
  {
    case S1:
    {
	  TIM2->CCR3 = _val; // Usado para os servos  == S1)
	  break;
    }

    case S2:
    {
      TIM2->CCR4 = _val; // Usado para os servos  == S2)
      break;
    }
  }/* end switch */
}


void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
  flag_UART1_iBus = (huart->Instance == USART1);
}

void HAL_TIM_PWM_PulseFinishedCallback(TIM_HandleTypeDef *htim)
{
	 //HAL_GPIO_TogglePin(PLACA_LED_GPIO_Port, PLACA_LED_Pin);
	 //TIM2->CCR4=0;
  //if(htim->Instance == TIM2)
}

//void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim)
//{

	//TIM2->CCR4=20000;

//}
