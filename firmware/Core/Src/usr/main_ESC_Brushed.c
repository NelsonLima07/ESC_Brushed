/*
 * main_ESC_Brushed.c
 *
 *  Created on: Jun 2, 2022
 *      Author: Nelson Lima
 */


#include "main_ESC_Brushed.h"
#include "tim.h"
#include "usart.h"
#include "j3_ibus_flysky.h"

#include "stdbool.h"

/* Definicao dos canais */
#define CH_MOTOR_A 3   /* Define o canal de leitura para o Motor A */
#define CH_MOTOR_B 4   /* Define o canal de leitura para o Motor B */
#define CH_SERVO_A 1   /* Define o canal de leitura para o Servo S1 */
#define CH_SERVO_B 2   /* Define o canal de leitura para o Servo S2 */

/* Instancia do receptor iBUS gerenciada pela biblioteca J3 iBus FlySky.
 * Precisa ser estatica: a ISR da UART guarda o ponteiro para ela. */
static J3_IBus_Receptor g_rx;

/* Aplica os canais recebidos nos servos e nas pontes H. */
static void J3_ESC_AplicarCanais(void)
{
  J3_ESC_Servo(J3_IBus_LerCanal(&g_rx, CH_SERVO_A), S1);
  J3_ESC_Servo(J3_IBus_LerCanal(&g_rx, CH_SERVO_B), S2);
  J3_ESC_Motor(J3_IBus_LerCanal(&g_rx, CH_MOTOR_A), A);
  J3_ESC_Motor(J3_IBus_LerCanal(&g_rx, CH_MOTOR_B), B);
}

/* Para as pontes e centraliza os servos. */
static void J3_ESC_FailSafe(void)
{
  J3_PonteH_Para(A);
  J3_PonteH_Para(B);
  J3_ESC_Servo(1500, S1);
  J3_ESC_Servo(1500, S2);
}

void main_ESC_Brushed(void)
{
  uint32_t cont_LED;        /* Conta o tempo para piscar o LED */
  uint32_t ultimo_frame;    /* Momento do ultimo frame iBUS valido */
  uint32_t frames_ok;       /* Ultimo valor de frames validos lido */
  uint32_t agora;

  if (!J3_IBus_Iniciar(&g_rx, &huart1))
  {
    Error_Handler();
  }

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

  /* Estado inicial seguro: servos centrados e motores parados. */
  J3_ESC_FailSafe();

  cont_LED = HAL_GetTick();
  ultimo_frame = cont_LED;
  frames_ok = 0;

  while(1)
  {
    /* Conclui reinicios de DMA pendentes fora da ISR. */
    J3_IBus_Tarefa(&g_rx);

    /* Aplica os canais apenas quando um novo frame valido chega. */
    if (g_rx.frames_ok != frames_ok)
    {
      frames_ok = g_rx.frames_ok;
      ultimo_frame = HAL_GetTick();
      J3_ESC_AplicarCanais();
    }

    agora = HAL_GetTick();

    if ((agora - cont_LED) > 1000)
    {
      cont_LED = agora;
      HAL_GPIO_TogglePin(PLACA_LED_GPIO_Port, PLACA_LED_Pin);
    }

    if (FAIL_OVER_ATIVO && ((agora - ultimo_frame) >= (FAIL_OVER_TEMPO * 1000u)))
    {
      J3_ESC_FailSafe();
      /* Evita reaplicar o fail-safe a cada iteracao. */
      ultimo_frame = agora;
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
      auxVal = (1500 - REVERSE_OFFSET - auxVal) * 2.22; // 2.22 ~= (1000 / 450);
      J3_PonteH_SetVal(auxVal, _ch);
	  J3_PonteH_Reverse(_ch);
    }
    else if (auxVal > (1500 + REVERSE_OFFSET))
    {
      auxVal = (auxVal - 1500 - REVERSE_OFFSET) * 2.22; // 2.22 ~= (10000 / 450);
      J3_PonteH_SetVal(auxVal, _ch);
  	  J3_PonteH_Frente(_ch);
    }
    else
    {
      J3_PonteH_Para(_ch);
    }
  }
  else // Nao tem reverse
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
	  TIM3->CCR1 = _val; // Usado para a ponte H A // Pin PA6
	  break;
	}

	case B:
	{
	  TIM3->CCR2 = _val; // Usado para a ponte H B // Pin PA7
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
	  TIM2->CCR3 = _val; // Usado para o servo S1
	  break;
    }

    case S2:
    {
      TIM2->CCR4 = _val; // Usado para o servo S2
      break;
    }
  }/* end switch */
}


void HAL_UART_RxCpltCallback(UART_HandleTypeDef *huart)
{
  J3_IBus_TratarRxCompleto(&g_rx, huart);
}

void HAL_UART_ErrorCallback(UART_HandleTypeDef *huart)
{
  J3_IBus_TratarErroUart(&g_rx, huart);
}
