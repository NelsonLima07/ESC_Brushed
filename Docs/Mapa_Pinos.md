# 📍 Mapa de pinos — ESC_Brushed

Mapa completo da pinagem do **STM32F103C8T6 (Blue Pill)** usada pelo firmware
`J3_ESC_Brushed`, incluindo as duas saídas **DShot300** (PA8/PA9).

- **MCU:** STM32F103C8T6 · Cortex-M3 · 64 KB flash · 20 KB RAM
- **Clock:** HSE 8 MHz × 9 = **72 MHz** (TIM2/TIM3/TIM4 também a 72 MHz, APB1 ×2)
- **Lógica:** 3,3 V (os pinos usados são 5 V-tolerantes quando indicado)
- **Referência de pinagem:** [`stm32f103c8t6_pinout_voltage01.png`](stm32f103c8t6_pinout_voltage01.png)

> **DShot300:** implementado em `firmware/Core/Src/usr/dshot.c` (TIM1 + DMA1_Ch2/Ch3),
> com API em `firmware/Core/Inc/usr/dshot.h`.

---

## 1. Mapa principal

| Pino | Função | Periférico / configuração | Observações |
|---|---|---|---|
| **PB7** | iBUS RX | `USART1_RX` remapeado · 115200 8N1 | DMA1_Channel5 · receptor FlySky |
| **PB6** | iBUS TX | `USART1_TX` remapeado | Não utilizado (só RX) |
| **PA2** | Servo S1 | `TIM2_CH3` · 50 Hz | Pulso 1000–2000 µs |
| **PA3** | Servo S2 | `TIM2_CH4` · 50 Hz | Pulso 1000–2000 µs |
| **PA6** | PWM Motor A | `TIM3_CH1` | 20 kHz (TB6612) / 1 kHz (L298N) |
| **PA7** | PWM Motor B | `TIM3_CH2` | 20 kHz (TB6612) / 1 kHz (L298N) |
| **PC14** | Ponte A — A1 | GPIO push-pull | `AIN1` (TB6612) / `IN1` (L298N) |
| **PC15** | Ponte A — A2 | GPIO push-pull | `AIN2` (TB6612) / `IN2` (L298N) |
| **PA4** | Ponte B — B1 | GPIO push-pull | `BIN1` (TB6612) / `IN3` (L298N) |
| **PA5** | Ponte B — B2 | GPIO push-pull | `BIN2` (TB6612) / `IN4` (L298N) |
| **PB0** | Ponte STBY | GPIO push-pull | `STBY` da TB6612FNG · `HIGH` habilita · não usado no L298N |
| **PA8** | **DShot A** | `TIM1_CH1` · DMA1_Channel2 | 300 kbit/s · 1 kHz · 3,3 V |
| **PA9** | **DShot B** | `TIM1_CH2` · DMA1_Channel3 | 300 kbit/s · 1 kHz · 3,3 V |
| **PC13** | LED de status | GPIO | Pisca a cada 1 s |
| **PA13** | SWDIO | `SYS_JTMS-SWDIO` | Debug (não usar como GPIO) |
| **PA14** | SWCLK | `SYS_JTCK-SWCLK` | Debug (não usar como GPIO) |
| **PD0** | OSC_IN | HSE 8 MHz | Cristal — não usar |
| **PD1** | OSC_OUT | HSE 8 MHz | Cristal — não usar |
| **PA0** | *(reservado)* | `TIM2_CH1` no `.ioc` | Sem uso no firmware · futuro servo S3 |
| **PA1** | *(reservado)* | `TIM2_CH2` no `.ioc` | Sem uso no firmware · futuro servo S4 |

> `PC14`/`PC15` são `OSC32_IN`/`OSC32_OUT` no Blue Pill; aqui são usados como GPIO,
> portanto o **LSE (32,768 kHz) não está disponível**.

---

## 2. Vista dos conectores (Blue Pill, USB para cima)

| Lado esquerdo (topo → base) | Uso | Lado direito (topo → base) | Uso |
|---|---|---|---|
| VBAT | — (não usar) | 3V3 | Alimentação 3,3 V |
| PC13 | LED | GND | GND |
| PC14 | Ponte A · A1 | 5V | Alimentação 5 V |
| PC15 | Ponte A · A2 | PB9 | Livre |
| PA0 | TIM2_CH1 (reservado) | PB8 | Livre |
| PA1 | TIM2_CH2 (reservado) | PB7 | **iBUS RX** |
| PA2 | Servo S1 | PB6 | iBUS TX (não usado) |
| PA3 | Servo S2 | PB5 | Livre |
| PA4 | Ponte B · B1 | PB4 | Livre (NJTRST) |
| PA5 | Ponte B · B2 | PB3 | Livre (JTDO) |
| PA6 | PWM Motor A | PA15 | Livre (JTDI) |
| PA7 | PWM Motor B | PA12 | Livre (USB DP) |
| PB0 | STBY TB6612 | PA11 | Livre (USB DM) |
| PB1 | Livre | PA10 | Livre |
| PB10 | Livre | PA9 | **DShot B** |
| PB11 | Livre | PA8 | **DShot A** |

