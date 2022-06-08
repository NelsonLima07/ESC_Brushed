/*
 * main_ESC_Brushed.c
 *
 *  Created on: Jun 2, 2022
 *      Author: Nelson Lima
 */


#include "usr\main_ESC_Brushed.h"
#include "tim.h"
#include "usr\J3_IBUS_FLYSKY.h"


TRxIBus *RxIBus;

int main_ESC_Brushed(void)
{
  int16_t pwm = 0;
  char str[6];

  RxIBus = J3_IBUS_new(&huart1, 14);
  HAL_UART_Receive_DMA(&huart1, RxIBus->buffer, 64);


  TIM2->CCR1 = 0; // Usado para os servos
  TIM2->CCR2 = 0; // Usado para os servos
  TIM2->CCR3 = 0; // PWM da Ponte A
  TIM2->CCR4 = 0; // PWM da Ponte B

  HAL_TIM_PWM_Start_IT(&htim2, TIM_CHANNEL_1);
  HAL_TIM_PWM_Start_IT(&htim2, TIM_CHANNEL_2);
  HAL_TIM_PWM_Start_IT(&htim2, TIM_CHANNEL_3);
  HAL_TIM_PWM_Start_IT(&htim2, TIM_CHANNEL_4);

  //HAL_TIM_PWM_Start(&htim2, TIM_CHANNEL_1);
  //HAL_TIM_PWM_Start(&htim2, TIM_CHANNEL_2);
  //HAL_TIM_PWM_Start(&htim2, TIM_CHANNEL_3);
  //HAL_TIM_PWM_Start(&htim2, TIM_CHANNEL_4);

  //  TIM2->CCR2 = 1000;
//  HAL_Delay(1500);
//  TIM2->CCR2 = 1500;
//  HAL_Delay(1500);
  while(1)
  {
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

	  HAL_Delay(10);
	  //HAL_GPIO_TogglePin(GPIOC, GPIO_PIN_13);

	  J3_PonteH_SetVal(J3_IBUS_GetCh(RxIBus, 3), A);
	  J3_PonteH_SetVal(J3_IBUS_GetCh(RxIBus, 4), B);
	  J3_Servo_SetVal(J3_IBUS_GetCh(RxIBus, 1), A);
	  J3_Servo_SetVal(J3_IBUS_GetCh(RxIBus, 2), B);

	  //TIM2->CCR4 = J3_IBUS_GetCh(RxIBus, 3);
	  /*
	  while(pwm < 20000)
    {
      TIM2->CCR4 = pwm;
      pwm += 10;
      HAL_Delay(1);
    }
    while(pwm > 0)
    {
      TIM2->CCR4 = pwm;
      pwm -= 10;
      HAL_Delay(1);
    }
    */
   // HAL_GPIO_TogglePin(PLACA_LED_GPIO_Port, PLACA_LED_Pin);

  }/* end while loop */

}/* end main */


void J3_PonteH_SetVal(uint16_t _val, tcanal _ch)
{
  if (_val > 2000)
  {	_val = 2000; }
  else if (_val < 1000)
  {	 _val = 1000; }

  _val = (_val - 1000) * 20; /* Converte o valor q vem do Rx */

  switch(_ch)
  {
	case A:
	{
	  TIM2->CCR1 = _val; // Usado para os servos  == A)
	  break;
	}

	case B:
	{
	  TIM2->CCR2 = _val; // Usado para os servos  == A)
	  break;
	}
  }/* end switch */

}

void J3_PonteH_SetPot(uint8_t _val, tcanal _ch)
{

}

void J3_PonteH_Para(tcanal _ch)
{
}

void J3_PonteH_Frente(tcanal _ch)
{

}

void J3_PonteH_Reverse(tcanal _ch)
{

}

void J3_PonteH_Inverte(tcanal _ch)
{

}

void J3_Servo_SetVal(uint16_t _val, tcanal _ch)
{
  if (_val > 2000)
    _val = 2000;

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
  if(huart->Instance == USART1)
 {
	J3_IBUS_ProcessBuffer(RxIBus);
    HAL_UART_Receive_DMA(&huart1, RxIBus->buffer, 64);
  }
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
