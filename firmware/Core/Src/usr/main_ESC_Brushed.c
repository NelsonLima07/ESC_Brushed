/*
 * main_ESC_Brushed.c
 *
 *  Created on: Jun 2, 2022
 *      Author: Nelson Lima
 */


#include "main_ESC_Brushed.h"
#include "tim.h"
#include "usart.h"
#include "dshot.h"
#include "j3_ibus_flysky.h"

#include "stdbool.h"

/* Definicao dos canais */
#define CH_MOTOR_A 3   /* Define o canal de leitura para o Motor A */
#define CH_MOTOR_B 4   /* Define o canal de leitura para o Motor B */
#define CH_SERVO_A 1   /* Define o canal de leitura para o Servo S1 */
#define CH_SERVO_B 2   /* Define o canal de leitura para o Servo S2 */
#define CH_DSHOT_A 5   /* Define o canal de leitura para a saida DShot A */
#define CH_DSHOT_B 6   /* Define o canal de leitura para a saida DShot B */

/* Instancia do receptor iBUS gerenciada pela biblioteca J3 iBus FlySky.
 * Precisa ser estatica: a ISR da UART guarda o ponteiro para ela. */
static J3_IBus_Receptor g_rx;

/* Ultimo sentido aplicado em cada ponte: -1 = re, 0 = parado, +1 = frente.
 * Evita reescrever os pinos de direcao a cada quadro (glitch de PWM). */
static int8_t s_sentido[2] = {0, 0};

/* Aplica sentido + PWM na ordem segura:
 *   1) PWM = 0
 *   2) muda a direcao (somente quando ela realmente muda)
 *   3) aplica o novo PWM
 */
static void J3_PonteH_Aplicar(tcanalMotor _ch, int8_t sentido, uint16_t pwm)
{
  int8_t *atual = (_ch == A) ? &s_sentido[0] : &s_sentido[1];

  if (sentido != *atual)
  {
    J3_PonteH_SetVal(0, _ch);

    if (sentido > 0)
    {
      J3_PonteH_Frente(_ch);
    }
    else if (sentido < 0)
    {
      J3_PonteH_Reverse(_ch);
    }
    else
    {
      J3_PonteH_Para(_ch);
    }

    *atual = sentido;
  }

  J3_PonteH_SetVal(pwm, _ch);
}

/* Converte o pulso do radio (us) para a faixa de throttle do DShot.
 * Abaixo de DSHOT_ARM_MAX a saida fica em 0 (desarmado). */
static uint16_t J3_DShot_Map(uint16_t rx)
{
  if (rx <= DSHOT_ARM_MAX)
  {
    return 0;
  }

  return (uint16_t)(DSHOT_THR_MIN +
         ((uint32_t)(rx - DSHOT_ARM_MAX) * (DSHOT_THR_MAX - DSHOT_THR_MIN)) /
         (RX_VAL_MAX - DSHOT_ARM_MAX));
}

/* Aplica os canais recebidos nos servos, nas pontes H e nas saidas DShot. */
static void J3_ESC_AplicarCanais(void)
{
  J3_ESC_Servo(J3_IBus_LerCanal(&g_rx, CH_SERVO_A), S1);
  J3_ESC_Servo(J3_IBus_LerCanal(&g_rx, CH_SERVO_B), S2);
  J3_ESC_Motor(J3_IBus_LerCanal(&g_rx, CH_MOTOR_A), A);
  J3_ESC_Motor(J3_IBus_LerCanal(&g_rx, CH_MOTOR_B), B);

  J3_DShot_Set(J3_DShot_Map(J3_ESC_ValidVal(J3_IBus_LerCanal(&g_rx, CH_DSHOT_A))),
               J3_DShot_Map(J3_ESC_ValidVal(J3_IBus_LerCanal(&g_rx, CH_DSHOT_B))));
}