---

## 3. Canais de rádio (iBUS)

| Canal | Macro | Destino |
|---|---|---|
| CH1 | `CH_SERVO_A` | Servo S1 (PA2) |
| CH2 | `CH_SERVO_B` | Servo S2 (PA3) |
| CH3 | `CH_MOTOR_A` | Ponte H A (PA6 + PC14/PC15) |
| CH4 | `CH_MOTOR_B` | Ponte H B (PA7 + PA4/PA5) |
| CH5 | `CH_DSHOT_A` | Saída DShot A (PA8) |
| CH6 | `CH_DSHOT_B` | Saída DShot B (PA9) |

Os canais DShot são macros em `firmware/Core/Src/usr/main_ESC_Brushed.c` e podem ser
remapeados sem tocar no hardware:

```c
#define CH_DSHOT_A 5
#define CH_DSHOT_B 6
```

---

## 4. DShot300

### 4.1 Pinos e periféricos

| Sinal | Pino | Timer | DMA | Nível |
|---|---|---|---|---|
| DShot A | **PA8** | `TIM1_CH1` | **DMA1_Channel2** | 3,3 V |
| DShot B | **PA9** | `TIM1_CH2` | **DMA1_Channel3** | 3,3 V |

- `PA9` é o `USART1_TX` padrão, mas o UART está **remapeado para PB6/PB7** — sem conflito.
- `PA8`/`PA9` são **5 V-tolerantes (FT)**, mas os ESCs usam lógica de 3,3 V.
- O **TIM1 é inicializado manualmente em `dshot.c`** (não pelo CubeMX) para sobreviver à
  regeneração do código.

### 4.2 Temporização

| Parâmetro | Valor |
|---|---|
| Clock do TIM1 | 72 MHz (APB2) |
| Prescaler | `PSC = 0` |
| Período | `ARR = 239` → 240 ticks/bit |
| Bit rate | **300 kbit/s** (3,333 µs/bit) |
| Bit 0 (`T0H`) | `CCR = 90` → 1,25 µs (37,5%) |
| Bit 1 (`T1H`) | `CCR = 180` → 2,5 µs (75%) |
| Frame | 16 bits ≈ **53,3 µs** |
| Repetição | **1 kHz** (1 ms) |
| Idle | Linha em **nível baixo** |
| Telemetria | **Unidirecional** (bit = 0) |

### 4.3 Frame

| Bits | Campo |
|---|---|
| 11 | Throttle (0–2047) |
| 1 | Telemetria (sempre `0`) |
| 4 | CRC |

```c
v     = throttle << 1;                        /* telemetria = 0 */
crc   = (v ^ (v >> 4) ^ (v >> 8)) & 0x0F;
frame = (v << 4) | crc;
```

### 4.4 Mapeamento do stick

| Macro | Valor | Significado |
|---|---|---|
| `DSHOT_THR_MIN` | `48` | Throttle mínimo válido |
| `DSHOT_THR_MAX` | `2047` | Throttle máximo |
| `DSHOT_ARM_MAX` | `1050` | Abaixo disso (µs) → **0 (desarmado)** |
| `DSHOT_RATE_HZ` | `1000` | Taxa de repetição |

- `1..47` são reservados para comandos DShot → nunca usados como throttle.
- `0` = **desarmado**; usado no boot e no fail-safe.
- Faixa útil: `1050–2000 µs` → `48–2047`.

### 4.5 API

| Função | O que faz |
|---|---|
| `J3_DShot_Init()` | Configura PA8/PA9, TIM1 e os dois canais de DMA |
| `J3_DShot_Set(a, b)` | Atualiza os alvos de throttle (0–2047) |
| `J3_DShot_Tarefa()` | Envia um frame a cada 1 ms, se o DMA estiver livre |
| `J3_DShot_Parar()` | Zera os alvos (desarmado) — boot e fail-safe |

O `CCR` é usado com **preload**: o DMA escreve o próximo bit no evento de comparação e o valor
só entra em vigor no início do bit seguinte, sem alterar o pulso em curso.

---

## 5. DMA1

