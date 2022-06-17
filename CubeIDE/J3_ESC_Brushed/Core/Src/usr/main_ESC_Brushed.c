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




/* flags */
bool flag_UART1_iBus = false;
/* ----------------------- */

TRxIBus *RxIBus;

int main_ESC_Brushed(void)
{
  RxIBus = J3_IBUS_new(&huart1, 14);
  HAL_UART_Receive_DMA(&huart1, RxIBus->buffer, 64);


  TIM2->CCR1 = 0; // Usado para os servos
  TIM2->CCR2 = 0; // Usado para os servos
  TIM2->CCR3 = 0; // PWM da Ponte A
  TIM2->CCR4 = 0; // PWM da Ponte B

  HAL_GPIO_WritePin(PonteH_A1_GPIO_Port, PonteH_A1_Pin, GPIO_PIN_RESET);
  HAL_GPIO_WritePin(PonteH_A2_GPIO_Port, PonteH_A2_Pin, GPIO_PIN_RESET);
  HAL_GPIO_WritePin(PonteH_B1_GPIO_Port, PonteH_B1_Pin, GPIO_PIN_RESET);
  HAL_GPIO_WritePin(PonteH_B2_GPIO_Port, PonteH_B2_Pin, GPIO_PIN_RESET);

  //HAL_TIM_PWM_Start_IT(&htim2, TIM_CHANNEL_1);
  //HAL_TIM_PWM_Start_IT(&htim2, TIM_CHANNEL_2);
  //HAL_TIM_PWM_Start_IT(&htim2, TIM_CHANNEL_3);
  //HAL_TIM_PWM_Start_IT(&htim2, TIM_CHANNEL_4);
  HAL_TIM_PWM_Start(&htim2, TIM_CHANNEL_1);
  HAL_TIM_PWM_Start(&htim2, TIM_CHANNEL_2);
  HAL_TIM_PWM_Start(&htim2, TIM_CHANNEL_3);
  HAL_TIM_PWM_Start(&htim2, TIM_CHANNEL_4);

  while(1)
  {
	  /* Processar as entradas da UART1 receptor */
	  if(flag_UART1_iBus){
		J3_IBUS_ProcessBuffer(RxIBus);
	    HAL_UART_Receive_DMA(&huart1, RxIBus->buffer, 64);
	    flag_UART1_iBus = false;
	  }
	  /* --------------------------------------- */

	  HAL_Delay(10);
	  //HAL_GPIO_TogglePin(GPIOC, GPIO_PIN_13);
	  J3_ESC_Servo(J3_IBUS_GetCh(RxIBus, CH_SERVO_A), A);
	  J3_ESC_Servo(J3_IBUS_GetCh(RxIBus, CH_SERVO_B), B);
	  J3_ESC_Motor(J3_IBUS_GetCh(RxIBus, CH_MOTOR_A), A);
	  J3_ESC_Motor(J3_IBUS_GetCh(RxIBus, CH_MOTOR_B), B);

	  /*
	  HAL_UART_Transmit(&huart1, "CH1:", 4, 100);
	  sprintf(str, "%d", J3_IBUS_GetCh(RxIBus, 1));
	  HAL_UART_Transmit(&huart1, (char*)str, sprintf(str, "%d", J3_IBUS_GetCh(RxIBus, 1)), 100);
	  HAL_UART_Transmit(&huart1, "\r\n", 2, 100);

	  HAL_UART_Transmit(&huart1, "CH2:", 4, 100);
	  sprintf(str, "%d", J3_IBUS_GetCh(RxIBus, 2));
	  HAL_UART_Transmit(&huart1, (char*)str, sprintf(str, "%d", J3_IBUS_GetCh(RxIBus, 2)), 100);
	  HAL_UART_Transmit(&huart1, "\r\n", 2, 100);

	  HAL_UART_Transmit(&huart1, "CH3:", 4, 100);
	  sprintf(str, "%d", J3_IBUS_GetCh(RxIBus, 3));
	  HAL_UART_Transmit(&huart1, (char*)str, sprintf(str, "%d", J3_IBUS_GetCh(RxIBus, 3)), 100);
	  HAL_UART_Transmit(&huart1, "\r\n", 2, 100);

	  HAL_UART_Transmit(&huart1, "CH4:", 4, 100);
	  sprintf(str, "%d", J3_IBUS_GetCh(RxIBus, 4));
	  HAL_UART_Transmit(&huart1, (char*)str, sprintf(str, "%d", J3_IBUS_GetCh(RxIBus, 4)), 100);
	  HAL_UART_Transmit(&huart1, "\r\n", 2, 100);
	  HAL_UART_Transmit(&huart1, RxIBus->buffer, 64, 100);
	  HAL_UART_Transmit(&huart1, "\r\n", 2, 100);
      */


   // HAL_GPIO_TogglePin(PLACA_LED_GPIO_Port, PLACA_LED_Pin);

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


void J3_ESC_Servo(uint16_t _val, tcanal _ch)
{
  uint16_t auxVal = 0;

  auxVal = J3_ESC_ValidVal(_val);

  J3_Servo_SetVal(auxVal, _ch);
}

void J3_ESC_Motor(uint16_t _val, tcanal _ch)
{
  uint16_t auxVal = 0;

  auxVal = J3_ESC_ValidVal(_val);

  if(RX_REVERSE){
    if(auxVal < (1500 - REVERSE_OFFSET)) /* Reverse ativado */
    {
      auxVal = (1500 - REVERSE_OFFSET - auxVal) * 41; // 41 ~= (20000 / 480);
      J3_PonteH_SetVal(auxVal, _ch);
	  J3_PonteH_Reverse(_ch);
    }
    else if (auxVal > (1500 + REVERSE_OFFSET))
    {
      auxVal = (auxVal - 1500 + REVERSE_OFFSET) * 41; // (20000 / 480);
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
    auxVal = (auxVal - 1000) * 20;
    J3_PonteH_SetVal(auxVal, _ch);
    J3_PonteH_Frente(_ch);
  }
}


void J3_PonteH_SetVal(uint16_t _val, tcanal _ch)
{
  switch(_ch)
  {
	case A:
	{
	  TIM2->CCR1 = _val; // Usado para os ponteH1)
	  break;
	}

	case B:
	{
	  TIM2->CCR2 = _val; // Usado para os ponteH2)
	  break;
	}
  }/* end switch */

}

void J3_PonteH_Para(tcanal _ch)
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

void J3_PonteH_Frente(tcanal _ch)
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

void J3_PonteH_Reverse(tcanal _ch)
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

void J3_PonteH_Inverte(tcanal _ch)
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

void J3_Servo_SetVal(uint16_t _val, tcanal _ch)
{
  switch(_ch)
  {
    case A:
    {
	  TIM2->CCR3 = _val; // Usado para os servos  == A)
	  break;
    }

    case B:
    {
      TIM2->CCR4 = _val; // Usado para os servos  == A)
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
