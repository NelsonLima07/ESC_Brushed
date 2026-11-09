/*
 * dshot.c
 *
 *  Saidas DShot300 unidirecionais para ESC_Brushed.
 *
 *  TIM1_CH1 (PA8) e TIM1_CH2 (PA9) geram os pulsos; DMA1_Channel2 e
 *  DMA1_Channel3 escrevem o proximo bit em CCR1/CCR2 a cada evento de
 *  comparacao. O CCR tem preload habilitado, entao o valor escrito no
 *  meio do bit atual so entra em vigor no update event (inicio do bit
 *  seguinte).
 *
 *  Frame: 11 bits de throttle + 1 de telemetria (0) + 4 de CRC.
 *  300 kbit/s (3,333 us/bit), repetido a 1 kHz, linha em nivel baixo
 *  entre os frames.
 */

#include "dshot.h"

#include <stdbool.h>

/* 16 bits do frame + 1 posicao de idle (linha em nivel baixo). */
#define DSHOT_BUF_LEN   (DSHOT_FRAME_BITS + 1u)

/* Memoria -> periferico, 16 bits, incrementa a origem, prioridade alta. */
#define DSHOT_DMA_CCR   (DMA_CCR_DIR | DMA_CCR_MINC | \
                         DMA_CCR_PSIZE_0 | DMA_CCR_MSIZE_0 | DMA_CCR_PL_1)

static uint16_t s_buf_a[DSHOT_BUF_LEN];
static uint16_t s_buf_b[DSHOT_BUF_LEN];

static uint16_t s_thr_a;
static uint16_t s_thr_b;
static uint32_t s_ultimo_tick;
static bool     s_pronto;

/* Monta o frame de 16 bits: throttle (11) + telemetria (1) + CRC (4). */
static uint16_t J3_DShot_Frame(uint16_t thr)
{
  uint16_t v   = (uint16_t)(thr << 1);   /* bit de telemetria = 0 */
  uint16_t crc = (uint16_t)((v ^ (v >> 4) ^ (v >> 8)) & 0x0Fu);

  return (uint16_t)((v << 4) | crc);
}

/* Duracao (em ticks) do bit de indice idx, comecando pelo MSB. */
static uint16_t J3_DShot_Bit(uint16_t frame, uint32_t idx)
{
  return ((frame >> (DSHOT_FRAME_BITS - 1u - idx)) & 0x01u) ? DSHOT_T1H : DSHOT_T0H;
}

/* Preenche o buffer com os 16 bits e o idle final em nivel baixo. */
static void J3_DShot_MontarBuffer(uint16_t *buf, uint16_t thr)
{
  uint16_t frame = J3_DShot_Frame(thr);
  uint32_t i;

  for (i = 0; i < DSHOT_FRAME_BITS; i++)
  {
    buf[i] = J3_DShot_Bit(frame, i);
  }

  buf[DSHOT_FRAME_BITS] = 0u;
}

/* Carrega o primeiro bit, arma o DMA e inicia os dois canais juntos. */
static void J3_DShot_Disparar(void)
{
  /* Para o timer e desabilita as saidas (linha em nivel baixo). */
  TIM1->CR1  &= ~TIM_CR1_CEN;
  TIM1->CCER &= ~(TIM_CCER_CC1E | TIM_CCER_CC2E);
  TIM1->CNT   = 0;

  /* Primeiro bit vai para o preload e o UG o transfere para o ativo. */
  TIM1->CCR1 = s_buf_a[0];
  TIM1->CCR2 = s_buf_b[0];
  TIM1->EGR  = TIM_EGR_UG;
  TIM1->SR   = 0;   /* limpa UIF/CCxIF antes de rearmar o DMA */

  /* DMA: do segundo bit ate o idle (DSHOT_FRAME_BITS posicoes). */
  DMA1_Channel2->CCR = 0;
  DMA1_Channel3->CCR = 0;
  DMA1->IFCR = DMA_IFCR_CGIF2 | DMA_IFCR_CGIF3;

  DMA1_Channel2->CMAR  = (uint32_t)&s_buf_a[1];
  DMA1_Channel3->CMAR  = (uint32_t)&s_buf_b[1];
  DMA1_Channel2->CNDTR = DSHOT_FRAME_BITS;
  DMA1_Channel3->CNDTR = DSHOT_FRAME_BITS;
  DMA1_Channel2->CCR   = DSHOT_DMA_CCR | DMA_CCR_EN;
  DMA1_Channel3->CCR   = DSHOT_DMA_CCR | DMA_CCR_EN;

  /* Comeca a contar e so entao habilita as saidas: evita um primeiro
   * pulso mais longo por causa do estado combinacional do comparador. */
  TIM1->CR1  |= TIM_CR1_CEN;
  TIM1->CCER |= TIM_CCER_CC1E | TIM_CCER_CC2E;
}