| Canal | Periféricos possíveis (F103) | Uso neste projeto |
|---|---|---|
| **Ch1** | TIM2_CH3 · TIM4_CH1 | Livre |
| **Ch2** | TIM1_CH1 · TIM3_CH3 · SPI1_RX · USART3_TX | **DShot A (TIM1_CH1)** |
| **Ch3** | TIM1_CH2 · TIM3_CH4/UP · SPI1_TX · USART3_RX | **DShot B (TIM1_CH2)** |
| **Ch4** | TIM1_CH4/TRIG/COM · TIM3_CH2 · TIM4_CH2 · SPI2_RX · USART1_TX | Livre |
| **Ch5** | TIM1_UP · TIM2_CH1 · TIM4_CH3 · SPI2_TX · USART1_RX | **iBUS RX (USART1_RX)** |
| **Ch6** | TIM1_CH3 · TIM3_CH1/TRIG · I2C1_TX · USART2_RX | Livre |
| **Ch7** | TIM2_CH2/CH4 · TIM4_UP · I2C1_RX · USART2_TX | Livre |

> IRQ usada: `DMA1_Channel5_IRQHandler` (iBUS). O DShot usa **polling** de `CNDTR`
> (sem IRQ de DMA para os canais 2/3).

---

## 6. Timers

| Timer | Clock | Uso | PSC / ARR | Resultado |
|---|---|---|---|---|
| **TIM1** | 72 MHz (APB2) | DShot A/B (`CH1`/`CH2`) | `0` / `239` | 300 kbit/s · 1 kHz |
| **TIM2** | 72 MHz | Servos S1/S2 (`CH3`/`CH4`) | `71` / `19999` | 50 Hz · 1–2 ms |
| **TIM2** | 72 MHz | `CH1`/`CH2` (PA0/PA1) | `71` / `19999` | Configurado, **sem uso** |
| **TIM3** | 72 MHz | Motores A/B (`CH1`/`CH2`) | `0`/`3599` ou `71`/`999` | 20 kHz / 1 kHz |
| **TIM4** | 72 MHz | — | — | Não usado |

---

## 7. Pinos reservados / conflitos

| Pino(s) | Motivo |
|---|---|
| **PD0 / PD1** | Cristal HSE 8 MHz |
| **PA13 / PA14** | SWD (debug) |
| **PB6 / PB7** | USART1 remapeado (iBUS) |
| **PB0** | STBY da TB6612FNG |
| **PA0 / PA1** | `TIM2_CH1/CH2` reservados (servos extras) |
| **PC13** | LED de status |
| **PC14 / PC15** | Sentido da Ponte A (impede LSE) |
| **PA2–PA7** | Servos e PWM das pontes H |
| **PA8 / PA9** | DShot A/B |

---

## 8. Pinos livres

| Pino | Restrição |
|---|---|
| **PA10** | Livre |
| **PA11** | USB_DM (livre se não usar USB) |
| **PA12** | USB_DP (livre se não usar USB) |
| **PA15** | JTDI — requer `__HAL_AFIO_REMAP_SWJ_NOJTAG()` |
| **PB1** | Livre |
| **PB2** | BOOT1 — usar com cautela (pull-down no Blue Pill) |
| **PB3** | JTDO — requer `__HAL_AFIO_REMAP_SWJ_NOJTAG()` |
| **PB4** | NJTRST — requer `__HAL_AFIO_REMAP_SWJ_NOJTAG()` |
| **PB5** | Livre |
| **PB8 / PB9** | Livres |
| **PB10 / PB11** | Livres (I2C2 / USART3) |
| **PB12–PB15** | Livres (SPI2) |

---

## 9. Notas elétricas

- **GND comum** entre bateria, ponte H, ESCs e Blue Pill é obrigatório.
- **DShot:** sinal 3,3 V, referenciado ao GND dos ESCs. Não alimentar o ESC pelo pino de sinal.
- **TB6612FNG:** VCC lógico em **3,3 V**; VM **≤ 13,5 V**; `STBY` (PB0) não pode flutuar.
- **L298N:** lógica em 5 V; PWM dos motores cai para 1 kHz (`PONTE_H_TB6612 = 0`).
- **Alimentação:** com TB6612 o Blue Pill precisa de **5 V separados** (o módulo não fornece 5 V).
- **Servos:** alimentação própria; apenas o sinal vem do STM32.

---

## 10. Regeneração pelo CubeMX

- O `.ioc` cobre TIM2, TIM3, USART1, DMA1_Channel5 e GPIO.
- **TIM1 e os DMA1_Channel2/3 do DShot não estão no `.ioc`** — são criados em
  `firmware/Core/Src/usr/dshot.c` e sobrevivem à regeneração.
- Após regenerar, confira:
  - clock em **72 MHz**;
  - TIM3 com `MOTOR_PWM_PSC` / `MOTOR_PWM_ARR` (20 kHz na TB6612);
  - blocos `USER CODE` preservados.

---

## 11. Referências

- [Pinagem do STM32F103C8T6](stm32f103c8t6_pinout_voltage01.png)
- [Módulo ponte H L298N (HW-95)](Ponte_H_L298_HW95.jpg)
- [Esquema da montagem](Esquema.png)
- [STM32 cross-series timer overview (PDF)](dm00042534-stm32-cross-series-timer-overview-stmicroelectronics.pdf)
- [README do projeto](../README.md)
