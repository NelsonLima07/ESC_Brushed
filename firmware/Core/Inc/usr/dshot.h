/*
 * dshot.h
 *
 *  Saidas DShot300 unidirecionais para ESC_Brushed.
 *
 *  Duas saidas independentes em TIM1_CH1 (PA8) e TIM1_CH2 (PA9), cada uma
 *  com seu proprio canal de DMA (DMA1_Channel2 / DMA1_Channel3).
 *
 *  O TIM1 e configurado manualmente aqui (fora do CubeMX) para sobreviver
 *  a regeneracao do codigo pelo .ioc.
 */

#ifndef INC_USR_DSHOT_H_
#define INC_USR_DSHOT_H_

#include "main.h"

/* --------------------------------------------------------------------------
 * Configuracao do protocolo
 * ------------------------------------------------------------------------ */

/* Faixa de throttle do DShot: 1..47 sao reservados para comandos. */
#define DSHOT_THR_MIN       48u
#define DSHOT_THR_MAX       2047u

/* Abaixo deste valor (em us) a saida vai para 0 (desarmado). */
#define DSHOT_ARM_MAX       1050u

/* Repeticao dos frames. */
#define DSHOT_RATE_HZ       1000u

/* Periodo entre frames (ms), derivado de DSHOT_RATE_HZ. */
#define DSHOT_PERIOD_MS     (1000u / DSHOT_RATE_HZ)

/* 72 MHz / 300 kHz = 240 ticks por bit (PSC = 0, ARR = 239). */
#define DSHOT_BIT_TICKS     240u
#define DSHOT_T0H           90u    /* 37,5% do bit -> 1,25 us */
#define DSHOT_T1H           180u   /* 75% do bit   -> 2,50 us */

/* 11 bits de throttle + 1 de telemetria + 4 de CRC. */
#define DSHOT_FRAME_BITS    16u

/* --------------------------------------------------------------------------
 * API
 * ------------------------------------------------------------------------ */

/* Configura GPIO, TIM1 e os dois canais de DMA. */
void J3_DShot_Init(void);

/* Atualiza os alvos de throttle (0..2047) das saidas A e B. */
void J3_DShot_Set(uint16_t thr_a, uint16_t thr_b);

/* Envia um frame por milissegundo, se o DMA estiver livre. */
void J3_DShot_Tarefa(void);

/* Zera os alvos (desarmado) - usado no boot e no fail-safe. */
void J3_DShot_Parar(void);

#endif /* INC_USR_DSHOT_H_ */