void J3_DShot_Init(void)
{
  GPIO_InitTypeDef gpio = {0};

  __HAL_RCC_GPIOA_CLK_ENABLE();
  __HAL_RCC_TIM1_CLK_ENABLE();
  __HAL_RCC_DMA1_CLK_ENABLE();

  /* PA8 = TIM1_CH1, PA9 = TIM1_CH2 (mapeamento padrao, sem remap). */
  gpio.Pin   = GPIO_PIN_8 | GPIO_PIN_9;
  gpio.Mode  = GPIO_MODE_AF_PP;
  gpio.Speed = GPIO_SPEED_FREQ_HIGH;
  HAL_GPIO_Init(GPIOA, &gpio);

  /* TIM1: 300 kbit/s, PWM mode 1, CCR com preload.
   *
   * O preload e obrigatorio: o DMA escreve o proximo bit no evento de
   * comparacao (fim do pulso do bit atual) e o valor so entra em vigor
   * no update event (inicio do bit seguinte). Sem preload o pulso do
   * bit atual seria alterado no meio. */
  TIM1->CR1   = 0;
  TIM1->PSC   = 0;
  TIM1->ARR   = DSHOT_BIT_TICKS - 1u;
  TIM1->RCR   = 0;
  TIM1->CCR1  = 0;
  TIM1->CCR2  = 0;
  TIM1->CCMR1 = TIM_CCMR1_OC1M_2 | TIM_CCMR1_OC1M_1 | TIM_CCMR1_OC1PE
              | TIM_CCMR1_OC2M_2 | TIM_CCMR1_OC2M_1 | TIM_CCMR1_OC2PE;
  TIM1->CCER  = TIM_CCER_CC1E | TIM_CCER_CC2E;
  TIM1->BDTR  = TIM_BDTR_MOE;
  TIM1->DIER  = TIM_DIER_CC1DE | TIM_DIER_CC2DE;

  TIM1->EGR = TIM_EGR_UG;   /* carrega PSC/ARR e zera o contador */
  TIM1->SR  = 0;

  /* DMA1_Channel2 -> TIM1->CCR1, DMA1_Channel3 -> TIM1->CCR2. */
  DMA1_Channel2->CCR = 0;
  DMA1_Channel3->CCR = 0;
  DMA1->IFCR = DMA_IFCR_CGIF2 | DMA_IFCR_CGIF3;

  DMA1_Channel2->CPAR = (uint32_t)&TIM1->CCR1;
  DMA1_Channel3->CPAR = (uint32_t)&TIM1->CCR2;

  s_thr_a = 0u;
  s_thr_b = 0u;
  J3_DShot_MontarBuffer(s_buf_a, 0u);
  J3_DShot_MontarBuffer(s_buf_b, 0u);

  s_ultimo_tick = HAL_GetTick() - 1u;
  s_pronto = true;
}

void J3_DShot_Set(uint16_t thr_a, uint16_t thr_b)
{
  s_thr_a = (thr_a > DSHOT_THR_MAX) ? DSHOT_THR_MAX : thr_a;
  s_thr_b = (thr_b > DSHOT_THR_MAX) ? DSHOT_THR_MAX : thr_b;
}

void J3_DShot_Tarefa(void)
{
  uint32_t agora;

  if (!s_pronto)
  {
    return;
  }

  agora = HAL_GetTick();

  if ((uint32_t)(agora - s_ultimo_tick) < DSHOT_PERIOD_MS)
  {
    return;   /* ainda nao completou o periodo de 1 ms (1 kHz) */
  }

  s_ultimo_tick = agora;

  /* Frame anterior ainda em andamento? Nao sobrepoe. */
  if ((DMA1_Channel2->CNDTR != 0u) || (DMA1_Channel3->CNDTR != 0u))
  {
    return;
  }

  J3_DShot_MontarBuffer(s_buf_a, s_thr_a);
  J3_DShot_MontarBuffer(s_buf_b, s_thr_b);
  J3_DShot_Disparar();
}

void J3_DShot_Parar(void)
{
  s_thr_a = 0u;
  s_thr_b = 0u;
}