/* Para as pontes, centraliza os servos e desarma os ESCs. */
static void J3_ESC_FailSafe(void)
{
  /* Passa pelo J3_PonteH_Aplicar para manter o cache de sentido coerente. */
  J3_PonteH_Aplicar(A, 0, 0);
  J3_PonteH_Aplicar(B, 0, 0);
  J3_ESC_Servo(1500, S1);
  J3_ESC_Servo(1500, S2);
  J3_DShot_Parar();
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

  /* Saidas DShot300: TIM1_CH1/CH2 (PA8/PA9) + DMA1_Channel2/3. */
  J3_DShot_Init();

  /* Estado inicial seguro: servos centrados e motores parados. */
  J3_ESC_FailSafe();

  /* Habilita a saida da ponte (TB6612FNG). No L298N e no-op. */
  J3_PonteH_Habilita(true);

  cont_LED = HAL_GetTick();
  ultimo_frame = cont_LED;
  frames_ok = 0;

  while(1)
  {
    /* Conclui reinicios de DMA pendentes fora da ISR. */
    J3_IBus_Tarefa(&g_rx);

    /* Repete os frames DShot a 1 kHz. */
    J3_DShot_Tarefa();

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
  uint16_t auxVal = J3_ESC_ValidVal(_val);

  if(RX_REVERSE){
    if(auxVal < (1500 - REVERSE_OFFSET)) /* Reverse ativado */
    {
      auxVal = (uint16_t)((1500u - REVERSE_OFFSET - auxVal) * 20u / 9u); // 20/9 ~= (1000 / 450)
      J3_PonteH_Aplicar(_ch, -1, auxVal);
    }
    else if (auxVal > (1500 + REVERSE_OFFSET))
    {
      auxVal = (uint16_t)((auxVal - 1500u - REVERSE_OFFSET) * 20u / 9u); // 20/9 ~= (1000 / 450)
      J3_PonteH_Aplicar(_ch, +1, auxVal);
    }
    else
    {
      J3_PonteH_Aplicar(_ch, 0, 0);
    }
  }
  else // Nao tem reverse
  {
    auxVal = (uint16_t)(auxVal - 1000u);
    J3_PonteH_Aplicar(_ch, +1, auxVal);
  }
}


void J3_PonteH_SetVal(uint16_t _val, tcanalMotor _ch)
{
  /* _val vai de 0 a 1000 (0..100% de duty), independente da frequencia do TIM3. */
  uint32_t ccr = ((uint32_t)_val * (MOTOR_PWM_ARR + 1u)) / 1000u;

  switch(_ch)
  {
	case A:
	{
	  TIM3->CCR1 = ccr; // Usado para a ponte H A // Pin PA6
	  break;
	}

	case B:
	{
	  TIM3->CCR2 = ccr; // Usado para a ponte H B // Pin PA7
	  break;
	}
  }/* end switch */

}

void J3_PonteH_Para(tcanalMotor _ch)
{
  J3_PonteH_SetVal(0, _ch); /* zera o PWM antes de mudar a direcao */

  if (_ch == A)
  {
	HAL_GPIO_WritePin(PonteH_A1_GPIO_Port, PonteH_A1_Pin, GPIO_PIN_RESET);
	HAL_GPIO_WritePin(PonteH_A2_GPIO_Port, PonteH_A2_Pin, GPIO_PIN_RESET);
	s_sentido[0] = 0;
  }
  else if(_ch == B)
  {
	HAL_GPIO_WritePin(PonteH_B1_GPIO_Port, PonteH_B1_Pin, GPIO_PIN_RESET);
	HAL_GPIO_WritePin(PonteH_B2_GPIO_Port, PonteH_B2_Pin, GPIO_PIN_RESET);
	s_sentido[1] = 0;
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

/* Habilita/desabilita a saida da ponte (STBY da TB6612FNG).
 * No L298N nao existe STBY: a funcao e no-op. */
void J3_PonteH_Habilita(bool on)
{
#if PONTE_H_TB6612
  HAL_GPIO_WritePin(PonteH_STBY_GPIO_Port, PonteH_STBY_Pin,
                    on ? GPIO_PIN_SET : GPIO_PIN_RESET);
#else
  (void)on;
#endif
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
